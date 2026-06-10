unit UMDashboardHtml;

{
  UMDashboardHtml
  ---------------
  Generates an executive HTML dashboard from in-memory MQM job data
  (same logic as GetColors in UMSchedCont) and opens it in the default browser.

  Call: GenerateAndOpenDashboard
  - Iterates all resources -> VisRes -> ActArea -> jobs (via p_pl / p_sc globals)
  - Counts status, delays, material warnings per job
  - Writes %TEMP%\mqm_dashboard.html and opens it via ShellExecute
}

interface

procedure GenerateAndOpenDashboard;

implementation

uses
  SysUtils, Classes, Windows, ShellAPI,
  UMObjCont, UMSchedCont, UMRes, UMActArea, UMSchedContFunc;

// ---------------------------------------------------------------------------

type
  TLateJobRec = record
    OrderCode : string;
    WkctCode  : string;
    EndDate   : TDateTime;
    DaysLate  : Integer;
  end;

const
  MAX_LATE_JOBS = 10;

// ---------------------------------------------------------------------------

procedure GenerateAndOpenDashboard;
var
  nTotal, nClosed, nFinProg, nInProg, nFinal, nTemp, nMaterial, nLate : Integer;
  nLevel        : array[1..5] of Integer;
  nLateW, nWarnW, nOkW : array[1..4] of Integer;
  weekStarts, weekEnds  : array[1..4] of TDateTime;
  LateJobs      : array[1..MAX_LATE_JOBS] of TLateJobRec;
  nLateJobs, minLateIdx, minDays : Integer;
  i, j, iRes, iVisRes, iApa : Integer;
  res           : TMqmRes;
  VisRes        : TMqmVisibleRes;
  ActArea       : TMqmActArea;
  Id            : TSchedId;
  html          : TStringList;
  tempFile      : string;
  nScheduled, nOnTime, otifPct, latePct : Integer;
  tmp           : TLateJobRec;

  // ── nested helpers ────────────────────────────────────────────────────────

  function WkOf(dt : TDateTime) : Integer;
  var w : Integer;
  begin
    Result := 0;
    for w := 1 to 4 do
      if (dt >= weekStarts[w]) and (dt <= weekEnds[w]) then
      begin
        Result := w;
        Exit;
      end;
  end;

  function FD(dt : TDateTime) : string;
  begin
    if dt = 0 then Result := '-'
    else Result := FormatDateTime('dd/mm/yy', dt);
  end;

  function IPct(n, d : Integer) : Integer;
  begin
    if d = 0 then Result := 0
    else Result := Round(n / d * 100);
  end;

  function OtifColor(pct : Integer) : string;
  begin
    if pct >= 90 then Result := 'green'
    else if pct >= 75 then Result := 'amber'
    else Result := 'red';
  end;

  function LateColor(pct : Integer) : string;
  begin
    if pct <= 10 then Result := 'green'
    else if pct <= 25 then Result := 'amber'
    else Result := 'red';
  end;

  function OtifLabel(pct : Integer) : string;
  begin
    if pct >= 90 then Result := 'On Track'
    else if pct >= 75 then Result := 'Watch'
    else Result := 'Critical';
  end;

  // ── per-job processing ────────────────────────────────────────────────────

  procedure ProcessJob(aId : TSchedId; const aResCode : string);
  var
    aDatesInfo  : TSQDatesInfo;
    aProgress   : CProgress;
    aErrSet     : SetOfErrors;
    aSchedType  : string;
    aDaysLate, aw, k : Integer;
  begin
    p_sc.GetDatesInfo(aId, aDatesInfo);
    if aDatesInfo.isGroup then Exit;      // skip group objects

    Inc(nTotal);

    // -- schedule / progress status --
    aProgress := p_sc.IsProgressed(aId);
    case aProgress of
      prg_Starting, prg_General : Inc(nInProg);
      prg_Final, prg_FinalSplit : Inc(nFinProg);
    else
      aSchedType := p_sc.GetSchedType(aId);
      if      aSchedType = '1' then Inc(nTemp)
      else if aSchedType = '2' then Inc(nFinal)
      else if aSchedType = '3' then Inc(nLevel[1])
      else if aSchedType = '4' then Inc(nLevel[2])
      else if aSchedType = '5' then Inc(nLevel[3])
      else if aSchedType = '6' then Inc(nLevel[4])
      else if (aSchedType = '7') or (aSchedType = '8') then Inc(nLevel[5]);
    end;

    // -- late? (endDate > HighEndDate) --
    if (aDatesInfo.HighEndDate > 0) and (aDatesInfo.endDate > aDatesInfo.HighEndDate) then
    begin
      Inc(nLate);
      aDaysLate := Trunc(aDatesInfo.endDate - aDatesInfo.HighEndDate);

      if nLateJobs < MAX_LATE_JOBS then
      begin
        Inc(nLateJobs);
        LateJobs[nLateJobs].OrderCode := IntToStr(aId);
        LateJobs[nLateJobs].WkctCode  := aResCode;
        LateJobs[nLateJobs].EndDate   := aDatesInfo.endDate;
        LateJobs[nLateJobs].DaysLate  := aDaysLate;
      end
      else
      begin
        // replace the entry with the fewest days late if current is worse
        minDays := LateJobs[1].DaysLate;
        minLateIdx := 1;
        for k := 2 to MAX_LATE_JOBS do
          if LateJobs[k].DaysLate < minDays then
          begin
            minDays    := LateJobs[k].DaysLate;
            minLateIdx := k;
          end;
        if aDaysLate > minDays then
        begin
          LateJobs[minLateIdx].OrderCode := IntToStr(aId);
          LateJobs[minLateIdx].WkctCode  := aResCode;
          LateJobs[minLateIdx].EndDate   := aDatesInfo.endDate;
          LateJobs[minLateIdx].DaysLate  := aDaysLate;
        end;
      end;
    end;

    // -- week risk bucket (future / current jobs only) --
    if aDatesInfo.endDate >= Trunc(Date) then
    begin
      aw := WkOf(aDatesInfo.endDate);
      if aw > 0 then
      begin
        if (aDatesInfo.HighEndDate > 0) and (aDatesInfo.endDate > aDatesInfo.HighEndDate) then
          Inc(nLateW[aw])
        else if (aDatesInfo.HighEndDate > 0) and
                (aDatesInfo.endDate > aDatesInfo.HighEndDate - 3) then
          Inc(nWarnW[aw])   // within 3 days of deadline
        else
          Inc(nOkW[aw]);
      end;
    end;

    // -- material warning --
    aErrSet := [];
    p_sc.CheckWarningStatistic(aId, aErrSet);
    if CSE_Materials in aErrSet then Inc(nMaterial);
  end;

  // ── HTML line helper ──────────────────────────────────────────────────────

  procedure L(const s : string);
  begin
    html.Add(s);
  end;

// ── main body ──────────────────────────────────────────────────────────────
begin
  // init counters
  nTotal := 0; nClosed := 0; nFinProg := 0; nInProg := 0;
  nFinal := 0; nTemp   := 0; nMaterial := 0; nLate   := 0;
  for i := 1 to 5 do nLevel[i] := 0;
  for i := 1 to 4 do begin nLateW[i] := 0; nWarnW[i] := 0; nOkW[i] := 0; end;
  nLateJobs := 0; minLateIdx := 1; minDays := 0;

  // 4-week boundaries from today
  for i := 1 to 4 do
  begin
    weekStarts[i] := Trunc(Date) + (i-1) * 7;
    weekEnds[i]   := weekStarts[i] + 6;
  end;

  // iterate all resources -> VisRes -> ActArea -> jobs
  for iRes := 0 to p_pl.p_ResList.Count - 1 do
  begin
    res := TMqmRes(p_pl.p_ResList[iRes]);

    if res.p_isMultiRes then
    begin
      for iVisRes := 0 to res.p_VisResCount - 1 do
      begin
        VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);
        for iApa := 0 to VisRes.p_ActAreasCount - 1 do
        begin
          ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
          Id := ActArea.GetSchedObj(0);
          if Id = CSchedIDNull then Continue;
          for i := 0 to ActArea.p_ObjCount - 1 do
          begin
            Id := ActArea.GetSchedObj(i);
            if Id = CSchedIDNull then Continue;
            ProcessJob(Id, res.p_ResCode);
          end;
        end;
      end;
    end
    else
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[0]);
      for iApa := 0 to VisRes.p_ActAreasCount - 1 do
      begin
        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
        Id := ActArea.GetSchedObj(0);
        if Id = CSchedIDNull then Continue;
        for i := 0 to ActArea.p_ObjCount - 1 do
        begin
          Id := ActArea.GetSchedObj(i);
          if Id = CSchedIDNull then Continue;
          ProcessJob(Id, res.p_ResCode);
        end;
      end;
    end;
  end;

  // sort top late jobs descending by DaysLate (bubble sort, max 10 items)
  for i := 1 to nLateJobs - 1 do
    for j := 1 to nLateJobs - i do
      if LateJobs[j].DaysLate < LateJobs[j+1].DaysLate then
      begin
        tmp          := LateJobs[j];
        LateJobs[j]  := LateJobs[j+1];
        LateJobs[j+1]:= tmp;
      end;

  // compute OTIF
  nScheduled := nTotal - nClosed;
  nOnTime    := nScheduled - nLate;
  otifPct    := IPct(nOnTime, nScheduled);
  latePct    := IPct(nLate,   nScheduled);

  // ── build HTML ────────────────────────────────────────────────────────────
  html := TStringList.Create;
  try

    L('<!DOCTYPE html>');
    L('<html lang="en"><head>');
    L('<meta charset="UTF-8">');
    L('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    L('<title>MQM Executive Planning Dashboard</title>');
    L('<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>');
    L('<style>');
    L('*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }');
    L(':root {');
    L('  --red:#D93B3B; --red-bg:#FDEAEA; --red-border:#F5BFBF;');
    L('  --green:#2E7D32; --green-bg:#E8F5E9; --green-mid:#43A047; --green-border:#A5D6A7;');
    L('  --amber:#C07000; --amber-bg:#FFF8E1; --amber-border:#FFD54F;');
    L('  --blue:#1565C0; --blue-bg:#E3F2FD;');
    L('  --border:rgba(0,0,0,0.08); --surface:#FFFFFF; --page:#EEF0F4;');
    L('  --text-primary:#1A1A2E; --text-secondary:#4A5568; --text-muted:#8898AA;');
    L('  --header-bg:#0D1B2A; --card-shadow:0 2px 8px rgba(0,0,0,0.08);');
    L('}');
    L('body { font-family: Arial, sans-serif; background: var(--page); color: var(--text-primary); min-height:100vh; }');
    L('.dashboard { max-width:1400px; margin:0 auto; padding:16px 20px 32px; display:flex; flex-direction:column; gap:14px; }');
    L('.header { background:var(--header-bg); border-radius:12px; padding:18px 28px; display:flex; justify-content:space-between; align-items:center; }');
    L('.header h1 { font-size:22px; font-weight:800; color:#fff; text-transform:uppercase; letter-spacing:0.5px; }');
    L('.header p { font-size:12px; color:rgba(255,255,255,0.5); text-transform:uppercase; letter-spacing:0.8px; margin-top:3px; }');
    L('.header-right { display:flex; gap:8px; align-items:center; }');
    L('.pill { padding:5px 12px; border-radius:20px; font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:0.5px; }');
    L('.pill-green { background:var(--green-bg); color:var(--green); }');
    L('.pill-amber { background:var(--amber-bg); color:var(--amber); }');
    L('.pill-red   { background:var(--red-bg);   color:var(--red);   }');
    L('.pill-blue  { background:var(--blue-bg);  color:var(--blue);  }');
    L('.timestamp  { font-size:11px; color:rgba(255,255,255,0.4); margin-left:8px; }');
    L('.kpi-bar { display:grid; grid-template-columns:repeat(3,1fr); gap:14px; }');
    L('.kpi-card { background:var(--surface); border-radius:10px; box-shadow:var(--card-shadow);');
    L('            padding:20px 22px; display:flex; align-items:center; gap:16px;');
    L('            border-left:5px solid transparent; }');
    L('.kpi-card.green { border-left-color:var(--green-mid); }');
    L('.kpi-card.amber { border-left-color:var(--amber); }');
    L('.kpi-card.red   { border-left-color:var(--red); }');
    L('.kpi-card.blue  { border-left-color:var(--blue); }');
    L('.kpi-icon { width:48px; height:48px; border-radius:12px; display:flex; align-items:center;');
    L('            justify-content:center; font-size:22px; flex-shrink:0; }');
    L('.kpi-icon.green { background:var(--green-bg); }');
    L('.kpi-icon.amber { background:var(--amber-bg); }');
    L('.kpi-icon.red   { background:var(--red-bg);   }');
    L('.kpi-icon.blue  { background:var(--blue-bg);  }');
    L('.kpi-info { flex:1; }');
    L('.kpi-label { font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:0.7px; color:var(--text-muted); }');
    L('.kpi-value { font-size:36px; font-weight:800; line-height:1; margin:4px 0 2px; }');
    L('.kpi-value.green { color:var(--green); }');
    L('.kpi-value.amber { color:var(--amber); }');
    L('.kpi-value.red   { color:var(--red);   }');
    L('.kpi-value.blue  { color:var(--blue);  }');
    L('.kpi-sub { font-size:12px; color:var(--text-secondary); }');
    L('.kpi-sub span { font-weight:600; }');
    L('.row-2 { display:grid; grid-template-columns:1fr 1.3fr; gap:14px; }');
    L('.card { background:var(--surface); border-radius:10px; box-shadow:var(--card-shadow); overflow:hidden; }');
    L('.card-header { padding:12px 18px 10px; border-bottom:1px solid var(--border);');
    L('               display:flex; justify-content:space-between; align-items:center; }');
    L('.card-title { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:0.8px; color:var(--text-secondary); }');
    L('.card-body  { padding:16px 18px; }');
    L('.card-msg   { font-size:11px; font-style:italic; color:var(--text-muted);');
    L('              border-top:1px solid var(--border); padding:8px 18px; background:rgba(0,0,0,0.015); }');
    L('.heatmap-table, .orders-table, .status-table { width:100%; border-collapse:collapse; }');
    L('.heatmap-table th, .orders-table th, .status-table th {');
    L('  font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:0.6px;');
    L('  color:var(--text-muted); padding:8px 12px; text-align:left;');
    L('  border-bottom:1px solid var(--border); background:rgba(0,0,0,0.02); }');
    L('.heatmap-table td, .orders-table td, .status-table td {');
    L('  padding:9px 12px; font-size:13px; border-bottom:1px solid var(--border); vertical-align:middle; }');
    L('.heatmap-table tr:last-child td, .orders-table tr:last-child td, .status-table tr:last-child td { border-bottom:none; }');
    L('.orders-table tr:hover td { background:rgba(0,0,0,0.015); }');
    L('.cell-green { background:var(--green-bg); color:var(--green); border-radius:6px;');
    L('              padding:5px 8px; font-weight:700; text-align:center; display:inline-block; min-width:36px; }');
    L('.cell-amber { background:var(--amber-bg); color:var(--amber); border-radius:6px;');
    L('              padding:5px 8px; font-weight:700; text-align:center; display:inline-block; min-width:36px; }');
    L('.cell-red   { background:var(--red-bg);   color:var(--red);   border-radius:6px;');
    L('              padding:5px 8px; font-weight:800; font-size:15px; text-align:center; display:inline-block; min-width:36px; }');
    L('.status-badge { display:inline-block; padding:3px 9px; border-radius:12px;');
    L('                font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:0.4px; }');
    L('.status-red   { background:var(--red-bg);   color:var(--red);   border:1px solid var(--red-border); }');
    L('.status-amber { background:var(--amber-bg); color:var(--amber); border:1px solid var(--amber-border); }');
    L('.status-green { background:var(--green-bg); color:var(--green); border:1px solid var(--green-border); }');
    L('.status-gray  { background:#F3F4F6; color:#374151; border:1px solid #D1D5DB; }');
    L('.chart-wrap { height:160px; margin-bottom:12px; }');
    L('.legend-row { display:flex; gap:14px; align-items:center; }');
    L('.legend-item { display:flex; align-items:center; font-size:11px; color:var(--text-muted); font-weight:500; }');
    L('.dot { display:inline-block; width:9px; height:9px; border-radius:50%; margin-right:5px; vertical-align:middle; }');
    L('.dot-red   { background:var(--red); }');
    L('.dot-amber { background:var(--amber); }');
    L('.dot-green { background:var(--green-mid); }');
    L('.order-id  { font-weight:700; font-size:14px; color:var(--blue); }');
    L('.wk-label  { font-size:11px; color:var(--text-muted); }');
    L('td.num     { text-align:right; }');
    L('</style></head><body>');
    L('<div class="dashboard">');

    // ── HEADER ────────────────────────────────────────────────────────────
    L('<div class="header">');
    L('  <div>');
    L('    <h1>MQM - Executive Planning Dashboard</h1>');
    L('    <p>Job Status Analysis - All Loaded Resources</p>');
    L('  </div>');
    L('  <div class="header-right">');
    L('    <div class="pill pill-blue">All Jobs</div>');
    L('    <span class="timestamp">Generated: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now) + '</span>');
    L('  </div>');
    L('</div>');

    // ── KPI BAR ───────────────────────────────────────────────────────────
    L('<div class="kpi-bar">');

    // OTIF
    L(Format('  <div class="kpi-card %s">', [OtifColor(otifPct)]));
    L(Format('    <div class="kpi-icon %s">&#128230;</div>', [OtifColor(otifPct)]));
    L('    <div class="kpi-info">');
    L('      <div class="kpi-label">OTIF (Projected)</div>');
    L(Format('      <div class="kpi-value %s">%d%%</div>', [OtifColor(otifPct), otifPct]));
    L(Format('      <div class="kpi-sub"><span>%d on time</span> of %d scheduled</div>', [nOnTime, nScheduled]));
    L('    </div>');
    L(Format('    <div class="pill pill-%s">%s</div>', [OtifColor(otifPct), OtifLabel(otifPct)]));
    L('  </div>');

    // Late Jobs
    L(Format('  <div class="kpi-card %s">', [LateColor(latePct)]));
    L(Format('    <div class="kpi-icon %s">&#9888;</div>', [LateColor(latePct)]));
    L('    <div class="kpi-info">');
    L('      <div class="kpi-label">Late Jobs</div>');
    L(Format('      <div class="kpi-value %s">%d</div>', [LateColor(latePct), nLate]));
    L(Format('      <div class="kpi-sub"><span>%d%%</span> of %d scheduled jobs</div>', [latePct, nScheduled]));
    L('    </div>');
    L(Format('    <div class="pill pill-%s">%d%%</div>', [LateColor(latePct), latePct]));
    L('  </div>');

    // In Progress / totals
    L('  <div class="kpi-card blue">');
    L('    <div class="kpi-icon blue">&#9881;</div>');
    L('    <div class="kpi-info">');
    L('      <div class="kpi-label">In Progress</div>');
    L(Format('      <div class="kpi-value blue">%d</div>', [nInProg]));
    L(Format('      <div class="kpi-sub">Total: <span>%d</span> &nbsp;|&nbsp; Done: <span>%d</span> &nbsp;|&nbsp; Closed: <span>%d</span></div>', [nTotal, nFinProg, nClosed]));
    L('    </div>');
    L('  </div>');

    L('</div><!-- /kpi-bar -->');

    // ── ROW 2: HEATMAP + STATUS CHART ─────────────────────────────────────
    L('<div class="row-2">');

    // -- Risk heatmap --
    L('  <div class="card">');
    L('    <div class="card-header">');
    L('      <span class="card-title">&#128197; Orders Risk Distribution - Next 4 Weeks</span>');
    L('      <div class="legend-row">');
    L('        <div class="legend-item"><span class="dot dot-green"></span>OK</div>');
    L('        <div class="legend-item"><span class="dot dot-amber"></span>Watch</div>');
    L('        <div class="legend-item"><span class="dot dot-red"></span>Late</div>');
    L('      </div>');
    L('    </div>');
    L('    <div class="card-body">');
    L('      <table class="heatmap-table">');
    L('        <thead><tr><th>Week</th><th>OK</th><th>Watch</th><th>Late</th></tr></thead>');
    L('        <tbody>');
    for i := 1 to 4 do
    begin
      L(Format('          <tr>',[]));
      L(Format('            <td><b>Week %d</b><br><span class="wk-label">%s - %s</span></td>', [i, FD(weekStarts[i]), FD(weekEnds[i])]));
      L(Format('            <td><div class="cell-green">%d</div></td>', [nOkW[i]]));
      if nWarnW[i] > 0 then
        L(Format('            <td><div class="cell-amber">%d</div></td>', [nWarnW[i]]))
      else
        L(Format('            <td><div class="cell-green">%d</div></td>', [nWarnW[i]]));
      if nLateW[i] > 0 then
        L(Format('            <td><div class="cell-red">%d &#128308;</div></td>', [nLateW[i]]))
      else
        L(Format('            <td><div class="cell-green">%d</div></td>', [nLateW[i]]));
      L('          </tr>');
    end;
    L('        </tbody>');
    L('      </table>');
    L('    </div>');
    L('    <div class="card-msg">&#128172; "Problems are visible before they happen"</div>');
    L('  </div>');

    // -- Status distribution (chart + table) --
    L('  <div class="card">');
    L('    <div class="card-header">');
    L('      <span class="card-title">&#128202; Job Status Distribution</span>');
    L(Format('      <div class="pill pill-blue">%d Total Jobs</div>', [nTotal]));
    L('    </div>');
    L('    <div class="card-body">');
    L('      <div class="chart-wrap"><canvas id="statusChart"></canvas></div>');
    L('      <table class="status-table">');
    L('        <thead><tr><th>Status</th><th class="num">Count</th><th class="num">%</th></tr></thead>');
    L('        <tbody>');
    if nInProg  > 0 then L(Format('          <tr><td><span class="status-badge status-amber">In Progress</span></td><td class="num">%d</td><td class="num">%d%%</td></tr>', [nInProg,  IPct(nInProg,  nTotal)]));
    if nFinProg > 0 then L(Format('          <tr><td><span class="status-badge status-green">Done</span></td><td class="num">%d</td><td class="num">%d%%</td></tr',          [nFinProg, IPct(nFinProg, nTotal)]));
    if nFinal   > 0 then L(Format('          <tr><td><span class="status-badge status-green">Final</span></td><td class="num">%d</td><td class="num">%d%%</td></tr>',         [nFinal,   IPct(nFinal,   nTotal)]));
    if nTemp    > 0 then L(Format('          <tr><td><span class="status-badge status-amber">Temporary</span></td><td class="num">%d</td><td class="num">%d%%</td></tr>',      [nTemp,    IPct(nTemp,    nTotal)]));
    for j := 1 to 5 do
      if nLevel[j] > 0 then
        L(Format('          <tr><td><span class="status-badge status-amber">Level %d</span></td><td class="num">%d</td><td class="num">%d%%</td></tr>', [j, nLevel[j], IPct(nLevel[j], nTotal)]));
    if nClosed  > 0 then L(Format('          <tr><td><span class="status-badge status-gray">Closed</span></td><td class="num">%d</td><td class="num">%d%%</td></tr>',          [nClosed,  IPct(nClosed,  nTotal)]));
    if nMaterial > 0 then
    begin
      L('          <tr style="border-top:2px solid var(--border);">');
      L(Format('            <td><span class="status-badge status-red">&#9888; Material Warning</span></td><td class="num">%d</td><td class="num">%d%%</td></tr>', [nMaterial, IPct(nMaterial, nTotal)]));
    end;
    L('        </tbody>');
    L('      </table>');
    L('    </div>');
    L('  </div>');

    L('</div><!-- /row-2 -->');

    // ── TOP LATE JOBS TABLE ──────────────────────────────────────────────
    if nLateJobs > 0 then
    begin
      L('<div class="card">');
      L('  <div class="card-header">');
      L('    <span class="card-title">&#128230; Top Late Jobs - Management Action Required</span>');
      L(Format('    <div style="display:flex;gap:8px;"><div class="pill pill-red">%d Total Late</div><div class="pill pill-blue">Top %d Shown</div></div>', [nLate, nLateJobs]));
      L('  </div>');
      L('  <div class="card-body" style="padding:0;">');
      L('    <table class="orders-table">');
      L('      <thead><tr><th>Order</th><th>Work Center</th><th>End Date</th><th>Days Late</th><th>Risk Level</th></tr></thead>');
      L('      <tbody>');
      for i := 1 to nLateJobs do
      begin
        if LateJobs[i].DaysLate >= 10 then
          L(Format('        <tr><td><div class="order-id">%s</div></td><td>%s</td><td>%s</td><td style="font-weight:700;color:var(--red);">%d days</td><td><span class="status-badge status-red">High</span></td></tr>',
            [LateJobs[i].OrderCode, LateJobs[i].WkctCode, FD(LateJobs[i].EndDate), LateJobs[i].DaysLate]))
        else if LateJobs[i].DaysLate >= 3 then
          L(Format('        <tr><td><div class="order-id">%s</div></td><td>%s</td><td>%s</td><td style="font-weight:700;color:var(--amber);">%d days</td><td><span class="status-badge status-amber">Medium</span></td></tr>',
            [LateJobs[i].OrderCode, LateJobs[i].WkctCode, FD(LateJobs[i].EndDate), LateJobs[i].DaysLate]))
        else
          L(Format('        <tr><td><div class="order-id">%s</div></td><td>%s</td><td>%s</td><td style="font-weight:700;color:var(--amber);">%d days</td><td><span class="status-badge status-amber">Low</span></td></tr>',
            [LateJobs[i].OrderCode, LateJobs[i].WkctCode, FD(LateJobs[i].EndDate), LateJobs[i].DaysLate]));
      end;
      L('      </tbody>');
      L('    </table>');
      L('  </div>');
      L('  <div class="card-msg">&#128172; "Act on the most delayed orders first"</div>');
      L('</div>');
    end;

    L('</div><!-- /dashboard -->');

    // ── CHART SCRIPT ──────────────────────────────────────────────────────
    L('<script>');
    L('(function(){');
    L('  var el = document.getElementById(''statusChart'');');
    L('  if (!el || typeof Chart === ''undefined'') return;');
    L('  new Chart(el.getContext(''2d''), {');
    L('    type: ''bar'',');
    L('    data: {');
    L(Format('      labels: [''In Progress'',''Done'',''Final'',''Temp'',''Lvl1'',''Lvl2'',''Lvl3'',''Lvl4'',''Lvl5'',''Closed''],', []));
    L(Format('      datasets: [{ data: [%d,%d,%d,%d,%d,%d,%d,%d,%d,%d],', [nInProg, nFinProg, nFinal, nTemp, nLevel[1], nLevel[2], nLevel[3], nLevel[4], nLevel[5], nClosed]));
    L('        backgroundColor: [');
    L('          ''rgba(192,112,0,0.75)'',''rgba(46,125,50,0.75)'',''rgba(67,160,71,0.75)'',');
    L('          ''rgba(192,112,0,0.55)'',''rgba(21,101,192,0.75)'',''rgba(21,101,192,0.65)'',');
    L('          ''rgba(21,101,192,0.55)'',''rgba(21,101,192,0.45)'',''rgba(21,101,192,0.35)'',');
    L('          ''rgba(150,150,150,0.5)''');
    L('        ],');
    L('        borderRadius: 4, borderSkipped: false');
    L('      }]');
    L('    },');
    L('    options: {');
    L('      responsive: true, maintainAspectRatio: false,');
    L('      plugins: { legend: { display: false } },');
    L('      scales: {');
    L('        x: { grid: { display: false }, ticks: { font: { size: 10 }, color: ''#8898AA'' } },');
    L('        y: { grid: { color: ''rgba(0,0,0,0.05)'' },');
    L('             ticks: { font: { size: 10 }, color: ''#8898AA'' }, beginAtZero: true }');
    L('      }');
    L('    }');
    L('  });');
    L('})();');
    L('</script>');
    L('</body></html>');

    // write + open
    tempFile := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'))
                + 'mqm_dashboard.html';
    html.SaveToFile(tempFile, TEncoding.UTF8);

  finally
    html.Free;
  end;

  ShellExecute(0, 'open', PChar(tempFile), nil, nil, SW_SHOWNORMAL);
end;

end.

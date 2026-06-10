unit FMCompareSavedBuckets;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Grids;

type
  TFCompareSaved = class(TForm)
    Panel1: TPanel;
    Button1: TcxButton;
    Button2: TcxButton;
    cbPlan: TCheckBox;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    cbType: TComboBox;
    Label1: TLabel;
    sgMain: TStringGrid;
    sgSec: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbPlanClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure GenerateExcel;
  public
    { Public declarations }
  end;

  type
    RecSavedPlanCopy = record
    IDENTIFIER : string;
    FROMDATE   : TDateTime;
    TODATE     : TDateTime;
    WKST_CODE	 : string;
    SET_NAME   : string;
    SET_DESC   : string;
    PREQ_NO    : string;
    STEP_ID	   : integer;
    SubStep    : integer;
    REPROC_NO	 : integer;
    RSC        : string;
    BucDate    : TDate;
    BucType    : String;
    BucQty     : double;
    SchedStart : TDateTime;
    SchedEnd   : TDateTime;
    ExeMin     : Double;
  end;
  PRecSavedPlanCopy = ^RecSavedPlanCopy;

var
  FCompareSaved: TFCompareSaved;
  ReportType,
  SheetName,
  FileName     : String;
  ShowExcel    : Boolean;
  Date_from,
  Time_from,
  SumBucketsQty: Double;
  BucketNumber,
  RoundLevel   : Integer;
  set1, set2  :TList;

implementation

  uses UMPlan, UMObjCont, UReshape, gnugettext, ComObj, UMReportExport, mxNativeExcel, DMsrvPc, UMTblDesc, umglobal;

{$R *.dfm}

procedure TFCompareSaved.Button1Click(Sender: TObject);
var set1,set2 : String;
begin
  if sgMain.Cells[sgMain.Col, sgMain.Row] = ''  then
  begin
    MessageDlg(_('Select set 1!'), mtError, [mbOk], 0);
    exit;
  end;

  if (sgSec.Cells[sgSec.Col, sgSec.Row] = '' ) and (not cbPlan.Checked) then
  begin
    MessageDlg(_('Select set 2!'), mtError, [mbOk], 0);
    exit;
  end;

  set1 := sgMain.Cells[0, sgMain.Row];

  if not cbPlan.Checked then
  begin
    set2 := sgSec.Cells[0, sgSec.Row];

    if set1 = set2 then
    begin
      MessageDlg(_('Cannot select same sets for comparing!'), mtError, [mbOk], 0);
      exit;
    end;
  end;

  GenerateExcel;
end;

//----------------------------------------------------------------------------//

procedure TFCompareSaved.Button2Click(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFCompareSaved.cbPlanClick(Sender: TObject);
begin
    sgSec.Enabled := not cbPlan.Checked;
end;

//----------------------------------------------------------------------------//

procedure TFCompareSaved.FormCreate(Sender: TObject);
var i, x, w : Integer;
s : String;
   tbi : ^TTblInfo;
  RecSavedPlan : PRecSavedPlanCopy;
  qry: TMqmQuery;
begin

  p_pl.ClearSavedPlanCopyList;
  p_pl.LoadSavedPlanCopy;

  qry := CreateQuery(Main_DB);
  tbi := @tblInfo[tbl_SavedPlanCopyHeader];

  sgMain.ColWidths[0] := 90;
  sgMain.ColWidths[1] := 160;
  sgMain.ColWidths[2] := 100;
  sgMain.ColWidths[3] := 100;
  sgMain.Cells[0,0] := _('Set name');
  sgMain.Cells[1,0] := _('Description');
  sgMain.Cells[2,0] := _('Date from');
  sgMain.Cells[3,0] := _('Date to');

  sgSec.ColWidths[0] := 90;
  sgSec.ColWidths[1] := 160;
  sgSec.ColWidths[2] := 100;
  sgSec.ColWidths[3] := 100;
  sgSec.Cells[0,0] := _('Set name');
  sgSec.Cells[1,0] := _('Description');
  sgSec.Cells[2,0] := _('Date from');
  sgSec.Cells[3,0] := _('Date to');

  with Qry.SQL do
  begin
    Clear;
    Add('select  CPH_SET_NAME, CPH_SET_DESC, CPH_START_DATE, CPH_END_DATE');
    Add(' from  ' + tbi.GetTableName);
    Add(' where CPH_IDENTIFIER = ' + IniAppGlobals.Identifier + ' and CPH_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));
    Add('order by CPH_SET_NAME, CPH_START_DATE, CPH_END_DATE');
  end;

  qry.Open;
  i := 0;
  while not qry.eof do
  begin
    sgMain.Cells[0, i+1] := qry.FieldByName('CPH_SET_NAME').AsString;
    sgMain.Cells[1, i+1] := qry.FieldByName('CPH_SET_DESC').AsString;
    sgMain.Cells[2, i+1] := qry.FieldByName('CPH_START_DATE').AsString;
    sgMain.Cells[3, i+1] := qry.FieldByName('CPH_END_DATE').AsString;

    sgSec.Cells[0, i+1] := qry.FieldByName('CPH_SET_NAME').AsString;
    sgSec.Cells[1, i+1] := qry.FieldByName('CPH_SET_DESC').AsString;
    sgSec.Cells[2, i+1] := qry.FieldByName('CPH_START_DATE').AsString;
    sgSec.Cells[3, i+1] := qry.FieldByName('CPH_END_DATE').AsString;

    Inc(i);
    qry.next;
  end;

  qry.Close;
  Qry.Free;

  ReShape(Self);
end;

//----------------------------------------------------------------------------//

function ExcelInstalled: boolean;
var
  XLApp: OLEVariant;
begin
  Result := False;
  try
    XLApp := CreateOleObject('Excel.Application');
    if not VarIsEmpty(XLApp) then
    begin
      Result := True;
      XLApp.Quit;
      XLAPP := Unassigned;
    end;
  except
    Result := False;
  end;
end;

//----------------------------------------------------------------------------//

function SortSet(Item1, Item2: Pointer) : integer;
var
  res1, res2:  PRecSavedPlanCopy;
begin
  res1 := PRecSavedPlanCopy(Item1);
  res2 := PRecSavedPlanCopy(Item2);

  if res1.RSC < res2.RSC then
    Result := -1
  else if res1.RSC > res2.RSC then
    Result := 1
  else
  begin
    if res1.PREQ_NO < res2.PREQ_NO then
      Result := -1
    else if res1.PREQ_NO > res2.PREQ_NO then
      Result := 1
    else
    begin
      if res1.STEP_ID < res2.STEP_ID then
        Result := -1
      else if res1.STEP_ID > res2.STEP_ID then
        Result := 1
      else
      begin
        if res1.SET_NAME < res2.SET_NAME then
          Result := -1
        else if res1.SET_NAME > res2.SET_NAME then
          Result := 1
        else
        begin
          if res1.BucDate < res2.BucDate then
            Result := -1
          else if res1.BucDate > res2.BucDate then
              Result := 1
            else
              Result := 0
         // end;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function SummarizeSet(sets : TList; ResLevel : Boolean): TList;
var i : Integer;
  RecSavedPlan : PRecSavedPlanCopy;
begin
  RecSavedPlan := nil;
  result := TList.Create;

  for I := 0 to sets.Count - 1 do
  begin

    if ResLevel then
    begin
      if not assigned(RecSavedPlan) then
       begin
          RecSavedPlan := PRecSavedPlanCopy(sets[i]);
          Result.Add(RecSavedPlan);
       end else
       if (PRecSavedPlanCopy(sets[i]).PREQ_NO = RecSavedPlan.PREQ_NO)
        and (PRecSavedPlanCopy(sets[i]).STEP_ID = RecSavedPlan.STEP_ID)
        and (PRecSavedPlanCopy(sets[i]).BucDate = RecSavedPlan.BucDate)
        and (PRecSavedPlanCopy(sets[i]).BucType = RecSavedPlan.BucType)
        and (PRecSavedPlanCopy(sets[i]).SET_NAME = RecSavedPlan.SET_NAME)
        and (PRecSavedPlanCopy(sets[i]).RSC <> RecSavedPlan.RSC)
       // and (PRecSavedPlanCopy(sets[i]).SubStep <> RecSavedPlan.SubStep)
        then
       begin
        RecSavedPlan.BucQty := RecSavedPlan.BucQty + PRecSavedPlanCopy(sets[i]).BucQty;
       end else
       begin
         RecSavedPlan := PRecSavedPlanCopy(sets[i]);
         Result.Add(RecSavedPlan);
         RecSavedPlan := nil;
       end;
    end else
    begin

      if not assigned(RecSavedPlan) then
       begin
          RecSavedPlan := PRecSavedPlanCopy(sets[i]);
          Result.Add(RecSavedPlan);
       end else
       if (PRecSavedPlanCopy(sets[i]).PREQ_NO = RecSavedPlan.PREQ_NO)
        and (PRecSavedPlanCopy(sets[i]).STEP_ID = RecSavedPlan.STEP_ID)
        and (PRecSavedPlanCopy(sets[i]).BucDate = RecSavedPlan.BucDate)
        and (PRecSavedPlanCopy(sets[i]).BucType = RecSavedPlan.BucType)
        and (PRecSavedPlanCopy(sets[i]).RSC = RecSavedPlan.RSC)
        and (PRecSavedPlanCopy(sets[i]).SET_NAME = RecSavedPlan.SET_NAME)
        and (PRecSavedPlanCopy(sets[i]).SubStep <> RecSavedPlan.SubStep)
        then
       begin
        RecSavedPlan.BucQty := RecSavedPlan.BucQty + PRecSavedPlanCopy(sets[i]).BucQty;
       end else
       begin
         RecSavedPlan := PRecSavedPlanCopy(sets[i]);
         Result.Add(RecSavedPlan);
         RecSavedPlan := nil;
       end;
    end;

  end;

end;

function CollideSets(Set1, Set2: TList): TList;
var i : Integer;
begin
  result := TList.Create;

  for i := 0 to set1.Count -1 do
    Result.Add(PRecSavedPlanCopy(set1[i]));

  for i := 0 to set2.Count - 1 do
    Result.Add(PRecSavedPlanCopy(set2[i]));

end;

procedure TFCompareSaved.GenerateExcel;
var saveDialog    : TSaveDialog;
    ReportName    : string;
    ReportSettings: TSettings;
    i             : Integer;
    date_to, date_from : Double;
    FinalSet : TList;
begin

    saveDialog := TSaveDialog.Create(self);
    saveDialog.Title := _('Save compare buckets report as') + ':';
    saveDialog.InitialDir := GetCurrentDir;
    if ExcelInstalled then
    begin
      saveDialog.Filter := 'Microsoft Excel Worksheet|*.xlsx|Microsoft Excel 97-2003 Worksheet|*.xls';
      saveDialog.DefaultExt := 'xlsx';
    end else
    begin
      saveDialog.Filter := 'Microsoft Excel 97-2003 Worksheet|*.xls';
      saveDialog.DefaultExt := 'xls';
    end;
    saveDialog.FilterIndex := 1;

    if not saveDialog.Execute then
    begin
      ShowMessage(_('Saving file was cancelled'));
      exit;
    end;

    SheetName := 'MQM Compare Buckets Report';
    FileName  := saveDialog.FileName;

    set1 := TList.Create;
    //FileName  := GetCurrentDir + '\tst.xlsx';

    if ExcelInstalled then ReportName := 'Excel_Compare_Buckets'
    else ReportName := 'Excel_Compare_Buckets_for_non_excel';
    ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);

    Date_to := 0;
    Date_from := 0;

    for i := 0 to p_pl.p_GetSavedPlanCopyCount - 1 do   //get latest date from set 1
    begin

      if PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).SET_NAME = sgMain.Cells[0, sgMain.Row] then
      begin
         if (PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).TODATE > Date_to)
          and (PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).BucType = '2') then
            Date_to := PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).TODATE;

        if Date_from = 0 then
           Date_from := PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).FROMDATE
        else
        if PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).FROMDATE < Date_from then
          Date_from := PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).FROMDATE;

        set1.Add(PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]));
      end;
    end;

    if not cbPlan.Checked then
    begin
      set2 := TList.Create;
      for i := 0 to p_pl.p_GetSavedPlanCopyCount - 1 do    //get latest date from set 2
      begin
        if PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).SET_NAME = sgSec.Cells[0, sgSec.Row] then
        begin
          if PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).TODATE > Date_to then
            Date_to := PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).TODATE;

          if Date_from = 0 then
            Date_from := PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).FROMDATE
          else
          if PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).FROMDATE < Date_from then
            Date_from := PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]).FROMDATE;

          set2.Add(PRecSavedPlanCopy(p_pl.p_SavedPlanCopyList[i]));
        end;
      end;
    end  else
    begin
     // Date_to :=  p_pl.GetLatestDateFromPlan;  //get latest date from current plan
     { if Date_from > Now then
        Date_from := Now;
      Date_to := Date_from + 15;    }

      set2 := p_pl.GetListForSavedPlan('Current plan', Date_from, Date_to);
    end;

    if set1.Count = 0 then
    begin
      Messagedlg(_('There is no jobs in set 1!'), mtError, [mbOk], 0);
      saveDialog.Free;
      exit;
    end;

    if set2.Count = 0 then
    begin
      Messagedlg(_('There is no jobs in set 2!'), mtError, [mbOk], 0);
      saveDialog.Free;
      exit;
    end;

    ReportSettings.DateFrom         := Date_from;
    ReportSettings.DateTo           := Date_to;
    ReportSettings.SaveFileLocation := FileName;
    ReportSettings.ReportType       := ReportName;
    ReportSettings.MaxRows          := -1;
    ReportSettings.MaxCols          := -1;
    ReportSettings.Report_Date_From := Date_from;
    ReportSettings.SheetName        := SheetName;
    ReportSettings.ShowExcel        := ShowExcel;
    if cbPlan.Checked then
      ReportSettings.GroupType        := 1
    else
      ReportSettings.GroupType        := 0;

    ReportSettings.ShowResources := cbType.ItemIndex = 0;

    FinalSet := TList.Create;
    FinalSet := CollideSets(Set1, Set2);
    FinalSet.Sort(SortSet);

    FinalSet := SummarizeSet(FinalSet, False);

    if ReportSettings.ShowResources then
      FinalSet := SummarizeSet(FinalSet, True);

    ShowMessage(WriteCompareBucketExcel(FinalSet, ReportSettings));

    Set1.Clear;

    Set2.Clear;
    FinalSet.Clear;
    saveDialog.Free;
    FinalSet.Free;
    set1.Free;
    set2.Free;
end;

//----------------------------------------------------------------------------//

end.

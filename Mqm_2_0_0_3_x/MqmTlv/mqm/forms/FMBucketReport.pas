unit FMBucketReport;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, gnugettext, ExtCtrls, Buttons, UMTabCfg, UMBinTbs, CheckLst, ComCtrls, StdCtrls, UReShape;

type
  TFBucketReport = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    LblFromDate: TLabel;
    ChkLstBoxRsc: TCheckListBox;
    ChkLstBoxWkc: TCheckListBox;
    DateTimePickerDate: TDateTimePicker;
    DateTimePickerTime: TDateTimePicker;
    CBBucketType: TComboBox;
    Label3: TLabel;
    EditBucketNumber: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    CBRound: TComboBox;
    Label6: TLabel;
    ComboBoxCalList: TComboBox;
    ComBoxSortCrits: TComboBox;
    LabelSortCrit: TLabel;
    BtnCreate: TcxButton;
    BitBtn1: TcxButton;
    Label7: TLabel;
    constructor CreateBucketReport(AOwner: TComponent; RepType: String);
    procedure FormCreate(Sender: TObject);
    procedure BtnExcelBucketReportClick(Sender: TObject);
    procedure GetBucketData;
    procedure ChkLstBoxWkcClickCheck(Sender: TObject);
    procedure EditBucketNumberChange(Sender: TObject);
    procedure FillCalList;
    procedure BitBtn1Click(Sender: TObject);
    procedure CBBucketTypeChange(Sender: TObject);
  end;

var
  FBucketReport: TFBucketReport;

implementation
uses
  ComObj,
  UMWkctr,
  UMRes,
  UMPlan,
  UMObjCont,
  UMPlanObj,
  UMActArea,
  mxNativeExcel,
  UMbinGrid,
  UMSchedContFunc,
  UMBinPanel,
  UMReportExport, FMbin;

{$R *.dfm}

var
  ReportType,
  SheetName,
  FileName     : String;
  ShowExcel    : Boolean;
  BucketSize,
  Date_from,
  Time_from,
  SumBucketsQty: Double;
  BucketNumber,
  RoundLevel   : Integer;

//----------------------------------------------------------------------------//

constructor TFBucketReport.CreateBucketReport(AOwner: TComponent; RepType: String);
begin
  inherited Create(AOwner);
  ReportType := RepType;
  if ReportType = 'excel' then Caption := _('Excel Bucket Report')
  else if ReportType = 'html' then Caption := _('HTML Bucket Report');
end;

//----------------------------------------------------------------------------//

procedure TFBucketReport.FillCalList;
var
  I,j,m,SubResIndex, noOfSubRes : Integer;
  VisRes: TMqmVisibleRes;
  Res_Code : String;
  res               : TMqmRes;
  wkc_List   : TList;
  wkc        : TMqmWrkCtr;
  res_obj    : TMqmPlanObj;
begin
  ComboBoxCalList.Items.Clear;

  wkc_List := p_pl.p_AllWrkCtr;
  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    wkc := TMqmWrkCtr(Wkc_List[i]);
    ChkLstBoxWkc.Items.Add(wkc.p_WrkCtrCode);
    SubResIndex := 1;
    for j := 0 to wkc.p_ResCount - 1 do
    begin
      res_Obj := TMqmPlanObj(wkc.p_Res[j]);
      res := TMqmRes(res_Obj);

      VisRes := TMqmVisibleRes(res.p_VisRes[0]);
      VisRes.p_Calendar;

      if (VisRes.p_EfficiencyOnLevel = EffLvl_Res) or (VisRes.p_EfficiencyOnLevel = EffLvl_Wc) then
      begin
        if ComboBoxCalList.Items.IndexOf(VisRes.p_CalendarReal.GetKey) = -1 then
           ComboBoxCalList.Items.Add(VisRes.p_CalendarReal.GetKey)
      end
      else
      begin
        if ComboBoxCalList.Items.IndexOf(VisRes.p_Calendar.GetKey) = -1 then
           ComboBoxCalList.Items.Add(VisRes.p_Calendar.GetKey)
      end;
    end;
  end;

  { for i := 0 to (ChkLstBoxRsc.Items.Count - 1) do
   begin
      Res_Code := ChkLstBoxRsc.Items.Strings[i];
      res := TMqmRes(p_pl.FindResByCode(Res_Code));

      if not assigned(res) then
        continue;

      if res.p_isMultiRes then
        noOfSubRes := res.p_VisResCount
      else
        noOfSubRes := 1;

      for m := 1 to noOfSubRes do
      begin
        if not res.p_isMultiRes then
          visRes := res.p_VisRes[0]
        else
          visRes := res.GetSubRes(m);

        if Assigned(visRes) then
        begin
          if (VisRes.p_EfficiencyOnLevel = EffLvl_Res) or (VisRes.p_EfficiencyOnLevel = EffLvl_Wc) then
          begin
            if ComboBoxCalList.Items.IndexOf(VisRes.p_CalendarReal.GetKey) = -1 then
               ComboBoxCalList.Items.Add(VisRes.p_CalendarReal.GetKey)
          end
          else
          begin
            if ComboBoxCalList.Items.IndexOf(VisRes.p_Calendar.GetKey) = -1 then
               ComboBoxCalList.Items.Add(VisRes.p_Calendar.GetKey)
          end;
        end;
      end;
   end;  }
end;

//----------------------------------------------------------------------------//

procedure TFBucketReport.FormCreate(Sender: TObject);
var
  wkc_List   : TList;
  wkc        : TMqmWrkCtr;
  res_obj    : TMqmPlanObj;
  res        : TmqmRes;
  subres     : TMqmVisibleRes;
  i, j, pos,
  SubResIndex: Integer;
begin
  try
    TranslateComponent(self);
    wkc_List := p_pl.p_AllWrkCtr;
    for i := 0 to p_pl.p_WrkCtrsCount - 1 do
    begin
      wkc := TMqmWrkCtr(Wkc_List[i]);
      ChkLstBoxWkc.Items.Add(wkc.p_WrkCtrCode);
      for j := 0 to wkc.p_ResCount - 1 do
      begin
        SubResIndex := 1;
        res_Obj := TMqmPlanObj(wkc.p_Res[j]);
        res := TMqmRes(res_Obj);
        if not res.p_isMultiRes then
        begin
          pos := ChkLstBoxRsc.Items.Add(res.p_ResCode);
          ChkLstBoxRsc.Items.Objects[pos] := res.p_VisRes[0];//res;
        end
        else
        begin
          while (Assigned(res.GetSubRes(SubResIndex))) do
          begin
            subres := res.GetSubRes(SubResIndex);
            pos := ChkLstBoxRsc.Items.Add(res.p_ResCode + SUBRESSEPARATOR + IntToStr(subres.p_SubCode));
            ChkLstBoxRsc.Items.Objects[pos] := subres;
            SubResIndex := SubResIndex + 1;
          end;
        end;
      end;
    end;
    DateTimePickerDate.Date := Now;
    FillCalList;
  except
    on e:Exception do MessageDlg('FMBucketExcelReport - FormCreate'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;

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

procedure TFBucketReport.GetBucketData;
var
  date_to       : Double;
  ReportName    : string;
  ReportSettings: TSettings;
  CalCode : String;
begin
  //try
    ReportSettings.BucketByShift := false;
    if BucketSize = -2 then // handling shifts
    begin
      ReportSettings.BucketByShift := true;
      CalCode := ComboBoxCalList.items.Strings[ComboBoxCalList.ItemIndex];
      CalculateDateToShift(bucketNumber, date_to, BucketSize, time_from, date_from, ReportSettings, CalCode);
    end
    else
      CalculateDateTo(bucketNumber, date_to, BucketSize, time_from, date_from);

    if ExcelInstalled then ReportName := 'Excel_Bucket'
    else ReportName := 'Excel_Bucket_for_non_excel';
    ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);

    if ComBoxSortCrits.Text = '' then
      ReportSettings.GroupingFields := 0
    else
      ReportSettings.GroupingFields := StrToInt(ComBoxSortCrits.Text);


    ReportSettings.DateFrom         := Date_from;
    ReportSettings.DateTo           := Date_to;
    ReportSettings.SaveFileLocation := FileName;
    ReportSettings.ChkLstBoxRsc     := ChkLstBoxRsc;
    ReportSettings.ReportType       := ReportName;
    ReportSettings.MaxRows          := -1;
    ReportSettings.MaxCols          := -1;
    ReportSettings.BucketNumber     := BucketNumber;
    ReportSettings.RoundLevel       := RoundLevel;
    ReportSettings.BucketSize       := BucketSize;
    ReportSettings.SumBucketsQty    := SumBucketsQty;
    ReportSettings.Report_Date_From := Date_from;// + Time_from;
    ReportSettings.SheetName        := SheetName;
    ReportSettings.ShowExcel        := ShowExcel;
    ShowMessage(BucketReport(ReportSettings));

    //new form preview
    {var info := BucketReport(ReportSettings);
    if info <> '' then
      showmessage(info);   }

 // except
 //   on e:Exception do MessageDlg('FMBucketExcelReport - GetBucketData'+#13'Message: '+e.Message,mtError, [mbOK],0);
 // end;
  ReportSettings.NativeExcel.Free;
end;

procedure TFBucketReport.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFBucketReport.BtnExcelBucketReportClick(Sender: TObject);
var
  saveDialog : TSaveDialog;
begin
//  try

    if (CBBucketType.ItemIndex = 4) and (ComboBoxCalList.ItemIndex = -1) then
    begin
      ShowMessage(_('Please selecet a calendar code'));
      exit;
    end;

    saveDialog := TSaveDialog.Create(self);
    saveDialog.Title := _('Save resource report as') + ':';
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

    SheetName := 'MQM Bucket Report';
    FileName  := saveDialog.FileName;
    bucketNumber := StrToInt(EditBucketNumber.text);
    case CBBucketType.ItemIndex of
       -1:  BucketSize := 30 ;
        0:  BucketSize := 30 ;
        1:  BucketSize := 7 ;
        2:  BucketSize := 1;
        3:  BucketSize := -1; //   1/24; hourly
        4:  BucketSize := -2 //   1/24; Shift
    end;
    RoundLevel := (-1) * CBRound.ItemIndex;
    if RoundLevel > 0 then RoundLevel := 0;
    Date_from := Int(DateTimePickerDate.Date);
    Time_from := Frac(DateTimePickerTime.Time);
    GetBucketData;
    saveDialog.Free;
 // except
 //   on e:Exception do MessageDlg('FMBucketExcelReport - BtnExcelBucketReportClick'+#13'Message: '+e.Message,mtError, [mbOK],0);
 // end;
end;

//----------------------------------------------------------------------------//

procedure TFBucketReport.CBBucketTypeChange(Sender: TObject);
begin
  if cbBucketType.ItemIndex = 4 then
  begin
    Label7.Visible := True;
    ComboBoxCalList.Visible := True;
  end else
  begin
    Label7.Visible := False;
    ComboBoxCalList.Visible := False;
    ComboBoxCalList.Text := '';
  end;

end;

procedure TFBucketReport.ChkLstBoxWkcClickCheck(Sender: TObject);
var
  wkc_List   : TList;
  wkc        : TMqmWrkCtr;
  res        : TMqmRes;
  subres     : TMqmVisibleRes;
  i, j, k,
  SubResIndex: Integer;
begin
  try
    wkc_List := p_pl.p_AllWrkCtr;
    for i := 0 to p_pl.p_WrkCtrsCount - 1 do
    begin
      wkc := TMqmWrkCtr(Wkc_List[i]);
      if ChkLstBoxWkc.ItemIndex <> i then continue;
      for j:= 0 to wkc.p_ResCount - 1 do
      begin
        for k := 0 to ChkLstBoxRsc.Items.Count - 1 do
        begin
          res := TMqmRes(wkc.p_Res[j]);
          if (ChkLstBoxWkc.Checked[i]) and (res.p_ResCode = ChkLstBoxRsc.Items.Strings[k])
            and (not ChkLstBoxRsc.Checked[k]) then ChkLstBoxRsc.Checked[k] := True
          else if (not ChkLstBoxWkc.Checked[i]) and (res.p_ResCode = ChkLstBoxRsc.Items.Strings[k])
            and (ChkLstBoxRsc.Checked[k]) then ChkLstBoxRsc.Checked[k] := False;
          // Take care of Subresources
          if res.p_isMultiRes then
          begin
            SubResIndex := 1;
            while (Assigned(res.GetSubRes(SubResIndex))) do
            begin
              subres := res.GetSubRes(SubResIndex);
              SubResIndex := SubResIndex + 1;
                if (ChkLstBoxWkc.Checked[i]) and (res.p_ResCode + SUBRESSEPARATOR +
                  IntToStr(subres.p_SubCode) = ChkLstBoxRsc.Items.Strings[k])
                  and (not ChkLstBoxRsc.Checked[k]) then
                  ChkLstBoxRsc.Checked[k] := True
                else if (not ChkLstBoxWkc.Checked[i]) and (res.p_ResCode + SUBRESSEPARATOR +
                  IntToStr(subres.p_SubCode) = ChkLstBoxRsc.Items.Strings[k])
                  and (ChkLstBoxRsc.Checked[k]) then
                  ChkLstBoxRsc.Checked[k] := False;
            end;
          end;
        end;
      end;
    end;
  except
    on e:Exception do MessageDlg('FMBucketExcelReport - ChkLstBoxWkcClickCheck'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBucketReport.EditBucketNumberChange(Sender: TObject);
begin
  if not IsNumeric(EditBucketNumber.Text, 'i') then EditBucketNumber.Text := '1';
end;

//----------------------------------------------------------------------------//

end.

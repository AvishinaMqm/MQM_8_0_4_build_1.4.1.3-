unit FMSavedPlanCopy;

interface

uses
  UReShape, cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.Menus, cxGraphics, dxUIAClasses, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TSavedPlanCopy = class(TForm)
    Panel1: TPanel;
    LableName: TLabel;
    EditName: TEdit;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    dtFrom: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    dtTo: TDateTimePicker;
    sgMain: TStringGrid;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    eDesc: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure dtFromChange(Sender: TObject);
  private
  public
    ListSavedPlanCopy : TList;
    constructor CreateSavedPlanCopy(AOwner: TComponent);
  end;

implementation

  uses gnugettext, UMObjCont, UMPlan, DMsrvPc, UMTblDesc, UMGlobal, FMWait, StrUtils;
{$R *.dfm}

//----------------------------------------------------------------------------//

procedure TSavedPlanCopy.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

//----------------------------------------------------------------------------//

procedure TSavedPlanCopy.BtnOkClick(Sender: TObject);
var i, x : Integer;
begin
  x := 0;

  for I := 0 to sgMain.RowCount - 1 do
    if sgMain.Cells[0, i] = EditName.Text then
    begin
      MessageDlg(_('Name of set already exists!'), mtError, [mbOk], 0);
      exit;
    end;

  for I := 0 to sgMain.RowCount - 1 do
    if Trim(sgMain.Cells[0, i]) <> '' then
      inc(x);

  if x = 6 then
  begin
    MessageDlg(_('You cannot create more than 5 sets!'), mtError, [mbOk], 0);
    exit;
  end;

  if EditName.Text = '' then
  begin
    MessageDlg(_('Name cannot be empty!'), mtError, [mbOk], 0);
    exit;
  end;

  if dtFrom.DateTime > dtTo.DateTime then
  begin
    MessageDlg(_('Invalid dates!'), mtError, [mbOk], 0);
    exit;
  end;

  ListSavedPlanCopy :=  p_pl.GetListForSavedPlan(EditName.Text, dtFrom.DateTime, dtTo.DateTime);

  if ListSavedPlanCopy.Count = 0 then
  begin
    MessageDlg(_('Selected date range don''t have jobs!'), mtWarning, [mbOk], 0);
    exit;
  end;

  TFWait.CreateWaitFormSavedPlan(self, w_SavedPlanCopy, EditName.Text , eDesc.Text, dtFrom.DateTime, dtTo.DateTime, ListSavedPlanCopy).ShowModal;

  sgMain.Cells[0, x] := EditName.Text;
  sgMain.Cells[1, x] := eDesc.Text;
  sgMain.Cells[2, x] := DateTimeToStr(dtFrom.DateTime);
  sgMain.Cells[3, x] := DateTimeToStr(dtTo.DateTime);

  //ModalResult := mrOk;
end;

//----------------------------------------------------------------------------//

procedure SortStringGrid(var GenStrGrid: TStringGrid; ThatCol: Integer);
const
  TheSeparator = '@';
var
  CountItem, I, J, K, ThePosition: integer;
  MyList: TStringList;
  MyString, TempString: string;
begin
  CountItem := GenStrGrid.RowCount;
  MyList        := TStringList.Create;
  MyList.Sorted := False;

  try
    begin

      for I := 1 to (CountItem - 1) do
      begin
        MyList.Add(GenStrGrid.Rows[I].Strings[ThatCol] + TheSeparator +
          GenStrGrid.Rows[I].Text);
      end;

      Mylist.Sort;

      for K := 1 to Mylist.Count do
      begin
        MyString := MyList.Strings[(K - 1)];
        ThePosition := Pos(TheSeparator, MyString);
        TempString  := '';
        TempString := Copy(MyString, (ThePosition + 1), Length(MyString));
        MyList.Strings[(K - 1)] := '';
        MyList.Strings[(K - 1)] := TempString;
      end;

      for J := 1 to (CountItem - 1) do
        GenStrGrid.Rows[J].Clear;

      j := 1;
      K := 1;

      while j <= CountItem - 1 do
      begin
        if MyList[(J - 1)].IndexOf(#$D#$A) = 0
          //or (MyList[(J - 1)] = '#$D#$A#$D#$A#$D#$A#$D#$A')
        then
        begin
          inc(j);
          continue;
        end;

        GenStrGrid.Rows[k].Text := MyList.Strings[(J - 1)];
        inc(j);
        Inc(k);
      end;

    end;

  finally
    MyList.Free;
  end;

end;

procedure TSavedPlanCopy.Button1Click(Sender: TObject);
var s : String;
  qry : TMqmQuery;
  tbInfoHeader, tbInfo: ^TTblInfo;
begin
  //if lbList.Items.Count = 0 then exit;

  if sgMain.Cells[sgMain.Col, sgMain.Row] = '' then exit;


  qry := CreateQuery(Main_DB);
  tbInfoHeader := @tblInfo[tbl_SavedPlanCopyHeader];
  tbInfo := @tblInfo[tbl_SavedPlanCopy];

  //s := lbList.Items[lbList.ItemIndex];
  s := sgMain.Cells[0, sgMain.Row];
  if MessageDlg(_('Do you want to delete ') + s + ' ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin

    //lbList.Items.Delete(lbList.ItemIndex);
    sgMain.Rows[sgMain.Row].Clear;
    SortStringGrid(sgMain, 0);
    qry.Connection.StartTransaction;

    qry.Connection.ExecSQL('delete from ' + tbInfoHeader.GetTableName
      + ' where CPH_IDENTIFIER = ' + IniAppGlobals.Identifier + ' and CPH_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode)
      + ' and CPH_SET_NAME = ' + QuotedStr(s));

    qry.Connection.ExecSQL('delete from ' + tbInfo.GetTableName
      + ' where CP_IDENTIFIER = ' + IniAppGlobals.Identifier + ' and CP_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode)
      + ' and CP_SET_NAME = ' + QuotedStr(s));

    qry.Connection.Commit;

    MessageDlg('Deleted!', mtInformation, [mbOk], 0);
  end;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

constructor TSavedPlanCopy.CreateSavedPlanCopy(AOwner: TComponent);
var qry : TMqmQuery;
  tbInfoHeader: ^TTblInfo;
begin
  inherited Create(AOwner);

  dtFrom.Date := now();
  dtTo.Date := now();

  sgMain.ColWidths[0] := 90;
  sgMain.ColWidths[1] := 210;
  sgMain.ColWidths[2] := 100;
  sgMain.ColWidths[3] := 100;
  sgMain.Cells[0,0] := _('Set name');
  sgMain.Cells[1,0] := _('Description');
  sgMain.Cells[2,0] := _('Date from');
  sgMain.Cells[3,0] := _('Date to');
  qry := CreateQuery(Main_DB);
  tbInfoHeader := @tblInfo[tbl_SavedPlanCopyHeader];

  qry.SQL.Text := 'Select CPH_SET_NAME, CPH_SET_DESC, CPH_START_DATE, CPH_END_DATE from ' + tbInfoHeader.GetTableName
    + ' where CPH_IDENTIFIER = ' + IniAppGlobals.Identifier + ' and CPH_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode);
  qry.Open;
  var i := 1;
  while not qry.EOF do
  begin
    sgMain.Cells[0,i] := Trim(qry.FieldByName('CPH_SET_NAME').AsString);
    sgMain.Cells[1,i] := Trim(qry.FieldByName('CPH_SET_DESC').AsString);
    sgMain.Cells[2,i] := qry.FieldByName('CPH_START_DATE').AsString;
    sgMain.Cells[3,i] := qry.FieldByName('CPH_END_DATE').AsString;
    Inc(I);
    qry.Next;
  end;

  qry.Close;
  qry.Free;
end;

procedure TSavedPlanCopy.dtFromChange(Sender: TObject);
begin
  dtTo.Date := dtFrom.Date + 14;
end;

//----------------------------------------------------------------------------//

procedure TSavedPlanCopy.FormCreate(Sender: TObject);
begin
  ReShape(Self);
end;

end.

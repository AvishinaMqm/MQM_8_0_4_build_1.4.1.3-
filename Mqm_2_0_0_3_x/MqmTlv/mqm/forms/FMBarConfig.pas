//******************************************************************************
// This form shows a list of fields and properties per set . The set can be
// Applied per Work Center . The user can also create and delete sets.
// The set in focus in the Combo box is the active set.
// If there is no set configured for the Wkc then a default set is returned.
// all the data is kept in two lists
// BarSetList keeps all the sets with their name
// WkcSetList keeps all the WorkCenters with their sets
//******************************************************************************
unit FMBarConfig;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls, UReShape, StrUtils,
  UMBinDefault,
  UMSchedContFunc,
  DMsrvPc,
  UMTblDesc,
  UMObjCont,
  UMWkCtr,
  gnugettext,
  UMSchedOnPlan,
  UMDescUM,
  UMRes,
  UmCompat,
  UmGlobal,
  TypInfo,
  variants, Buttons, ComCtrls, UGGlobal,VCL.Samples.Spin;

type
  // holds one row of the set
  TBarCurrentSet = Record
    Field     : integer;//
    FieldName : string;
    BinColId  : CBinColId;
    OrgTitle  : string;
    Title     : string;
    Checked   : boolean;
    FromPos   : integer;
    ToPos     : integer;
    Width     : integer;
    Visible   : boolean;
    PropertyCode : string;
    SetType      : string;
    SetName      : string;
    LineSeq  : Integer;
    LineNum  : Integer;
  end;
  PTBarCurrentSet = ^TBarCurrentSet;

  // one set
    PTBarItem = ^TBarCurrentSet;
//    PTBarSetListItems = ^TList;

  //holds one set and it's name
  TBarDefinitionSet = Record
    set_type    : String; //job bar or status bar
    set_name    : String;
 //   Index   : Integer;
    workstation : String;
    CurrentSet: TList;
  end;
  PTBarDefinitionSet = ^TBarDefinitionSet;

  //holds one set Name and the Wkc to apply to
  TWorkCenterBarSet = Record
    WKC_Code    : String;
    set_name    : String;
    set_type    : String; //job bar or status bar
    workstation : String;
    CurrentSet  : TList;
  end;
  PTWorkCenterBarSet = ^TWorkCenterBarSet;

  TFBarConfig = class(TForm)
    GroupBox3: TGroupBox;
    SB_Frames: TScrollBox;
    Label2: TLabel;
    Label3: TLabel;
    LblSetName: TLabel;
    GroupBox2: TGroupBox;
    CLBWorkCenters: TCheckListBox;
    Bevel1: TBevel;
    BitOK: TcxButton;
    BitAbort: TcxButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Labell: TLabel;
    constructor Create(AOwner: TComponent; setT,setN: string); reintroduce;
    procedure CreateFrameArray(setName: String);
    procedure CreateNewFrame(var BaseFrame: Tframe; index: integer);
    procedure FillFrameData(BarConfig : TList;var SetName: String; SetIndex,frameIndex: Integer; BinColId : CBinColId);
    function  getBarSet(var SetName: string):TList;
    procedure SetNewSet(SetName: string; NewCfg : TList);
    procedure FindSetIndex(SetName: String; Var setIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SaveBarDataToDB(newset: boolean; SetName, SetType : string);
    procedure SaveWkcSetToDB(SetType : string);
    function  Save(newset,SaveBarData,SaveWkcSet: boolean; SetName, SetType : string): boolean;
    procedure SaveDataToMemory(setName, setType: string); //; NewSet: boolean);
    destructor Destroy; override;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function  deleteSet(SetName, SetType: String): boolean;
    procedure BtnSaveChangesClick(Sender: TObject);
    procedure deleteWkcSet(SetName, SetType: String);
    procedure UpdateWkcCLB(setName: String);
//    procedure ChangeActiveSet(setName, SetType: String);
    //not used currently
    procedure enableRowClick(Sender: TObject);
    procedure BitCloseClick(Sender: TObject);
    function CheckNameIfValid(NewSetName: string): boolean;
    procedure GetSetNames(var WkcList: Tstrings; setType : String);
    procedure SaveWorkCentersList;
    procedure CreateNewSet(setName,setType: string);
//    procedure CLBWorkCentersClickCheck(Sender: TObject);
    function  IsWkcAvaliable(workcenter: String): boolean;
    procedure Panel1Click(Sender: TObject);
    procedure SB_FramesMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

  private
    { Private declarations }
     PropCodeSavedInDB : boolean;
     frameArray: Array [0..BinColNum] of TFrame;  //83 columns
  public
    m_Abort : boolean;
    { Public declarations }
  end;

  procedure LoadBarDataFromDB();
  procedure LoadWkcSetsFromDB();
  function  GetValueOfField(index,WkcIndex: Integer; sc:TSCProdSched; isGroup: boolean; BinColId : CBinColId):variant;//ProdReqDet: TSCProdReqDet): String;
  function  GetPropertyValue(PropertyIndex: Integer; sc:TSCProdSched):variant;
  function  GetBarString(workcenter: String; sc:TSCProdSched; isGroup: boolean;  isJobBar:boolean; LineNumber: Integer):string;//ProdReqDet: TSCProdReqDet):string;
  function GetLineNumber(workcenter: String; isJobBar:boolean): Integer;
  procedure ClearBarSetList;
  procedure ClearWkcSetList;

var
  FBarConfig: TFBarConfig;
  m_Save,m_NoDuplicates : boolean;

implementation

uses UMCOmmon;

{$R *.DFM}

var
  BarSetList : Tlist;
  WkcSetList : Tlist;
  m_FoundJobBarPropSavedInDB, m_FoundStatusBarPropSavedInDB : boolean;
  setType,
  GlobalSetName    : string;

//----------------------------------------------------------------------------//

constructor TFBarConfig.Create(AOwner: TComponent; setT,setN: string);
begin
  inherited Create(AOwner);
  setType := setT;

  if setType = 'Job_bar' then
  begin
    Caption := _('Configuration of job bar set');
    PropCodeSavedInDB := m_FoundJobBarPropSavedInDB;
  end
  else
  begin
    Caption := _('Configuration of status bar set');
    PropCodeSavedInDB := m_FoundStatusBarPropSavedInDB;
    Width := Width - 100;
    sb_Frames.width := sb_Frames.width - 100;
  end;
  GlobalSetName := setN;

  ReShape(Self);

end;

{
********************************************************************************
  This procedure creates the actual frame.
  @param BaseFrame is a frame object being returned
  @param index is the frame index in the frame array
********************************************************************************
}

procedure TFBarConfig.createNewFrame(var BaseFrame: Tframe; Index: Integer);
var
  CB_Field: TCheckBox;
  Lbl_to: TLabel;
  Edit_Heading: TEdit;
  Edit_From: TEdit;
  Edit_To: TEdit;

  LineNum,LineSeq : TSpinEdit;
  CurLeft : Integer;
begin
  BaseFrame := TFrame.Create(self);
  BaseFrame.parent := self;
  BaseFrame.Width := SB_frames.Width - 10;
  //BaseFrame.top:=10;
  //BaseFrame.Left := 0;
  //BaseFrame.Top := 0;
  //  BaseFrame.Width := 415 * Screen.PixelsPerInch div DEFAULT_DPI+100;
  //  BaseFrame.Height := 31 * Screen.PixelsPerInch div DEFAULT_DPI;
    BaseFrame.TabOrder := 0;
  BaseFrame.Font.Name := 'Montserrat';

  CurLeft := 10;
  Labell.Left := CurLeft;

  CB_Field:= TCheckBox.Create(BaseFrame);
  with CB_Field do
  begin
    Parent := BaseFrame;
    Left := CurLeft;
    Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI-6;
    Width := 230;
    //Height := 30;
    Height := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
    Caption := '';
    TabOrder := 0 ;
   // CB_Field.OnClick := enableRowClick;
    Name := 'CB' + inttostr(index);
    StyleName := 'datatex1';
    Font.Name := 'Montserrat';
  end;

  CurLeft := CB_Field.Left + CB_Field.width;
  Label2.Left := CurLeft;

  Edit_heading := TEdit.Create(BaseFrame);
  with Edit_heading do
  begin
    Parent := BaseFrame;
    Left := CurLeft;
    Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI-6;
    Width := 230;
    Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
    TabOrder := 1;
    StyleName := 'datatex1';
    Font.Name := 'Montserrat';
  end;

  CurLeft := Edit_heading.Left + Edit_heading.width + 10;
  Label3.Left := CurLeft+10;

  Edit_From := TEdit.Create(BaseFrame);
  with Edit_From do
  begin
    Parent := BaseFrame;
    Left := CurLeft;
    Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI-6;
    Width := 25;
    Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
    TabOrder := 2 ;
    Text := '0';
    StyleName := 'datatex1';
    Font.Name := 'Montserrat';
  end;

  CurLeft := Edit_From.Left + Edit_From.width + 10;

  Lbl_to := TLabel.Create(BaseFrame);
  with Lbl_to do
  begin
    Parent := BaseFrame;
    Left := CurLeft;
    Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI-6;
    Width := 20;
    Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
    Alignment := taCenter;
    Anchors := [akLeft, akBottom];
    Caption := 'to';
    StyleName := 'datatex1';
    Font.Name := 'Montserrat';
  end;

  CurLeft := Lbl_to.Left + Lbl_to.width + 10;

  Edit_To := TEdit.Create(BaseFrame);
  with Edit_To do
  begin
    Parent := BaseFrame;
    Left := CurLeft;
    Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI-6;
    Width := 25;
    Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI ;
    TabOrder := 2 ;
    Text := '40';
    StyleName := 'datatex1';
    Font.Name := 'Montserrat';
  end;

  if setType = 'Job_bar' then
  begin

  CurLeft := Edit_To.Left + Edit_To.width + 20;


    LineNum := TSpinEdit.Create(BaseFrame);
    with LineNum do
    begin
      Parent := BaseFrame;
      Left := CurLeft;
      Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI-6;
      Width := 40 ;
      Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI ;
      TabOrder := 4;
      MinValue := 1;
      MaxValue := 4;
      StyleName := 'datatex1';
      //Font.Name := 'Montserrat';
    end;

    Label4.Left := LineNum.Left;
    CurLeft := LineNum.Left + LineNum.width+30;

    Label1.Left := CurLeft;

    LineSeq := TSpinEdit.Create(BaseFrame);
    with LineSeq do
    begin
      Parent := BaseFrame;
      Left := CurLeft;
      Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI-6;
      Width := 40 ;
      Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI ;
      TabOrder := 3 ;
      MinValue := 0;
      MaxValue := 9;
      StyleName := 'datatex1';
      //Font.Name := 'Montserrat';
    end;
  end;


  if setType = 'Job_bar' then
  begin
   // LineSeq.Visible := True;
    //LineNum.Visible := True;
    Label1.Visible := True;
    Label4.Visible := True;
  end else
  begin
   // LineSeq.Visible := False;
   // LineNum.Visible := False;
    Label1.Visible := False;
    Label4.Visible := False;
  end;
end;

{
********************************************************************************
  This procedure creates all the frames in the scroll box.
  Each frame is part of an array.
  we create only BinColNum frames.
  @param setName the name of the set
********************************************************************************
}
procedure TFBarConfig.createFrameArray(setName: String);
var
  I, J, LastIndex, skippedRows: Integer;
  BarConfig: TList;
  BarItemTest: PTBarItem;
  BarItem: PTBarItem;
  propertyIndex: Integer;
  pId: TPropId;
  PropCode: string;
  foundPropInList: Boolean;
begin
  skippedRows := 0;
  BarConfig := getBarSet(setName);

  // --------------------------------------------
  // SAFETY: BarConfig must not be NIL
  // --------------------------------------------
  if BarConfig = nil then
    raise Exception.Create('BarConfig is NIL. getBarSet returned nothing.');

  propertyIndex := getNumberfields;

  // --------------------------------------------
  // MAIN LOOP
  // --------------------------------------------
  for I := 0 to BarConfig.Count - 1 do
  begin
    // SAFETY: protect invalid pointers
    if (I < 0) or (I >= BarConfig.Count) then
      Continue;

    BarItemTest := BarConfig[I];
    if BarItemTest = nil then
      Continue;

    if (BarItemTest.SetType <> setType) then
      Continue;

    // SAFETY: BinDefaultTabColumnSet bounds
    if (I > High(BinDefaultTabColumnSet)) then
      Continue;

    if not BinDefaultTabColumnSet[I].Visible then
    begin
      Inc(skippedRows);
      Continue;
    end;

    // SAFETY: Check ShowBinPropArry
    if (I + 1) > propertyIndex then
    begin
      if (I - propertyIndex) <= High(DBAppGlobals.ShowBinPropArry) then
      begin
        pId := DBAppGlobals.ShowBinPropArry[I - propertyIndex];
        if pId = nil then
          Continue;
      end
      else
        Continue;
    end;

    // SAFETY: frameArray bounds
    if (I > High(frameArray)) then
      raise Exception.Create('frameArray too small for index ' + I.ToString);

    // Create frame if needed
    if not Assigned(frameArray[I]) then
    begin
      createNewFrame(frameArray[I], I);

      if frameArray[I] = nil then
        raise Exception.Create('createNewFrame did not create instance.');

      // SAFETY: SB_Frames must exist
      if SB_Frames = nil then
        raise Exception.Create('SB_Frames is NIL.');

      frameArray[I].Parent := SB_Frames;
      frameArray[I].Left := -3;
      frameArray[I].Top := (I - skippedRows) * 30;
      frameArray[I].Name := 'Frame' + IntToStr(I);
    end;

    // SAFETY: BarItemTest may be overwritten later — safe to use now
    FillFrameData(BarConfig, setName, 0, I, BarItemTest.BinColId);

    LastIndex := I;
  end; // for

  m_Abort := false;

  UpdateWkcCLB(setName);

  if not PropCodeSavedInDB then
    Exit;

  Inc(LastIndex);

  // -------------------------------------------------------------
  // ADD PROPERTIES NOT IN LIST
  // -------------------------------------------------------------
  for J := 0 to High(DBAppGlobals.ShowBinPropArry) do
  begin
    if LastIndex > High(BinColDefault) then
      Break;

    if DBAppGlobals.ShowBinPropArry[J] = nil then
      Break;

    pId := DBAppGlobals.ShowBinPropArry[J];
    PropCode := GetPropCodeFromID(pId);

    foundPropInList := False;

    // Search inside BarConfig
    for I := 0 to BarConfig.Count - 1 do
    begin
      BarItemTest := BarConfig[I];
      if BarItemTest = nil then Continue;

      if (BarItemTest.SetType <> setType) then
        Continue;

      if PropCode = BarItemTest.PropertyCode then
      begin
        foundPropInList := True;
        Break;
      end;
    end;

    if not foundPropInList then
    begin
      // SAFETY: Frame bounds
      if (LastIndex > High(frameArray)) then
        raise Exception.Create('frameArray too small at new property index ' + LastIndex.ToString);

      // Create frame if needed
      if not Assigned(frameArray[LastIndex]) then
      begin
        createNewFrame(frameArray[LastIndex], LastIndex);

        if SB_Frames = nil then
          raise Exception.Create('SB_Frames is NIL on additional properties.');

        frameArray[LastIndex].Parent := SB_Frames;
        frameArray[LastIndex].Left := -3;
        frameArray[LastIndex].Top := (LastIndex - skippedRows) * 30;
        frameArray[LastIndex].Name := 'Frame' + IntToStr(LastIndex);
      end;

      // SAFETY: Create new item
      New(BarItem);
      if BarItem = nil then
        raise Exception.Create('Failed to New BarItem');

      BarItem.Checked := False;
      BarItem.PropertyCode := PropCode;
      BarItem.OrgTitle := GetPropDescr(pId);
      BarItem.Title := BarItem.OrgTitle;

      // SAFETY: BinColDefault bounds
      if (LastIndex <= High(BinColDefault)) then
        BarItem.FieldName := BinColDefault[LastIndex].FieldName;

      BarItem.LineSeq := 0;
      BarItem.LineNum := 1;

      BarConfig.Add(BarItem);

      // SAFETY: DO NOT use BarItemTest here — use BarItem
      FillFrameData(BarConfig, setName, 0, LastIndex, BarItem.BinColId);

      Inc(LastIndex);
    end;
  end;
end;

{
********************************************************************************
  This procedure creates the actual frame.
  @param BaseFrame is a frame object being returned
  @param index is the frame index in the frame array
********************************************************************************
}
function TFBarConfig.getBarSet(var SetName: string):Tlist;
var
  setIndex: Integer;
  DefSet: PTBarDefinitionSet;
begin
  result := nil;

  setIndex := 0;
  DefSet := BarsetList.Items[0];

  Assert(Assigned(DefSet));
  if (DefSet.set_name <> SetName) or (DefSet.set_type <> setType) then
  begin
    findsetIndex(SetName,setIndex);
    //In case we didn't find the setname ,try to take the one
    //in view of the combo box.
    if setIndex < 0 then
    begin
      DefSet := BarsetList.Items[0];
      setName := DefSet.set_name;
      findsetIndex(setName,setIndex);
      if setIndex < 0 then exit; //no sets do exist
    end;
    DefSet := BarsetList.Items[SetIndex];
  end;
  Result := DefSet.CurrentSet;
end;

{
********************************************************************************
  This procedure fills the frame with it's data - what is checked , name etc.
  @param setname is the name of the set - each set has different data
  @param Setindex is the index of the set in the DB
  @param frameindex is the index of frame in the frame array
********************************************************************************
}

{function ReturnBarItem(BarConfig : TList; BinColId : CBinColId) : PTBarItem;
var
  I : Integer;
begin
  for I := 0 to BarConfig.Count - 1 do
  begin
    if PTBarItem(BarConfig[I]).BinColId = BinColId then
    begin
      Result := BarConfig[I];
      Exit;
    end;

  end;

end;   }



procedure TFBarConfig.FillFrameData(BarConfig : TList; var SetName: String; SetIndex,frameIndex: Integer; BinColId : CBinColId);
var
  j: Integer;
  PropDescription: String;
//  BarConfig: TList;
  BarItem : PTBarItem;
  pId: TPropId;
  propertyIndex: Integer;
begin
//  try
  propertyIndex := getNumberfields;
//  BarConfig := getBarSet(setName);
  //loop over the components of the frame and fill their data
  try
  for j := 0 to (frameArray[frameIndex].ComponentCount -1) do
  begin

   BarItem := BarConfig.Items[frameIndex];

   case j of
       0: begin
            TCheckBox(frameArray[frameIndex].Components[j]).Checked := BarItem.Checked;

            if PropCodeSavedInDB then
            begin
              if BarItem.PropertyCode <> '' then
              begin
                BarItem.Checked := BarItem.Checked;
               // BarItem.FromPos := 0;
               // BarItem.ToPos := 0;

              end;
            end
            else if (frameIndex + 1)> propertyIndex then  // for properties get their name and values
              begin
                pId :=DBAppGlobals.ShowBinPropArry[frameIndex - propertyIndex];
                if pId = nil then exit;
                PropDescription := GetPropDescr(pId);//GetPropCodeFromID(pId);
                BarItem.OrgTitle :=  PropDescription;//BinDefaultTabColumnSet[j].Title;
                BarItem.Field := frameIndex;
                BarItem.PropertyCode := GetPropCodeFromID(pId);
                BarItem.Checked := BarItem.Checked;
                BarItem.FromPos := 0;
                BarItem.ToPos := 0;
                BarItem.LineSeq := 0;
                BarItem.LineNum := 1;
              end;

            TCheckBox(frameArray[frameIndex].Components[j]).Caption := BarItem.OrgTitle;
          end;
       1: TEdit(frameArray[frameIndex].Components[j]).Text := BarItem.Title;

       2: TEdit(frameArray[frameIndex].Components[j]).Text := IntToStr(BarItem.FromPos);

       4: TEdit(frameArray[frameIndex].Components[j]).Text := IntToStr(BarItem.ToPos);

       5: begin
        if setType = 'Job_bar' then
          TSpinEdit(frameArray[frameIndex].Components[j]).Value := BarItem.LineNum ;
       end;
       6: begin
        if setType = 'Job_bar' then
          TSpinEdit(frameArray[frameIndex].Components[j]).Value := BarItem.LineSeq;
       end;

     end; //case

   end; //for j

  except
    BarItem.ToPos := 0;
  end;
{   except
     on e:Exception do MessageDlg('FMBarConfig - FillFrameData'+#13'Message: '+e.Message,mtError, [mbOK],0);
  //   exit;
   end; }

end;

{
********************************************************************************
  This procedure creates the form

********************************************************************************
}

procedure TFBarConfig.FormCreate(Sender: TObject);
var
  i: Integer;
  workcenter: String;
  ExistOneWc : boolean;
begin
//  try
  m_Abort := false;
  m_Save := false;
  ExistOneWc := false;
  TranslateComponent(self);
 // ScaleFormSize(Self, Screen.PixelsPerInch);


  CLBWorkCenters.Items.Clear;

  for i := 0 to p_pl.p_WrkCtrsCount-1 do
  begin
    workcenter := TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_WrkCtrCode;
    CLBWorkCenters.Items.Add(workcenter);
    if IsWkcAvaliable(workcenter) then
    begin
      CLBWorkCenters.ItemEnabled[i] := true;
      ExistOneWc := true
    end
    else
      CLBWorkCenters.ItemEnabled[i] := false;
  end;

  if not ExistOneWc then
  begin
    ShowMessage(_('Set can not be applied to any work center'));
    deleteSet(GlobalsetName, SetType);
    m_Abort := true;
    Exit;
  end;
  LblSetName.Caption := _('Set name:') + ' ' + GlobalsetName;
  LblSetName.Font.Size := 20;
  //LblSetName.Left := width div 2 - Length(LblSetName.Caption);
  createFrameArray(GlobalsetName); //show the active set
//  except
//    on e:Exception do MessageDlg('FMBarConfig - FormCreate'+#13'Message: '+e.Message,mtError, [mbOK],0);
//  end;
end;

{
********************************************************************************
  This procedure loads the sets data from the DB.
  Is called from the FMMainPlan FormCreate
********************************************************************************
}

procedure LoadBarDataFromDB();
var
 temp, I, B, A , PropPosition:       integer;
 NewFieldToAdd,IsExistProp : boolean;
 qry:        TMqmQuery;
 tbInfo:     ^TTblInfo;
 BarConfig:  TList;
 BarItem, BarItemCheck, NewBarItem:    PTBarItem;
// Index,
// setIndex :  integer;
 DefSet:     PTBarDefinitionSet;
 setName,
 PrevSetName,
 setType,
 PrevSetType,
 CurrentWS:  String;
 FieldName : string;
 TempFieldList : TStringList;
 pId: TPropId;
 PropCode : string;
 foundprop :  boolean;
 FoundPropSavedInDB : boolean;
 propertyIndex : integer;
 PropCodeSavedInDB : boolean;
 StatuS_bar_Lines : boolean;
begin
  //try
    BarConfig := nil;
    PropCodeSavedInDB := false;
    StatuS_bar_Lines := false;
    m_FoundJobBarPropSavedInDB := false;
    m_FoundStatusBarPropSavedInDB := false;
  //  Index := -1;
    SetName := '';
    BarsetList.Clear;
    qry := CreateQuery(Cfg_DB);
    tbInfo := @tblInfo[tbl_cfg_text_display_set_fields];
  //  SetFldPfx(tbInfo.pfx);
  ///  try
    TempFieldList := TStringList.create;
    CurrentWS := IniAppGlobals.WkstCode;
    propertyIndex := getNumberfields;

    qry.SQL.Clear;
    qry.SQL.Add('select * from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_PropertyCode) + '<> ''' + '' + '''');
    qry.SQL.Add(' AND ' + CreateFld(tbInfo.pfx, fli_settype) + '= ''' + 'Job_bar' + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.open;
    if not qry.Eof then  //No data in DB
       m_FoundJobBarPropSavedInDB := true;
    qry.close;

    qry.SQL.Clear;
    qry.SQL.Add('select * from ' + tbInfo.GetTableName);
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_PropertyCode) + '<> ''' + '' + '''');
    qry.SQL.Add(' AND ' + CreateFld(tbInfo.pfx, fli_settype) + '= ''' + 'Status_bar' + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.open;
    if not qry.Eof then  //No data in DB
       m_FoundStatusBarPropSavedInDB := true;
    qry.close;

    qry.SQL.Clear;
    qry.SQL.Add('select * from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_workstation) + '= ''' + CurrentWS + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.SQL.Add(' order by '+ CreateFld(tbInfo.pfx, fli_settype));//CreatePfxFld(fli_setIndex));
    qry.SQL.Add(', ' + CreateFld(tbInfo.pfx, fli_setname));
    qry.SQL.Add(', ' + CreateFld(tbInfo.pfx, fli_fieldType));
    qry.open;

    if qry.Eof then  //No data in DB
    begin
      exit;
    end;//EOF

    while not qry.Eof do
    begin
      setName := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setName)).AsString;
      setType := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setType)).AsString;
      if  ( setName <> PrevSetName ) or (setType <> PrevSetType )then
      begin
        Application.ProcessMessages;
        PrevSetName       := setName;
        PrevSetType       := setType;
        BarConfig        := Tlist.Create;
        new(DefSet);
        DefSet.set_name    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setName)).AsString;
        DefSet.set_Type    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setType)).AsString;
        DefSet.workstation := qry.FieldByName(CreateFld(tbInfo.pfx, fli_workstation)).AsString;
        DefSet.CurrentSet  := BarConfig;
        BarSetList.Add(DefSet);
      end;

      if setType = 'Job_bar' then
         PropCodeSavedInDB := m_FoundJobBarPropSavedInDB
      else if setType = 'Status_bar' then
         PropCodeSavedInDB := m_FoundStatusBarPropSavedInDB;

      if PropCodeSavedInDB and (qry.FieldByName(CreateFld(tbInfo.pfx, fli_FieldName)).AsString = 'CSC_property1') then
      begin

        while not qry.Eof do
        begin
          Application.ProcessMessages;
          /// we have 2 set : 1 job jar , 2 status_bar
          setName := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setName)).AsString;
          setType := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setType)).AsString;
          if  ( setName <> PrevSetName ) or (setType <> PrevSetType )then
          begin
            Application.ProcessMessages;
            PrevSetName       := setName;
            PrevSetType       := setType;
            BarConfig        := Tlist.Create;
            new(DefSet);
            DefSet.set_name    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setName)).AsString;
            DefSet.set_Type    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setType)).AsString;
            DefSet.workstation := qry.FieldByName(CreateFld(tbInfo.pfx, fli_workstation)).AsString;
            DefSet.CurrentSet  := BarConfig;
            BarSetList.Add(DefSet);
          end;

          new(BarItem);
          foundprop := false;

          for A := Low(DBAppGlobals.ShowBinPropArry) to High(DBAppGlobals.ShowBinPropArry) do
          begin
            if DBAppGlobals.ShowBinPropArry[A] = nil then break;
            pId := DBAppGlobals.ShowBinPropArry[A];
            if qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString = GetPropCodeFromID(pId) then
            begin
              foundprop := true;
              break
            end;
          end;

          BarItem.PropertyCode := '';
          if foundprop then
          begin
            BarItem.PropertyCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
           // pId :=DBAppGlobals.ShowBinPropArry[propertyIndex];
            FieldName := BinColDefault[propertyIndex].FieldName;
            Inc(propertyIndex);

            if propertyIndex >= High(BinColDefault) then break;

          end
          else
          begin
            FieldName     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FieldName)).AsString;
          end;


          BarItem.Field := qry.FieldByName(CreateFld(tbInfo.pfx, fli_fieldType)).AsInteger;//BinColDefault[].Field;
          BarItem.Title := qry.FieldByName(CreateFld(tbInfo.pfx, fli_title)).AsString; //
          BarItem.OrgTitle := qry.FieldByName(CreateFld(tbInfo.pfx, fli_orgTitle)).AsString; //
          temp := qry.FieldByName(CreateFld(tbInfo.pfx, fli_checked)).AsInteger;            //
          //if temp = 0 then
          BarItem.Checked := false;
          if (temp = 1) then BarItem.Checked := true;
          BarItem.FromPos := qry.FieldByName(CreateFld(tbInfo.pfx, fli_fromPos)).AsInteger;  //
          BarItem.ToPos := qry.FieldByName(CreateFld(tbInfo.pfx, fli_toPos)).AsInteger;      //
          BarItem.SetType       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setType)).AsString;
          BarItem.SetName       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SetName)).AsString;
         // FieldName     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FieldName)).AsString;   //
          BarItem.LineSeq := qry.FieldByName(CreateFld(tbInfo.pfx, fli_LineSeq)).asInteger;
          BarItem.LineNum := qry.FieldByName(CreateFld(tbInfo.pfx, fli_LineNumber)).asInteger;

          if trim(FieldName) = '' then
          begin
             BarItem.BinColId := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_fieldType)).AsInteger].Field; //
          end
          else
          begin
            for I := Low(BinColDefault) to High(BinColDefault) do
            begin
              if BinColDefault[I].FieldName = FieldName then
              begin
                if TempFieldList.indexof(FieldName) = 1 then
                  continue
                else
                begin
                  BarItem.BinColId := BinColDefault[I].Field;
                  BarItem.FieldName := FieldName;
                  Break;
                end;
              end;
            end;
          end;
          BarConfig.Add(BarItem);
          qry.Next;

          if qry.FieldByName(CreateFld(tbInfo.pfx, fli_setType)).AsString = 'Status_bar' then
          begin
            StatuS_bar_Lines := true;
            break
          end;
        end;

        if qry.Eof then
        begin
          qry.Close;
          qry.Free;
          exit;
        end;
      end;

      if StatuS_bar_Lines then
      begin
        StatuS_bar_Lines := false;
        propertyIndex := getNumberfields;
        continue
      end;
      new(BarItem);

      BarItem.Field := qry.FieldByName(CreateFld(tbInfo.pfx, fli_fieldType)).AsInteger;//BinColDefault[].Field;
      BarItem.Title := qry.FieldByName(CreateFld(tbInfo.pfx, fli_title)).AsString; //
      BarItem.OrgTitle := qry.FieldByName(CreateFld(tbInfo.pfx, fli_orgTitle)).AsString; //
      temp := qry.FieldByName(CreateFld(tbInfo.pfx, fli_checked)).AsInteger;            //
      //if temp = 0 then
      if temp = 0 then BarItem.Checked := false;
      if temp = 1 then BarItem.Checked := true;
      BarItem.FromPos := qry.FieldByName(CreateFld(tbInfo.pfx, fli_fromPos)).AsInteger;  //
      BarItem.ToPos := qry.FieldByName(CreateFld(tbInfo.pfx, fli_toPos)).AsInteger;      //
      FieldName     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FieldName)).AsString;   //
      BarItem.SetType       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setType)).AsString;
      BarItem.SetName       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SetName)).AsString;
      BarItem.LineSeq := qry.FieldByName(CreateFld(tbInfo.pfx, fli_LineSeq)).asInteger;
      BarItem.LineNum := qry.FieldByName(CreateFld(tbInfo.pfx, fli_LineNumber)).asInteger;

      //    BarItem.BinColId := BinColDefault[qry.FieldByName(CreatePfxFld(fli_fieldType)).AsInteger].Field;

      if trim(FieldName) = '' then
      begin
         BarItem.BinColId := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_fieldType)).AsInteger].Field; //
        // BarItem.FieldName := GetEnumName(TypeInfo(CBinColId), Ord(BarItem.BinColId));
      end
      else
      begin
        //BarItem.FieldName := BinColDefault[qry.FieldByName(CreatePfxFld(fli_fieldType)).AsInteger].FieldName;
        for I := Low(BinColDefault) to High(BinColDefault) do
        begin
          if BinColDefault[I].FieldName = FieldName then
          begin
            if TempFieldList.indexof(FieldName) = 1 then
            begin
             // ShowMessage('Found');
              continue
            end

            else
            begin
              TempFieldList.Add(FieldName);
              BarItem.BinColId := BinColDefault[I].Field;
              BarItem.FieldName := FieldName;
              Break;
            end;
          end;
        end;
      end;

      BarConfig.Add(BarItem);
      qry.Next;
    end;

  //except
  //  on e:Exception do MessageDlg('FMBarConfig - LoadBarDataFromDB'+#13'Message: '+e.Message,mtError, [mbOK],0);
  {
      qry.Close;        //Vinc
      trs.Commit;       //Vinc

      qry.Free;         //Vinc
      trs.Free;         //Vinc
      }
  //end;
end;

{
********************************************************************************
  This procedure loads the WorkCenter set names data from the DB.
  Is called from the FMMainPlan FormCreate
********************************************************************************
}

procedure LoadWkcSetsFromDB();
var
  qry:           TMqmQuery;
  tbInfo:        ^TTblInfo;
  i :            Integer;
  DefSet:        PTBarDefinitionSet;
  WorkCenterSet: PTWorkCenterBarSet;
  CurrentWS:     String;
begin
try
  WkcSetList.Clear;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_text_display_set_wkc];
//  SetFldPfx(tbInfo.pfx);

  CurrentWS := IniAppGlobals.WkstCode;

  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_workstation) + ' = ''' + CurrentWS + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.open;

  while not qry.Eof do
  begin
    new(WorkCenterSet);
    Application.ProcessMessages;
    WorkCenterSet.WKC_Code    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString;
    WorkCenterSet.set_name    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_setName)).AsString;
    WorkCenterSet.set_Type    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SetType)).AsString;
    WorkCenterSet.workstation := qry.FieldByName(CreateFld(tbInfo.pfx, fli_workstation)).AsString;

    for i:= 0 to BarSetList.Count -1 do
    begin
      DefSet := BarSetList.Items[i];
      if (WorkCenterSet.set_name = DefSet.set_name) and
         (WorkCenterSet.set_type = DefSet.set_type) then
      begin
        WorkCenterSet.CurrentSet := DefSet.CurrentSet;

      end;//if
    end;//for

    WkcSetList.Add(WorkCenterSet);
    qry.Next;
  end; //while

  qry.Close;
  qry.Free;

  except
    on e:Exception do MessageDlg('FMBarConfig - LoadWkcSetsFromDB'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

{
********************************************************************************
  This procedure saves the WorkCenter set names data to the DB.
  is called when the form is closed
********************************************************************************
}

procedure TFBarConfig.SaveWkcSetToDB(SetType : string);
var
  i:             Integer;
  qry:           TMqmQuery;
  tbInfo:        ^TTblInfo;
  WorkCenterSet: PTWorkCenterBarSet;
  CurrentWS:     String;
begin
try
  tbInfo := @tblInfo[tbl_cfg_text_display_set_wkc];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  CurrentWS := IniAppGlobals.WkstCode;

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' +  tbInfo.GetTableName);
  qry.SQL.Add('where ' + CreateFld(tbInfo.pfx, fli_workstation) + ' = ''' + CurrentWS + '''');
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_SetType) + ' = ''' + setType + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
//  Qry.Transaction.Commit;
  qry.Close;

//  Qry.Transaction.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('Insert into ' + tbInfo.GetTableName  + ' ( ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)    + ' ,' );
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_workstation)   + ' ,' );
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_setType)       + ' ,' );
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SetName)       + ' ,' );
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkCtrCode)     + ' )' );

  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ' ,' );
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_workstation)  + ' ,' );
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_setType)    + ' ,' );
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SetName)    + ' ,' );
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkCtrCode)  + ' )' );

  for i:= 0 to WkcSetList.count-1 do
  begin
    WorkCenterSet := WkcSetList.Items[i];
    if WorkCenterSet.set_type <> setType then continue;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger := StrToInt(IniAppGlobals.Identifier);
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_workstation)).AsString := WorkCenterSet.workstation ;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_SetType)).AsString     := WorkCenterSet.set_type ;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_setName)).AsString     := WorkCenterSet.set_name ;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString   := WorkCenterSet.WKC_Code ;
    qry.ExecSQL;
  end;
  qry.Close;
  Qry.Transaction.Commit;
  qry.Free;
  except
    on e:Exception do MessageDlg('FMBarConfig - SaveWkcSetsToDB'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

{
********************************************************************************
  This procedure saves the Bar sets data to the DB.
  is called when the form is closed
********************************************************************************
}

procedure TFBarConfig.SaveBarDataToDB(newset: boolean; SetName, SetType : string);
var
  i, j, B, A, SavedIndex, PropPosition, T:      Integer;
  qry:       TMqmQuery;
  tbInfo:    ^TTblInfo;
  BarConfig: TList;
  BarItem, BarItemCheck, NewBarItem :   PTBarItem;
  DefSet:    PTBarDefinitionSet;
  CurrentWS: String;
  NewFieldToAdd, IsExistProp, ProplistBuild : boolean;
  BarConfigTmp : TList;
begin

  tbInfo := @tblInfo[tbl_cfg_text_display_set_fields];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
  CurrentWS := IniAppGlobals.WkstCode;
  NewFieldToAdd := false;
  ProplistBuild := false;

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' +  tbInfo.GetTableName);
  qry.SQL.Add('where ' + CreateFld(tbInfo.pfx, fli_workstation) + ' = ''' + CurrentWS + '''');
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_SetName) + ' = ''' + setName + '''');
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_SetType) + ' = ''' + setType + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  Qry.Transaction.Commit;
  qry.Close;

  Qry.Transaction.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName    + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Workstation)     + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SetName)         + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_setType)         + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_fieldtype)       + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_title)           + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Orgtitle)        + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Checked)         + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FromPos)         + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_ToPos)           + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FieldName)       + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode)    + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_LineSeq)           + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_LineNumber)           + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)     + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Workstation)    + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SetName)        + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_setType)        + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_fieldtype)      + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_title)          + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OrgTitle)       + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Checked)        + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FromPos)        + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToPos)          + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FieldName)      + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode)   + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_LineSeq)          + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_LineNumber));

  qry.SQL.Add(')');

  for i:=0 to BarSetList.Count-1 do
  begin
    DefSet := BarSetList.Items[i];
    if DefSet.set_type <> setType then continue;
    if DefSet.set_Name <> setName then continue;

    BarConfig := DefSet.CurrentSet;

    for j := 0 to BarConfig.Count -1 do
    begin
        BarItem := BarConfig.Items[j];


      if ContainsText(BarItem.FieldName, 'CSC_Property') and (BarItem.PropertyCode = '') then
        continue;

        qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger  := StrToInt(IniAppGlobals.Identifier);
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_workstation)).AsString := DefSet.workstation;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SetName)).AsString     := DefSet.set_name; //BarSet[i].set_name;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_setType)).AsString     := DefSet.set_type;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_fieldtype)).AsInteger  := j;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_title)).AsString       := BarItem.Title;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_Orgtitle)).AsString    := BarItem.OrgTitle;
        if  BarItem.Checked then
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_Checked)).AsInteger  := 1
        else
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_Checked)).AsInteger  := 0;

        if BarItem.FromPos > 100 then
           BarItem.FromPos := 0;

        qry.ParamByName(CreateFld(tbInfo.pfx, fli_FromPos)).AsInteger  := BarItem.FromPos;

        if BarItem.ToPos > 100 then
          BarItem.ToPos := 0;

        qry.ParamByName(CreateFld(tbInfo.pfx, fli_ToPos)).AsInteger    := BarItem.ToPos;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_FieldName)).AsString := BarItem.FieldName;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString := BarItem.PropertyCode;

        if setType = 'Job_bar' then
        begin
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_LineSeq)).asInteger := BarItem.LineSeq;
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_LineNumber)).asInteger := BarItem.LineNum;
        end else
        begin
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_LineSeq)).asInteger := 0;
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_LineNumber)).asInteger := 0;
        end;

        qry.ExecSQL;

      {  try
          qry.ExecSQL;
        except
           showmessage(DefSet.set_name + ' ' +inttostr(j) + char(13)
            + BarItem.Title + char(13)
            + BarItem.OrgTitle + char(13)
            + BarItem.FieldName + char(13)
            + BarItem.PropertyCode);
        end; }

    end;//j
  end;//i


  if setType = 'Job_bar' then
    m_FoundJobBarPropSavedInDB := true
  else
    m_FoundStatusBarPropSavedInDB := true;

  qry.Close;
  Qry.Transaction.Commit;
  qry.Free;
 // except
  //  on e:Exception do MessageDlg('FMBarConfig - SaveBarDataToDB'+#13'Message: '+e.Message,mtError, [mbOK],0);
  //end;
end;

{
********************************************************************************
  This procedure is called only from BarConfigSets once.
  It checks if the new setname is unique.

  @param  NewSetName the new set name the user wants to create.
********************************************************************************
}
function TFBarConfig.CheckNameIfValid(NewSetName: string): boolean;
var
  i: Integer;
  DefSet: PTBarDefinitionSet;
begin
  Result := true;
  for i := 0 to BarSetList.Count-1 do
  begin
    DefSet := BarSetList.Items[i];
    if NewSetName = Defset.set_name then
    begin
      Result := false;
      exit
    end;
  end;//i
end;


{
********************************************************************************
  This procedure saves a set data from the form to the memory .
  @param setName the name of the set to save.
  @param NewSet is this a new set or not
********************************************************************************
}

procedure TFBarConfig.SaveDataToMemory(setName,setType: String); // NewSet: boolean);
var
  i : Integer;
  BarConfig: TList;
  BarItem: PTBarItem;
  DefSet: PTBarDefinitionSet;
  sl : TStringList;
begin
  BarConfig := nil;

    for i := 0 to BarSetList.Count-1 do
    begin
      DefSet := BarSetList.Items[i];
      if  (setName = DefSet.set_name) and (setType = DefSet.set_type) then
      begin
        BarConfig := DefSet.CurrentSet;
      end;
    end;//for

    sl := TStringList.Create;
    sl.Sorted := True;
    sl.Duplicates := dupError;

    //Check duplicates for Line Seq and Number
  {  try
    for i := 0 to BinColNum -1 do
      begin
         if not Assigned(frameArray[i]) then continue;
         if TCheckBox(frameArray[i].Components[0]).Checked then
         begin
          try
            sl.Add(IntToStr(TSpinEdit(frameArray[i].Components[5]).Value) +'|'+ IntTOStr(TSpinEdit(frameArray[i].Components[6]).Value));
          except
            on e: EStringListError do
            begin
              MEssageDlg('You cannot select same Line Sequance and Line Number for checked fields!', mtError, [mbOk], 0);
              sl.clear;
              sl.Free;
              m_NoDuplicates := False;
              exit;
            end;
          end;
         end;
      end;
    except
      MessageDlg(_('No matching set found.'), mtError, [mbOK], 0);
      exit;
    end;     }

    sl.clear;
    sl.free;
    m_NoDuplicates := True;

  // loop over all frames and save their data
  try
    for i := 0 to BinColNum -1 do
    begin
       if not Assigned(frameArray[i]) then continue;
       BarItem := BarConfig.Items[i];
       BarItem.Field    := i;
       BarItem.Title    := TEdit(frameArray[i].Components[1]).Text;
       BarItem.OrgTitle := TEdit(frameArray[i].Components[0]).Text;
       BarItem.Checked  := TCheckBox(frameArray[i].Components[0]).Checked;
       BarItem.FromPos  := strToInt(TEdit(frameArray[i].Components[2]).Text);
       BarItem.ToPos    := strToInt(TEdit(frameArray[i].Components[4]).Text);

       if setType = 'Job_bar' then
       begin
        BarItem.LineNum    := TSpinEdit(frameArray[i].Components[5]).Value;
        BarItem.LineSeq    := TSpinEdit(frameArray[i].Components[6]).Value;
       end;
    end;//i
  except
    MessageDlg(_('No matching set found.'), mtError, [mbOK], 0);
    exit;
  end;

end;

//----------------------------------------------------------------------------//

destructor TFBarConfig.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TFBarConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 // if not m_NoDuplicates then
 //   Action := caNone;

  if m_Save then
    Save(false,true,true, GlobalSetName,setType);
 // SaveBarDataToDB(false);
 // SaveWkcSetToDB();
end;

{
********************************************************************************
  This procedure Saves the new set to memory
********************************************************************************
}

procedure TFBarConfig.BtnSaveChangesClick(Sender: TObject);
var
  i: Integer;
  checked: boolean;
begin
  checked := false;

  for i := 0 to CLBWorkCenters.Count - 1 do
  begin
    if  CLBWorkCenters.Checked[i] then
    begin
      checked := true;
      break;
    end;
  end;

  if not checked then
  begin
    ShowMessage(_('Set is not applied to any work center'));
    Exit;
  end;


{  if not checked then
    if MessageDlg(_('Set is not applied to any work center'), mtConfirmation, [mbOK, mbCancel], 0)in [mrOK] then
    begin
      close;
    end;  }

  m_Save := true;
  SaveDataToMemory(GlobalSetName, setType); //, false);
  SaveWorkCentersList;

  if checked then
  begin
    close;
  end;
end;

{
********************************************************************************
  This procedure finds the index in the DB of a set.
  if we return -1 it means this set doesn't exist.
  @param SetName the set we are looking for
  @param setIndex returns the index of the set
********************************************************************************
}

procedure TFBarConfig.findsetIndex(SetName: String; var setIndex: Integer);
var
  i: Integer;
  DefSet: PTBarDefinitionSet;
begin
  setIndex := -1;
  for i:= 0 to BarSetList.Count -1 do
    begin
      DefSet := BarSetList.Items[i];
      if (DefSet.set_name = SetName) and (DefSet.set_type = SetType) then
      begin
        setIndex := i;
        exit;
      end;
    end;
end;

{
********************************************************************************
  This function deletes a set from the set list .
  returns true on success.
  @param SetName the set we are deleting.
********************************************************************************
}

function TFBarConfig.deleteSet(SetName, SetType: String): boolean;
var
  i: Integer;
  DefSet: PTBarDefinitionSet;
begin
  result := false;
  if BarSetList.Count <= 0 then exit;
  for i:= 0 to BarSetList.Count -1 do
    begin
      DefSet := BarSetList.Items[i];
      if (DefSet.set_name = SetName) and (DefSet.set_type = SetType) then
      begin
        BarSetList.Delete(i);
        result := true;
        exit;
      end; //if
    end;//for
end;

{
********************************************************************************
  This procedure deletes a set from the Workcenter list
  @param SetName the set we are deleting
********************************************************************************
}

procedure TFBarConfig.deleteWkcSet(SetName, SetType: String);
var
  i: Integer;
  WkcSet: PTWorkCenterBarSet;
begin
  for i:= WkcSetList.Count-1 downto 0 do
    begin
      WkcSet := WkcSetList.Items[i];
      if (WkcSet.set_name = SetName) and (WkcSet.set_type = SetType) then
      begin
        WkcSetList.Delete(i);
      end; //if
    end;//for
end;

{
********************************************************************************
  This procedure updates the checked and unchecked WKC in the
  workcenter Check list box .It also updates the workcenter list
********************************************************************************
}

procedure TFBarConfig.SaveWorkCentersList;
var
  WkC_Code: String;
  WkcList: Tstrings;
  i, j: Integer;
  WkcSet: PTWorkCenterBarSet;
  DefSet: PTBarDefinitionSet;
begin
// add or delete a wkc to list

//first delete all Wkc of current set only
  for j:= WkcSetList.Count-1 downto 0   do
  begin
    wkcSet := WkcSetList.Items[j];
    if (wkcSet.set_name <> GlobalSetName) or
       (wkcset.set_type <> SetType)
       then continue
    else
      WkcSetList.Delete(j);
  end;//for j

  for i:= 0 to CLBWorkCenters.Count-1 do begin   //if checked
    WkcList := CLBWorkCenters.Items;
    WkC_Code := WkcList.Strings[i];

    if CLBWorkCenters.checked[i] then
    begin
      new(WkcSet);
      WkcSet.WKC_Code    := WkC_Code;
      WkcSet.set_name    := GlobalSetName;
      WkcSet.set_type    := SetType;
      Wkcset.workstation := IniAppGlobals.WkstCode;

      for j:= 0 to BarSetList.Count -1 do
      begin
        DefSet := BarSetList.Items[j];
        if (DefSet.set_name = WkcSet.set_name) and
           (DefSet.set_type = WkcSet.set_type) then
        begin
          wkcSet.CurrentSet := DefSet.CurrentSet;
          WkcSetList.Add(WkcSet);
        end;//if
      end; //for j
     end;//if checked
   end;//for i
end;

procedure TFBarConfig.SB_FramesMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  var
  LTopLeft, LTopRight, LBottomLeft, LBottomRight: SmallInt;
  LPoint: TPoint;
begin
  inherited;

  LPoint := TScrollbox(Sender).ClientToScreen(Point(0,0));

  LTopLeft := LPoint.X;
  LTopRight := LTopLeft + TScrollbox(Sender).Width;

  LBottomLeft := LPoint.Y;
  LBottomRight := LBottomLeft + TScrollbox(Sender).Width;


  if (MousePos.X >= LTopLeft) and
    (MousePos.X <= LTopRight) and
    (MousePos.Y >= LBottomLeft)and
    (MousePos.Y <= LBottomRight) then
  begin
    TScrollbox(Sender).VertScrollBar.Position :=
    TScrollbox(Sender).VertScrollBar.Position - WheelDelta;

    Handled := True;
  end;

end;

procedure TFBarConfig.SetNewSet(SetName: string; NewCfg: TList);
var
  setIndex: Integer;
  DefSet: PTBarDefinitionSet;
begin

  setIndex := 0;
  DefSet := BarsetList.Items[0];

  Assert(Assigned(DefSet));
  if (DefSet.set_name <> SetName) or (DefSet.set_type <> setType) then
  begin
    findsetIndex(SetName,setIndex);
    //In case we didn't find the setname ,try to take the one
    //in view of the combo box.
    if setIndex < 0 then
    begin
      DefSet := BarsetList.Items[0];
      setName := DefSet.set_name;
      findsetIndex(setName,setIndex);
      if setIndex < 0 then exit; //no sets do exist
    end;
    DefSet := BarsetList.Items[SetIndex];
  end;
  DefSet.CurrentSet := NewCfg;

end;

{
********************************************************************************
  This procedure updates/refreshes the WKC check list box when a new set
  has been chosen
  @param SetName the new set we changing for
********************************************************************************
}

procedure TFBarConfig.UpdateWkcCLB(setName: String);
var
  WkC_Code: String;
  WkcList: Tstrings;
  i, j: Integer;
  WkcSet: PTWorkCenterBarSet;
begin
//  WkcList := TStringList.Create();
  for i:= 0 to CLBWorkCenters.Count-1 do begin
    CLBWorkCenters.checked[i] := false;
    WkcList := CLBWorkCenters.Items;
    WkC_Code := WkcList.Strings[i];

    for j:= 0 to WkcSetList.count-1 do
    begin
      WkcSet := WkcSetList.Items[j];
      if ( WkC_Code = WkcSet.WKC_Code )  and
         ( SetType  = WkcSet.set_type )  and
         ( setName  = WkcSet.set_name ) then
        CLBWorkCenters.checked[i] := true;
    end; //j
  end;//i
end;

{
********************************************************************************
  This procedure adds the set names to the set list .
  Is called once from the BarconfigSets only.

  @param WkcList a string list with all the set names
  @param setType  the type of the set
********************************************************************************
}

procedure TFBarConfig.GetSetNames(var WkcList: Tstrings; setType : String);
var
//  WkcList: Tstrings;
  WkcSet: PTWorkCenterBarSet;
  DefSet: PTBarDefinitionSet;
  j,i: Integer;
  WkcFound: boolean;
begin
  WkcList.Clear;
  for j:= 0 to WkcSetList.count-1 do
    begin
      WkcSet := WkcSetList.Items[j];
      if assigned(WkcSet) then
      begin
        if WkcList.IndexOf(WkcSet.set_name) < 0 then
        begin
          if (WkcSet.set_type = setType) then //show just our type of sets
                WkcList.add(WkcSet.set_name);
        end;
      end;//if
    end;//j

  //Add all sets that are not applied to any Wkc
    for i:= 0 to BarSetList.Count -1 do
    begin
      WkcFound := false;
      DefSet := BarSetList.Items[i];
      for j:= 0 to WkcSetList.Count-1 do
      begin
        WkcSet := WkcSetList.Items[j];
        if (WkcSet.set_name = DefSet.set_name) and
           (WkcSet.set_type = DefSet.set_type)
            then WkcFound := true;
      end;//j
      if ( WkcFound = false) and (DefSet.set_type = setType) then
          WkcList.add(DefSet.set_name);
    end;//i


end;

{
********************************************************************************
  This procedure is for future use. It is an event function that is called when
  a checkbox in a row is clicked
********************************************************************************
}

procedure TFBarConfig.enableRowClick(Sender: TObject);
var
  index: String;
begin
//enablerow
  index := tcheckbox(Sender).Name;
  MessageDlg(index, mtInformation, [mbOK], 0);
end;

{
********************************************************************************
  This procedure returns the Bar String according to the Active set of the user
  is being called from UmSchedOnPlan.
  @param workcenter for what workcenter
  @param sc is a TSCProdSched object which is needed to get the info of the job
  @param isGroup if the job is a group then we need to know
********************************************************************************
}

function getLineNumber(workcenter: String; isJobBar:boolean): Integer;
var i, j: Integer;
  WkcSet: PTWorkCenterBarSet;
  BarConfig: TList;
  BarItem: PTBarItem;
  BarItemList : TStringlist;
  CurNum,LineNum,a: Integer;
  setType : String;
begin
    Result := 0;

    if not isJobBar then
      exit;

    setType := 'Job_bar' ;

    BarItemList := TStringList.Create;
    BarItemList.Sorted := True;
    BarItemList.Duplicates := DupIgnore;

  for i:= 0 to WkcSetList.Count-1 do   //find our workcenter
  begin
    WkcSet := WkcSetList.Items[i];
    if WkcSet.WKC_Code <> workcenter then continue;
    if Wkcset.set_type <> setType then continue;
    BarConfig := Wkcset.CurrentSet;
    if not assigned(BarConfig) then continue;

    BarItemList.Clear;

    for j := 0 to BarConfig.Count - 1 do
    begin
        BarItem := BarConfig.Items[j];
        if BarItem.Checked = false then continue;
        if BarItem.field < 0 then continue;

        BarItemList.add(IntToStr(BarItem.LineNum));
    end;

      LineNum := 0;

    for j := 0 to BarItemList.Count - 1 do
    begin
        CurNum := StrToInt(BarItemList[j]);

        if LineNum < CurNum then
        Begin
          LineNum := CurNum;
          Inc(Result);
        End;
    end;
  end;

  BarItemList.Free;

end;

function getBarString(workcenter: String; sc:TSCProdSched; isGroup: boolean; isJobBar:boolean; LineNumber : Integer):String; //ProdReqDet: TSCProdReqDet):string;
var
  FieldValue: String;
  i, j: Integer;
  WkcSet: PTWorkCenterBarSet;
//  DefSet: PTBarDefinitionSet;
  BarConfig: TList;
  BarItem: PTBarItem;
  FieldLength : integer;
//  ActiveSet:  String;
  setType,temp:    String;
  LookingForField : boolean;
  BarItemList : TStringlist;
  CurNum,LineNum,a: Integer;
begin

  LookingForField := false;
  result := '';
//  BarConfig := nil;

  if isJobBar then
   begin
    setType := 'Job_bar';
 //   activeSet := IniAppGlobals.JobBarTextSet; //what is our Active set ?
   end
  else
  begin
    setType := 'Status_bar';
 //   activeSet := IniAppGlobals.StatusBarTextSet; //what is our Active set ?
  end;

  BarItemList := TStringList.Create;
  BarItemList.Sorted := True;

 try
  for i:= 0 to WkcSetList.Count-1 do   //find our workcenter
  begin
    WkcSet := WkcSetList.Items[i];
 //   if WkcSet.set_name <> activeSet then continue;
    if WkcSet.WKC_Code <> workcenter then continue;
    if Wkcset.set_type <> setType then continue;
    BarConfig := Wkcset.CurrentSet;
    if not assigned(BarConfig) then continue;
    LookingForField := false;

    FieldValue := '';
    BarItemList.Clear;

    if LineNumber > 0 then
    begin
      for j := 0 to BarConfig.Count - 1 do
      begin
        BarItem := BarConfig.Items[j];
        if BarItem.Checked = false then continue;
        if BarItem.field < 0 then continue;
        if BarItem.LineNum <> LineNumber then continue;

        BarItemList.add(IntToStr(BarItem.LineNum) + IntToStr(BarItem.LineSeq) +'='+ IntToStr(j));
      end;

     { if BarItemList.Count = 0 then
      begin
        Result := '';
        Exit;
      end;  }

      Result := '';

      BarItemList.Delimiter := '=';

      LineNum := 0;

      for j := 0 to BarItemList.Count - 1 do
      begin
        CurNum := StrToInt(BarItemList.Names[j]);
        CurNum := StrToInt(AnsiLeftStr(IntToStr(CurNum),1));

        if LineNum = 0 then
          LineNum := CurNum;

        BarItem := BarConfig.Items[StrToInt(BarItemList.ValueFromIndex[j])];
        //if BarItem.Checked = false then continue;
        //if BarItem.field < 0 then continue;
        FieldValue := VartoStr(GetValueOfField(j,i,sc,isGroup,BarItem.BinColId));

        LookingForField := true;
        if FieldValue = '' then continue;
        FieldLength := BarItem.ToPos - BarItem.FromPos;

        if FieldLength <= 0 then
          FieldValue := Copy(FieldValue,0,50)
        else
          FieldValue := Copy(FieldValue,BarItem.FromPos,FieldLength + 1);

        if trim(Result) <> '' then Result := Result + ',  ';
        if trim(BarItem.Title) <> '' then
            Result := Result + Trim(BarItem.Title) + ':';

          Result := Result + FieldValue;
      end; //for j

      {if BarItemList.Count = 0 then
      begin
        Result := '';
        Exit;
      end;   }

    end else
    begin
      for j := 0 to BarConfig.Count - 1 do
      begin

        BarItem := BarConfig.Items[j];
        if BarItem.Checked = false then continue;
        if BarItem.field < 0 then continue;
        FieldValue := VartoStr(GetValueOfField(j,i,sc,isGroup,BarItem.BinColId));

        LookingForField := true;
        if FieldValue = '' then continue;
        FieldLength := BarItem.ToPos - BarItem.FromPos;

        if FieldLength <= 0 then
          FieldValue := Copy(FieldValue,0,50)
        else
          FieldValue := Copy(FieldValue,BarItem.FromPos,FieldLength + 1);

        if trim(Result) <> '' then Result := Result + ',  ';
        if trim(BarItem.Title) <> '' then
            Result := Result + Trim(BarItem.Title) + ':';

          Result := Result + FieldValue;
      end; //for j
    end;
  end; //i
 except
  Result := '';
  Exit
  //on e:Exception do MessageDlg('FMBarConfig - GetBarString'+#13'Message: '+e.Message,mtError, [mbOK],0);
 end;

 BarItemList.Clear;
 BarItemList.Free;
  //Default BarString ( if we don't have an Active Set )
  if (Result = '') and not LookingForField and (getLineNumber(workcenter,isJobBar) = 0) then
  begin
    if not isgroup then
    begin
    Result := _('Job') + ' ';

    if not Assigned(sc.m_reqDet) then
      Result := Result + _('detail data not found')
    else if not Assigned(sc.m_reqDet.m_hdr) then
      Result := Result + _('header data not found')
    else
      Result := sc.m_reqDet.m_hdr.m_code +
                ' - ' + _('Step') + ' ' + IntToStr(sc.m_reqDet.m_code) +
                ' - ' + _('Sub step') + ' ' + IntToStr(sc.m_code) +
                ' - ' + _('Reprocess') + ' ' + IntTostr(sc.m_reprocNo);
    end;

    if isgroup then
    begin
      if sc.m_grp.m_list.Count = 1 then Result := sc.m_reqDet.m_hdr.m_code + ' - '
      else Result := '';
      if sc.m_grp.m_code < 0 then
        Result := Result + IntToStr((-1) * sc.m_grp.m_code) + '(-Host)'
      else
        Result := Result + _('Step group')+ ' ' + IntToStr(sc.m_grp.m_code) ;
    end;
  end;
end;

{
********************************************************************************
  This procedure returns the Bar String according to the Active set of the user
  is being called from UmSchedOnPlan.
  @param index of the field in the BarConfig array
  @param Wkcindex index of the Wkc list
  @param sc is a TSCProdSched object which is needed to get the info of the job
  @param isGroup if the job is a group then we need to know
********************************************************************************
}

function  GetValueOfField(index,WkcIndex: Integer; sc:TSCProdSched; isGroup: boolean; BinColId : CBinColId):variant;//ProdReqDet: TSCProdReqDet):String;
var
  WkcSet: PTWorkCenterBarSet;
//  DefSet: PTBarDefinitionSet;
//  BarConfig: PTBarSetArray;
//  BarConfig: TList;
  BarItem: PTBarItem;
  WrkCtr: TMqmWrkCtr;
  res : TMqmRes;
  FieldVal : variant;
  dataType: CBinColValType;
begin
  result := '';
  WkcSet := WkcSetList.Items[WkcIndex];
  if not assigned(WkcSet)then exit;
//  BarConfig := Wkcset.CurrentSet;
//  BarItem := BarConfig.Items[Index];

  if isGroup then
    Result := p_sc.GetFldDescr(sc.m_grp.m_Id, BinColId, false)
  else
    Result := p_sc.GetFldDescr(sc.m_Id, BinColId, false);

  exit;
  case BarItem.Field of
  0:;//info.
  1: begin
       if isGroup then exit;
       result := sc.m_reqDet.m_hdr.m_code;///Field: CSC_ProdReq;     // PRODUCTION. REQ.
     end;
  2: result := sc.m_reqDet.m_code;///Field: CSC_ProdStep;           // STEP
  3: result := sc.m_code;///(Field: CSC_ProdSubStep;      // SUB STEP
  4: result := sc.m_reprocNo ;//(Field: CSC_ReprocNo;       // RE - PROCESS
  5: begin
       if Assigned(sc.m_grp) then
       begin
         if sc.m_grp.m_code < 0 then
           result := intToStr((- 1)* sc.m_grp.m_code) + '(-Host)'
         else
           result := intToStr(sc.m_grp.m_code) ;
       end;
     end;

  6: begin
      WrkCtr := TMqmWrkCtr(sc.p_WrkCtrPtr);
      if Assigned(WrkCtr) then
      result := WrkCtr.p_WrkCtrCode;
    end;// result := sc.p_WorkCenter; // WORK CENTER
  7:begin
      WrkCtr := TMqmWrkCtr(sc.p_WrkCtrPtr);
      if Assigned(WrkCtr) then
      result := WrkCtr.p_WrkCtrSDesc;
    end; //(Field: CSC_WkctCodeDesc;       // WORK CENTER Desc
  8: result := sc.p_Process;  //(Field: CSC_WkctProc;       // PROCESS
  9:begin
      WrkCtr := TMqmWrkCtr(sc.p_WrkCtrPtr);
      if Assigned(WrkCtr) then
      result := WrkCtr.GetProcDesc(sc.p_Process); //m_SchedwkcProc);
    end;  //(Field: CSC_WkctProcDesc;       // PROCESS Desc
  10: result := sc.m_PlanWkCtrCode ;//(Field: CSC_PlanWkctCode;          // Planed Work Center
  11:begin
      WrkCtr := TMqmWrkCtr(sc.m_reqDet.m_PlanWrkCtrPtr);
//      WrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(sc.m_PlanWkCtrCode));
      if Assigned(WrkCtr) then
      result := WrkCtr.p_WrkCtrSDesc;
    end;  //(Field: CSC_PlanWkctDesc;     // Planed Work Center description
  12: result := sc.m_PlanWrkCtrProc ;//(Field: CSC_PlanWkctProc;       // Planed process
  13:begin
      WrkCtr := TMqmWrkCtr(sc.m_reqDet.m_PlanWrkCtrPtr);
//      WrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(sc.m_PlanWkCtrCode));
      if Assigned(WrkCtr) then
      result := WrkCtr.GetProcDesc(sc.m_PlanWrkCtrProc);
    end;  //  (Field: CSC_PlanWkctProcDesc;   // Planed Process description
  14:  result := sc.m_reqDet.m_hdr.m_prodType;//  (Field: CSC_ProdType;     // PRODUCT TYPE
  15:  result := p_ArtType.GetSDesc(sc.m_reqDet.m_hdr.m_prodType);//  (Field: CSC_ProdTypeDesc;   // PRODUCT TYPE Desc
  16:  result := sc.m_reqDet.m_hdr.m_prodLine;//  (Field: CSC_ProdLine;       // PRODUCTION LINE
  17:  begin
         result := sc.m_reqDet.m_hdr.m_prodFamily;// (Field: CSC_ProdFamily;      // PRODUCT FAMILY
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ProdFamily, false);
       end;
  18:  begin
         result := sc.m_reqDet.m_hdr.m_matFamily;// (Field: CSC_ProdMatFamily;     // MATERIAL FAMILY
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ProdMatFamily, false);
       end;
  19:  result := sc.m_reqDet.m_hdr.m_prodUMCode;//  (Field: CSC_ProdUM;   // PRODUCTION UM
  20:  result := GetSUmDesc(sc.m_reqDet.m_hdr.m_prodUMCode);//  (Field: CSC_ProdUMDesc;           // PRODUCTION UM Desc
  21:  result := sc.m_comment;//  (Field: CSC_Comment;     // COMMENT
  22:begin
       result := DateTimeToStr(sc.m_reqDet.m_lowStartTimeLimit);//  (Field: CSC_LowStartTimeLimit;  // PROD.REQ LOWEST DATE
       if isGroup then result := DateTimeToStr(sc.m_grp.p_LowStartDate);
     end;
  23:begin
       result := DateTimeToStr(sc.m_reqDet.m_hdr.m_prodDelivDate);//  (Field: CSC_ProdDlvDate;   // PROD.REQ DELIVERY DAT
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ProdDlvDate, false)//DateTimeToStr(sc.m_grp.  p_DeliveryDate);
     end;
  24:begin
       result := sc.m_reqDet.m_stepType;
       case result of
       1: result := 'Batch';
       2: result := 'Continuous';//  (Field: CSC_StepType;     // STEP TYPE
       end;
     end;
  25:begin
       result := DateTimeToStr(sc.m_reqDet.m_materialArrivDate);//  (Field: CSC_MatArrivalDate;   // MATERIAL ARRIVAL DATE
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_MatArrivalDate, false)
     end;
  26:begin
       result := DateTimeToStr(sc.m_reqDet.m_planStart);//  (Field: CSC_PlanStartDate;  // PLAN START
        if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_PlanStartDate, false)
     end;
  27:begin
       result := DateTimeToStr(sc.m_reqDet.m_lowStartTimeLimit);//  (Field: CSC_LowStartDate;    // LOWEST START
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_LowStartDate, false)
     end;
  28:begin
       result := DateTimeToStr(sc.m_reqDet.m_planEnd);//  (Field: CSC_PlanEndDate;    // PLAN END
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_PlanEndDate, false)
     end;
  29:begin
       result := DateTimeToStr(sc.m_reqDet.m_highEndTimeLimit);//  (Field: CSC_HighEndLimit;   // HIGHEST END
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_HighEndLimit, false)
     end;
  30:  result := sc.m_reqDet.m_calCod;//  (Field: CSC_Calendar;       // CALENDAR
  31:  begin
         result := sc.m_reqDet.m_quantInit;//  (Field: CSC_IniQty;       // INITIAL QUANTITY
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_IniQty, false)
       end;
  32:  begin
         result := sc.m_reqDet.m_quantFinl;//  (Field: CSC_FinQty;         // FINAL QUANTITY
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_FinQty, false)
       end;
  33:  begin
         result := FloatToStr(sc.m_reqDet.m_weight) + '    ' + sc.m_reqDet.m_weightUM; //sc.m_reqDet.m_weightUM;//  (Field: CSC_WeightWithUM;  // WEIGHT + UM
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_WeightWithUM, false)
       end;
  34:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_PlanSetup, false);//  (Field: CSC_PlanSetup;     // PLANED SETUP TIME
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_PlanSetup, false)
       end;
  35:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ExeTime, false);//  (Field: CSC_ExeTime;   // PLANED EXECUTION TIME
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ExeTime, false)
       end;
  36:  result := sc.m_reqDet.m_planNumRes;//  (Field: CSC_NumOfRscPlan;  // NUMBER OF RESOURCES
  37:  result := sc.m_reqDet.m_connTypeToPrevious;//  (Field: CSC_ConnTypePrvStep;   // CONNECTION TYPE PREVIOUS STEP
  38:  begin
         result := p_sc.GetFldDescr(sc.m_id, CSC_QtyToSched, false);//  (Field: CSC_QtyToSched;   // QUANTITY TO SCHED
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_QtyToSched, false);
       end;
  39:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ExeTimeSched, false);//  (Field: CSC_ExeTimeSched;    // EXECUTION TIME TO SCHED
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id,  CSC_ExeTimeSched, false);
       end;
  40:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_SupTimeSched, false);//  (Field: CSC_SupTimeSched;    // SET - UP TIME TO SCHED
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id,  CSC_SupTimeSched, false);
       end;
  41:  result := sc.p_rscCode;  //  (Field: CSC_Rsc;                  // Resource
  42:  begin
         res := TMqmRes(p_pl.FindResByCode(sc.p_rscCode));
         if Assigned(res) then
         result := res.p_ResSDesc
       end;//  (Field: CSC_RscDesc;   // Resource Desc
  43:begin
       result := p_sc.GetFldDescr(sc.m_Id , CSC_SchedStart, false);//  (Field: CSC_SchedStart;   // SCHED Start
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_SchedStart, false); //DateTimeToStr();
     end;
  44:begin
       result := DateTimeToStr(sc.p_schedEnd);//  (Field: CSC_SchedEnd;         // SCHED End
       if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_SchedEnd, false);
     end;
  45:  begin
       result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgStart, false);//  (Field: CSC_ProgStart;         // Progress Start
       if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_ProgStart, false);
       end;
  46:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgEnd, false);//  (Field: CSC_ProgEnd;      // Progress end
         if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_ProgEnd, false);
       end;
  47:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgQty, false);//  (Field: CSC_ProgQty;             // Progress qty
         if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_ProgQty, false);
       end;
  48:  begin
       if sc.m_ProgType <> '' then
       begin
          case StrToInt(sc.m_ProgType[1]) of
              0 : result := _('No');
              1 : result := _('Start');
              2 : result := _('General');
              3 : result := _('Final');
              4 : result := _('Final and Split');
            end;
          end;
       end;   //  (Field: CSC_ProgType;           // Progress Type
  49:  result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgRsc, false);//sc.m_ProgRsc;//  (Field: CSC_ProgRsc;    // Progress Resource
  50:  begin
       if (sc.m_ProgRsc = '') and Assigned(sc.m_srvPtr) then
         if (sc.p_rscCode <> '') and Assigned(sc.m_srvPtr) then
          begin
            res := TMqmRes(p_pl.FindResByCode(sc.p_rscCode));
            if Assigned(res) then
              result := res.p_ResSDesc;//  (Field: CSC_ProgRscDesc; // Progress Resource Description
          end;
       end;
  51:  begin
          case sc.m_bkwConnReProcs of
            -2: result := _('All');
            -1: result := _('Many')
           else
            result := sc.m_bkwConnSubStp;
          end;
       end;//result := sc.m_bkwConnSubStp;//  (Field: CSC_BkwConnSubStp; // BACKWORD CONNECTION SUB STEP
  52:  begin
          case sc.m_bkwConnReProcs of
            -2: result := _('All');
            -1: result := _('Many')
           else
            result := sc.m_bkwConnReProcs;
          end;
       end;//  result := sc.m_bkwConnReProcs;//  (Field: CSC_BkwConnReProcs; // BACKWORD CONNECTION RE - PROCESS
  53:  begin
          case sc.m_bkwConnReProcs of
            -2: result := _('All');
            -1: result := _('Many')
           else
            result := sc.m_fwdConnSubStp;
          end;
       end; // result := sc.m_fwdConnSubStp;//  (Field: CSC_FwdConnSubStp; // FORWARD CONNECTION SUB STEP
  54:  begin
          case sc.m_bkwConnReProcs of
            -2: result := _('All');
            -1: result := _('Many')
           else
            result := sc.m_fwdConnReProcs;
          end;
       end;//result := sc.m_fwdConnReProcs;//  (Field: CSC_FwdConnReProcs;      // FORWARD CONNECTION RE - PROCESS

  55:  begin
        result := sc.p_GetActualTime;
       end;//result := sc.m_fwdConnReProcs;//  (Field: CSC_FwdConnReProcs;      // FORWARD CONNECTION RE - PROCESS

  56:  result := sc.P_Grp_Sequence;


  57:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_Customized_column1, FieldVal, dataType);
         Result := FieldVal;
       end;

  58:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_PrvHighestDate, FieldVal, dataType);
          Result := FieldVal;
       end;

  59:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_NxtLowestDate, FieldVal, dataType);
          Result := FieldVal;
       end;

  60:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_LastScheudleChange, FieldVal, dataType);
         Result := FieldVal;
       end;

  61:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_SharedComment, FieldVal, dataType);
         Result := FieldVal;
       end;

  62:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_Customized_column2, FieldVal, dataType);
         Result := FieldVal;
       end;

  63:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_Customized_column3, FieldVal, dataType);
         Result := FieldVal;
       end;

  64:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_Case_with_prev_job, FieldVal, dataType);
         Result := FieldVal;
       end;

  65:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_GenericPlanWC, FieldVal, dataType);
         Result := FieldVal;
       end;

  66:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_GenericPlanDur, FieldVal, dataType);
         Result := FieldVal;
       end;

  67:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_GenericPlanLeadTime, FieldVal, dataType);
         Result := FieldVal;
       end;

  68:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_GenericPlanMachineNum, FieldVal, dataType);
         Result := FieldVal;
       end;

  69:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_GenericPlanStartDate, FieldVal, dataType);
         Result := FieldVal;
       end;

  70:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_GenericPlanEndDate, FieldVal, dataType);
         Result := FieldVal;
       end;

  71:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_ServingGroupCode, FieldVal, dataType);
         Result := FieldVal;
       end;

  72:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_ServingGroupLowestDate, FieldVal, dataType);
         Result := FieldVal;
       end;

  73:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_PrvActualEnd, FieldVal, dataType);
         Result := FieldVal;
       end;

  74:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_NxtActualStart, FieldVal, dataType);
         Result := FieldVal;
       end;

  75:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_CustomerDate, FieldVal, dataType);
         Result := FieldVal;
       end;

  76:  begin
         p_sc.GetFldValue(sc.m_Id, CSC_SavedScheduleDate, FieldVal, dataType);
         Result := FieldVal;
       end;

  77:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property1;         // Property1
  78:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property2;          // Property2
  79:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property3;          // Property3
  80:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property4;         // Property4
  81:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property5;         // Property5
  82:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property6;          // Property6
  83:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property7;           // Property7
  84:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property8;           // Property8
  85:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property9;           // Property9
  86:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property10;  // Property10
  87:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property11;      // Property11
  88:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property12;      // Property12
  89:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property13;      // Property13
  90:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property14;        // Property14
  91:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property15;      // Property15
  92:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property16;      // Property16
  93:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property17;     // Property17
  94:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property18;    // Property18
  95:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property19;      // Property19
  96:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property20;      // Property20
  97:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property21;       // Property21
  98:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property22;     // Property22
  99:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property23;      // Property23
  100:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property24;   // Property24
  101:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property25;// Property25
  102:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property26;     // Property26
  103:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property27;    // Property27
  104:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property28;    // Property28
  105:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property29;     // Property29
  106:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property30;      // Property30
  107:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property31;         // Property31
  108:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property32;          // Property32
  109:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property33;          // Property33
  110:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property34;         // Property34
  111:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property35;         // Property35
  112:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property36;          // Property36
  113:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property37;           // Property37
  114:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property38;           // Property38
  115:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property39;           // Property39
  116:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property40;  // Property40
  117:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property41;      // Property41
  118:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property42;      // Property42
  119:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property43;      // Property43
  120:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property44;        // Property44
  121:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property45;      // Property45
  122:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property46;      // Property46
  123:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property47;     // Property47
  124:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property48;    // Property48
  125:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property49;      // Property49
  126:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property50;      // Property50
  127:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property51;       // Property51
  128:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property52;     // Property52
  129:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property53;      // Property53
  130:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property54;   // Property54
  131:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property55;// Property55
  132:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property56;     // Property56
  133:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property57;    // Property57
  134:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property58;    // Property58
  135:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property59;     // Property59
  136:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property60;      // Property60


 end;//case
end;

{
********************************************************************************
  This procedure returns the value of the property
  @param PropertyIndex the index of the property
  @param sc is a TSCProdSched object which is needed to get the value
  @return the value of the property as variant
********************************************************************************
}

function GetPropertyValue(PropertyIndex: Integer; sc:TSCProdSched):variant;
var
 pId: TPropId;
 value: variant;
begin
  PropertyIndex := PropertyIndex - getNumberfields ;//PropertyIndex - 55;
  pId :=DBAppGlobals.ShowBinPropArry[PropertyIndex];
  if (pId = nil) then Result := ''//or ( sc.m_reqDet.m_propList.GetValforProp(pId,value)) then //g GetPropVal(id, pId, value)) then
  else
    begin
      sc.m_reqDet.m_propList.GetValforProp(pId,value);
      Result := value;
    end;
end;

//********************************************************************************

procedure ClearBarSetList;
var
  I,J : Integer;
  BarDefinitionSet : PTBarDefinitionSet;
begin
  for I := BarSetList.Count -1 downto 0 do
  begin
    BarDefinitionSet := PTBarDefinitionSet(BarSetList[I]);
    for J := BarDefinitionSet.CurrentSet.Count - 1 downto 0 do
      Dispose(PTBarItem(BarDefinitionSet.CurrentSet[J]));
    dispose(PTBarDefinitionSet(BarSetList[I]));
  end;
  BarSetList.Clear;
end;

//********************************************************************************

procedure ClearWkcSetList;
var
  I : integer;
begin
  for I := WkcSetList.Count -1 downto 0 do
    dispose(PTWorkCenterBarSet(WkcSetList[I]));
  WkcSetList.Clear;
end;

//********************************************************************************

procedure TFBarConfig.BitCloseClick(Sender: TObject);
begin
   m_Save := false;
   m_NoDuplicates := True;
   close
end;

{
********************************************************************************
  This procedure creates a new set.
  @param setName the set name to create
  @param setType the set type
********************************************************************************
}
procedure TFBarConfig.CreateNewSet(setName,setType: string);
var
  j, A, PropPos: Integer;
  BarConfig: TList;
  BarItem: PTBarItem;
  DefSet: PTBarDefinitionSet;
  pId : TPropId;
begin
//  new(BarConfig);
  BarConfig := Tlist.Create;
  new(DefSet);
  DefSet.set_name := setName;
  DefSet.set_type := setType;
//  DefSet.Index := BarSetList.Count;
  DefSet.workstation := IniAppGlobals.WkstCode;
  DefSet.CurrentSet := BarConfig;
  BarsetList.Add(DefSet);

  for j := 0 to BinColNum -1  do
  begin

    if BinColDefault[J].Field = CSC_property1 then
    begin

        PropPos := J;

        for A := Low(DBAppGlobals.ShowBinPropArry) to High(DBAppGlobals.ShowBinPropArry) do
        begin
          if DBAppGlobals.ShowBinPropArry[A] = nil then break;
          pId := DBAppGlobals.ShowBinPropArry[A];
          new(BarItem);
          BarItem.Field        := BinColDefault[PropPos].Index;
          BarItem.PropertyCode := GetPropCodeFromID(pId);
          BarItem.OrgTitle := GetPropDescr(pId);
          BarItem.Title := GetPropDescr(pId);
          BarItem.Checked := false;
          BarItem.FromPos := 0;
          BarItem.ToPos := 0;
          BarItem.BinColId := BinColDefault[PropPos].Field;
          BarItem.FieldName := BinColDefault[PropPos].FieldName;
          BarItem.SetType   := setType;
          BarItem.LineSeq := 0;
          BarItem.LineNum := 1;
          BarConfig.Add(BarItem);
          Inc(PropPos);
        end;
        exit;

    end;

    new(BarItem);
    BarItem.Field := BinDefaultTabColumnSet[j].Index;  //Pos; // Field;
    BarItem.OrgTitle := BinDefaultTabColumnSet[j].Title;
    BarItem.Title := BinDefaultTabColumnSet[j].Title;
    BarItem.Checked := false;
    BarItem.FromPos := 0;
    BarItem.ToPos := 0;
    BarItem.BinColId := BinColDefault[J].Field;
    BarItem.FieldName := BinColDefault[J].FieldName;
    BarItem.SetType   := setType;
    BarItem.LineSeq := 0;
    BarItem.LineNum := 1;
    BarConfig.Add(BarItem);
  end; //for j
end;//


{
********************************************************************************
  This procedure checks wether our WC has a set defined for it or not.
  @param workcenter the wkc we are checking for
********************************************************************************
}

function TFBarConfig.IsWkcAvaliable(workcenter: String): boolean;
var
  i: Integer;
  WkcSet: PTWorkCenterBarSet;
begin
  Result := true;
  for i:= 0 to WkcSetList.Count-1 do   //find our workcenter
  begin
    WkcSet := WkcSetList.Items[i];
    if ( ( WkcSet.WKC_Code = workcenter ) and
         ( Wkcset.set_type = setType    ) and
         ( Wkcset.set_name <> GlobalSetName ) ) then
       begin
         Result := false; //found a different set for this wkc
         break;
       end;
  end;//for
end;

procedure TFBarConfig.Panel1Click(Sender: TObject);
begin

end;

{
********************************************************************************
  This procedure checks wether our WC has a set defined for it or not.
  @param workcenter the wkc we are checking for
********************************************************************************
}

function TFBarConfig.Save(newset,SaveBarData,SaveWkcSet: boolean; SetName, SetType : string): boolean;
begin
  Result := true;
  if SaveBarData then
    SaveBarDataToDB(newset, SetName, SetType);
  if SaveWkcSet  then
    SaveWkcSetToDB(SetType);
end;


initialization
  BarSetList := Tlist.Create;
  WkcSetList := Tlist.Create;


finalization
  ClearBarSetList;
  BarSetList.free;
  ClearWkcSetList;
  WkcSetList.free;


end.

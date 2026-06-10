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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls,
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
  variants, Buttons, ComCtrls, UGGlobal;

type
  // holds one row of the set
  TBarCurrentSet = Record
    Field     : Integer;
    OrgTitle  : string;
    Title     : string;
    Checked   : boolean;
    FromPos   : integer;
    ToPos     : integer;
    Width     : integer;
    Visible   : boolean;
  end;

  // one set
    PTBarItem = ^TBarCurrentSet;
    PTBarSetListItems = ^TList;

  //holds one set and it's name
  TBarDefinitionSet = Record
    set_type    : String; //job bar or status bar
    set_name    : String;
 //   Index   : Integer;
    workstation : String;
    CurrentSet: PTBarSetListItems;
  end;
  PTBarDefinitionSet = ^TBarDefinitionSet;

  //holds one set Name and the Wkc to apply to
  TWorkCenterBarSet = Record
    WKC_Code    : String;
    set_name    : String;
    set_type    : String; //job bar or status bar
    workstation : String;
    CurrentSet  : PTBarSetListItems;
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
    BitOK: TBitBtn;
    BitAbort: TBitBtn;
    Bevel1: TBevel;
    constructor Create(AOwner: TComponent; setT,setN: string); reintroduce;
    procedure CreateFrameArray(setName: String);
    procedure CreateNewFrame(var BaseFrame: Tframe; index: integer);
    procedure FillFrameData(var SetName: String; SetIndex,frameIndex: Integer);
    function  getBarSet(var SetName: string):PTBarSetListItems;
    procedure FindSetIndex(SetName: String; Var setIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SaveBarDataToDB(newset: boolean);
    procedure SaveWkcSetToDB();
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
   
  private
    { Private declarations }
     frameArray: Array [0..BinColNum] of TFrame;  //83 columns
  public
    { Public declarations }
  end;

  procedure LoadBarDataFromDB();
  procedure LoadWkcSetsFromDB();
  function  GetValueOfField(index,WkcIndex: Integer; sc:TSCProdSched; isGroup: boolean):variant;//ProdReqDet: TSCProdReqDet): String;
  function  GetPropertyValue(PropertyIndex: Integer; sc:TSCProdSched):variant;
  function  GetBarString(workcenter: String; sc:TSCProdSched; isGroup: boolean;  isJobBar:boolean):string;//ProdReqDet: TSCProdReqDet):string;

var
  FBarConfig: TFBarConfig;

implementation

{$R *.DFM}

var
  BarSetList : Tlist;
  WkcSetList : Tlist;
  setType,
  GlobalSetName    : string;

//----------------------------------------------------------------------------//

constructor TFBarConfig.Create(AOwner: TComponent; setT,setN: string);
begin
  inherited Create(AOwner);
  setType := setT;
  if setType = 'Job_bar' then
    Caption := _('Configuration of job bar set')
  else
    Caption := _('Configuration of status bar set');
  GlobalSetName := setN;

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
begin
  BaseFrame := TFrame.Create(self);
  BaseFrame.parent := self;
  //BaseFrame.top:=10;
  //BaseFrame.Left := 0;
  //BaseFrame.Top := 0;
    BaseFrame.Width := 415 * Screen.PixelsPerInch div DEFAULT_DPI;
    BaseFrame.Height := 31 * Screen.PixelsPerInch div DEFAULT_DPI;
    BaseFrame.TabOrder := 0;
  
  CB_Field:= TCheckBox.Create(BaseFrame);
  CB_Field.Parent := BaseFrame;
  CB_Field.Left := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  CB_Field.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  CB_Field.Width := 145 * Screen.PixelsPerInch div DEFAULT_DPI;
  CB_Field.Height := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
  CB_Field.Caption := '';
  CB_Field.TabOrder := 0 ;
 // CB_Field.OnClick := enableRowClick;
  CB_Field.Name := 'CB' + inttostr(index);

  Edit_heading := TEdit.Create(BaseFrame);
  Edit_heading.Parent := BaseFrame;
  Edit_heading.Left := 168 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_heading.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_heading.Width := 145 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_heading.Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_heading.TabOrder := 1;

  Edit_From := TEdit.Create(BaseFrame);
  Edit_From.Parent := BaseFrame;
  Edit_From.Left := 330 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_From.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_From.Width := 25 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_From.Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_From.TabOrder := 2 ;
  Edit_From.Text := '0';

  Lbl_to := TLabel.Create(BaseFrame);
  Lbl_to.Parent := BaseFrame;
  Lbl_to.Left := 360 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_to.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_to.Width := 15 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_to.Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_to.Alignment := taCenter;
  Lbl_to.Anchors := [akLeft, akBottom];
  Lbl_to.Caption := 'to';

  Edit_To := TEdit.Create(BaseFrame);
  Edit_To.Parent := BaseFrame;
  Edit_To.Left := 380 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_To.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_To.Width := 25 * Screen.PixelsPerInch div DEFAULT_DPI ;
  Edit_To.Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI ;
  Edit_To.TabOrder := 2 ;
  Edit_To.Text := '40';
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
  I, skippedRows: Integer;
  BarConfig: PTBarSetListItems;
begin
  skippedRows := 0;
  BarConfig := getBarSet(setName);
  for I := 0 to BarConfig.Count-1 do
  begin
    //this should be checked where to check visible
    if  BinDefaultTabColumnSet[i].Visible = false then
     begin
       skippedRows := skippedRows + 1;
       continue;
     end;

   if not assigned(frameArray[I]) then
     begin
       createNewFrame(frameArray[I],I);
       frameArray[I].parent := SB_Frames;
       frameArray[I].left:= -3;
       frameArray[I].top:= (I - skippedRows) * 30;
       frameArray[I].name := 'Frame' + InttoStr(I);
     end;//if
    FillFrameData(setName,0,I); //default data index=0
    end;// for
  UpdateWkcCLB(setName);
end;

{
********************************************************************************
  This procedure creates the actual frame.
  @param BaseFrame is a frame object being returned
  @param index is the frame index in the frame array
********************************************************************************
}
function TFBarConfig.getBarSet(var SetName: string):PTBarSetListItems;
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

procedure TFBarConfig.FillFrameData(var SetName: String; SetIndex,frameIndex: Integer);
var
  j: Integer;
  PropDescription: String;
  BarConfig: PTBarSetListItems;
  BarItem: PTBarItem;
  pId: TPropId;
  propertyIndex: Integer;
begin
  try
  propertyIndex := getNumberfields;
  BarConfig := getBarSet(setName);
  //loop over the components of the frame and fill their data
  for j := 0 to (frameArray[frameIndex].ComponentCount -1) do
  begin
   BarItem := BarConfig.Items[frameIndex];
   case j of
       0: begin
            TCheckBox(frameArray[frameIndex].Components[j]).Checked := BarItem.Checked;

            If (frameIndex + 1)> propertyIndex then  // for properties get their name and values
            begin
              pId :=DBAppGlobals.ShowBinPropArry[frameIndex - propertyIndex  ];
              PropDescription := GetPropDescr(pId);//GetPropCodeFromID(pId);
              BarItem.OrgTitle :=  PropDescription;//BinDefaultTabColumnSet[j].Title;
              BarItem.Field := frameIndex;
              BarItem.Title := BarItem.OrgTitle;
         //     BarItem.Checked := false;
              BarItem.Checked := BarItem.Checked;
              BarItem.FromPos := 0;
              BarItem.ToPos := 0;
            end;
            TCheckBox(frameArray[frameIndex].Components[j]).Caption := BarItem.OrgTitle;
          end;
       1: TEdit(frameArray[frameIndex].Components[j]).Text := BarItem.Title;

       2: TEdit(frameArray[frameIndex].Components[j]).Text := IntToStr(BarItem.FromPos);

       4: TEdit(frameArray[frameIndex].Components[j]).Text := IntToStr(BarItem.ToPos);

     end; //case

   end; //for j

   except
     on e:Exception do MessageDlg('FMBarConfig - FillFrameData'+#13'Message: '+e.Message,mtError, [mbOK],0);
  //   exit;
   end;

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
begin
  try
  TranslateComponent(self);
  ScaleFormSize(Self, Screen.PixelsPerInch);

  CLBWorkCenters.Items.Clear;

  for i := 0 to p_pl.p_WrkCtrsCount-1 do
  begin
    workcenter := TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_WrkCtrCode;
    CLBWorkCenters.Items.Add(workcenter);
    if IsWkcAvaliable(workcenter) then
      CLBWorkCenters.ItemEnabled[i] := true
    else
      CLBWorkCenters.ItemEnabled[i] := false;
  end;

   LblSetName.Caption := _('Set name:') + ' ' + GlobalsetName;
   createFrameArray(GlobalsetName); //show the active set
  except
    on e:Exception do MessageDlg('FMBarConfig - FormCreate'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

{
********************************************************************************
  This procedure loads the sets data from the DB.
  Is called from the FMMainPlan FormCreate
********************************************************************************
}

procedure LoadBarDataFromDB();
var
 temp:       integer;
 qry:        TMqmQuery;
 trs:        TMqmTransaction;
 tbInfo:     ^TTblInfo;
 BarConfig:  PTBarSetListItems;
 BarItem:    PTBarItem;
// Index,
// setIndex :  integer;
 DefSet:     PTBarDefinitionSet;
 setName,
 PrevSetName,
 setType,
 PrevSetType,
 CurrentWS:  String;
begin
  try
  BarConfig := nil;

//  Index := -1;
  SetName := '';
  BarsetList.Clear;
  trs := CreateTransaction(Cfg_DB, true);
  qry := CreateQuery(trs, Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_text_display_set_fields];
  SetFldPfx(tbInfo.pfx);
///  try
  qry.Transaction.StartTransaction;

  CurrentWS := IniAppGlobals.WkstCode;

  qry.SQL.Add('select * from ' + tbInfo.PCname );
  qry.SQL.Add(' where ' + CreatePfxFld(fli_workstation) + '= ''' + CurrentWS + '''');
  qry.SQL.Add(' order by '+ CreatePfxFld(fli_settype));//CreatePfxFld(fli_setIndex));
  qry.SQL.Add(', ' + CreatePfxFld(fli_setname));
  qry.SQL.Add(', ' + CreatePfxFld(fli_fieldType));
  qry.open;

  if qry.Eof then  //No data in DB
  begin
    exit;
  end;//EOF

  while not qry.Eof do
  begin
{
    setIndex := qry.FieldByName(CreatePfxFld(fli_setIndex)).Asinteger;
    if setIndex < 0 then break;
    if ( setIndex > Index ) then
}
    setName := qry.FieldByName(CreatePfxFld(fli_setName)).AsString;
    setType := qry.FieldByName(CreatePfxFld(fli_setType)).AsString;
    if  ( setName <> PrevSetName ) or (setType <> PrevSetType )then
    begin
  //    Index := setIndex;
      PrevSetName       := setName;
      PrevSetType       := setType;
      new(BarConfig);
      BarConfig^        := Tlist.Create;
      new(DefSet);
      DefSet.set_name    := qry.FieldByName(CreatePfxFld(fli_SetName)).AsString;
      DefSet.set_Type    := qry.FieldByName(CreatePfxFld(fli_SetType)).AsString;
//      DefSet.Index      := Index;
      DefSet.workstation := qry.FieldByName(CreatePfxFld(fli_workstation)).AsString;
      DefSet.CurrentSet  := BarConfig;
      BarSetList.Add(DefSet);
    end;
    new(BarItem);

    BarItem.Field := qry.FieldByName(CreatePfxFld(fli_fieldType)).AsInteger;//BinColDefault[].Field;
    BarItem.Title := qry.FieldByName(CreatePfxFld(fli_title)).AsString;
    BarItem.OrgTitle := qry.FieldByName(CreatePfxFld(fli_orgTitle)).AsString;
    temp := qry.FieldByName(CreatePfxFld(fli_checked)).AsInteger;
    if temp = 0 then BarItem.Checked := false;
    if temp = 1 then BarItem.Checked := true;
    BarItem.FromPos := qry.FieldByName(CreatePfxFld(fli_fromPos)).AsInteger;
    BarItem.ToPos := qry.FieldByName(CreatePfxFld(fli_toPos)).AsInteger;

    BarConfig.Add(BarItem);
    qry.Next;
  end; //while
 
  qry.Close;        //Vinc
  trs.Commit;       //Vinc

  qry.Free;         //Vinc
  trs.Free;         //Vinc

  except
    on e:Exception do MessageDlg('FMBarConfig - LoadBarDataFromDB'+#13'Message: '+e.Message,mtError, [mbOK],0);
  {
      qry.Close;        //Vinc
      trs.Commit;       //Vinc

      qry.Free;         //Vinc
      trs.Free;         //Vinc
      }
  end;
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
  trs:           TMqmTransaction;
  tbInfo:        ^TTblInfo;
  i :            Integer;
  DefSet:        PTBarDefinitionSet;
  WorkCenterSet: PTWorkCenterBarSet;
  CurrentWS:     String;
begin
try
  WkcSetList.Clear;
  trs := CreateTransaction(Cfg_DB, true);
  qry := CreateQuery(trs, Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_text_display_set_wkc];
  SetFldPfx(tbInfo.pfx);
  qry.Transaction.StartTransaction;

  CurrentWS := IniAppGlobals.WkstCode;

  qry.SQL.Add('select * from ' + tbInfo.PCname + ' where ' + CreatePfxFld(fli_workstation) + ' = ''' + CurrentWS + '''');
  qry.open;

  while not qry.Eof do
  begin
    new(WorkCenterSet);
    WorkCenterSet.WKC_Code    := qry.FieldByName(CreatePfxFld(fli_wkCtrCode)).AsString;
    WorkCenterSet.set_name    := qry.FieldByName(CreatePfxFld(fli_setName)).AsString;
    WorkCenterSet.set_Type    := qry.FieldByName(CreatePfxFld(fli_SetType)).AsString;
    WorkCenterSet.workstation := qry.FieldByName(CreatePfxFld(fli_workstation)).AsString;

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

  qry.Close;          //Vinc
  trs.Commit;         //Vinc

  qry.Free;          //Vinc
  trs.Free;          //Vinc
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

procedure TFBarConfig.SaveWkcSetToDB();
var
  i:             Integer;
  qry:           TMqmQuery;
  trs:           TMqmTransaction;
  tbInfo:        ^TTblInfo;
  WorkCenterSet: PTWorkCenterBarSet;
  CurrentWS:     String;
begin
try
  tbInfo := @tblInfo[tbl_cfg_text_display_set_wkc];
  SetFldPfx(tbInfo.pfx);
  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(trs,Cfg_DB);
  trs.StartTransaction;
  CurrentWS := IniAppGlobals.WkstCode;

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' +  tbInfo.PCname );
  qry.SQL.Add('where ' + CreatePfxFld(fli_workstation) + ' = ''' + CurrentWS + '''');
  qry.ExecSQL;
  qry.Close;
  trs.Commit;

  trs.StartTransaction;


  qry.SQL.Clear;
  qry.SQL.Add('Insert into ' + tbInfo.PCname  + ' ( ');
  qry.SQL.Add(CreatePfxFld(fli_workstation)   + ' ,' );
  qry.SQL.Add(CreatePfxFld(fli_setType)       + ' ,' );
  qry.SQL.Add(CreatePfxFld(fli_SetName)       + ' ,' );
  qry.SQL.Add(CreatePfxFld(fli_wkCtrCode)     + ' )' );

  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreatePfxFld(fli_workstation)  + ' ,' );
  qry.SQL.Add(':' + CreatePfxFld(fli_setType)    + ' ,' );
  qry.SQL.Add(':' + CreatePfxFld(fli_SetName)    + ' ,' );
  qry.SQL.Add(':' + CreatePfxFld(fli_wkCtrCode)  + ' )' );


  qry.Prepare;

  for i:= 0 to WkcSetList.count-1 do
  begin
    WorkCenterSet := WkcSetList.Items[i];
    qry.ParamByName(CreatePfxFld(fli_workstation)).AsString := WorkCenterSet.workstation ;
    qry.ParamByName(CreatePfxFld(fli_SetType)).AsString     := WorkCenterSet.set_type ;
    qry.ParamByName(CreatePfxFld(fli_setName)).AsString     := WorkCenterSet.set_name ;
    qry.ParamByName(CreatePfxFld(fli_wkCtrCode)).AsString   := WorkCenterSet.WKC_Code ;

    qry.ExecSQL;
  end;//for
  qry.Close;
  trs.Commit;

  qry.Free;
  trs.Free
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

procedure TFBarConfig.SaveBarDataToDB(newset: boolean);
var
  i, j:      Integer;
  qry:       TMqmQuery;
  trs:       TMqmTransaction;
  tbInfo:    ^TTblInfo;
  BarConfig: PTBarSetListItems;
  BarItem:   PTBarItem;
  DefSet:    PTBarDefinitionSet;
  CurrentWS: String;
begin
try
  tbInfo := @tblInfo[tbl_cfg_text_display_set_fields];
  SetFldPfx(tbInfo.pfx);
  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(trs,Cfg_DB);
  trs.StartTransaction;
  CurrentWS := IniAppGlobals.WkstCode;

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' +  tbInfo.PCname );
  qry.SQL.Add('where ' + CreatePfxFld(fli_workstation) + ' = ''' + CurrentWS + '''');
  qry.ExecSQL;
  qry.Close;
  trs.Commit;

  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.PCname    + '(');
  qry.SQL.Add(CreatePfxFld(fli_Workstation)     + ',');
 // qry.SQL.Add(CreatePfxFld(fli_setIndex)        + ',');
  qry.SQL.Add(CreatePfxFld(fli_SetName)         + ',');
  qry.SQL.Add(CreatePfxFld(fli_setType)         + ',');
  qry.SQL.Add(CreatePfxFld(fli_fieldtype)       + ',');
  qry.SQL.Add(CreatePfxFld(fli_title)           + ',');
  qry.SQL.Add(CreatePfxFld(fli_Orgtitle)        + ',');
  qry.SQL.Add(CreatePfxFld(fli_Checked)         + ',');
  qry.SQL.Add(CreatePfxFld(fli_FromPos)         + ',');
  qry.SQL.Add(CreatePfxFld(fli_ToPos)           + ')');
  qry.SQL.Add(' values (');
 // qry.SQL.Add(':' + CreatePfxFld(fli_setIndex)       + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_Workstation)    + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_SetName)        + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_setType)        + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_fieldtype)      + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_title)          + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_OrgTitle)       + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_Checked)        + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_FromPos)        + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_ToPos) );
  qry.SQL.Add(')');
  qry.Prepare;

  for i:=0 to BarSetList.Count-1 do
  begin
    DefSet := BarSetList.Items[i];
      BarConfig := DefSet.CurrentSet;
      for j := 0 to BarConfig.Count -1 do
      begin
        BarItem := BarConfig.Items[j];

    //    qry.ParamByName(CreatePfxFld(fli_setIndex)).AsInteger := i;//So to keep the index updated //DefSet.Index;  //BarSet[i].Index;
        qry.ParamByName(CreatePfxFld(fli_workstation)).AsString := DefSet.workstation;
        qry.ParamByName(CreatePfxFld(fli_SetName)).AsString     := DefSet.set_name; //BarSet[i].set_name;
        qry.ParamByName(CreatePfxFld(fli_setType)).AsString     := DefSet.set_type;
        qry.ParamByName(CreatePfxFld(fli_fieldtype)).AsInteger  := j;
        qry.ParamByName(CreatePfxFld(fli_title)).AsString       := BarItem.Title;
        qry.ParamByName(CreatePfxFld(fli_Orgtitle)).AsString    := BarItem.OrgTitle;
        if  BarItem.Checked then
          qry.ParamByName(CreatePfxFld(fli_Checked)).AsInteger  := 1
        else
          qry.ParamByName(CreatePfxFld(fli_Checked)).AsInteger  := 0;
          qry.ParamByName(CreatePfxFld(fli_FromPos)).AsInteger  := BarItem.FromPos;
          qry.ParamByName(CreatePfxFld(fli_ToPos)).AsInteger    := BarItem.ToPos;

    qry.ExecSQL;
    end;//j
  end;//i

  qry.Close;
  trs.Commit;

  qry.Free;
  trs.Free
  except
    on e:Exception do MessageDlg('FMBarConfig - SaveBarDataToDB'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
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
  BarConfig: PTBarSetListItems;
  BarItem: PTBarItem;
  DefSet: PTBarDefinitionSet;
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
  SaveBarDataToDB(false);
  SaveWkcSetToDB();
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
    if MessageDlg(_('Set is not applied to any work center'), mtConfirmation, [mbOK, mbCancel], 0)in [mrOK] then
    begin
      close;
    end;

  SaveDataToMemory(GlobalSetName, setType); //, false);
  SaveWorkCentersList;

  if checked then close;
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

function getBarString(workcenter: String; sc:TSCProdSched; isGroup: boolean; isJobBar:boolean):String; //ProdReqDet: TSCProdReqDet):string;
var
  FieldValue: String;
  i, j: Integer;
  WkcSet: PTWorkCenterBarSet;
//  DefSet: PTBarDefinitionSet;
  BarConfig: PTBarSetListItems;
  BarItem: PTBarItem;
  FieldLength: integer;
//  ActiveSet:  String;
  setType:    String;
begin
  result := '';

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

  for i:= 0 to WkcSetList.Count-1 do   //find our workcenter
  begin
    WkcSet := WkcSetList.Items[i];
 //   if WkcSet.set_name <> activeSet then continue;
    if WkcSet.WKC_Code <> workcenter then continue;
    if Wkcset.set_type <> setType then continue;
    BarConfig := Wkcset.CurrentSet;

    for j := 0 to BarConfig.Count - 1 do
    begin
      BarItem := BarConfig.Items[j];
      if BarItem.Checked = false then continue;
      if BarItem.field < 0 then continue;
      FieldValue := VartoStr(GetValueOfField(j,i,sc,isGroup));
      if FieldValue = '' then continue;
      FieldLength := BarItem.ToPos - BarItem.FromPos;
      if FieldLength <= 0 then
        FieldValue := Copy(FieldValue,0,50)
      else
        FieldValue := Copy(FieldValue,BarItem.FromPos,FieldLength + 1);
        if Result <> '' then Result := Result + ',  ';
        if BarItem.Title <> '' then
          Result := Result + BarItem.Title + ': ';

        Result := Result + FieldValue;
    end; //for j
  end; //i

  //Default BarString ( if we don't have an Active Set )
  if Result = '' then
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
      if sc.m_grp.m_code < 0 then
      Result := intToStr((-1)* sc.m_grp.m_code) + '(-Host)'
    else
      Result := _('Step group')+ ' ' + intToStr(sc.m_grp.m_code) ;

    end;//if is group
  end; //if Result =''
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

function  GetValueOfField(index,WkcIndex: Integer; sc:TSCProdSched; isGroup: boolean ):variant;//ProdReqDet: TSCProdReqDet):String;
var
  WkcSet: PTWorkCenterBarSet;
//  DefSet: PTBarDefinitionSet;
//  BarConfig: PTBarSetArray;
  BarConfig: PTBarSetListItems;
  BarItem: PTBarItem;
  WrkCtr: TMqmWrkCtr;
  res : TMqmRes;
begin
  result := '';
  WkcSet := WkcSetList.Items[WkcIndex];
  if not assigned(WkcSet)then exit;
  BarConfig := Wkcset.CurrentSet;
  BarItem := BarConfig.Items[Index];
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
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ProdFamily);
       end;
  18:  begin
         result := sc.m_reqDet.m_hdr.m_matFamily;// (Field: CSC_ProdMatFamily;     // MATERIAL FAMILY
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ProdMatFamily);
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
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ProdDlvDate)//DateTimeToStr(sc.m_grp.  p_DeliveryDate);
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
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_MatArrivalDate)
     end;
  26:begin
       result := DateTimeToStr(sc.m_reqDet.m_planStart);//  (Field: CSC_PlanStartDate;  // PLAN START
        if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_PlanStartDate)
     end;
  27:begin
       result := DateTimeToStr(sc.m_reqDet.m_lowStartTimeLimit);//  (Field: CSC_LowStartDate;    // LOWEST START
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_LowStartDate)
     end;
  28:begin
       result := DateTimeToStr(sc.m_reqDet.m_planEnd);//  (Field: CSC_PlanEndDate;    // PLAN END
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_PlanEndDate)
     end;
  29:begin
       result := DateTimeToStr(sc.m_reqDet.m_highEndTimeLimit);//  (Field: CSC_HighEndLimit;   // HIGHEST END
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_HighEndLimit)
     end;
  30:  result := sc.m_reqDet.m_calCod;//  (Field: CSC_Calendar;       // CALENDAR
  31:  begin
         result := sc.m_reqDet.m_quantInit;//  (Field: CSC_IniQty;       // INITIAL QUANTITY
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_IniQty)
       end;
  32:  begin
         result := sc.m_reqDet.m_quantFinl;//  (Field: CSC_FinQty;         // FINAL QUANTITY
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_FinQty)
       end;
  33:  begin
         result := FloatToStr(sc.m_reqDet.m_weight) + '    ' + sc.m_reqDet.m_weightUM; //sc.m_reqDet.m_weightUM;//  (Field: CSC_WeightWithUM;  // WEIGHT + UM
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_WeightWithUM)
       end;
  34:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_PlanSetup);//  (Field: CSC_PlanSetup;     // PLANED SETUP TIME
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_PlanSetup)
       end;
  35:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ExeTime);//  (Field: CSC_ExeTime;   // PLANED EXECUTION TIME
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_ExeTime)
       end;
  36:  result := sc.m_reqDet.m_planNumRes;//  (Field: CSC_NumOfRscPlan;  // NUMBER OF RESOURCES
  37:  result := sc.m_reqDet.m_connTypeToPrevious;//  (Field: CSC_ConnTypePrvStep;   // CONNECTION TYPE PREVIOUS STEP
  38:  begin
         result := p_sc.GetFldDescr(sc.m_id, CSC_QtyToSched);//  (Field: CSC_QtyToSched;   // QUANTITY TO SCHED
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id, CSC_QtyToSched);
       end;
  39:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ExeTimeSched);//  (Field: CSC_ExeTimeSched;    // EXECUTION TIME TO SCHED
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id,  CSC_ExeTimeSched);
       end;
  40:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_SupTimeSched);//  (Field: CSC_SupTimeSched;    // SET - UP TIME TO SCHED
         if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id,  CSC_SupTimeSched);
       end;
  41:  result := sc.p_rscCode;  //  (Field: CSC_Rsc;                  // Resource
  42:  begin
         res := TMqmRes(p_pl.FindResByCode(sc.p_rscCode));
         if Assigned(res) then
         result := res.p_ResSDesc
       end;//  (Field: CSC_RscDesc;   // Resource Desc
  43:begin
       result := p_sc.GetFldDescr(sc.m_Id , CSC_SchedStart);//  (Field: CSC_SchedStart;   // SCHED Start
       if isGroup then result := p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_SchedStart); //DateTimeToStr();
     end;
  44:begin
       result := DateTimeToStr(sc.p_schedEnd);//  (Field: CSC_SchedEnd;         // SCHED End
       if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_SchedEnd);
     end;
  45:  begin
       result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgStart);//  (Field: CSC_ProgStart;         // Progress Start
       if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_ProgStart);
       end;
  46:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgEnd);//  (Field: CSC_ProgEnd;      // Progress end
         if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_ProgEnd);
       end;
  47:  begin
         result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgQty);//  (Field: CSC_ProgQty;             // Progress qty
         if isGroup then result :=  p_sc.GetFldDescr(sc.m_grp.m_Id , CSC_ProgQty);
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
  49:  result := p_sc.GetFldDescr(sc.m_Id , CSC_ProgRsc);//sc.m_ProgRsc;//  (Field: CSC_ProgRsc;    // Progress Resource
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
  55:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property1;         // Property1
  56:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property2;          // Property2
  57:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property3;          // Property3
  58:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property4;         // Property4
  59:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property5;         // Property5
  60:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property6;          // Property6
  61:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property7;           // Property7
  62:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property8;           // Property8
  63:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property9;           // Property9
  64:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property10;  // Property10
  65:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property11;      // Property11
  66:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property12;      // Property12
  67:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property13;      // Property13
  68:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property14;        // Property14
  69:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property15;      // Property15
  70:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property16;      // Property16
  71:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property17;     // Property17
  72:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property18;    // Property18
  73:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property19;      // Property19
  74:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property20;      // Property20
  75:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property21;       // Property21
  76:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property22;     // Property22
  77:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property23;      // Property23
  78:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property24;   // Property24
  79:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property25;// Property25
  80:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property26;     // Property26
  81:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property27;    // Property27
  82:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property28;    // Property28
  83:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property29;     // Property29
  84:  result := GetPropertyValue(BarItem.Field,sc);//  (Field: CSC_property30;      // Property30
   
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


procedure TFBarConfig.BitCloseClick(Sender: TObject);
begin
   close; 
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
  j: Integer;
  BarConfig: PTBarSetListItems;
  BarItem: PTBarItem;
  DefSet: PTBarDefinitionSet;
begin
  new(BarConfig);
  BarConfig^ := Tlist.Create;
  new(DefSet);
  DefSet.set_name := setName;
  DefSet.set_type := setType;
//  DefSet.Index := BarSetList.Count;
  DefSet.workstation := IniAppGlobals.WkstCode; 
  DefSet.CurrentSet := BarConfig;
  BarsetList.Add(DefSet);

  for j := 0 to BinColNum -1  do
  begin
    new(BarItem);
    BarItem.Field := BinDefaultTabColumnSet[j].Index;  //Pos; // Field;
    BarItem.OrgTitle := BinDefaultTabColumnSet[j].Title;
    BarItem.Title := BinDefaultTabColumnSet[j].Title;
    BarItem.Checked := false;
    BarItem.FromPos := 0;
    BarItem.ToPos := 0;

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


initialization
  BarSetList := Tlist.Create;
  WkcSetList := Tlist.Create;


finalization
  BarSetList.free;
  WkcSetList.free;


end.

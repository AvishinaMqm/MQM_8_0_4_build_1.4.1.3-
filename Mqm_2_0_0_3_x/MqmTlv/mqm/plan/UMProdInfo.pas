unit UMProdInfo;

interface

uses
  classes, Sysutils,
  UMCommon,
  stdctrls,
  DMSrvPC,
  gnugettext;

type

  InfoType = (IF_Gen, IF_Prod, IF_Mat, IF_Inst, IF_Comments, IF_Others);

  TMProdInfo = class
  private
    m_list : TStringList;
    m_LastRequest: string;
    m_LastIndex: integer;
    procedure clear;
    procedure AddInformation(ProdReq : string; stepId : Integer; If_Type : InfoType ; InfoArea : string);
  public
    procedure GetInformation(ProdReq : string; stepId : Integer; If_Type : InfoType ; HeaderList : TStringlist ;StepInfoList : TStringlist);
    procedure LoadAllFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
    procedure LoadFromDb(ProdReq: string);
    Constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  UMGlobal,
  UMTblDesc;

type

  TInfoStep = Class
    m_StepId : integer;
    m_InfoType : InfoType;
    m_GenInfo : TStringList;
    m_ProdInfo : TStringList;
    m_MatInfo : TStringList;
    m_InstInfo : TStringList;
    m_CommInfo : TStringList;
    m_OthersInfo : TStringList;
    destructor Destroy ; override;
  end;

  TInfoHeadr = class
    m_InfoType : InfoType;
    m_infoHeader : TStringList;
    destructor Destroy ; override;
  end;

  TInfoCont = class
   m_Header  : TList;
   m_StepInfo : TList;
   destructor Destroy ; override;
  end;

{ TMProdInfo }

//----------------------------------------------------------------------------//

procedure TMProdInfo.AddInformation(ProdReq: string; stepId: Integer; If_Type: InfoType; InfoArea: string);
var
  i : integer;
  InfoCont : TInfoCont;
  StpInfo  : TInfoStep;
  HeadrInfo : TInfoHeadr;
  FoundStep : boolean;
  FoundHeadr : boolean;
begin
  HeadrInfo := nil;
  StpInfo := nil;

  FoundStep := false;
  FoundHeadr := false;

  if ProdReq = m_LastRequest then
    i := m_LastIndex
  else
  begin
    m_LastRequest := ProdReq;
    i := m_list.IndexOf(ProdReq);
    m_LastIndex := i;
  end;

  if i = -1 then
  begin
    m_list.Add(ProdReq);
    i := m_list.IndexOf(ProdReq);
    m_LastIndex := i;
    m_list.Objects[i] := TInfoCont.Create;
  end;

  InfoCont := TInfoCont(m_list.Objects[i]);

  if stepId = 0 then
  begin
    if not Assigned(InfoCont.m_Header) then
      InfoCont.m_Header := TList.Create;

    for I := 0 to InfoCont.m_Header.count - 1 do
    begin
      if TInfoHeadr(InfoCont.m_Header[I]).m_InfoType = If_Type then
      begin
        HeadrInfo := TInfoHeadr(InfoCont.m_Header[I]);
        FoundHeadr := true;
        break;
      end;
    end;

    if not FoundHeadr then
    begin
      HeadrInfo := TInfoHeadr.create;
      HeadrInfo.m_InfoType := If_Type;
      HeadrInfo.m_infoHeader := TStringList.Create;
    end;
    HeadrInfo.m_infoHeader.add(InfoArea);
    if not FoundHeadr then
      InfoCont.m_Header.add(HeadrInfo);
  end else
  begin
    if not Assigned(InfoCont.m_StepInfo) then
      InfoCont.m_StepInfo := TList.Create;

    for I := 0 to InfoCont.m_StepInfo.count - 1 do
    begin
      if TInfoStep(InfoCont.m_StepInfo[I]).m_StepId = stepId then
      begin
        StpInfo := TInfoStep(InfoCont.m_StepInfo[I]);
        FoundStep := true;
        break;
      end;
    end;

    if not FoundStep then
    begin
      StpInfo := TInfoStep.create;
      StpInfo.m_StepId := stepId;
    end;

    case If_Type of
    IF_Gen : begin                 // General Information
          if not Assigned(StpInfo.m_GenInfo) then
            StpInfo.m_GenInfo := TStringList.Create;
          StpInfo.m_GenInfo.add(InfoArea);
        end;

    IF_Prod : begin                 // Product Information
          if not Assigned(StpInfo.m_ProdInfo) then
            StpInfo.m_ProdInfo := TStringList.Create;
          StpInfo.m_ProdInfo.add(InfoArea);
        end;

    IF_Mat : begin                 // Materials Information
          if not Assigned(StpInfo.m_MatInfo) then
            StpInfo.m_MatInfo := TStringList.Create;
          StpInfo.m_MatInfo.add(InfoArea);
        end;

    IF_Inst : begin                 // Instruction Information
          if not Assigned(StpInfo.m_InstInfo) then
            StpInfo.m_InstInfo := TStringList.Create;
          StpInfo.m_InstInfo.add(InfoArea);
        end;

    IF_Comments : begin                 // Comments Information
          if not Assigned(StpInfo.m_CommInfo) then
            StpInfo.m_CommInfo := TStringList.Create;
          StpInfo.m_CommInfo.add(InfoArea);
        end;

    IF_Others : begin                 // Others Information
          if not Assigned(StpInfo.m_OthersInfo) then
            StpInfo.m_OthersInfo := TStringList.Create;
          StpInfo.m_OthersInfo.add(InfoArea);
        end;

    end;

    if not FoundStep then
    begin
      InfoCont.m_StepInfo.add(StpInfo);
    end;

  end;
end;

//----------------------------------------------------------------------------//

procedure TMProdInfo.clear;
var
  I : Integer;
begin
  for I := 0 to m_list.Count - 1 do
    TInfoCont(m_list.Objects[I]).free;

  m_list.Clear;
end;

//----------------------------------------------------------------------------//

constructor TMProdInfo.Create;
begin
  Inherited Create;
  m_list := TStringList.Create;
end;

//----------------------------------------------------------------------------//

destructor TMProdInfo.Destroy;
begin
  Clear;
  m_list.free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMProdInfo.GetInformation(ProdReq : string; stepId : Integer; If_Type : InfoType ; HeaderList : TStringlist ; StepInfoList : TStringlist);
var
  I,J : Integer;
  HeadrInfo : TInfoHeadr;
  StepInfo   : TInfoStep;
  InfoCont : TInfoCont;
begin

  I := m_list.IndexOf(ProdReq);

  if I = -1 then
  begin
    LoadFromDb(ProdReq);
    I := m_list.IndexOf(ProdReq);
  end;
  
  if I = -1 then
    exit;

  InfoCont := TInfoCont(m_list.Objects[I]);

  if Assigned(InfoCont.m_Header) then
  begin

    for I := 0 to InfoCont.m_Header.Count - 1 do
    begin
      if TInfoHeadr(InfoCont.m_Header[I]).m_InfoType = If_Type then
      begin
        HeadrInfo := TInfoHeadr(InfoCont.m_Header[I]);
        for J := 0 to HeadrInfo.m_infoHeader.Count -1 do
          HeaderList.add(HeadrInfo.m_infoHeader.Strings[J]);
        break;
      end;
    end;

  end;

  if Assigned(InfoCont.m_StepInfo) then
  begin

    for I := 0 to InfoCont.m_StepInfo.Count - 1 do
    begin
      if TInfoStep(InfoCont.m_StepInfo[I]).m_StepId = stepId then
      begin
        StepInfo := TInfoStep(InfoCont.m_StepInfo[I]);
        case If_Type of

          IF_Gen : begin
                     if Assigned(StepInfo.m_GenInfo) then
                        for J := 0 to StepInfo.m_GenInfo.Count -1 do
                          StepInfoList.add(StepInfo.m_GenInfo.Strings[J]);
                   end;

          IF_Prod : begin
                      if Assigned(StepInfo.m_ProdInfo) then
                        for J := 0 to StepInfo.m_ProdInfo.Count -1 do
                           StepInfoList.add(StepInfo.m_ProdInfo.Strings[J]);
                    end;

          IF_Mat :  begin
                      if Assigned(StepInfo.m_MatInfo) then
                        for J := 0 to StepInfo.m_MatInfo.Count -1 do
                          StepInfoList.add(StepInfo.m_MatInfo.Strings[J]);
                    end;
          IF_Inst : begin
                      if Assigned(StepInfo.m_InstInfo) then
                        for J := 0 to StepInfo.m_InstInfo.Count -1 do
                          StepInfoList.add(StepInfo.m_InstInfo.Strings[J]);

                    end;
          IF_Comments : begin
                          if Assigned(StepInfo.m_CommInfo) then
                            for J := 0 to StepInfo.m_CommInfo.Count -1 do
                              StepInfoList.add(StepInfo.m_CommInfo.Strings[J]);
                        end;
          IF_Others : begin
                        if Assigned(StepInfo.m_OthersInfo) then
                          for J := 0 to StepInfo.m_OthersInfo.Count -1 do
                            StepInfoList.add(StepInfo.m_OthersInfo.Strings[J]);
                      end;
        end;
        break;
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMProdInfo.LoadFromDb(ProdReq : string);
var
  tbInfo:     ^TTblInfo;
  Info_Type : InfoType;
  qry:    TMqmQuery;
begin
  qry := CreateQuery(Main_DB);
  Info_Type := IF_Gen;
  tbInfo := @tblInfo[tbl_prod_info];

  with qry do
  begin
    sql.Clear;
    SQL.Add(' select * from ' + tbInfo.GetTableName);
    SQL.Add(' where ' + CreateFld(tbInfo.pfx,fli_preqNo) + ' = ''' + ProdReq + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    SQL.Add(' Order by ' + CreateFld(tbInfo.pfx,fli_preqNo) + ',' + CreateFld(tbInfo.pfx,fli_pstepId) + ',');
    SQL.Add(CreateFld(tbInfo.pfx,fli_infoType) + ',' + CreateFld(tbInfo.pfx,fli_infoLineNum));
    open;

    while not Eof do
    begin
      case StrToInt(FieldByName(CreateFld(tbInfo.pfx,fli_infoType)).Asstring) of
        1 : Info_Type := IF_Gen;
        2 : Info_Type := IF_Prod;
        3 : Info_Type := IF_Mat;
        4 : Info_Type := IF_Inst;
        5 : Info_Type := IF_Comments;
        9 : Info_Type := IF_Others;
      end;
      AddInformation(FieldByName(CreateFld(tbInfo.pfx,fli_preqNo)).AsString,
                     FieldByName(CreateFld(tbInfo.pfx,fli_pstepId)).AsInteger,
                     Info_Type,
                     FieldByName(CreateFld(tbInfo.pfx,fli_InfoArea)).AsString
                     );
      next;
    end;
  end;
  qry.Close;

end;

//----------------------------------------------------------------------------//

procedure TMProdInfo.LoadAllFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
var
  tbInfo:     ^TTblInfo;
//  tbiPS:      ^TTblInfo;
//  tbiPD:      ^TTblInfo;
//  tbiPH:      ^TTblInfo;
//  tbiWW:      ^TTblInfo;
//  tbiSP:      ^TTblInfo;
  Info_Type : InfoType;
begin
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading additional info from database...');

  Info_Type := IF_Gen;

  tbInfo := @tblInfo[tbl_prod_info];

  with qry do
  begin
    sql.Clear;
    SQL.Add(' select * from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    SQL.Add(' Order by ' + CreateFld(tbInfo.pfx,fli_preqNo) + ',' + CreateFld(tbInfo.pfx,fli_pstepId) + ',');
    SQL.Add(CreateFld(tbInfo.pfx,fli_infoType) + ',' + CreateFld(tbInfo.pfx,fli_infoLineNum));

    open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(1000);
    if Assigned(Status) then
      Status.Caption := _('Loading additional info in memory...');

    while not Eof do
    begin
      case StrToInt(FieldByName(CreateFld(tbInfo.pfx,fli_infoType)).Asstring) of
        1 : Info_Type := IF_Gen;
        2 : Info_Type := IF_Prod;
        3 : Info_Type := IF_Mat;
        4 : Info_Type := IF_Inst;
        5 : Info_Type := IF_Comments;
        9 : Info_Type := IF_Others;
      end;
      AddInformation(FieldByName(CreateFld(tbInfo.pfx,fli_preqNo)).AsString,
                     FieldByName(CreateFld(tbInfo.pfx,fli_pstepId)).AsInteger,
                     Info_Type,
                     FieldByName(CreateFld(tbInfo.pfx,fli_InfoArea)).AsString
                     );
      next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

destructor TInfoCont.Destroy;
var
  I : Integer;
begin
  if Assigned(m_Header) then
  begin
    for I := 0 to m_Header.count - 1 do
      TInfoHeadr(m_Header[I]).Free;
  end;

  if Assigned(m_StepInfo) then
  begin
    for I := 0 to m_StepInfo.count - 1 do
      TInfoStep(m_StepInfo[I]).Free;
  end;

  inherited destroy;

end;

//----------------------------------------------------------------------------//

destructor TInfoStep.Destroy;
begin
  if Assigned(m_GenInfo) then
    m_GenInfo.free;
  if Assigned(m_ProdInfo) then
    m_ProdInfo.free;
  if Assigned(m_MatInfo) then
    m_MatInfo.free;
  if Assigned(m_InstInfo) then
    m_InstInfo.free;
  if Assigned(m_CommInfo) then
    m_CommInfo.free;
  if Assigned(m_OthersInfo) then
    m_OthersInfo.free;

  inherited destroy;

end;

//----------------------------------------------------------------------------//

destructor TInfoHeadr.Destroy;
begin
  if Assigned(m_infoHeader) then
    m_infoHeader.Free;
  inherited Destroy;
end;

end.


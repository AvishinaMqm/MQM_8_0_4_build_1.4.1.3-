unit UMObjCont;

interface

uses
  UMSchedCont,
  UMOpStack,
  UMPlan,
  UMProdInfo,
  UMWkCtrDesc,
  UMArticle,
  UMArticles,
  UMPriorities;


  function InitializeObjects: boolean;

  function p_sc:      TMSchedCont;
  function p_pl:      TMqmPlan;
  function p_opStack: TOpStack;
  function p_Priorities: TMPriorities;
  function p_ProdInfo : TMProdInfo;
  function p_WrkctrDesc : TWorkCntrDesc;
  function p_ArtType : TArticle; // trasforare in TMQMArtType
  function p_ArtTypeList : TMQMArtTypeList;

implementation

uses
  UMGlobal,
  DMSrvPC,
  UMCompat;

var
  s_sc:          TMSchedCont;
  s_mainPlan:    TMqmPlan;
  s_opStack:     TOpStack;
  s_Priorities:  TMPriorities;
  s_ProdInfo :   TMProdInfo;
  s_WrkctrDesc : TWorkCntrDesc;
  S_ArtType    : TArticle;
  s_ArtTypeList: TMQMArtTypeList;

//----------------------------------------------------------------------------//

function InitializeObjects: boolean;
var
  qry: TMqmQuery;
begin
  qry := CreateQuery(Main_DB);

  LoadPropRec(qry);

  qry.Close;
  qry.Free;

  Result := true
end;

//----------------------------------------------------------------------------//

function p_sc: TMSchedCont;
begin
  if not Assigned(s_sc) then
    s_sc := TMSchedCont.Create;
  Result := s_sc
end;

//----------------------------------------------------------------------------//

function p_pl: TMqmPlan;
begin
  if not Assigned(s_mainPlan) then
    s_mainPlan := TMqmPlan.CreatePlan(p_sc);
  Result := s_mainPlan
end;

//----------------------------------------------------------------------------//

function p_opStack: TOpStack;
begin
  if not Assigned(s_opStack) then
    s_opStack := TOpStack.CreateStack;
  Result := s_opStack
end;

//----------------------------------------------------------------------------//

function p_Priorities: TMPriorities;
begin
  if not Assigned(s_Priorities) then
    s_Priorities := TMPriorities.Create;
  Result := s_Priorities
end;

//----------------------------------------------------------------------------//

function p_ProdInfo : TMProdInfo;
begin
  if not Assigned(s_ProdInfo) then
    s_ProdInfo := TMProdInfo.Create;
  Result := s_ProdInfo
end;

//----------------------------------------------------------------------------//

function p_WrkctrDesc : TWorkCntrDesc;
begin
  if not Assigned(S_WrkctrDesc) then
    S_WrkctrDesc := TWorkCntrDesc.Create;
  Result := S_WrkctrDesc;
end;

//----------------------------------------------------------------------------//

function p_ArtType : TArticle;
begin
  if not Assigned(S_ArtType) then
    S_ArtType := TArticle.Create;
  Result := S_ArtType;
end;

//----------------------------------------------------------------------------//

function p_ArtTypeList : TMQMArtTypeList;
begin
  if not Assigned(S_ArtTypeList) then
    S_ArtTypeList := TMQMArtTypeList.Create;
  Result := S_ArtTypeList;
end;

//----------------------------------------------------------------------------//

function GetMainSchedCont: TMSchedCont;
begin
  if not Assigned(s_sc) then
    s_sc := TMSchedCont.Create;
  Result := s_sc
end;

//----------------------------------------------------------------------------//

function GetMainPlan: TMqmPlan;
begin
  if not Assigned(s_mainPlan) then
    s_mainPlan := TMqmPlan.CreatePlan(GetMainSchedCont);
  Result := s_mainPlan
end;

//----------------------------------------------------------------------------//

initialization

  s_sc       := nil;
  s_mainPlan := nil;
  s_ProdInfo := nil;
  s_opStack  := nil;
  s_Priorities := nil;
  s_WrkctrDesc := nil;

finalization

  try
    if Assigned(s_sc) then s_sc.Free;
  except
  end;

  try
    if Assigned(s_mainPlan) then s_mainPlan.Free;
  except
  end;

  try
    if Assigned(s_ProdInfo) then s_ProdInfo.Free;
  except
  end;

  try
    if Assigned(s_Priorities) then s_Priorities.Free;
  except
  end;

  try
    if Assigned(s_opStack)    then s_opStack.Free;
  except
  end;

  try
    if Assigned(s_WrkctrDesc) then s_WrkctrDesc.Free;
  except
  end;

  try
    if Assigned(s_ArtTypeList) then s_ArtTypeList.Free;
  except
  end;

//----------------------------------------------------------------------------//

end.

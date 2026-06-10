unit UMBatchQtyConv;

interface

uses
  classes,
  UMSchedContFunc;

type

  TBtchQtyConv = class
    constructor Create;
    destructor  Destroy; override;
  private
    m_recList: TList;
    m_ProdReqNo: string;
    m_ProdReqStp: integer;
    procedure MainIdChanged;
    procedure Clear;
  public
    procedure SetMainId(id: TSchedId);
    function ResUmToProdUm(BatchUm: string; ResQty: double): double;
    function ProdUmToResUm(BatchUm: string; ProdQty: double): double;
  end;

implementation

uses
  SysUtils,
  UMTblDesc,
  DMSrvPC,
  UMCommon,
  UMSchedCont,
  UMObjCont;

type

  TQtyConvRec = record
    BtchSizeUm: string;
    Multiplier: double;
  end;
  PTQtyConvRec = ^TQtyConvRec;

//----------------------------------------------------------------------------//

constructor TBtchQtyConv.Create;
begin
  inherited Create;
  m_recList := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TBtchQtyConv.Destroy;
begin
  Clear;
  m_recList.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TBtchQtyConv.Clear;
var
  i:    integer;
  pRec: PTQtyConvRec;
begin
  for i := 0 to m_recList.Count-1 do
  begin
    pRec := PTQtyConvRec(m_recList[i]);
    Dispose(pRec)
  end;
end;

//----------------------------------------------------------------------------//

procedure TBtchQtyConv.SetMainId(id: TSchedId);
var
  Info: TSQtimingInfo;
begin
  p_sc.GetTimingInfo(id, Info);

  if (m_ProdReqNo <> Info.prodReq) or (m_ProdReqStp <> Info.step) then
  begin
    m_ProdReqNo := Info.prodReq;
    m_ProdReqStp := Info.step;
    MainIdChanged
  end
end;

//----------------------------------------------------------------------------//

procedure TBtchQtyConv.MainIdChanged;
var
  tbInfo: ^TTblInfo;
  qry:    TMqmQuery;
  pRec:   PTQtyConvRec;
begin
  Clear;
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_step_batchSize];

  with qry.SQL do
  begin
    Add('select');
    Add(CreateFld(tbInfo.pfx, fli_BchUM)   + ',');
    Add(CreateFld(tbInfo.pfx, fli_multipToBatchUm));
    Add('from ' + tbInfo.GetTableName);
    Add('where ');
    Add(CreateFld(tbInfo.pfx, fli_preqNo) + '=''' + m_ProdReqNo + ''' and ');
    Add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + IntToStr(m_ProdReqStp));
    Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  end;

  qry.Open;

  while not qry.EOF do
  begin
    New(pRec);

    pRec.BtchSizeUm := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BchUM)).AsString;
    pRec.Multiplier  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_multipToBatchUm)).AsFloat;

    m_recList.Add(pRec);

    qry.Next
  end;

  qry.Close;

  qry.Free;

end;

//----------------------------------------------------------------------------//

function TBtchQtyConv.ResUmToProdUm(BatchUm: string; ResQty: double): double;
var
  i: integer;
  pRec:   PTQtyConvRec;
begin
  Result := ResQty;

  for i := 0 to m_recList.Count-1 do
  begin
    pRec := m_recList[i];
    if (pRec.BtchSizeUm = BatchUm) then
    begin
      Result := ResQty*pRec.Multiplier;
      exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TBtchQtyConv.ProdUmToResUm(BatchUm: string; ProdQty: double): double;
var
  i: integer;
  pRec:   PTQtyConvRec;
begin
  Result := ProdQty;

  for i := 0 to m_recList.Count-1 do
  begin
    pRec := m_recList[i];
    if (pRec.BtchSizeUm = BatchUm) then
    begin
      Result := ProdQty/pRec.Multiplier;
      exit
    end;
  end;

end;

//----------------------------------------------------------------------------//

end.

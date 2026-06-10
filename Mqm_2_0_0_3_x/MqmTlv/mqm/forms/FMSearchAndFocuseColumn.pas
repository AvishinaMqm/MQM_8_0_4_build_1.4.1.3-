unit FMSearchAndFocuseColumn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UMSchedContFunc;

type
  TSearchAndFocuseColumn = class(TForm)
    EditSearch: TEdit;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    constructor CreateSearchColumnFocuse(AOwner: TWinControl; ValToSearch : string; BinColId : CBinColId);
    { Public declarations }
  end;

  procedure CreateSearchColumnAndFocus(AOwner : TWinControl; ValToSearch : string; BinColId : CBinColId);

implementation

{$R *.dfm}

uses UMBinTbs, UMSchedCont, UMObjCont,gnugettext,FMbin;

var
  SearchAndFocuseColumn : TSearchAndFocuseColumn;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuseColumn.BitBtn1Click(Sender: TObject);
var
  StrSearch : string;
  tbs : TBinTabSheet;
  I : Integer;
  Id : TschedId;
  FieldVal : variant;
  dataType: CBinColValType;
  found : boolean;
  info:  TSQPlanInfo;
begin
  found := false;
  ModalResult := mrnone;
  StrSearch := EditSearch.Text;
  tbs := TBinTabSheet(FBin.GetActiveView);
  if Assigned(tbs) then
  begin
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetFldValue(Id, CSC_ProdReq, FieldVal, dataType);

      p_sc.GetPlanInfo(Id, info);

      if info.isGroup then
      begin
        if p_sc.CheckGroupValues(id, CSC_ProdReq, StrSearch, '') then
            FieldVal := StrSearch;
      end;

      if (StrSearch = FieldVal) then
      begin
        found := true;
        Fbin.FocusBinOnJobID(id, False);
        break;
      end;
    end;
    if not found then
    begin
      showmessage(_('Production request can not be found'));
      ModalResult := mrNone;
    end
    else if not found then
    begin
      showmessage(_('Cant find anymore Production request '));
      ModalResult := mrNone;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuseColumn.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndFocuseColumn.BitBtn3Click(Sender: TObject);
var
  StrSearch : string;
  tbs : TBinTabSheet;
  I : Integer;
  Id, CurrSelectedRow : TschedId;
  FieldVal : variant;
  dataType: CBinColValType;
  found : boolean;
  info:  TSQPlanInfo;
begin
  found := false;
  ModalResult := mrnone;
  StrSearch := EditSearch.Text;
  tbs := TBinTabSheet(FBin.GetActiveView);
  CurrSelectedRow := tbs.m_BinPanel.p_Grid.Row;
  if Assigned(tbs) then
  begin
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
    begin
      if I < CurrSelectedRow then continue;
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(Id, info);

      p_sc.GetFldValue(Id, CSC_ProdReq, FieldVal, dataType);
      if info.isGroup then
      begin
        if p_sc.CheckGroupValues(id, CSC_ProdReq, StrSearch, '') then
           FieldVal := StrSearch;
      end;

      if (StrSearch = FieldVal) then
      begin
        found := true;
        Fbin.FocusBinOnJobID(id, False);
        break;
      end;
    end;
    if not found then//and (m_SchedList.GetLinkCount = 0) then
    begin
      showmessage(_('Production request can not be found'));
      ModalResult := mrNone;
    end
    else if not found then
    begin
      showmessage(_('Cant find anymore Production request '));
      ModalResult := mrNone;
    end;
  end;
end;

//----------------------------------------------------------------------------//

constructor TSearchAndFocuseColumn.CreateSearchColumnFocuse(AOwner: TWinControl; ValToSearch : string; BinColId : CBinColId);
begin
  inherited Create(AOwner);
  EditSearch.Text := ValToSearch;
end;

procedure TSearchAndFocuseColumn.FormCreate(Sender: TObject);
begin
 //
end;

//----------------------------------------------------------------------------//

procedure CreateSearchColumnAndFocus(AOwner : TWinControl; ValToSearch : string; BinColId : CBinColId);
begin
  if not Assigned(SearchAndFocuseColumn) then
  begin
    SearchAndFocuseColumn := TSearchAndFocuseColumn.CreateSearchColumnFocuse(AOwner, ValToSearch, BinColId);
    SearchAndFocuseColumn.formStyle := fsStayOnTop;
  end;
  SearchAndFocuseColumn.Show;
  SearchAndFocuseColumn.SetFocus;
end;

//----------------------------------------------------------------------------//


end.

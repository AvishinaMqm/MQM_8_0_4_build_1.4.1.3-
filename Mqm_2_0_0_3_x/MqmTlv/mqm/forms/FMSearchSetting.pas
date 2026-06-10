unit FMSearchSetting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, ExtCtrls;

type

  TSearchType = (SRC_ProdReq, SRC_ProdType, SRC_ProdFamily, SRC_ProdMatFamily,
                   SRC_ProdLine, SRC_StepType, SRC_GroupNo, SRC_WkctProc, SRC_QtyToSched, SRC_ExeTime);

  TConfigSearch = Record
    Field     : TSearchType;
    Name      : string;
    pos       : Integer;
    RealPos   : Integer;
    Height    : Integer;
    Visible   : boolean;
   end;
//  ArraySrcCnfg = array of TConfigSearch;
  PTConfigSearch = ^TConfigSearch;

  TSearchSet = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
  public
    CheckListBox : TCheckListBox;
    m_ArrayConfigSearch : array[0..9] of TConfigSearch;
//    m_ArrayConfigSearch_Temp : array of TConfigSearch;
    procedure InitComponent;
    procedure SetArray(var ArrayConf : array of TConfigSearch);
    constructor CrtSearchSet(AOwner : TComponent ; ArrayConfig : array of TConfigSearch);
  end;


implementation

{$R *.DFM}

//----------------------------------------------------------------------------//

constructor TSearchSet.CrtSearchSet(AOwner: TComponent ; ArrayConfig : array of TConfigSearch);
var
  I : Integer;
begin
  inherited Create(AOwner);
  for I := Low(ArrayConfig) to High(ArrayConfig) do
  begin
    m_ArrayConfigSearch[I] := ArrayConfig[I];
  end;
  InitComponent;
end;

//----------------------------------------------------------------------------//

procedure TSearchSet.InitComponent;
var
  I : Integer;
begin
  CheckListBox := TCheckListBox.Create(Self);
  CheckListBox.Parent := Self;
  CheckListBox.Align := alClient;
  CheckListBox.Width := 169;

  for I := Low(m_ArrayConfigSearch) to High(m_ArrayConfigSearch) do
  begin
    CheckListBox.Items.Add(m_ArrayConfigSearch[I].Name);
    CheckListBox.Checked[I] := m_ArrayConfigSearch[I].Visible;
  end;

end;

//----------------------------------------------------------------------------//

procedure TSearchSet.SetArray(var ArrayConf: array of TConfigSearch);
var
  I : Integer;
begin
  for I := Low(m_ArrayConfigSearch) to High(m_ArrayConfigSearch) do
  begin
    ArrayConf[I] := m_ArrayConfigSearch[I];
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearchSet.BitBtn1Click(Sender: TObject);
var
  I : Integer;
begin
  for I := Low(m_ArrayConfigSearch) to High(m_ArrayConfigSearch) do
  begin

    m_ArrayConfigSearch[I].Visible := CheckListBox.Checked[I];
  end;
end;

//----------------------------------------------------------------------------//

end.

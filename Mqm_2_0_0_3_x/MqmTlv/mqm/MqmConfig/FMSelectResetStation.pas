unit FMSelectResetStation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, gnugettext, CheckLst, Buttons;

type

  TInfoStation = record
    station : string;
  end;
  PInfoStation = ^TInfoStation;

  TSelectResetstation = class(TForm)
    ListBoxStation: TCheckListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    function CheckUserChoose(var Station : string) : boolean;
    { Public declarations }
  end;

  procedure ShowListStations(AOwner: TComponent);

implementation

{$R *.dfm}

uses
  DMSrvPc,
  UMTblDesc;


procedure ShowListStations(AOwner: TComponent);
var
  FSelectResetstation: TSelectResetstation;
begin
  FSelectResetstation := TSelectResetStation.Create(AOwner);
  FSelectResetstation.ShowModal;
  FSelectResetstation.Free
end;

//----------------------------------------------------------------------------//

procedure TSelectResetstation.FormCreate(Sender: TObject);
var
  qry:          TMqmQuery;
  tbInfo:      ^TTblInfo;
  Pos :         Integer;
  StationName : PInfoStation;
begin
  TranslateComponent (self);

  tbInfo := @tblInfo[tbl_wkst];
  SetFldPfx(tbInfo.pfx);

  qry := CreateQuery(Main_DB);

  qry.Transaction.StartTransaction;

  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.Open;
  while not qry.EOF do
  begin
    Pos := ListBoxStation.Items.Add(qry.FieldByName(CreatePfxFld(fli_wkDescr)).AsString);
    New(StationName);
    StationName.station := qry.FieldByName(CreatePfxFld(fli_wkstCode)).AsString;
    ListBoxStation.Items.Objects[Pos] := Tobject(StationName);
    qry.Next
  end;
end;

//----------------------------------------------------------------------------//

procedure TSelectResetstation.BitBtn1Click(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  Station : string;
begin
  if not CheckUserChoose(Station) then
    exit;

  qry := CreateQuery(Cfg_DB);

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  with qry do
  begin
    SQL.Add('delete from ' + tbInfo.GetTableName);
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + Station + '''');
    qry.Transaction.StartTransaction;
    ExecSQL;
    Close;
  end;

  qry.Transaction.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function TSelectResetstation.CheckUserChoose(var Station : string) : boolean;
var
  I : Integer;
  Count, SavedIndex : Integer;
  StationName : PInfoStation;
begin
  Station := '';
  SavedIndex := -1;
  Count := 0;
  for I := 0 to ListBoxStation.Count - 1 do
  begin
    if ListBoxStation.Checked[I] then
    begin
      SavedIndex := I;
      Count := Count + 1;
    end;
  end;

  if (Count <> 1) then
  begin
    Result := false;
    Showmessage('One Station must be Choosen');
    ModalResult := mrNone;
    exit;
  end
  else
  begin
    ModalResult := mrOk;
    Result := true;
    StationName := PInfoStation(ListBoxStation.Items.Objects[SavedIndex]);
    Station := StationName.station;
  end;
end;

//----------------------------------------------------------------------------//

end.

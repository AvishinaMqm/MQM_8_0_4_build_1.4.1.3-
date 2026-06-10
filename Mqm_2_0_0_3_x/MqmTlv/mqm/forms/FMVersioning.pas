unit FMVersioning;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UMSchedList, UReShape;

type
  TFVersioning = class(TForm)
    EditVersing: TEdit;
    BitBtn2: TcxButton;
    BitBtn1: TcxButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    m_sched_list : TMSchedList;
  public
    constructor CreateVersioning(AOwner: TWinControl; ListIds : TMSchedList);
    Procedure AssignedVersionValues(Clean : boolean);
  end;

  function  IsVersionIdExists(Version : string) : boolean;
  procedure AddVersionIdtoList(Version : string);
  procedure RemoveVersionIdFromList(Version : string);

implementation

  uses UMSchedContFunc, UMSchedOnPlan, UMSchedCont, UMObjCont, gnugettext;

{$R *.dfm}

var
  Versioning : TFVersioning;
  m_VersionIdsList : TStringList;

constructor TFVersioning.CreateVersioning(AOwner: TWinControl; ListIds : TMSchedList);
begin
  inherited Create(AOwner);
  m_sched_list := ListIds;
end;

//----------------------------------------------------------------------------//

procedure TFVersioning.BitBtn1Click(Sender: TObject);

begin
  if EditVersing.Text = '' then
  begin
    MessageDlg(_('Version identifier must have a value') + '!', mtError, [mbOk], 0);
    exit;
  end;

  if not IsVersionIdExists(EditVersing.Text) then
     AddVersionIdtoList(EditVersing.Text)
  else
  begin
    MessageDlg(_('Version identifier already exists') + '!', mtError, [mbOk], 0);
    Exit;
  end;

  AssignedVersionValues(false);
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFVersioning.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFVersioning.FormCreate(Sender: TObject);
begin
  ReShape(Self);
  EditVersing.Text := '';
end;

//----------------------------------------------------------------------------//

Procedure TFVersioning.AssignedVersionValues(Clean : boolean);
var ChildId, id : TSchedID;
  JobsInBinCount, g, i : Integer;
  sc:  TSCSchedOnPlan;
  job: TSCProdSched;
  planInfo: TSQplanInfo;
begin

  JobsInBinCount := m_sched_list.GetLinkCount;

  for i := 0 to JobsInBinCount - 1 do
  begin
    id := m_sched_list.GetLink(I);

    if id = CSchedIdNull then
      exit;

    p_sc.GetPlanInfo(id, planInfo);

    if planInfo.isGroup then
    begin
      for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
      begin
        ChildId := p_sc.GetGrpSon(Id, G);

        if not clean then
        begin
          if p_sc.GetSchedStart(ChildId) > 0 then
            p_sc.SetVersioning(ChildId, EditVersing.Text, false);
        end
        else
          p_sc.SetVersioning(ChildId, EditVersing.Text, true);

      end;
    end
    else
    begin
      if not clean then
      begin
        if p_sc.GetSchedStart(Id) > 0 then
           p_sc.SetVersioning(Id, EditVersing.Text, false);
      end
      else
        p_sc.SetVersioning(Id, EditVersing.Text, true);
    end;
  end;

end;

//----------------------------------------------------------------------------//

function IsVersionIdExists(Version : string) : boolean;
begin
  result := true;
  if m_VersionIdsList.IndexOf(Version) = -1 then
     result := false;
end;

//----------------------------------------------------------------------------//

procedure AddVersionIdtoList(Version : string);
begin
  m_VersionIdsList.Add(Version);
end;

//----------------------------------------------------------------------------//

procedure RemoveVersionIdFromList(Version : string);
begin
  if m_VersionIdsList.IndexOf(Version) > -1 then
    m_VersionIdsList.Delete(m_VersionIdsList.IndexOf(Version))
end;

//----------------------------------------------------------------------------//

initialization
  m_VersionIdsList := TStringList.Create;
  m_VersionIdsList.Sorted := true;
finalization
  m_VersionIdsList.free;

end.

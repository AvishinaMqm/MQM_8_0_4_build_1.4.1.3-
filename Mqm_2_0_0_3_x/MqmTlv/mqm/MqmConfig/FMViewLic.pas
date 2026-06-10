unit FMViewLic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, UGLicensing, gnugettext;

type
  TFViewLic = class(TForm)
    PanBtn: TPanel;
    BtnOk: TBitBtn;
    MmLic: TMemo;
    BtnViewCurr: TButton;
    BtnInstall: TButton;
    BtnLoad: TButton;
    OpenLic: TOpenDialog;
    procedure BtnViewCurrClick(Sender: TObject);
    procedure BtnInstallClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    constructor CreateLIC(AOwner : Tcomponent; MQM_MCM : integer);
  private
    m_MQM_MCM : integer;
    m_currLic: TLicMemory;
  end;

  procedure ShowLicence(AOwner: TComponent; MCM_MQM : integer);

implementation

{$R *.DFM}

uses
  DMSrvPC,
  UMGlobal,
  UMStoredProc;

// -------------------------------------------------------------------------- //

procedure ShowLicence(AOwner: TComponent; MCM_MQM : integer);
var
  FViewLic: TFViewLic;
begin
  FViewLic := TFViewLic.CreateLIC(AOwner, MCM_MQM);
  if MCM_MQM = 2 then
    FViewLic.m_currLic := s_licBytes
  else if MCM_MQM = 3 then
    FViewLic.m_currLic := s_licBytesMcm;
  TextLic(FViewLic.MmLic.Lines, FViewLic.m_currLic, MCM_MQM);
  FViewLic.ShowModal;
  FViewLic.Free
end;

// -------------------------------------------------------------------------- //

procedure TFViewLic.BtnViewCurrClick(Sender: TObject);
begin
  if m_MQM_MCM = 2 then
    TextLic(MmLic.Lines, s_licBytes, m_MQM_MCM)
  else if m_MQM_MCM = 3 then
    TextLic(MmLic.Lines, s_licBytesMcm, m_MQM_MCM)
end;

// -------------------------------------------------------------------------- //

constructor TFViewLic.CreateLIC(AOwner: Tcomponent; MQM_MCM: integer);
begin
  inherited create(AOwner);
  m_MQM_MCM := MQM_MCM;
end;

// -------------------------------------------------------------------------- //

procedure TFViewLic.BtnInstallClick(Sender: TObject);
var
  errStr:     string;
  lic:        TRecLicVers1;
  lockCode:   integer;
  canInstall: boolean;
//  qry : TMqmQuery;

begin
  DecodeLicVers1(lic, m_currLic, errStr);

  canInstall := true;

  if lic.MQMORMCM <> m_MQM_MCM then
  begin
    errStr := _('Different Licence codes');
    ShowMessage(errStr);
    exit;
  end;

  if lic.lockNum <> 0 then
  begin
    lockCode := 0;
    try
      if lic.MQMORMCM = 3 then
      begin
        lockCode := GetLockCode;//qry.FieldByName('GETLOCKMCM').AsInteger;
      end
      else if lic.MQMORMCM = 2 then
      begin
        lockCode := GetLockCode;//qry.FieldByName('GETLOCKMQM').AsInteger;
      end;
    except
      errStr := _('Invalid lock configuration');
      canInstall := false
    end;

    if canInstall and (lockCode <> lic.lockNum) then
    begin
      errStr := _('Different lock codes');
      canInstall := false
    end;

    if not canInstall then
      ShowMessage(errStr)
    else
    begin
      //s_licBytes := m_currLic;
      if lic.MQMORMCM = 2 then
      begin
        s_licBytes := m_currLic;
        if not SaveLicenceMqm(m_currLic, errStr) then
          ShowMessage(errStr);
      end
      else if lic.MQMORMCM = 3 then
      begin
        s_licBytesMcm := m_currLic;
        if not SaveLicenceMcm(m_currLic, errStr) then
          ShowMessage(errStr);
      end

    end;



  end;
end;

// -------------------------------------------------------------------------- //

procedure TFViewLic.BtnLoadClick(Sender: TObject);
begin
  if OpenLic.Execute then
  begin
    LoadLicFromFile(OpenLic.FileName, m_currLic);
    TextLic(MmLic.Lines, m_currLic, m_MQM_MCM)
  end
end;

// -------------------------------------------------------------------------- //
procedure TFViewLic.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
end;

end.

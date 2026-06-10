unit FMSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, gnugettext;

type
  TFSettings = class(TForm)
    PanBtn: TPanel;
    BtnOk: TBitBtn;
    BtnCanc: TBitBtn;
    Panel1: TPanel;
    CBoxCapRes: TCheckBox;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowSettings(AOwner: TControl);

var
  FSettings: TFSettings;

implementation

{$R *.DFM}

uses
  UMTblDesc,
  UMStoredProc,
  DMsrvPc,
  UMGlobal;

//----------------------------------------------------------------------------//

procedure ShowSettings(AOwner: TControl);
begin
  FSettings := TFSettings.Create(AOwner);
  FSettings.ShowModal()
end;

//----------------------------------------------------------------------------//

procedure TFSettings.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
//  GlobLoadSettingsValues;
//  CBoxCapRes.Checked := DBAppSettings.DisableCapRes
end;

//----------------------------------------------------------------------------//

procedure TFSettings.Button1Click(Sender: TObject);
var
  CapResNum, GrpNm, ReqNum, splitFamily : integer;
begin
  SP_GET_CAP_RES_NUM(CapResNum,'CAPRESNUMBER');
  SP_GET_GRP_NUM(GrpNm,'GROUPNUMBER');
  SP_GET_NEW_REQ_NO(ReqNum,'REQNUMBER');
  SP_GET_SPLIT_FAMILY_CODE(splitFamily,'SPLITFAMILY');
  SP_SEND_TEST;
end;

procedure TFSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    DBAppSettings.DisableCapRes := CBoxCapRes.Checked;
    GlobSaveSettingsValues;
  end;

  Action := caFree;
  FSettings := nil;
end;

//----------------------------------------------------------------------------//
end.

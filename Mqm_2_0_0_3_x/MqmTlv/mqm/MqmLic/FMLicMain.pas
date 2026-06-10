unit FMLicMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//  Menus, Db, IBCustomDataSet, IBTable, Grids, DBGrids, IBDatabase, gnugettext;
 Menus, Db, Grids, DBGrids, gnugettext;

type
  TFLicHdl = class(TForm)
    MainMenu: TMainMenu;
    IHandle: TMenuItem;
    ILicCreate: TMenuItem;
    procedure ILockClick(Sender: TObject);
    procedure ILicCreateClick(Sender: TObject);
    procedure IAddCustClick(Sender: TObject);
    procedure IModifyClick(Sender: TObject);
    procedure ICreateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    m_Issuer : string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLicHdl: TFLicHdl;

implementation

{$R *.DFM}

uses
  FMCreateLic,
  FMLock;
  
// -------------------------------------------------------------------------- //

procedure TFLicHdl.ILockClick(Sender: TObject);
begin
  ShowLockWindow(self)
end;

// -------------------------------------------------------------------------- //

procedure TFLicHdl.ILicCreateClick(Sender: TObject);
begin
  CreateLicence(Self, m_Issuer)
end;

// -------------------------------------------------------------------------- //

function GetLockCode(): integer;
var
  aDirectory: array[0..1023] of Char;
  sDrive: Char;
begin
  GetWindowsDirectory(aDirectory, SizeOf(aDirectory));
  sDrive := aDirectory[0];
  if GetVolumeInformation(PChar(sDrive + ':\'), nil, 0, @Result,
           DWORD(nil^), DWORD(nil^), nil, 0) then
    Result := Result xor $0FCD231A
  else
    Result := 0
end;

// -------------------------------------------------------------------------- //

procedure TFLicHdl.FormCreate(Sender: TObject);
var
  LockCode : Integer;
begin
  LockCode := GetLockCode;           // aviold                         // helen                   // Olga                     // bernard
  if (LockCode = 759932235) or (LockCode = 1435902659) or (LockCode = -1751274728) or (LockCode = -1685100417) or (LockCode = 629557399) or
                // anamaria1           // anamaria2
    (LockCode = 789581845) or (LockCode = 1104508144) then
    IHandle.Enabled := true
  else
    IHandle.Enabled := false;

  if ((LockCode = 759932235) or (LockCode = 1435902659)) then
     m_Issuer := 'Avi'
  else if (LockCode = -1751274728) then
     m_Issuer := 'Helen'
  else if (LockCode = -1685100417) then
     m_Issuer := 'Olga'
  else if (LockCode = -1685100417) then
     m_Issuer := 'Bernard'
  else if ((LockCode = 789581845) or (LockCode = 1104508144)) then
     m_Issuer := 'Ana'
end;

// -------------------------------------------------------------------------- //

procedure TFLicHdl.IAddCustClick(Sender: TObject);
begin
  ShowMessage(_('Add customer'))
end;

// -------------------------------------------------------------------------- //

procedure TFLicHdl.IModifyClick(Sender: TObject);
begin
  ShowMessage(_('Modify customer'))
end;

// -------------------------------------------------------------------------- //

procedure TFLicHdl.ICreateClick(Sender: TObject);
begin
  ShowMessage(_('Create database'))

{
CREATE TABLE "CUSTOMERS" 
(
  "CS_CODE"	CHAR(5) NOT NULL,
  "CS_DESCR"	VARCHAR(30),
 PRIMARY KEY ("CS_CODE")
);

CREATE TABLE "LICENCES" 
(
  "LC_CODE"	CHAR(5) NOT NULL,
  "LC_VAL"	INTEGER,
  "LC_LICTYPE"	SMALLINT,
  "LC_ISSUER"	VARCHAR(30),
  "LC_MAXWK"	SMALLINT,
  "LC_MAXCONC"	SMALLINT,
  "LC_RELEDATE"	TIMESTAMP,
 PRIMARY KEY ("LC_CODE")
);

CREATE TABLE "LOCKS" 
(
  "LK_CODE"	CHAR(5) NOT NULL,
  "LK_VAL"	INTEGER,
 PRIMARY KEY ("LK_CODE")
);
}
end;

// -------------------------------------------------------------------------- //
end.

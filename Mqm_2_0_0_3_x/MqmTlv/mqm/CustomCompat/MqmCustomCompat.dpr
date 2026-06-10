library MqmCustomCompat;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  CustCompFunc in 'CustCompFunc.pas',
  UMCompatSrv in '..\lib\UMCompatSrv.pas',
  UMDbFunc in '..\db\UMDbFunc.pas',
  UMglobal in '..\lib\UMglobal.pas',
  UMTblDesc in '..\db\UMTblDesc.pas',
  UMCompatRules in '..\lib\UMCompatRules.pas',
  gnugettext in '..\Internationalization\gnugettext.pas',
  UGprogCtrl in '..\..\lib\UGprogCtrl.pas',
  UGregItf in '..\..\lib\UGregItf.pas',
  DMsrvPc in '..\db\DMsrvPc.pas' {DMib: TDataModule},
  UMCompat in '..\lib\UMCompat.pas',
  UMCommon in '..\lib\UMCommon.pas',
  UMIBEvents in '..\db\UMIBEvents.pas',
  UMSrvConfig in '..\MqmSrv\UMSrvConfig.pas';

{$R *.RES}

exports CustomOOCompat1;
exports CustomOOCompat2;

begin
end.

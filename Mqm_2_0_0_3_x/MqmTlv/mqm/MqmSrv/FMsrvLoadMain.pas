unit FMsrvLoadMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, IBDatabase, Db, DBTables;

type
  TFSrvLoad = class(TForm)
    MainMenu: TMainMenu;
    ILoad: TMenuItem;
    ICalendar: TMenuItem;
    IBDatabase: TIBDatabase;
    IBTransaction: TIBTransaction;
    DBAs400: TDatabase;
    procedure ICalendarClick(Sender: TObject);
  end;

var
  FSrvLoad: TFSrvLoad;

implementation

{$R *.DFM}

uses
  IBSQL,
  ULoad;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.ICalendarClick(Sender: TObject);
var
  qry:      TIBSQL;
  qryAS400: TQuery;
begin
  qryAS400 := TQuery.Create(nil);
  qryAS400.DatabaseName   := 'SRV_MQM';
  qryAS400.UniDirectional := true;
  qryAS400.UpdateMode     := upWhereKeyOnly;

  IBDatabase.Connected := true;

  qry := TIBSQL.Create(nil);
  qry.Database := IBDatabase;
  qry.Transaction := IBTransaction;

  IBTransaction.Active := true;
  LoadCalendar(qry, qryAS400);
  IBTransaction.Commit;

  IBTransaction.Active := true;
  LoadResources(qry, qryAS400);
  IBTransaction.Commit;

  IBTransaction.Active := true;
  LoadSettings(qry, qryAS400);
  IBTransaction.Commit;

  IBTransaction.Active := true;
  LoadDispos(qry, qryAS400);
  IBTransaction.Commit;

  IBTransaction.Active := true;
  LoadPhases(qry, qryAS400);
  IBTransaction.Commit;

  qry.Free;

  IBTransaction.Active := false;
  IBDatabase.Connected := false;

  qryAS400.Close;
  qryAS400.Free
end;

//----------------------------------------------------------------------------//
end.

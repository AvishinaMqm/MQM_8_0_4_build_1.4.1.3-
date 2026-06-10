unit Demand;

interface

uses

  DMsrvPc;


function BuildProductionDemandFile(ArcQry : TMqmQuery; HostQry : TMqmQuery) : String;
procedure BuildSCHEDULESDOWNLOAD_WARP_RESERVATION_FILE(ArcQry : TMqmQuery; HostQry : TMqmQuery);
procedure DeleteAllNotRelevantProgresses2begin(HostQry : TMqmQuery; WcHandledStr : string);

implementation

uses UMglobal, UOpThread, ADODB, UMsrvLoad, gnugettext, System.Classes, UMload, UMSrvConfig, System.Threading, Forms,
      FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
      FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
      FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
      FireDAC.Stan.Pool,  FireDAC.Comp.Client, FireDAC.Comp.DataSet,
      FireDAC.Phys.IBBase, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.FB,
      SysUtils, UMCommon, Progress;

//------------------------------------------------------------------------------------------------//

procedure AddNewDemandsToSchedulesDownloadDemands2(HostQry : TMqmQuery; DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup : string; WcHandledStr : string);
var
  ConvertDateFormat : Integer;
  hostSqlStr : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveHostName;

  if DndArchiveArcName = TD_Db2 then
    ConvertDateFormat := 1
  else if DndArchiveArcName = TD_Oracle then
    ConvertDateFormat := 2
  else if DndArchiveArcName = TD_Db2OnAs400 then
    ConvertDateFormat := 3
  else
    ConvertDateFormat := 1;


  if ConvertDateFormat = 3 then // as400
    hostSqlStr := 'Insert into SchedulesDownloadDemands (companycode, environmentcode, countercode, code, templatecode, EverDownloaded) ' +
                '(Select PD.CompanyCode, ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' EnvironmentCode , ' +
                'PD.CounterCode, PD.Code, PD.TemplateCode, ' + QuotedStr('0') + ' EverDownloaded from ' +
                '(Select * from ' +
                '(Select distinct PD.CompanyCode, PD.CounterCode, PD.Code from ' +
                '(Select distinct DemandUpd.ProductionProgressCompanyCode CompanyCode, ' +
                'DemandUpd.DemandStepProDemandCntCode CounterCode, ' +
                'DemandUpd.DemandStepProductionDemandCode Code from ' +
                '(Select CompanyCode, ProgressNumber ' +
                'From SchedulesDownloadProgress ' +
                'Where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') SelectedPrg ' +
                'Join ProductionProgressStepUpdated DemandUpd ' +
                'on DemandUpd.ProductionProgressCompanyCode = SelectedPrg.CompanyCode ' +
                'and DemandUpd.ProProgressProgressNumber = SelectedPrg.ProgressNumber) PRG ' +
                'Join ProductionDemand PD ' +
                'on PD.CompanyCode = Prg.CompanyCode and PD.CounterCode = Prg.CounterCode ' +
                'and PD.Code = Prg.Code and PD.TemplateCode in (' + DemandTemplatesStr_HandledAlways + ')' +
                'Join ProductionDemandStep PDS ' +
                'ON PDS.ProductionDemandCompanyCode = PD.CompanyCode ' +
                'and PDS.ProductionDemandCounterCode = PD.CounterCode ' +
                'and PDS.ProductionDemandCode = PD.Code ' +
                'and PDS.WorkCenterCode IN (' + WcHandledStr + ')' +  //) PD ' +
                { DemandTemplatesStr_HandledOnlyGroup is same as HandledAlways � union branch not needed
                'union ' +
                'Select distinct PD.CompanyCode, PD.CounterCode, PD.Code from ' +
                '(Select distinct DemandUpd.ProductionProgressCompanyCode CompanyCode, ' +
                'DemandUpd.DemandStepProDemandCntCode CounterCode, ' +
                'DemandUpd.DemandStepProductionDemandCode Code from ' +
                '(Select CompanyCode, ProgressNumber ' +
                'From SchedulesDownloadProgress ' +
                'Where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') SelectedPrg ' +
                'Join ProductionProgressStepUpdated DemandUpd ' +
                'on DemandUpd.ProductionProgressCompanyCode = SelectedPrg.CompanyCode ' +
                'and DemandUpd.ProProgressProgressNumber = SelectedPrg.ProgressNumber) PRG ' +
                'Join ProductionDemand PD ' +
                'on PD.CompanyCode = Prg.CompanyCode and PD.CounterCode = Prg.CounterCode ' +
                'and PD.Code = Prg.Code and PD.TemplateCode in (' + DemandTemplatesStr_HandledOnlyGroup + ')' +
                'Join ProductionDemandStep PDS ' +
                'ON PDS.ProductionDemandCompanyCode = PD.CompanyCode ' +
                'and PDS.ProductionDemandCounterCode = PD.CounterCode ' +
                'and PDS.ProductionDemandCode = PD.Code ' +
                'and PDS.WorkCenterCode IN (' + WcHandledStr + ')' + ' AND ' +  //) PD ' +
              //  ') PD ' +
                'PDS.ProductionOrderCode is not null and PDS.ProductionOrderCode <> ' + QuotedStr(' ') + }
                ') as400 ' +
                'Except ' +
                'Select CompanyCode, CounterCode, Code ' +
                'from SchedulesDownloadDemands ' +
                'Where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') PDTemp ' +
                'Join ProductionDemand PD ' +
                ' on PD.CompanyCode = PDTemp.CompanyCode and PD.CounterCode = PDTemp.CounterCode ' +
                ' and PD.Code = PDTemp.Code)'
  else
    hostSqlStr := 'Insert into SchedulesDownloadDemands (companycode, environmentcode, countercode, code, templatecode, EverDownloaded) ' +
                '(Select PD.CompanyCode, ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' EnvironmentCode , ' +
                'PD.CounterCode, PD.Code, PD.TemplateCode, ' + QuotedStr('0') + ' EverDownloaded from ' +
                '(Select * from ' +
                '(Select distinct PD.CompanyCode, PD.CounterCode, PD.Code from ' +
                '(Select distinct DemandUpd.ProductionProgressCompanyCode CompanyCode, ' +
                'DemandUpd.DemandStepProDemandCntCode CounterCode, ' +
                'DemandUpd.DemandStepProductionDemandCode Code from ' +
                '(Select CompanyCode, ProgressNumber ' +
                'From SchedulesDownloadProgress ' +
                'Where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') SelectedPrg ' +
                'Join ProductionProgressStepUpdated DemandUpd ' +
                'on DemandUpd.ProductionProgressCompanyCode = SelectedPrg.CompanyCode ' +
                'and DemandUpd.ProProgressProgressNumber = SelectedPrg.ProgressNumber) PRG ' +
                'Join ProductionDemand PD ' +
                'on PD.CompanyCode = Prg.CompanyCode and PD.CounterCode = Prg.CounterCode ' +
                'and PD.Code = Prg.Code and PD.TemplateCode in (' + DemandTemplatesStr_HandledAlways + ')' +
                'Join ProductionDemandStep PDS ' +
                'ON PDS.ProductionDemandCompanyCode = PD.CompanyCode ' +
                'and PDS.ProductionDemandCounterCode = PD.CounterCode ' +
                'and PDS.ProductionDemandCode = PD.Code ' +
                'and PDS.WorkCenterCode IN (' + WcHandledStr + ')' +  //) PD ' +
                { DemandTemplatesStr_HandledOnlyGroup is same as HandledAlways — union branch not needed
                'union ' +
                'Select distinct PD.CompanyCode, PD.CounterCode, PD.Code from ' +
                '(Select distinct DemandUpd.ProductionProgressCompanyCode CompanyCode, ' +
                'DemandUpd.DemandStepProDemandCntCode CounterCode, ' +
                'DemandUpd.DemandStepProductionDemandCode Code from ' +
                '(Select CompanyCode, ProgressNumber ' +
                'From SchedulesDownloadProgress ' +
                'Where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') SelectedPrg ' +
                'Join ProductionProgressStepUpdated DemandUpd ' +
                'on DemandUpd.ProductionProgressCompanyCode = SelectedPrg.CompanyCode ' +
                'and DemandUpd.ProProgressProgressNumber = SelectedPrg.ProgressNumber) PRG ' +
                'Join ProductionDemand PD ' +
                'on PD.CompanyCode = Prg.CompanyCode and PD.CounterCode = Prg.CounterCode ' +
                'and PD.Code = Prg.Code and PD.TemplateCode in (' + DemandTemplatesStr_HandledOnlyGroup + ')' +
                'Join ProductionDemandStep PDS ' +
                'ON PDS.ProductionDemandCompanyCode = PD.CompanyCode ' +
                'and PDS.ProductionDemandCounterCode = PD.CounterCode ' +
                'and PDS.ProductionDemandCode = PD.Code ' +
                'and PDS.WorkCenterCode IN (' + WcHandledStr + ')' + ' AND ' +  //) PD ' +
              //  ') PD ' +
                'PDS.ProductionOrderCode is not null and PDS.ProductionOrderCode <> ' + QuotedStr(' ') + }
                ') ' +
                'Minus ' +
                'Select CompanyCode, CounterCode, Code ' +
                'from SchedulesDownloadDemands ' +
                'Where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') PDTemp ' +
                'Join ProductionDemand PD ' +
                ' on PD.CompanyCode = PDTemp.CompanyCode and PD.CounterCode = PDTemp.CounterCode ' +
                ' and PD.Code = PDTemp.Code)';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Connection.StartTransaction;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;
//  HostQryTest.Free;
  Application.ProcessMessages;
end;

//------------------------------------------------------------------------------------------------//

procedure AddNewDemandsToSchedulesDownloadDemands(HostQry : TMqmQuery; DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup : string; WcHandledStr : string);
var
  hostSqlStr : string;
  SqlPrint : TStringList;
begin
  SqlPrint := TStringList.Create;

  hostSqlStr :=
    'Insert into SchedulesDownloadDemands (companycode, environmentcode, countercode, code, templatecode, EverDownloaded) ' +
     '(Select ' +
        'PD.CompanyCode, ' +
        QuotedStr(IniAppGlobals.EnvironmentCode) + ' EnvironmentCode, ' +
        'PD.CounterCode, PD.Code, PD.TemplateCode, ' + QuotedStr('0') + ' EverDownloaded ' +
      'from ProductionDemand pd ' +
      'Where pd.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'and   pd.ProgressStatus IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' +  QuotedStr('5') + ') ' +
      'and   pd.TemplateCode IN (' + DemandTemplatesStr_HandledAlways + ') ' +
      'and exists ' +
       '(select 1 from ProductionDemandStep PDS ' +
       'where PDS.ProductionDemandCompanyCode = PD.CompanyCode ' +
       'and PDS.ProductionDemandCounterCode = PD.CounterCode ' +
       'and PDS.ProductionDemandCode = PD.Code ' +
       'and PDS.WorkCenterCode IN (' + WcHandledStr + ')) ' +
      'and not exists ' +
       '(select 1 from SchedulesDownloadDemands SDD ' +
       'Where sdd.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
       'and   sdd.COMPANYCODE = PD.CompanyCode ' +
       'and   sdd.countercode = PD.CounterCode ' +
       'and   sdd.code = PD.Code))';

  HostQry.SQL.Text := hostSqlStr;
  SqlPrint.Add(hostSqlStr);
  SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\AddNewOpenedDemandsToSchedulesDownloadDemands.txt');
  SqlPrint.Free;

  HostQry.Connection.StartTransaction;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;
  Application.ProcessMessages;
end;

//------------------------------------------------------------------------------------------------//

procedure DiscoverDemandsNotRelevantAndDeleteThem(HostQry : TMqmQuery);
var
  hostSqlStr : string;
begin
  hostSqlStr :=
  'DELETE FROM SchedulesDownloadDemands SSD ' +
  'WHERE SSD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
  'AND SSD.CompanyCode = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
  'AND EXISTS ' +
   '(SELECT 1 ' +
    'FROM ProductionDemand PD ' +
    'WHERE PD.CompanyCode = SSD.CompanyCode ' +
    'AND   PD.CounterCode = SSD.CounterCode ' +
    'AND   PD.Code = SSD.Code ' +
    'AND   PD.ProgressStatus = ' + QuotedStr('6') + ') ' +
  'AND NOT EXISTS ' +
   '(SELECT 1 ' +
    'FROM SchedulesDownloadProgress SDP  ' +
    'JOIN ProductionProgressStepUpdated PPSU ' +
    'ON  PPSU.ProductionProgressCompanyCode = SDP.CompanyCode ' +
    'AND PPSU.ProProgressProgressNumber = SDP.ProgressNumber ' +
    'AND PPSU.DemandStepProDemandCntCode = SSD.CounterCode ' +
    'AND PPSU.DemandStepProductionDemandCode = SSD.Code ' +
    'WHERE SDP.CompanyCode = SSD.CompanyCode ' +
    'AND   SDP.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' )';
  HostQry.SQL.Text := hostSqlStr;
  HostQry.Connection.StartTransaction;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;
  Application.ProcessMessages;
end;

//------------------------------------------------------------------------------------------------//

procedure DeleteAllNotRelevantDemands(HostQry : TMqmQuery; DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup : string; WcHandledStr : String);
var
  hostSqlStr : string;
begin

  hostSqlStr :=
   'DELETE FROM SchedulesDownloadDemands SSD ' +
   'WHERE SSD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
   'AND SSD.CompanyCode = ' + QuotedStr(IniAppGlobals.CompanyCode) +
   'AND NOT EXISTS ' +
    '(SELECT 1 ' +
     'FROM ProductionDemand PD ' +
     'WHERE PD.CompanyCode = SSD.CompanyCode ' +
     'AND   PD.CounterCode = SSD.CounterCode ' +
     'AND   PD.Code = SSD.Code ' +
     'AND   PD.TemplateCode IN (' + DemandTemplatesStr_HandledAlways + '))';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Connection.StartTransaction;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;
  Application.ProcessMessages;

  hostSqlStr :=
  'DELETE FROM SchedulesDownloadDemands SSD ' +
  'WHERE SSD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
  'AND SSD.CompanyCode = ' + QuotedStr(IniAppGlobals.CompanyCode) +
  'AND NOT EXISTS ' +
   '(SELECT 1 ' +
    'FROM ProductionDemandStep PDs ' +
    'WHERE PDS.ProductionDemandCompanyCode = SSD.CompanyCode ' +
    'AND   PDS.ProductionDemandCounterCode = SSD.CounterCode ' +
    'AND   PDS.ProductionDemandCode = SSD.Code ' +
    'AND   PDS.WorkCenterCode IN (' + WcHandledStr + '))';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Connection.StartTransaction;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;
  Application.ProcessMessages;


end;

//------------------------------------------------------------------------------------------------//

function BuildHandledWcStr(ArcQry : TMqmQuery; var WcHandledStr : string) : boolean;
var
  SrvSqlStr : string;
  DndArchiveArcName : TDndArchiveName;
  TableName : string;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'WKC';
  if DndArchiveArcName <> TD_Interbase then
    TableName := 'SCDA_' + 'WKC';
  Result := true;
  srvSqlStr := 'SELECT WC_WKCNTER '+
               ' FROM ' + TableName +
               ' WHERE WC_HANDLEDBYMQM = ' + QuotedStr('2') + ' OR WC_HANDLEDBYMQM = ' + QuotedStr('1') +
                     ' OR WC_HANDLEDBYMCM = ' + QuotedStr('1') + AND_IDF_Condition('WC_IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  Application.ProcessMessages;

  WcHandledStr := '';

  if ArcQry.Eof then
  begin
    if WcHandledStr = '' then
      WcHandledStr := QuotedStr(WcHandledStr);
    Result := false;
    Exit;
  end;

  while (not ArcQry.Eof ) do
  begin
    if (WcHandledStr <> '') then
      WcHandledStr := WcHandledStr + ', ';
    WcHandledStr   := WcHandledStr + QuotedStr(Trim(ArcQry.FieldByName('WC_WKCNTER').AsString));
    ArcQry.Next
  end;
  Application.ProcessMessages;

  if WcHandledStr = '' then
    WcHandledStr := QuotedStr(WcHandledStr);

  ArcQry.close;
end;

//------------------------------------------------------------------------------------------------//

function BuildHandledProductionDemandTemplatesStr(ArcQry : TMqmQuery; var DemandTemplatesStr_HandledAlways : string; var DemandTemplatesStr_HandledOnlyGroup : string) : boolean;
var
  SrvSqlStr : string;
  Handled : boolean;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
begin
  Result := true;
  Handled := true;

  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTIONDEMANDTEMPLATE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PRODUCTIONDEMANDTEMPLATE';

  srvSqlStr := 'SELECT CODE '+
               'FROM ' + TableName +
               ' WHERE (HANDLEDBYMQM = ' + QuotedStr('2') + ' OR HANDLEDBYMQM = ' + QuotedStr('1') +
                     ' OR HANDLEDBYMCM = ' + QuotedStr('1') + ')' + AND_IDF_Condition('IDENTIFIER');

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  Application.ProcessMessages;
  DemandTemplatesStr_HandledAlways := '';

  if ArcQry.Eof then
  begin
    Handled := false;
  end;

  while (not ArcQry.Eof ) do
  begin
    if (DemandTemplatesStr_HandledAlways <> '') then
      DemandTemplatesStr_HandledAlways := DemandTemplatesStr_HandledAlways + ', ';
    DemandTemplatesStr_HandledAlways   := DemandTemplatesStr_HandledAlways + QuotedStr(Trim(ArcQry.FieldByName('CODE').AsString));
    ArcQry.Next
  end;
  Application.ProcessMessages;

  if DemandTemplatesStr_HandledAlways = '' then
    DemandTemplatesStr_HandledAlways := QuotedStr(DemandTemplatesStr_HandledAlways);

  ArcQry.close;

  // DemandTemplatesStr_HandledOnlyGroup uses identical SQL to HandledAlways � set to blank, not needed
  DemandTemplatesStr_HandledOnlyGroup := '';
  if not Handled then
  begin
    Result := false;
    Exit;
  end;

  { srvSqlStr := 'SELECT CODE '+
               'FROM ' + TableName +
               ' WHERE (HANDLEDBYMQM = ' + QuotedStr('2') + ' OR HANDLEDBYMQM = ' + QuotedStr('1') +
                     ' OR HANDLEDBYMCM = ' + QuotedStr('1') + ')' + AND_IDF_Condition('IDENTIFIER');

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;

  DemandTemplatesStr_HandledOnlyGroup := '';

  if ArcQry.Eof and not Handled then
  begin
    Result := false;
    Exit;
  end;

  while (not ArcQry.Eof ) do
  begin
    if (DemandTemplatesStr_HandledOnlyGroup <> '') then
      DemandTemplatesStr_HandledOnlyGroup := DemandTemplatesStr_HandledOnlyGroup + ', ';
    DemandTemplatesStr_HandledOnlyGroup   := DemandTemplatesStr_HandledOnlyGroup + QuotedStr(Trim(ArcQry.FieldByName('CODE').AsString));
    ArcQry.Next
  end;
  Application.ProcessMessages;

  if DemandTemplatesStr_HandledOnlyGroup = '' then
    DemandTemplatesStr_HandledOnlyGroup := QuotedStr(DemandTemplatesStr_HandledOnlyGroup);

  ArcQry.close; }
end;

//------------------------------------------------------------------------------------------------//

function BuildProductionDemandFile(ArcQry : TMqmQuery; HostQry : TMqmQuery) : String;
var
  hostSqlStr, COMPANYCODE, COUNTERCODE, CODE, TEMPLATECODE, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup , WcHandledStr : string;
  ConvertDateFormat : Integer;
  Table : string;
  DndArchiveArcName : TDndArchiveName;
  taskDeleteProgress : ITask;
begin
  Result := '';

  UpdateOperation(_('Building Handled w.c'));
  IniAppGlobals.Time_For_BuildHandledWcStr := NOW;
  BuildHandledWcStr(ArcQry, WcHandledStr);
  Result := WcHandledStr;
  IniAppGlobals.Time_For_BuildHandledWcStr := NOW - IniAppGlobals.Time_For_BuildHandledWcStr;

  DndArchiveArcName := GetDndArchiveHostName;

  if IniAppGlobals.EnvironmentCode = '' then
     IniAppGlobals.EnvironmentCode := '   ';

  Table := 'SCHEDULESDOWNLOADDEMANDS';

  UpdateOperation(_('Creating SCHEDULESDOWNLOADDEMANDS file'));

  hostSqlStr := '';

  if DndArchiveArcName = TD_Db2 then
    ConvertDateFormat := 1
  else if DndArchiveArcName = TD_Oracle then
    ConvertDateFormat := 2
  else if DndArchiveArcName = TD_Db2OnAs400 then
    ConvertDateFormat := 3
  else
    ConvertDateFormat := 1;

  // ConvertDateFormat := 3 as400 on db2

  if ConvertDateFormat = 1 then
    HostSqlStr := ' SELECT tabname FROM SYSCAT.TABLES WHERE tabname in (' + QuotedStr(Table) + ')'
  else if ConvertDateFormat = 2 then
    HostSqlStr := ' SELECT Table_name FROM USER_TABLES where Table_name in (' + QuotedStr(Table) + ')'
  else if ConvertDateFormat = 3 then
    HostSqlStr := ' SELECT Table_name FROM SYSCOLUMNS where Table_name in (' + QuotedStr(Table) + ')';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Connection.StartTransaction;
  HostQry.Open;
  HostQry.Connection.Commit;

  if HostQry.Eof then
  begin
    if (ConvertDateFormat = 1) then
      hostSqlStr := ' select COLNAME, TYPENAME, LENGTH, SCALE from syscat.columns ' +
                   ' where tabname = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND colname = ' + QuotedStr('COMPANYCODE')
    else if (ConvertDateFormat = 2) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, data_length as length, data_scale as scale from USER_TAB_COLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('COMPANYCODE')
    else if (ConvertDateFormat = 3) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, length, NUMERIC_SCALE as scale from SYSCOLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('COMPANYCODE');

    HostQry.SQL.Text := hostSqlStr;
    HostQry.Connection.StartTransaction;
    HostQry.Open;
    COMPANYCODE := HostQry.FieldByName('COLNAME').AsString + ' ' + HostQry.FieldByName('TYPENAME').AsString + ' (' + IntToStr(HostQry.FieldByName('LENGTH').AsInteger) + ') NOT NULL ,' ;
    HostQry.Connection.Commit;

    if (ConvertDateFormat = 1) then
      hostSqlStr := ' select COLNAME, TYPENAME, LENGTH, SCALE from syscat.columns ' +
                    ' where tabname = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND colname = ' + QuotedStr('COUNTERCODE')
    else if (ConvertDateFormat = 2) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, data_length as length, data_scale as scale from USER_TAB_COLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('COUNTERCODE')
    else if (ConvertDateFormat = 3) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, length, NUMERIC_SCALE AS SCALE from SYSCOLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('COUNTERCODE');

    HostQry.SQL.Text := hostSqlStr;
    HostQry.Connection.StartTransaction;
    HostQry.Open;
    COUNTERCODE := HostQry.FieldByName('COLNAME').AsString + ' ' + HostQry.FieldByName('TYPENAME').AsString + ' (' + IntToStr(HostQry.FieldByName('LENGTH').AsInteger) + ') NOT NULL ,' ;
    HostQry.Connection.Commit;

    if (ConvertDateFormat = 1) then
      hostSqlStr := ' select COLNAME, TYPENAME, LENGTH, SCALE from syscat.columns ' +
                    ' where tabname = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND colname = ' + QuotedStr('CODE')
    else if (ConvertDateFormat = 2) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, data_length as length, data_scale as scale from USER_TAB_COLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('CODE')
    else if (ConvertDateFormat = 3) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, length, NUMERIC_SCALE AS SCALE from SYSCOLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('CODE');

    HostQry.SQL.Text := hostSqlStr;
    HostQry.Connection.StartTransaction;
    HostQry.Open;
    CODE := HostQry.FieldByName('COLNAME').AsString + ' ' + HostQry.FieldByName('TYPENAME').AsString + ' (' + IntToStr(HostQry.FieldByName('LENGTH').AsInteger) + ') NOT NULL ,' ;
    HostQry.Connection.Commit;

    if (ConvertDateFormat = 1) then
      hostSqlStr := ' select COLNAME, TYPENAME, LENGTH, SCALE from syscat.columns ' +
                    ' where tabname = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND colname = ' + QuotedStr('TEMPLATECODE')
    else if (ConvertDateFormat = 2) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, data_length as length, data_scale as scale from USER_TAB_COLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('TEMPLATECODE')
    else if (ConvertDateFormat = 3) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, length, NUMERIC_SCALE AS SCALE from SYSCOLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONDEMAND') + ' AND column_name = ' + QuotedStr('TEMPLATECODE');

    HostQry.SQL.Text := hostSqlStr;
    HostQry.Connection.StartTransaction;
    HostQry.Open;
    TEMPLATECODE := HostQry.FieldByName('COLNAME').AsString + ' ' + HostQry.FieldByName('TYPENAME').AsString + ' (' + IntToStr(HostQry.FieldByName('LENGTH').AsInteger) + ') NOT NULL ,' ;
    HostQry.Connection.Commit;

    hostSqlStr := '';
    hostSqlStr := 'CREATE TABLE ' + Table + '(';
    hostSqlStr := hostSqlStr + ' ' + COMPANYCODE;
    hostSqlStr := hostSqlStr + 'ENVIRONMENTCODE CHARACTER (3) NOT NULL,';
    hostSqlStr := hostSqlStr + ' ' + COUNTERCODE;
    hostSqlStr := hostSqlStr + ' ' + CODE;
    hostSqlStr := hostSqlStr + ' ' + TEMPLATECODE;
    hostSqlStr := hostSqlStr + 'EVERDOWNLOADED SMALLINT NOT NULL ,';
    hostSqlStr := hostSqlStr + 'PRIMARY KEY (ENVIRONMENTCODE, COMPANYCODE, COUNTERCODE, CODE))';
    HostQry.SQL.Text := hostSqlStr;
    try
      HostQry.Connection.StartTransaction;
      HostQry.ExecSQL;
      HostQry.Connection.Commit;
      Application.ProcessMessages;
    except
      HostQry.Connection.Rollback;
    end;
  end;

  CreateProgressTable(HostQry);

  UpdateOperation(_('Building production demand templates'));
  IniAppGlobals.Time_For_BuildHandledProductionDemandTemplatesStr := NOW;
  if not BuildHandledProductionDemandTemplatesStr(ArcQry, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup) then
  begin
    IniAppGlobals.Time_For_BuildHandledProductionDemandTemplatesStr := NOW - IniAppGlobals.Time_For_BuildHandledProductionDemandTemplatesStr;
    exit;
  end;
  IniAppGlobals.Time_For_BuildHandledProductionDemandTemplatesStr := NOW - IniAppGlobals.Time_For_BuildHandledProductionDemandTemplatesStr;

  IniAppGlobals.Time_For_BuildHandledProgressTemplatesList := NOW;
  BuildHandledProductionProgressTemplatesList(ArcQry);
  IniAppGlobals.Time_For_BuildHandledProgressTemplatesList := NOW - IniAppGlobals.Time_For_BuildHandledProgressTemplatesList;

  // Delete progresses that thier where deleted or thier template is no longer handled or old progresses that thier demands are closed or not handled.
  if DndArchiveArcName <> TD_Interbase then
  begin
    IniAppGlobals.Time_For_DeleteAllNotRelevantProgresses := NOW;
    taskDeleteProgress := TTask.Run(procedure
    var
      connHost : TMqmDatabase;
      qryHost  : TMqmQuery;
    begin
      connHost := nil;
      try
        connHost := ThreadCloneHostConnection;
        qryHost := TMqmQuery.Create(nil);
        try
          qryHost.Connection := connHost;
          DeleteAllNotRelevantProgresses(qryHost, WcHandledStr, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup);
        finally
          qryHost.Free;
        end;
      except
      end;
      if Assigned(connHost) then connHost.Free;
    end);
  end
  else
  begin
    UpdateOperation(_('Delete all not relevant progresses'));
    IniAppGlobals.Time_For_DeleteAllNotRelevantProgresses := NOW;
    DeleteAllNotRelevantProgresses(HostQry, WcHandledStr, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup);
    IniAppGlobals.Time_For_DeleteAllNotRelevantProgresses := NOW - IniAppGlobals.Time_For_DeleteAllNotRelevantProgresses;
  end;

  // Delete demands that thier template is not longer handled or do not have any step with the handled work centers
  UpdateOperation(_('Delete All Not Relevant Demands'));
  IniAppGlobals.Time_For_DeleteAllNotRelevantDemands := NOW;
  DeleteAllNotRelevantDemands(HostQry, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup, WcHandledStr);
  IniAppGlobals.Time_For_DeleteAllNotRelevantDemands := NOW - IniAppGlobals.Time_For_DeleteAllNotRelevantDemands;

  // Add all still opened demands with the correct templates and having at least one handled work center
  UpdateOperation(_('Adding new opened demands to SchedulesDownloadDemands'));
  IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands := NOW;
  AddNewDemandsToSchedulesDownloadDemands(HostQry,DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup,WcHandledStr);
  IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands := NOW - IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands;

  if Assigned(taskDeleteProgress) then
  begin
    UpdateOperation(_('Wait for deleting all not relevant progresses'));
    IniAppGlobals.Time_For_Wait_DeleteProgress := NOW;
    taskDeleteProgress.Wait;
    IniAppGlobals.Time_For_Wait_DeleteProgress := NOW - IniAppGlobals.Time_For_Wait_DeleteProgress;
    IniAppGlobals.Time_For_DeleteAllNotRelevantProgresses := NOW - IniAppGlobals.Time_For_DeleteAllNotRelevantProgresses;
    taskDeleteProgress := nil;
  end;

  // Add all progresses by date and template, even of demands not handled.
  // Add all progresses of all existing SCHEDULESDOWNLOADDEMANDS that are opened.
  UpdateOperation(_('Adding to schedules download progress'));
  IniAppGlobals.Time_For_AddToSchedulesDownloadProgress := NOW;
  AddToSchedulesDownloadProgress(ArcQry,HostQry,DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup);
  IniAppGlobals.Time_For_AddToSchedulesDownloadProgress := NOW - IniAppGlobals.Time_For_AddToSchedulesDownloadProgress;

  // Delete of demands that are closed and do not have a progress in SchedulesDownloadProgress
  UpdateOperation(_('Discover demands not relevant and delete them'));
  IniAppGlobals.Time_For_DiscoverDemandsNotRelevantAndDeleteThem := NOW;
  DiscoverDemandsNotRelevantAndDeleteThem(HostQry);
  IniAppGlobals.Time_For_DiscoverDemandsNotRelevantAndDeleteThem := NOW - IniAppGlobals.Time_For_DiscoverDemandsNotRelevantAndDeleteThem;

  // Add to SchedulesDownloadDemands that exists in SchedulesDownloadProgress and with the correct templates and having at least one handled work center
  UpdateOperation(_('Adding new progressed demands to SchedulesDownloadDemands'));
  IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands2 := NOW;
  AddNewDemandsToSchedulesDownloadDemands2(HostQry,DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup,WcHandledStr);
  IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands2 := NOW - IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands2;

end;

//------------------------------------------------------------------------------------------------//

procedure BuildSCHEDULESDOWNLOAD_WARP_RESERVATION_FILE(ArcQry : TMqmQuery; HostQry : TMqmQuery);
var
  hostSqlStr, COUNTERCODE, CODE, COMPANYCODE, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup , WcHandledStr : string;
  ConvertDateFormat : Integer;
  Table : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveHostName;

  Table := 'SCHEDULESDOWNLOADWARPRSV';

  UpdateOperation(_('Creating SCHEDULESDOWNLOADWARPRSV file'));

  hostSqlStr := '';

  if DndArchiveArcName = TD_Db2 then
    ConvertDateFormat := 1
  else if DndArchiveArcName = TD_Oracle then
    ConvertDateFormat := 2
  else if DndArchiveArcName = TD_Db2OnAs400 then
    ConvertDateFormat := 3
  else
    ConvertDateFormat := 1;

  // ConvertDateFormat := 3 as400 on db2

  if ConvertDateFormat = 1 then
    HostSqlStr := ' SELECT tabname FROM SYSCAT.TABLES WHERE tabname in (' + QuotedStr(Table) + ')'
  else if ConvertDateFormat = 2 then
    HostSqlStr := ' SELECT Table_name FROM USER_TABLES where Table_name in (' + QuotedStr(Table) + ')'
  else if ConvertDateFormat = 3 then
    HostSqlStr := ' SELECT Table_name FROM SYSCOLUMNS where Table_name in (' + QuotedStr(Table) + ')';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  if HostQry.Eof then
  begin
    hostSqlStr := '';
    hostSqlStr := 'CREATE TABLE ' + Table + '(';
    hostSqlStr := hostSqlStr + ' COMPANYCODE CHARACTER (3) NOT NULL,';
    hostSqlStr := hostSqlStr + ' ENVIRONMENTCODE CHARACTER (3) NOT NULL,';
    hostSqlStr := hostSqlStr + ' COUNTERCODE CHARACTER (8) NOT NULL,';
    hostSqlStr := hostSqlStr + ' CODE CHARACTER (15) NOT NULL,';
    hostSqlStr := hostSqlStr + ' RESERVATIONLINE DECIMAL (7) NOT NULL,';
    hostSqlStr := hostSqlStr + ' PRIMARY KEY (ENVIRONMENTCODE, COMPANYCODE, COUNTERCODE, CODE, RESERVATIONLINE))';
    HostQry.SQL.Text := hostSqlStr;
    try
      HostQry.ExecSQL;
      Application.ProcessMessages;
    except

    end;
  end;

  UpdateOperation(_('Building production demand templates'));
end;

//------------------------------------------------------------------------------------------------//

procedure DeleteAllNotRelevantProgresses2begin(HostQry : TMqmQuery; WcHandledStr : string);
begin
  if WcHandledStr = '' then
    exit;
  DeleteAllNotRelevantProgresses2(HostQry, WcHandledStr);
end;

//------------------------------------------------------------------------------------------------//

end.

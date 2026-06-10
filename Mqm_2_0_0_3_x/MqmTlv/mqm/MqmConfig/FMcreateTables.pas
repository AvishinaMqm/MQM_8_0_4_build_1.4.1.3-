unit FMcreateTables;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IBX.IBDatabase, Db, StdCtrls, IBX.IBSQLMonitor, UMglobal, gnugettext, Variants,
  ComCtrls, Gauges, IBX.IBCustomDataSet, IBX.IBQuery, FireDAC.Comp.Client,
  DMSrvPc, UMTblDesc, ExtCtrls, System.StrUtils;

type
  TCreateTables = class(TForm)
    Panel1: TPanel;
    CrtMainDB: TButton;
    CrtCfgDB: TButton;
    UpdMainDB: TButton;
    UpdCfgDB: TButton;
    lbStep: TLabel;
    Gauge1: TGauge;
  //  public
    Procedure InsertDefaults;
    procedure CreateMQM_Main_Tables;
    procedure CreateMQM_Cfg_Tables;
    procedure CreateNewTbl(qry: TMqmQuery; tbInfo: PTblInfo; lbText: TLabel);
//    procedure CreateNewTblLic(Cfg : boolean; qry: TMqmQuery; tbInfo: PTblInfo; lbText: TLabel);
    procedure UpdateDB_Interbase(DBType: TMqmDBType);
    procedure UpdateDB_Oracle(DBType: TMqmDBType);
    procedure UpdateDB_DB2(DBType: TMqmDBType);
    procedure UpdateLocalCal;
    procedure CreateGenerators(qry: TMQMQuery);
    procedure DeleteProc(qry: TMQMQuery; str: string);
    procedure DropTable(qry: TMqmQuery; listTable:TStrings; lbText:TLabel;
                        progbar: TGauge);
    procedure DropView(qry: TMqmQuery ; lbText:TLabel);
    procedure CreateIndex(qry: TMqmQuery ; lbText:TLabel);
    procedure CreateView(qry: TMqmQuery ; lbText:TLabel);
    procedure CrtMainDBClick(Sender: TObject);
    procedure CrtCfgDBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdMainDBClick(Sender: TObject);
    procedure UpdCfgDBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    Procedure CheckFilters;
    Procedure InsertColumns(cTable : String);
    Procedure InsertSettings;
    Procedure UpdateDefaultValues;
    Procedure InsertDefaultValues;
    public
    m_DatabaseCreate : boolean;
  end;

//var
//  CreateTables: TCreateTables;

implementation

{$R *.DFM}

uses
//  DMSrvPc, move in the first uses
  UGLicensing,
  UMStoredProc,
  FMPassword,
  UMCOMMON,
  FMCfgMain;
//  UMTblDesc, move in the first uses;

const
  TableHdrView = 'Rq_Hdr_products';

//----------------------------------------------------------------------------//

procedure TCreateTables.CreateGenerators(qry: TMQMQuery);
begin
  qry.SQL.Clear;
  qry.SQL.Add('CREATE GENERATOR SPLIT_FAMILY_CODE');
  try
    qry.ExecSQL;
  except
  end;

  qry.SQL.Clear;
  qry.SQL.Add('CREATE GENERATOR NEW_REQ_NO');
  try
    qry.ExecSQL;
  except
  end;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.DeleteProc(qry: TMQMQuery; str: string);
begin
  qry.SQL.Clear;
  qry.SQL.Add('DROP PROCEDURE ' + str);
  try
    qry.ExecSQL;
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure TCreateTables.CreateNewTbl(qry: TMqmQuery; tbInfo: PTblInfo; lbText: TLabel);
var
  sKey  : string;
  i     : integer;
begin
  lbText.Caption := 'CREATE TABLE ' + tbInfo.GetTableName;
  Application.ProcessMessages;

  qry.SQL.Clear;
  qry.SQL.Add('CREATE TABLE ' + tbInfo.GetTableName + '(');

  sKey := '';
  for i := 0 to tbInfo.nrfld - 1 do
  begin
    if ContainsText(CreatePfxFldDef(tbInfo.struct[i].fInfo), 'ABSUNIQUEID') then
      qry.SQL.Add(CreateFldDef('',tbInfo.struct[i].fInfo))
    else
      qry.SQL.Add(CreatePfxFldDef(tbInfo.struct[i].fInfo));

    if tbInfo.struct[i].defval > -1 then
      qry.SQL.Add(' DEFAULT ' + IntToStr(tbInfo.struct[i].defval));

    if tbInfo.struct[i].nrkey = 1 then
    begin
      if sKey = '' then
        sKey := 'PRIMARY KEY (';
      sKey := sKey + CreatePfxFld(tbInfo.struct[i].fInfo) +',';
    end;

    if tbInfo.struct[i].notnull then
      qry.SQL.Add(' NOT NULL ');

    qry.SQL.Add(',');
  end;

  if sKey = '' then
    qry.SQL.Delete(qry.SQL.Count-1)
  else
  begin
    if sKey[length(sKey)] = ',' then
    begin
      sKey[length(sKey)] := ')';
      qry.SQL.Add(sKey);
    end;
  end;

  qry.SQL.Add(')');
  qry.ExecSQL;
  qry.Close;
  lbText.Caption := '';
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------//
{
procedure TCreateTables.CreateNewTblLic(Cfg : boolean; qry: TMqmQuery; tbInfo: PTblInfo; lbText: TLabel);
var
  sKey  : string;
  i     : integer;
begin
  lbText.Caption := 'CREATE TABLE ' + tbInfo.GetLicTableName(Cfg);
  Application.ProcessMessages;

  qry.SQL.Clear;
  qry.SQL.Add('CREATE TABLE ' + tbInfo.GetLicTableName(Cfg) + '(');

  sKey := '';
  for i := 0 to tbInfo.nrfld - 1 do
  begin
    qry.SQL.Add(CreatePfxFldDef(tbInfo.struct[i].fInfo));

    if tbInfo.struct[i].defval > -1 then
    qry.SQL.Add(' DEFAULT ' + IntToStr(tbInfo.struct[i].defval));

    if tbInfo.struct[i].nrkey = 1 then
    begin
      if sKey = '' then
        sKey := 'PRIMARY KEY (';
      sKey := sKey + CreatePfxFld(tbInfo.struct[i].fInfo) +',';
    end;

    if tbInfo.struct[i].notnull then
      qry.SQL.Add(' NOT NULL ');

    qry.SQL.Add(',');
  end;

  if sKey = '' then
    qry.SQL.Delete(qry.SQL.Count-1)
  else
  begin
    if sKey[length(sKey)] = ',' then
    begin
      sKey[length(sKey)] := ')';
      qry.SQL.Add(sKey);
    end;
  end;

  qry.SQL.Add(')');
  qry.ExecSQL;
  qry.Close;
  lbText.Caption := '';
  Application.ProcessMessages;
end;

}

//----------------------------------------------------------------------------//

procedure TCreateTables.UpdateDB_Interbase(DBType: TMqmDBType);
type
  rField = record
    iOpType: integer; //-99=nothing, 1 = add, 2= alter colum, 3 not null, 4= both(2and3)
                      // 5= drop
    sField : string;
    sType  : string;
    iDef   : integer;
    bNull  : boolean;
  end;
var
  qry:          TMqmQuery;
  sysIdx,SysFld:TMqmQuery;
  listTables:   TStrings;
  listTblDrop:  TStrings;
  listField:    TStrings;
  I,Z,X, SavedRecordcount : Integer;
  RecordCountBool : boolean;
  ttbl:         table;
  tbInfo:       PTblInfo;//^TTblInfo;
  tCont:        Table;
  sKey,sFldKey: string;
  sFldTyp:      string;
  vProgBar:     variant;
  bFound:       boolean;
  recField:     array of rField;
  iRepeat:      integer;
  cSQL : string;
begin
  listTables  := TStringList.Create;
  listField   := TStringList.Create;

  SetLength(recField, 400);

  qry := CreateQuery(DBType);

  sysIdx := CreateQuery(DBType);
  sysFld := CreateQuery(DBType);

  // New Part fix for using delphi 2009.

  try
    qry.SQL.Clear;
    qry.SQL.Add('Drop Table RELATION_CONSTRAINTS');
    qry.ExecSQL;
  except
  end;
  qry.Connection.Commit;

  try
    qry.SQL.Clear;
    qry.SQL.Add('Drop Table INDICES');
    qry.ExecSQL;
  except
  end;
  qry.Connection.Commit;

  try
    qry.SQL.Clear;
    qry.SQL.Add('Drop Table INDEX_SEGMENTS');
    qry.ExecSQL;
  except
  end;
  qry.Connection.Commit;

  try
    qry.SQL.Clear;
    qry.SQL.Add('Drop Table RELATION_FIELDS');
    qry.ExecSQL;
  except
  end;
  qry.Connection.Commit;

  try
    qry.SQL.Clear;
    qry.SQL.Add('Drop Table FIELDS');
    qry.ExecSQL;
  except
  end;
  qry.Connection.Commit;

  qry.SQL.Clear;
  qry.SQL.ADD('CREATE TABLE "RELATION_CONSTRAINTS"("CONSTRAINT_NAME" VARCHAR(100),');
  qry.SQL.ADD('"RELATION_NAME" VARCHAR(100),');
  qry.SQL.ADD('"CONSTRAINT_TYPE" VARCHAR(100),');
  qry.SQL.ADD('"INDEX_NAME" VARCHAR(100))');
  qry.ExecSQL;
  qry.Connection.Commit;

  qry.SQL.Clear;
  qry.SQL.ADD('CREATE TABLE "INDICES"("INDEX_NAME" VARCHAR(100))');
  qry.ExecSQL;
  qry.Connection.Commit;

  qry.SQL.Clear;
  qry.SQL.ADD('CREATE TABLE "INDEX_SEGMENTS"("FIELD_POSITION" VARCHAR(100),');
  qry.SQL.ADD('"FIELD_NAME" VARCHAR(100),');
  qry.SQL.ADD('"INDEX_NAME" VARCHAR(100))');
  qry.ExecSQL;
  qry.Connection.Commit;

  qry.SQL.Clear;
  qry.SQL.ADD('CREATE TABLE "RELATION_FIELDS"("FIELD_NAME" VARCHAR(100),');
  qry.SQL.ADD('"FIELD_SOURCE" VARCHAR(100),');
  qry.SQL.ADD('"NULL_FLAG" VARCHAR(100),');
  qry.SQL.ADD('"DEFAULT_VALUE" BLOB,');
  qry.SQL.ADD('"RELATION_NAME" VARCHAR(100))');

  qry.ExecSQL;
  qry.Connection.Commit;

  qry.SQL.Clear;
  qry.SQL.ADD('CREATE TABLE "FIELDS"("FIELD_NAME" VARCHAR(100),');
  qry.SQL.ADD('"FIELD_TYPE" VARCHAR(100),');
  qry.SQL.ADD('"FIELD_LENGTH" VARCHAR(100),');
  qry.SQL.ADD('"FIELD_PRECISION" VARCHAR(100),');
  qry.SQL.ADD('"FIELD_SCALE" VARCHAR(100))');

  qry.ExecSQL;
  qry.Connection.Commit;

  if DBType = Main_DB then
    GetMqmDb(DBType).GetTableNames('MQM_MAIN', 'IB', '',listTables)
  else
    GetMqmDb(DBType).GetTableNames('MQM_CFG', 'IB', '',listTables);

{  for ttbl := Low(table) to High(table) do
  begin
    tbInfo := @tblInfo[table(ttbl)];
    if IsMain then
    begin
      if (tbInfo.group = 2) then continue;
    end
    else
    begin
      if (tbInfo.group = 1) then continue;
    end;

    listTables.Add(tbInfo.GetTableName(IsMain));
  end; }

  listTblDrop := listTables;

  lbStep.Caption := '';
  lbStep.Visible := True;
  vProgBar := High(tblInfo);
  Gauge1.ForeColor := clRed;
  Gauge1.Visible := True;
  Application.ProcessMessages;

  Gauge1.MaxValue := vProgBar;
  Gauge1.Progress := 0;

  if DBType = Main_DB then
  begin
    DeleteProc(qry, CMainGetCapResNum);
    DeleteProc(qry, CMainGetGrpNum);
    CreateGenerators(qry);
  end
  else
  begin
    DeleteProc(qry, CCfgGetAccess);
    DeleteProc(qry, CCfgEndAccess);
    DeleteProc(qry, CCfgGetStatus);
    DeleteProc(qry, CSrvLoadStatus);
    DeleteProc(qry, CSrvLoadGetAcc);
    DeleteProc(qry, CSrvLoadEndAcc);
    DeleteProc(qry, CCfgConnect);
    DeleteProc(qry, CCfgDisconnect);
    DeleteProc(qry, CCfgStillOn);
    DeleteProc(qry, CCfgActWrcst);
    DeleteProc(qry, CSevCngDataBase);
  end;

  qry.Close;
  qry.SQL.Clear;

  if DBType = Main_DB then
  begin
    DropView(qry, lbStep);
    CreateIndex(qry, lbStep);
//    CreateView(qry, lbStep);  // avi 24/03/08
  end;

  for iRepeat := 1 to 2 do
  begin
    for tCont := Low(tblInfo) to High(tblInfo) do
    begin
      tbInfo := @tblInfo[tCont];
      SetFldPfx(tbInfo.pfx);

      X := 2;
      if  DBType = Cfg_Db then
        X := 1;

      if (tbInfo.group = X) then
        Continue; //exclude table

   //   if (iRepeat = 1) then continue;
      if ( (iRepeat = 1) and (tbInfo.arc > 0) ) or
         ( (iRepeat > 1) and (tbInfo.arc < 1) ) then
        Continue; //for the first loop if not archive db the goto next db


      lbStep.Caption := 'Check table ' + tbInfo.GetTableName;

      Gauge1.Progress := Gauge1.Progress + 1;
      Application.ProcessMessages;

      {$ifdef WEBSERVICE}
      if (tbInfo.GetTableName = 'BALANCE_HEADER') or (tbInfo.GetTableName = 'MATERIAL') or
         (tbInfo.GetTableName = 'PROD_REQ') or (tbInfo.GetTableName = 'PROD_REQCONN') or
         (tbInfo.GetTableName = 'PROD_REQHDR') or (tbInfo.GetTableName = 'PROD_SCHED_PROGRESS') or
         (tbInfo.GetTableName = 'PROD_SCHED') or (tbInfo.GetTableName = 'PROD_SCHEDS_MCM') or
         (tbInfo.GetTableName = 'PROD_STEP') or (tbInfo.GetTableName = 'ROD_STEP_TIMES') or
         (tbInfo.GetTableName = 'PRODUCED_ARTICLE') or (tbInfo.GetTableName = 'PRODUCTS') or
         (tbInfo.GetTableName = 'PROP_PROD') or (tbInfo.GetTableName = 'PROD_STEP_BATCH_SIZE') then
      begin
        continue;
      end;
      {$endif}

      if tbInfo.GetTableName = 'BIN_FILTER' then
      begin
        if qry.Connection.ExecSQLScalar('Select count(RELATION_FIELDS.FIELD_NAME)'
          + ' from RELATION_FIELDS, FIELDS'
          + ' WHERE RELATION_FIELDS.RELATION_NAME='+QuotedStr('BIN_FILTER')
          + ' and RELATION_FIELDS.FIELD_NAME = '+QuotedStr('BF_DEPENDING_ON_NEXTHANDLEDSTEP')
          + ' AND RELATION_FIELDS.FIELD_SOURCE = FIELDS.FIELD_NAME') > 0 then
        begin
          qry.ExecSQL('Alter Table BIN_FILTER'
          + ' Alter BF_DEPENDING_ON_NEXTHANDLEDSTEP to '
          + CreateFld(tbInfo.pfx,fli_FiltDependingOnNextHandledStep) );
          qry.Connection.Commit;
        end;

        if qry.Connection.ExecSQLScalar('Select count(RELATION_FIELDS.FIELD_NAME)'
          + ' from RELATION_FIELDS, FIELDS'
          + ' WHERE RELATION_FIELDS.RELATION_NAME='+QuotedStr('BIN_FILTER')
          + ' and RELATION_FIELDS.FIELD_NAME = '+QuotedStr('BF_DEPENDING_ON_PREVHANDLEDSTEP')
          + ' AND RELATION_FIELDS.FIELD_SOURCE = FIELDS.FIELD_NAME') > 0 then
        begin
          qry.ExecSQL('Alter Table BIN_FILTER'
          + ' Alter BF_DEPENDING_ON_PREVHANDLEDSTEP to '
          + CreateFld(tbInfo.pfx,fli_FiltDependingOnPrevHandledStep) );
          qry.Connection.Commit;
        end;

        if qry.Connection.ExecSQLScalar('Select count(RELATION_FIELDS.FIELD_NAME)'
          + ' from RELATION_FIELDS, FIELDS'
          + ' WHERE RELATION_FIELDS.RELATION_NAME='+QuotedStr('BIN_FILTER')
          + ' and RELATION_FIELDS.FIELD_NAME = '+QuotedStr('BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST')
          + ' AND RELATION_FIELDS.FIELD_SOURCE = FIELDS.FIELD_NAME') > 0 then
        begin
          qry.ExecSQL('Alter Table BIN_FILTER'
          + ' Alter BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST to '
          + CreateFld(tbInfo.pfx,fli_filtDependingOnNextHandledLinkedRequest) );
          qry.Connection.Commit;
        end;

        if qry.Connection.ExecSQLScalar('Select count(RELATION_FIELDS.FIELD_NAME)'
          + ' from RELATION_FIELDS, FIELDS'
          + ' WHERE RELATION_FIELDS.RELATION_NAME='+QuotedStr('BIN_FILTER')
          + ' and RELATION_FIELDS.FIELD_NAME = '+QuotedStr('BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST')
          + ' AND RELATION_FIELDS.FIELD_SOURCE = FIELDS.FIELD_NAME') > 0 then
        begin
          qry.ExecSQL('Alter Table BIN_FILTER'
          + ' Alter BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST to '
          + CreateFld(tbInfo.pfx,fli_filtDependingOnPrevHandledLinkedRequest) );
          qry.Connection.Commit;
        end;
      end;

      if tbInfo.GetTableName = 'EXCG_WKST_SRVLOAD' then
      begin
        var Con := '';
        Con := qry.Connection.ExecSQLScalar('select RDB$Constraint_Name from RDB$RELATION_CONSTRAINTS'
          + ' where rdb$relation_name = '+QuotedStr('EXCG_WKST_SRVLOAD')+' and RDB$Constraint_type = '+QuotedStr('PRIMARY KEY'));
        if con <> '' then
        begin
          qry.ExecSQL('Alter Table EXCG_WKST_SRVLOAD drop CONSTRAINT '+ Con);
          qry.Connection.Commit;
        end;
      end;

      qry.SQL.Clear;

      if listTables.IndexOf(tbInfo.GetTableName) = -1 then
      begin
        CreateNewTbl(qry, tbInfo, lbStep);
        Gauge1.Progress := Gauge1.Progress + 1;
        qry.Connection.Commit;
        Continue;
      end;

      //check the list
      for i := 0 to listTblDrop.Count-1 do
      begin
        if UpperCase(listTblDrop[i]) = UpperCase(tbInfo.GetTableName) then
        begin
          listTblDrop.Delete(i);
          Break;
        end;
      end;

      qry.SQL.Clear;
      qry.SQL.Add('delete from RELATION_FIELDS');
      qry.ExecSQL;

      qry.SQL.Clear;
      qry.SQL.Add('insert into RELATION_FIELDS');
      qry.SQL.Add('select RDB$FIELD_NAME, RDB$FIELD_SOURCE, RDB$NULL_FLAG, RDB$DEFAULT_VALUE, RDB$RELATION_NAME FROM RDB$RELATION_FIELDS');
      qry.ExecSQL;

      qry.SQL.Clear;
      qry.SQL.Add('delete from FIELDS');
      qry.ExecSQL;

      qry.SQL.Clear;
      qry.SQL.Add('insert into FIELDS');
      qry.SQL.Add('select RDB$FIELD_NAME, RDB$FIELD_TYPE, RDB$FIELD_LENGTH, RDB$FIELD_PRECISION, RDB$FIELD_SCALE FROM RDB$FIELDS');
      qry.ExecSQL;

      //check the structure
      qry.SQL.Clear;

      // compiled with delphi 7
    {  qry.SQL.Add('Select RDB$RELATION_FIELDS.RDB$FIELD_NAME,RDB$RELATION_FIELDS.RDB$FIELD_SOURCE,');
      qry.SQL.Add('RDB$FIELDS.RDB$FIELD_NAME,RDB$FIELDS.RDB$FIELD_TYPE, RDB$FIELDS.RDB$FIELD_LENGTH,');
      qry.SQL.Add('RDB$FIELDS.RDB$FIELD_PRECISION, RDB$FIELDS.RDB$FIELD_SCALE,');
      qry.SQL.Add('RDB$RELATION_FIELDS.RDB$NULL_FLAG, RDB$RELATION_FIELDS.RDB$DEFAULT_VALUE');
      qry.SQL.Add('from RDB$RELATION_FIELDS, RDB$FIELDS');
      qry.SQL.Add('WHERE RDB$RELATION_FIELDS.RDB$RELATION_NAME=''' + UpperCase(tbInfo.PCname) +'''');
      qry.SQL.Add('AND RDB$RELATION_FIELDS.RDB$FIELD_SOURCE = RDB$FIELDS.RDB$FIELD_NAME '); }


      //  compiled with delphi 2009
      qry.SQL.Add('Select RELATION_FIELDS.FIELD_NAME,RELATION_FIELDS.FIELD_SOURCE,');
      qry.SQL.Add('FIELDS.FIELD_NAME,FIELDS.FIELD_TYPE, FIELDS.FIELD_LENGTH,');
      qry.SQL.Add('FIELDS.FIELD_PRECISION, FIELDS.FIELD_SCALE,');
      qry.SQL.Add('RELATION_FIELDS.NULL_FLAG, RELATION_FIELDS.DEFAULT_VALUE');
      qry.SQL.Add('from RELATION_FIELDS, FIELDS');
      qry.SQL.Add('WHERE RELATION_FIELDS.RELATION_NAME=''' + UpperCase(tbInfo.GetTableName) +'''');
      qry.SQL.Add('AND RELATION_FIELDS.FIELD_SOURCE = FIELDS.FIELD_NAME ');

      qry.Open;



      for X := Low(recField) to High(recField) do
      begin
        recField[X].iOpType := -99;
        recField[X].sField  := '';
        recField[X].sType   := '';
        recField[X].iDef    := -1;
        recField[X].bNull   := false;
      end;

      X := 0;
      while not qry.Eof do
      begin
        case qry.FieldByName('FIELD_TYPE').AsInteger of
          7: sFldTyp := 'SMALLINT';
          8: begin
               if  qry.FieldByName('FIELD_SCALE').AsInteger < 0 then
               begin
                 sFldTyp := 'DECIMAL('+
                            IntToStr(qry.FieldByName('FIELD_PRECISION').AsInteger) +','+
                            IntToStr(ABS(qry.FieldByName('FIELD_SCALE').AsInteger))+ ')';
               end
               else
                 sFldTyp := 'INTEGER';
             end;
         14: sFldTyp := 'CHAR('+IntToStr(qry.FieldByName('FIELD_LENGTH').AsInteger) +')';
         16: begin
               sFldTyp := 'DECIMAL('+
                          IntToStr(qry.FieldByName('FIELD_PRECISION').AsInteger) +','+
                          IntToStr(ABS(qry.FieldByName('FIELD_SCALE').AsInteger))+ ')';
             end;
         35: sFldTyp := 'TIMESTAMP';
         37: sFldTyp := 'VARCHAR('+IntToStr(qry.FieldByName('FIELD_LENGTH').AsInteger) +')';
        else
          ShowMessage('ERROR NEW TYPE!! CALL DATATEX - MI')  //Vincenzo -- do not change!
        end;

        recField[X].iOpType := 5 ;
        recField[X].sField  := Trim(qry.FieldByName('FIELD_NAME').AsString);
        recField[X].sType   := sFldTyp;
        recField[X].iDef    := -1;
        recField[X].bNull := not(qry.FieldByName('NULL_FLAG').IsNull);

        Inc( X );
        qry.Next;

      end;

      for I := 0 to tbInfo.nrfld-1 do
      begin
        sKey := CreatePfxFld(tbInfo.struct[I].fInfo);

        if ContainsText(sKey, 'ABSUNIQUEID') then
          sKey := CreateFld('', tbInfo.struct[I].fInfo);

        bFound := False;
        for X := Low(recField) to High(recField) do
        begin
          if recField[X].sField = sKey then
          begin
            bFound := True;
            Break;
          end;
        end;

        //add field
        if not bFound then
        begin

          for X := Low(recField) to High(recField) do
            if recField[X].iOpType = -99 then
              Break;

          recField[X].iOpType := 1;
          recField[X].sField  := sKey;
          recField[X].sType   := CreateFldType(tbInfo.struct[I].fInfo);
          if ContainsText(recField[X].sField, 'IDENTIFIER')  then
            recField[X].iDef := StrToInt(IniAppGlobals.Identifier)
          else
            recField[X].iDef    := tbInfo.struct[I].defval;
          recField[X].bNull   := tbInfo.struct[I].notnull;
          Continue;
        end;

        //change type and also the not null attribute
        if recField[X].sType <> CreateFldType(tbInfo.struct[I].fInfo) then
        begin
          recField[X].iOpType := 2;
          recField[X].sType   := CreateFldType(tbInfo.struct[I].fInfo);

          if recField[X].bNull <> tbInfo.struct[I].notnull then
          begin
            recField[X].iOpType := 4;
            recField[X].bNull   := tbInfo.struct[I].notnull;
          end;
          Continue;
        end;

        //change only not nulla attribute
        if recField[X].bNull <> tbInfo.struct[I].notnull then
        begin
          recField[X].iOpType := 3;
          recField[X].bNull   := tbInfo.struct[I].notnull;
          Continue;
        end;
        // if also in the loop the field is ok
          recField[X].iOpType := 0;
      end;

      qry.Close;

      listField.Clear;
      for X := Low(recField) to High(recField) do
      begin
        case recField[X].iOpType of
            0: Continue;
            1: begin
                listField.Add('ADD ' +  recField[X].sField + ' ' + recField[X].sType);

                if recField[X].iDef = -2 then  // avi 12.01.25 (to make default -1 in table OVERRIDE_STEP_PARAMETERS/PDO_SETUP)
                  listField.Add(' DEFAULT '+ IntToStr(-1))

                else if recField[X].iDef > -1 then
                  listField.Add(' DEFAULT '+ IntToStr(recField[X].iDef));

                if recField[X].bNull then
                  listField.Add(' NOT NULL');

                ListField.Add(',');
               end;
            2: listField.Add('ALTER COLUMN ' + recField[X].sField + ' TYPE ' + recField[X].sType + ',');
            3: begin
                 SysFld.Close;
                 SysFld.SQL.Clear;
                 SysFld.SQL.Add('update RELATION_FIELDS set  RELATION_FIELDS.NULL_FLAG = 1');
                 SysFld.SQL.Add('where RELATION_FIELDS.FIELD_NAME = '''+ recField[X].sField + ''''); //Copy(listField[Z], 6,Length(listField[Z]))+'''');
                 SysFld.ExecSQL;
               end;
            4: begin
              //   avi fix
              //   listField.Add('ALTER COLUMN ' + recField[X].sField +' TYPE ' + recField[X].sType + '",');
                 listField.Add('ALTER COLUMN ' + recField[X].sField +' TYPE ' + recField[X].sType + ',');
                 SysFld.Close;
                 SysFld.SQL.Clear;
                 SysFld.SQL.Add('update RELATION_FIELDS set  RELATION_FIELDS.NULL_FLAG = 1');
                 SysFld.SQL.Add('where RELATION_FIELDS.FIELD_NAME = '''+ recField[X].sField + '''');//Copy(listField[Z], 6,Length(listField[Z]))+'''');
                 SysFld.ExecSQL;
               end;
            5: listField.Add('DROP "' + recField[X].sField + '",');
          -99: Break;
        end;
      end;

      sysIdx.Close;
      sysIdx.SQL.Clear;

  //  NEW PART FOR DELPHI 2009

      sysIdx.SQL.Clear;
      sysIdx.SQL.Add('delete from RELATION_CONSTRAINTS');
      sysIdx.ExecSQL;

      sysIdx.SQL.Clear;
      sysIdx.SQL.Add('insert into RELATION_CONSTRAINTS');
      sysIdx.SQL.Add('select RDB$CONSTRAINT_NAME, RDB$RELATION_NAME, RDB$CONSTRAINT_TYPE, RDB$INDEX_NAME FROM RDB$RELATION_CONSTRAINTS');
      sysIdx.ExecSQL;

      sysIdx.SQL.Clear;
      sysIdx.SQL.Add('delete from INDICES');
      sysIdx.ExecSQL;

      sysIdx.SQL.Clear;
      sysIdx.SQL.Add('insert into INDICES');
      sysIdx.SQL.Add('select RDB$INDEX_NAME FROM RDB$INDICES');
      sysIdx.ExecSQL;

      sysIdx.SQL.Clear;
      sysIdx.SQL.Add('delete from INDEX_SEGMENTS');
      sysIdx.ExecSQL;

      sysIdx.SQL.Clear;
      sysIdx.SQL.Add('insert into INDEX_SEGMENTS');
      sysIdx.SQL.Add('select RDB$FIELD_POSITION, RDB$FIELD_NAME, RDB$INDEX_NAME FROM RDB$INDEX_SEGMENTS');
      sysIdx.ExecSQL;
      qry.Connection.Commit;

   //  COMPILED WITH DELPHI 7

      sysIdx.SQL.Clear;
      sysIdx.SQL.Add('select RDB$INDEX_SEGMENTS.RDB$FIELD_POSITION, ');
      sysIdx.SQL.Add('RDB$INDEX_SEGMENTS.RDB$FIELD_NAME as FIELDNAME,');
      sysIdx.SQL.Add('RDB$RELATION_CONSTRAINTS.RDB$CONSTRAINT_NAME as INDEXNAME,');
      sysIdx.SQL.Add('RDB$RELATION_CONSTRAINTS.RDB$RELATION_NAME,RDB$RELATION_CONSTRAINTS.RDB$CONSTRAINT_TYPE,');
      sysIdx.SQL.Add('RDB$INDICES.RDB$INDEX_NAME,RDB$RELATION_CONSTRAINTS.RDB$INDEX_NAME');
      sysIdx.SQL.Add('from RDB$RELATION_CONSTRAINTS, RDB$INDICES, RDB$INDEX_SEGMENTS');
      sysIdx.SQL.Add('where RDB$RELATION_CONSTRAINTS.RDB$RELATION_NAME = '''+ UpperCase(tbInfo.GetTableName) +'''');
      sysIdx.SQL.Add('and RDB$RELATION_CONSTRAINTS.RDB$CONSTRAINT_TYPE LIKE ''%PRIMARY%''');
      sysIdx.SQL.Add('and RDB$RELATION_CONSTRAINTS.RDB$INDEX_NAME= RDB$INDICES.RDB$INDEX_NAME');
      sysIdx.SQL.Add('and RDB$INDICES.RDB$INDEX_NAME = RDB$INDEX_SEGMENTS.RDB$INDEX_NAME');
      sysIdx.SQL.Add('order by RDB$INDEX_SEGMENTS.RDB$FIELD_POSITION');


   //  COMPILED WITH DELPHI 2009

   {   sysIdx.SQL.Clear;
      sysIdx.SQL.Add('select INDEX_SEGMENTS.FIELD_POSITION, ');
      sysIdx.SQL.Add('INDEX_SEGMENTS.FIELD_NAME as FIELDNAME,');
      sysIdx.SQL.Add('RELATION_CONSTRAINTS.CONSTRAINT_NAME as INDEXNAME,');
      sysIdx.SQL.Add('RELATION_CONSTRAINTS.RELATION_NAME,RELATION_CONSTRAINTS.CONSTRAINT_TYPE,');
      sysIdx.SQL.Add('INDICES.INDEX_NAME,RELATION_CONSTRAINTS.INDEX_NAME');
      sysIdx.SQL.Add('from RELATION_CONSTRAINTS, INDICES, INDEX_SEGMENTS');
      sysIdx.SQL.Add('where RELATION_CONSTRAINTS.RELATION_NAME = '''+ UpperCase(tbInfo.PCname) +'''');
      sysIdx.SQL.Add('and RELATION_CONSTRAINTS.CONSTRAINT_TYPE LIKE ''%PRIMARY%''');
      sysIdx.SQL.Add('and RELATION_CONSTRAINTS.INDEX_NAME= INDICES.INDEX_NAME');
      sysIdx.SQL.Add('and INDICES.INDEX_NAME = INDEX_SEGMENTS.INDEX_NAME');
      sysIdx.SQL.Add('order by INDEX_SEGMENTS.FIELD_POSITION');  }
      sysIdx.Open;

      if listField.Count > 0 then
      begin
        lbStep.Caption := 'ALTER TABLE ' + tbInfo.GetTableName;
        Application.ProcessMessages;


        qry.Close;
        qry.SQL.Clear;
        qry.SQL.Add('ALTER TABLE ' + tbInfo.GetTableName) ;

        if Trim(sysIdx.FieldByName('INDEXNAME').AsString) <> '' then
          qry.SQL.Add(' DROP CONSTRAINT ' +  sysIdx.FieldByName('INDEXNAME').AsString + ',');

        qry.SQL.AddStrings(listField);

        sKey := qry.SQL.Strings[qry.SQL.Count-1];
        if sKey[length(sKey)] = ',' then
        begin
          sKey[length(sKey)] := ' ';
          qry.SQL.Delete(qry.SQL.Count-1);
          qry.SQL.Add(sKey);
        end;

        qry.ExecSQL;
        qry.Close;

        qry.Connection.Commit;

        if tbinfo.PCname = 'CAL_SHIFT_EFFIC' then
        begin
          qry.sql.Clear;
          qry.sql.text := 'update CAL_SHIFT_EFFIC set CSE_RSC_CODE = ' + QuotedStr('') + ' where CSE_RSC_CODE is null';
          qry.ExecSQL;
          qry.Connection.Commit;
        end;

        sysIdx.Close;
        sysIdx.Open;

        lbStep.Caption := '';
        Application.ProcessMessages;
      end;

      //Find primaty key for all db
      Z := 0;
      bFound := False;
      sFldKey := '';
      SavedRecordcount := sysIdx.RecordCount;

      for I := 0 to tbInfo.nrfld - 1 do
      begin
        if tbInfo.struct[I].nrkey = 1 then
        begin
          sKey := CreatePfxFld(tbInfo.struct[I].fInfo);
          sFldKey := sFldKey + sKey + ',';

          if sKey <> Trim(sysIdx.FieldByName('FIELDNAME').AsString) then
            bFound :=True;

          sysIdx.Next;
          inc(Z);
        end;

      end;

    //  if Z <> sysIdx.RecordCount then
      if Z <> SavedRecordcount then
      begin
        bFound :=True;
        Z := sysIdx.RecordCount;
      end;

      qry.Close;

      if (sFldKey <> '') and bFound then
      begin
        sFldKey[length(sFldKey)] := ' ' ;

        if Z > 0 then
        begin
          qry.SQL.Clear;
          qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' drop CONSTRAINT ');
          qry.SQL.Add(sysIdx.FieldByName('INDEXNAME').AsString);
          qry.ExecSQL;
          qry.Close;
        end;

        qry.SQL.Clear;
        qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' add ');
        qry.SQL.Add('PRIMARY KEY (' + sFldKey + ')');
        try
        qry.ExecSQL;
        except
          qry.Close;
        end;
        qry.Close;
      end;
      if iRepeat > 1 then
      begin
        try
          qry.Connection.Commit;
        except
          Showmessage(_('The table ') + tbInfo.GetTableName + _(' cannot be converted! Table will be to re-created'));
          qry.Transaction.Rollback;
          qry.Close;
          qry.SQL.Clear;
          qry.SQL.Add('DROP TABLE ' + tbInfo.GetTableName);
          qry.ExecSQL;
          qry.Close;
          qry.Transaction.Commit;
          qry.Transaction.StartTransaction;
          CreateNewTbl(qry, tbInfo, lbStep);
          qry.Connection.Commit;
        end;
      end;
    end;

    sysIdx.Close;

    if iRepeat = 1 then
    begin
      try
        qry.Connection.Commit;
      except
        Showmessage(_('The ARCHIVE table cannot be converted! Function stopped!!!'));
        qry.Transaction.Rollback;
        Break;
      end;
    end;

  end;

  qry.Close;
  sysIdx.Close;
  sysFld.Close;

  if iRepeat > 1 then
  begin
    DropTable(qry, listTblDrop, lbStep, Gauge1);
    try
      qry.Connection.Commit;
    except
    end;
  end;

  listTblDrop.Free;
  listField.Free;

  if DBType = Main_DB then
  begin
    CreateView(qry, lbStep);  // avi 24/03/08
  end;

  qry.Connection.Commit;

  Gauge1.Progress :=  100;
  qry.Free;
  sysIdx.Free;
  sysFld.Free;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.UpdateDB_Oracle(DBType: TMqmDBType);
type
  rField = record
    iOpType: integer; //-99=nothing, 1 = add, 2= alter colum, 3 not null, 4= both(2and3)
                      // 5= drop
    sField : string;
    sType  : string;
    iDef   : integer;
    bNull  : boolean;
  end;
var
  qry:          TMqmQuery;
  sysIdx,SysFld:TMqmQuery;
  //trs:          TMqmTransaction;
  listTables:   TStrings;
  listTblDrop:  TStrings;
  listField:    TStrings;
  I,Z,X,J,W :        Integer;
  tbInfo:       PTblInfo;//^TTblInfo;
  tCont:        Table;
  sKey,sFldKey: string;
  sFldTyp:      string;
  vProgBar:     variant;
  bFound:       boolean;
  recField:     array of rField;
  iRepeat:      integer;
  SqlQryText:   string;
  ColNames, INDEX_NAME, TmpStr :     string;
  ColNamesStrList: TStringList;
begin
  listTables  := TStringList.Create;
  listField   := TStringList.Create;
  ColNamesStrList := TStringList.Create;
  bFound := false;
  SetLength(recField, 400);

  qry := CreateQuery(DBType);

  sysIdx := CreateQuery(DBType);
  sysFld := CreateQuery(DBType);

//  for I := Integer(Low(table)) to Integer(High(table)) do
//    listTables.Add(tblInfo[Table(I)].HostName);

  qry.SQL.Clear;

  var schema := ReplaceStr(DMib.m_MainDB.CurrentSchema, '"', '');

  if DBType = Main_DB then
    SqlQryText := ' SELECT distinct table_name FROM all_tables WHERE table_name like ' + QUOTEDsTR('%SCDM_%')
      + ' and OWNER = ' +QuotedStr(UpperCase(schema))
  else if DBType = Cfg_DB then
    SqlQryText := ' SELECT distinct table_name FROM all_tables WHERE table_name like ' + QUOTEDsTR('%SCDC_%')
      + ' and OWNER = ' +QuotedStr(UpperCase(schema));

  qry.SQL.Add(SqlQryText);
  qry.OPEN;
  while not qry.Eof do
  begin

    if (qry.FieldByName('table_name').Asstring = 'SCDM_LICENCE') or (qry.FieldByName('table_name').Asstring = 'SCDM_LICENCE2') or
       (qry.FieldByName('table_name').Asstring = 'SCDC_LICENCE') or (qry.FieldByName('table_name').Asstring = 'SCDC_LICENCE2') then
    begin
      qry.NEXT;
      continue
    end;

    if listTables.IndexOf(qry.FieldByName('table_name').Asstring) = -1 then
      listTables.Add(qry.FieldByName('table_name').Asstring);
    qry.NEXT;
  end;

  listTblDrop := listTables;

  lbStep.Caption := '';
  lbStep.Visible := True;
  vProgBar := High(tblInfo);
  Gauge1.ForeColor := clRed;
  //Gauge1.Visible := True;
  Application.ProcessMessages;

  Gauge1.MaxValue := vProgBar;
  Gauge1.Progress := 0;

  {
  if DBType = Main_DB then
  begin
    DeleteProc(qry, CMainGetCapResNum);
    DeleteProc(qry, CMainGetGrpNum);
  end
  else
  begin
    DeleteProc(qry, CCfgGetAccess);
    DeleteProc(qry, CCfgEndAccess);
    DeleteProc(qry, CCfgGetStatus);
    DeleteProc(qry, CSrvLoadStatus);
    DeleteProc(qry, CSrvLoadGetAcc);
    DeleteProc(qry, CSrvLoadEndAcc);
    DeleteProc(qry, CCfgConnect);
    DeleteProc(qry, CCfgDisconnect);
    DeleteProc(qry, CCfgStillOn);
    DeleteProc(qry, CCfgActWrcst);
    DeleteProc(qry, CSevCngDataBase);
  end;
  }

  qry.Close;
  qry.SQL.Clear;

  for iRepeat := 1 to 2 do
  begin
    for tCont := Low(tblInfo) to High(tblInfo) do
    begin

      tbInfo := @tblInfo[tCont];
      SetFldPfx(tbInfo.pfx);

      X := 2;
      if  DBType = Cfg_Db then
        X := 1;

      if (tbInfo.group = X) or (tbInfo.group = 9) then
        Continue; //exclude table

      if ( (iRepeat = 1) and (tbInfo.arc > 0) ) or
         ( (iRepeat > 1) and (tbInfo.arc < 1) ) then
        Continue; //for the first loop if not archive db the goto next db

      lbStep.Caption := 'Check table ' + tbInfo.GetTableName;
      Gauge1.Progress := Gauge1.Progress + 1;
      Application.ProcessMessages;

      {$ifdef WEBSERVICE}
      if (tbInfo.GetTableName = 'SCDM_BALANCE_HEADER') or (tbInfo.GetTableName = 'SCDM_MATERIAL') or
         (tbInfo.GetTableName = 'SCDM_PROD_REQ') or (tbInfo.GetTableName = 'SCDM_PROD_REQCONN') or
         (tbInfo.GetTableName = 'SCDM_PROD_REQHDR') or (tbInfo.GetTableName = 'SCDM_PROD_SCHED_PROGRESS') or
         (tbInfo.GetTableName = 'SCDM_PROD_SCHED') or (tbInfo.GetTableName = 'SCDM_PROD_SCHEDS_MCM') or
         (tbInfo.GetTableName = 'SCDM_PROD_STEP') or (tbInfo.GetTableName = 'SCDM_PROD_STEP_TIMES') or
         (tbInfo.GetTableName = 'SCDM_PRODUCED_ARTICLE') or (tbInfo.GetTableName = 'SCDM_PRODUCTS') or
         (tbInfo.GetTableName = 'SCDM_PROP_PROD') or (tbInfo.GetTableName = 'SCDM_PROD_STEP_BATCH_SIZE') then
      begin
        continue;
      end;
      {$endif}

      if tbInfo.GetTableName = 'SCDC_BIN_FILTER' then
      begin
        //BF_DEPENDING_ON_NEXTHANDLEDSTEP
        if qry.Connection.ExecSQLScalar('select count(column_name) from USER_TAB_COLUMNS c'
                    +' left join all_tables a on c.table_name = a.table_name and OWNER = ' +QuotedStr(UpperCase(schema))
                    +' where c.table_name = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and column_name = ' + QuotedStr('BF_DEPENDING_ON_NEXTHANDLEDSTEP')) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_NEXTHANDLEDSTEP to '
          + CreateFld(tbInfo.pfx,fli_FiltDependingOnNextHandledStep) );
          qry.Connection.Commit;
        end;

        //BF_DEPENDING_ON_PREVHANDLEDSTEP
        if qry.Connection.ExecSQLScalar('select count(column_name) from USER_TAB_COLUMNS c'
                    +' left join all_tables a on c.table_name = a.table_name and OWNER = ' +QuotedStr(UpperCase(schema))
                    +' where c.table_name = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and column_name = ' + QuotedStr('BF_DEPENDING_ON_PREVHANDLEDSTEP')) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_PREVHANDLEDSTEP to '
          + CreateFld(tbInfo.pfx,fli_FiltDependingOnPrevHandledStep) );
          qry.Connection.Commit;
        end;

        //BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST
        if qry.Connection.ExecSQLScalar('select count(column_name) from USER_TAB_COLUMNS c'
                    +' left join all_tables a on c.table_name = a.table_name and OWNER = ' +QuotedStr(UpperCase(schema))
                    +' where c.table_name = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and column_name = ' + QuotedStr('BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST')) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST to '
          + CreateFld(tbInfo.pfx,fli_filtDependingOnNextHandledLinkedRequest) );
          qry.Connection.Commit;
        end;

        //BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST
        if qry.Connection.ExecSQLScalar('select count(column_name) from USER_TAB_COLUMNS c'
                    +' left join all_tables a on c.table_name = a.table_name and OWNER = ' +QuotedStr(UpperCase(schema))
                    +' where c.table_name = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and column_name = ' + QuotedStr('BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST')) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST to '
          + CreateFld(tbInfo.pfx,fli_filtDependingOnPrevHandledLinkedRequest) );
          qry.Connection.Commit;
        end;
      end;

      if tbInfo.GetTableName = 'SCDC_EXCG_WKST_SRVLOAD' then
      begin
        var Con := '';
        Con := qry.Connection.ExecSQLScalar('select CONSTRAINT_NAME from all_cons_columns'
          + ' where table_name = '+QuotedStr('SCDC_EXCG_WKST_SRVLOAD')
          + ' and position is not null'
          + ' and OWNER = ' +QuotedStr(UpperCase(schema)));
        if con <> '' then
        begin
          qry.ExecSQL('Alter Table SCDC_EXCG_WKST_SRVLOAD drop CONSTRAINT '+ Con);
          qry.Connection.Commit;
        end;
      end;

      qry.SQL.Clear;
      SqlQryText := ' SELECT distinct data_type FROM USER_TAB_COLUMNS c'
                    +' left join all_tables a on c.table_name = a.table_name and OWNER = ' +QuotedStr(UpperCase(schema))
                    +' WHERE c.table_name = ''' + (UpperCase(tbInfo.GetTableName)) + '''';
      qry.SQL.Add(SqlQryText);

      qry.Open;

      if qry.EOF then
      begin
        CreateNewTbl(qry, tbInfo, lbStep);
        Gauge1.Progress := Gauge1.Progress + 1;

        qry.Connection.Commit;

        Continue;
      end;

      //check the list
      for i := 0 to listTblDrop.Count-1 do
      begin
        if UpperCase(listTblDrop[i]) = UpperCase(tbinfo.GetTableName) then
        begin
          listTblDrop.Delete(i);
          Break;
        end;
      end;

      qry.SQL.Clear;
      SqlQryText := ' select c.column_name as colname, c.data_type as typename, c.data_length as length, ' +
                    ' c.NULLABLE, c.DATA_PRECISION , c.DATA_SCALE from USER_TAB_COLUMNS c' +
                    ' join all_tables a on c.table_name = a.table_name' +
                    ' where c.table_name = ''' + (UpperCase(tbInfo.GetTableName)) + ''''
                    + ' and OWNER = ' +QuotedStr(UpperCase(schema));
      qry.SQL.Add(SqlQryText);

      qry.Open;

      for X := Low(recField) to High(recField) do
      begin
        recField[X].iOpType := -99;
        recField[X].sField  := '';
        recField[X].sType   := '';
        recField[X].iDef    := -1;
        recField[X].bNull   := false;
      end;

      X := 0;
      while not qry.Eof do
      begin
         if qry.FieldByName('typename').Asstring = 'VARCHAR' then
         begin
           sFldTyp := 'VARCHAR('+IntToStr(qry.FieldByName('length').AsInteger) +')';
         end

         else if qry.FieldByName('typename').Asstring = 'VARCHAR2' then
         begin
           sFldTyp := 'VARCHAR('+IntToStr(qry.FieldByName('length').AsInteger) +')';
         end

         else if (qry.FieldByName('typename').Asstring = 'NUMBER') AND
                  (qry.FieldByName('DATA_PRECISION').AsInteger > 0) then
                 // (qry.FieldByName('DATA_SCALE').AsInteger = 2) then
         begin
        //   sFldTyp := 'DECIMAL(9,2)';
           sFldTyp := 'DECIMAL('+
                       IntToStr(qry.FieldByName('DATA_PRECISION').AsInteger) +','+
                       IntToStr(ABS(qry.FieldByName('DATA_SCALE').AsInteger))+ ')';

         end


         else if qry.FieldByName('typename').Asstring = 'NUMBER' then
         begin
           sFldTyp :=  'NUMBER'; //'NUMBER('+IntToStr(qry.FieldByName('length').AsInteger) +')';
         end
         else if qry.FieldByName('typename').Asstring = 'INTEGER' then
         begin
           sFldTyp := 'INTEGER';
         end
         else if qry.FieldByName('typename').Asstring = 'CHAR' then
         begin
           sFldTyp := 'CHAR('+IntToStr(qry.FieldByName('length').AsInteger) +')';
         end
         else if qry.FieldByName('typename').Asstring = 'TIMESTAMP' then
         begin
           sFldTyp := 'TIMESTAMP';
         end


         else if qry.FieldByName('typename').Asstring = 'TIMESTAMP(6)' then
         begin
           sFldTyp := 'TIMESTAMP';
         end



         else if qry.FieldByName('typename').Asstring = 'DECIMAL' then
         begin
           sFldTyp := 'DECIMAL('+
                       IntToStr(qry.FieldByName('LENGTH').AsInteger) +','+
                       IntToStr(ABS(qry.FieldByName('SCALE').AsInteger))+ ')';
         end
         else if qry.FieldByName('typename').Asstring = 'CHARACTER' then
           sFldTyp := 'CHAR('+IntToStr(qry.FieldByName('LENGTH').AsInteger) +')'
         else
           ShowMessage('ERROR NEW TYPE!! CALL DATATEX');

        recField[X].iOpType := 5 ;
        recField[X].sField  := Trim(qry.FieldByName('COLNAME').AsString);
        recField[X].sType   := sFldTyp;
        recField[X].iDef    := -1;
        if qry.FieldByName('NULLABLE').AsString = 'Y' then
          recField[X].bNull := false
        else
          recField[X].bNull := true;
        Inc( X );
        qry.Next;
      end;

      for I := 0 to tbInfo.nrfld-1 do
      begin
      //  sKey := CreateFld(tbInfo.pfx, tbInfo.struct[I].fInfo);

        sKey := CreatePfxFld(tbInfo.struct[I].fInfo);

        if ContainsText(sKey, 'ABSUNIQUEID') then
          sKey := CreateFld('', tbInfo.struct[I].fInfo);

        bFound := False;
        for X := Low(recField) to High(recField) do
        begin
          if ((recField[X].sField) = sKey) or ('"' + (recField[X].sField + '"') = sKey) then
          begin
            bFound := True;
            Break;
          end;
        end;

        //add field
        if not bFound then
        begin

          for X := Low(recField) to High(recField) do
            if recField[X].iOpType = -99 then
              Break;

          recField[X].iOpType := 1;
          recField[X].sField  := sKey;
          recField[X].sType   := CreateFldType(tbInfo.struct[I].fInfo);
          if ContainsText(recField[X].sField, 'IDENTIFIER')  then
            recField[X].iDef := StrToInt(IniAppGlobals.Identifier)
          else
            recField[X].iDef    := tbInfo.struct[I].defval;
          recField[X].bNull   := tbInfo.struct[I].notnull;
          Continue;
        end;

        //change type and also the not null attribute
        if recField[X].sType <> CreateFldType(tbInfo.struct[I].fInfo) then
        begin
          recField[X].iOpType := 2;
          recField[X].sType   := CreateFldType(tbInfo.struct[I].fInfo);

          if recField[X].bNull <> tbInfo.struct[I].notnull then
          begin
            recField[X].iOpType := 4;
            recField[X].bNull   := tbInfo.struct[I].notnull;
          end;
          Continue;
        end;

        //change only not nulla attribute
        if recField[X].bNull <> tbInfo.struct[I].notnull then
        begin
          recField[X].iOpType := 3;
          recField[X].bNull   := tbInfo.struct[I].notnull;
          Continue;
        end;
        // if also in the loop the field is ok
          recField[X].iOpType := 0;
      end;

      qry.Close;

      listField.Clear;
      for X := Low(recField) to High(recField) do
      begin
        case recField[X].iOpType of
            0: Continue;
            1: begin
                listField.Add('ADD ' + recField[X].sField + ' ' + recField[X].sType);

                if recField[X].iDef = -2 then  // avi 12.01.25 (to make default -1 in table OVERRIDE_STEP_PARAMETERS/PDO_SETUP)
                  listField.Add(' DEFAULT '+ IntToStr(-1))

                else if recField[X].iDef > -1 then
                  listField.Add(' DEFAULT '+ IntToStr(recField[X].iDef));

                if recField[X].bNull then
                  listField.Add(' NOT NULL');

               end;
            2: begin

                 listField.Add(' MODIFY ' + recField[X].sField + ' ' + recField[X].sType + ' ');

               end;

            3: begin
                 SysFld.Close;
                 SysFld.SQL.Clear;
                 SysFld.SQL.Add(' ALTER TABLE ' + tbInfo.HostName);
                 if recField[X].bNull then
                   SysFld.SQL.Add(' MODIFY ' + recField[X].sField + ' NOT NULL')
                 else
                   SysFld.SQL.Add( 'MODIFY ' + recField[X].sField + ' DROP NOT NULL');
                 SysFld.ExecSQL;
               end;
            4: begin
                 SysFld.Close;
                 SysFld.SQL.Clear;
                 SysFld.SQL.Add(' ALTER TABLE ' + tbInfo.HostName);
                 if recField[X].bNull then
                   SysFld.SQL.Add(' MODIFY ' + recField[X].sField + ' NOT NULL')
                 else
                   SysFld.SQL.Add(' MODIFY ' + recField[X].sField + ' DROP NOT NULL');
                 SysFld.ExecSQL;

               end;
            5: listField.Add('DROP column "' + recField[X].sField + '",');
          -99: Break;
        end;
      end;

      if tbInfo.GetTableName = 'SCDM_BALANCE_HEADER' then continue;   // (b.c of the BH_TABLE_INDEX colums)

      sysIdx.Close;
      sysIdx.SQL.Clear;
      sysIdx.SQL.Add(' SELECT distinct cols.constraint_name as COLUMN_NAME');
      sysIdx.SQL.Add(' FROM all_constraints cons, all_cons_columns cols where  cols.table_name = ' + QuotedStr(UpperCase(tbInfo.GetTableName)));
      sysIdx.SQL.Add(' AND cons.constraint_type = '+ QuotedStr('P')+' AND cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner');
      sysIdx.SQL.Add(' and cols.OWNER = '+QuotedStr(UpperCase(schema)));

      sysIdx.Open;

      ColNamesStrList.Clear;
      ColNames := '';
      while not sysIdx.Eof do
      begin
        ColNamesStrList.add(sysIdx.FieldByName('COLUMN_NAME').AsString);
        sysIdx.next
      end;

      if listField.Count > 0 then
      begin
        lbStep.Caption := 'ALTER TABLE ' + tbinfo.GetTableName;
        Application.ProcessMessages;

        qry.Close;
        qry.SQL.Clear;
        qry.SQL.Add('ALTER TABLE ' + tbinfo.GetTableName ) ;

        qry.SQL.AddStrings(listField);

        sKey := qry.SQL.Strings[qry.SQL.Count-1];
        if sKey[length(sKey)] = ',' then
        begin
          sKey[length(sKey)] := ' ';
          qry.SQL.Delete(qry.SQL.Count-1);
          qry.SQL.Add(sKey);
        end;

        qry.ExecSQL;
        qry.Close;

        qry.Connection.Commit;

      //  sysIdx.Close;
      //  sysIdx.Open;

        lbStep.Caption := '';
        Application.ProcessMessages;
      end;

      //Find primaty key for all db
      J := 0;
      Z := 0;
      bFound := False;
      sFldKey := '';

      if ColNamesStrList.count > 0 then
      begin

        for I := 0 to tbInfo.nrfld - 1 do
        begin
          if tbInfo.struct[I].nrkey = 1 then
          begin
            sKey := CreatePfxFld(tbInfo.struct[I].fInfo);
            sFldKey := sFldKey + sKey + ',';
            if J >= ColNamesStrList.count then
              bFound :=True
            else
           //  if ColNamesStrList.IndexOf(sKey) = -1 then
              if sKey <> ColNamesStrList.Strings[J] then
               bFound :=True;

            inc(J);
          //  sysIdx.Next;
            inc(Z);
          end;
        end;

      end;

   //   if Z <> sysIdx.RecordCount then
      if z <> ColNamesStrList.count then
      begin
        bFound :=True;
       // Z := sysIdx.RecordCount;
      end;

      qry.Close;

      if (sFldKey <> '') and bFound then
      begin
        sFldKey[length(sFldKey)] := ' ' ;

        if Z > 0 then
        begin
          qry.SQL.Clear;
          INDEX_NAME := ColNamesStrList[0];//sysIdx.FieldByName('COLUMN_NAME').AsString;
          qry.SQL.Add('ALTER TABLE ' + UpperCase(tbInfo.GetTableName) + ' drop constraint ' + INDEX_NAME);
          try
            qry.ExecSQL;
          except

          end;
          qry.Close;
        end;

        qry.SQL.Clear;
        qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' add ');
        qry.SQL.Add('PRIMARY KEY (' + sFldKey + ')');
        try
          qry.ExecSQL;
        except
        end;
        qry.Close;
      end;
      if iRepeat > 1 then
      begin
        try
          qry.Connection.Commit;

        except
          Showmessage(_('The table ') + tbInfo.GetTableName + _(' cannot be converted! Table will be to re-created'));

          //trs.Rollback;
          qry.Connection.Rollback;
          //sysIDx.Connection.RollbackTrans;
          //sysFld.Connection.RollbackTrans;

          qry.Close;
          qry.SQL.Clear;
          qry.SQL.Add('DROP TABLE '+ tbInfo.GetTableName);
          qry.ExecSQL;
          qry.Close;

          //trs.Commit;
          //trs.StartTransaction;

          qry.Connection.Commit;
          //sysIDx.Connection.CommitTrans;
          //sysFld.Connection.CommitTrans;
         // qry.Connection.BeginTrans;
          //sysIDx.Connection.BeginTrans;
          //sysFld.Connection.BeginTrans;


          CreateNewTbl(qry, tbInfo, lbStep);

          //trs.Commit;
          //trs.StartTransaction
          qry.Connection.Commit;
          //sysIDx.Connection.CommitTrans;
          //sysFld.Connection.CommitTrans;
       //   qry.Connection.BeginTrans;
          //sysIDx.Connection.BeginTrans;
          //sysFld.Connection.BeginTrans;
        end;
      end;
    end;

    sysIdx.Close;

    if iRepeat = 1 then
    begin
      try
        //trs.Commit;
        //trs.StartTransaction;
        qry.Connection.Commit;
        //sysIDx.Connection.CommitTrans;
        //sysFld.Connection.CommitTrans;
     //   qry.Connection.BeginTrans;
        //sysIDx.Connection.BeginTrans;
        //sysFld.Connection.BeginTrans;
      except
        Showmessage(_('The ARCHIVE table cannot be converted! Function stopped!!!'));
        //trs.Rollback;
        qry.Connection.Rollback;
        //sysIDx.Connection.RollbackTrans;
        //sysFld.Connection.RollbackTrans;
        Break;
      end;
    end;

  end;

  qry.Close;
  sysIdx.Close;
  sysFld.Close;

  if iRepeat > 1 then
  begin
    DropTable(qry, listTblDrop, lbStep, Gauge1);
    try
      qry.Connection.Commit;
    except
    end;
  end;

  listTblDrop.Free;
  listField.Free;

  {
  if DBType = Main_DB then
  begin
    DropView(qry, lbStep);
    CreateIndex(qry, lbStep);
    //CreateView(qry, lbStep);
  end;
  }

  Gauge1.Progress :=  100;

  qry.Connection.Commit;
  //sysIDx.Connection.CommitTrans;
  //sysFld.Connection.CommitTrans;

  qry.Free;
  sysIdx.Free;
  sysFld.Free;
end;

procedure TCreateTables.InsertDefaultValues;
var qry : TmqmQuery;
tbInfo:       PTblInfo;
begin

  Qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_appini];

  qry.ExecSQL('Insert into ' + tbInfo.GetTableName
      + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                   + QuotedStr('cbCopiedSchedTypeFromMqm') + ', ' + QuotedStr('0')+')');

  qry.ExecSQL('Insert into ' + tbInfo.GetTableName
      + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                   + QuotedStr('CopiedSchedTypeFromMqm') + ', ' + QuotedStr(IntToStr(8))+')');


  qry.ExecSQL('Insert into ' + tbInfo.GetTableName
      + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                   + QuotedStr('cbCopiedBackwardFromMqmDays') + ', ' + QuotedStr('0')+')');

  qry.ExecSQL('Insert into ' + tbInfo.GetTableName
      + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                   + QuotedStr('CopiedBackwardFromMqmDays') + ', ' + QuotedStr(IntToStr(0))+')');

  qry.Close;
  qry.Free;

end;

procedure TCreateTables.UpdateDefaultValues;
var qry : TmqmQuery;
tbInfo:       PTblInfo;
begin

  Qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[table(tbl_cfg_binTab_col)];

  Qry.ExecSQL('Update ' + tbInfo.GetTableName
    + ' set ' + CreateFld(tbinfo.pfx, fli_TypeOfUse) +  ' = ' + QuotedStr('0')
    + ' where ' + CreateFld(tbinfo.pfx, fli_TypeOfUse) +  ' is null');
  qry.Close;


  tbInfo := @tblInfo[tbl_cfg_appini];

  qry.SQL.Text := 'Select * from ' + tbInfo.getTableName + ' where AI_WKST_CODE = ' + QuotedStr('MQMSRVLOAD')
    + ' and AI_IDENTIFIER = ' + IniAppGlobals.Identifier;
  qry.Open;

  if qry.RecordCount = 0 then
  begin

    qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE) '
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                     + QuotedStr('cbCopiedSchedTypeFromMqm') + ', ' + QuotedStr(IniAppGlobals.cbCopiedSchedTypeFromMqm)+')');

    qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE) '
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                     + QuotedStr('CopiedSchedTypeFromMqm') + ', ' + QuotedStr(IniAppGlobals.CopiedSchedTypeFromMqm)+')');


    qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE) '
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                     + QuotedStr('cbCopiedBackwardFromMqmDays') + ', ' + QuotedStr(IniAppGlobals.cbCopiedBackwardFromMqmDays)+')');

    qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE) '
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr('MQMSRVLOAD') + ', '
                     + QuotedStr('CopiedBackwardFromMqmDays') + ', ' + QuotedStr(IniAppGlobals.CopiedBackwardFromMqmDays)+')');

  end;


  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.UpdateDB_DB2(DBType: TMqmDBType);
type
  rField = record
    iOpType: integer; //-99=nothing, 1 = add, 2= alter colum, 3 not null, 4= both(2and3)
                      // 5= drop
    sField : string;
    sType  : string;
    iDef   : integer;
    bNull  : boolean;
  end;
var
  qry:          TMqmQuery;
  sysIdx,SysFld:TMqmQuery;
  listTables:   TStrings;
  listTblDrop:  TStrings;
  listField:    TStrings;
  I,Z,X,J,W :        Integer;
  tbInfo:       PTblInfo;//^TTblInfo;
  tCont:        Table;
  sKey,sFldKey: string;
  sFldTyp:      string;
  vProgBar:     variant;
  bFound:       boolean;
  recField:     array of rField;
  iRepeat:      integer;
  SqlQryText:   string;
  ColNames, TmpStr :     string;
  ColNamesStrList: TStringList;
begin
  listTables  := TStringList.Create;
  listField   := TStringList.Create;
  ColNamesStrList := TStringList.Create;

  SetLength(recField, 400);

  qry := CreateQuery(DBType);

  sysIdx := CreateQuery(DBType);
  sysFld := CreateQuery(DBType);

  qry.SQL.Clear;
  if DBType = Main_DB then
    SqlQryText := ' SELECT TABNAME FROM SYSCAT.TABLES WHERE TABNAME like ' + QUOTEDsTR('%SCDM_%')
    + ' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema)
  else if DBType = Cfg_DB then
    SqlQryText := ' SELECT TABNAME FROM SYSCAT.TABLES WHERE TABNAME like ' + QUOTEDsTR('%SCDC_%')
       + ' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema);

  qry.SQL.Add(SqlQryText);
  qry.OPEN;
  while not qry.Eof do
  begin
    if (qry.FieldByName('TABNAME').Asstring = 'SCDM_LICENCE') or (qry.FieldByName('TABNAME').Asstring = 'SCDM_LICENCE2') or
       (qry.FieldByName('TABNAME').Asstring = 'SCDC_LICENCE') or (qry.FieldByName('TABNAME').Asstring = 'SCDC_LICENCE2') then
    begin
      qry.NEXT;
      continue
    end;

    listTables.Add(qry.FieldByName('TABNAME').Asstring);
    qry.NEXT;
  end;

  listTblDrop := listTables;

  lbStep.Caption := '';
  lbStep.Visible := True;
  vProgBar := High(tblInfo);
  Gauge1.ForeColor := clRed;
  //Gauge1.Visible := True;
  Application.ProcessMessages;

  Gauge1.MaxValue := vProgBar;
  Gauge1.Progress := 0;

  qry.Close;
  qry.SQL.Clear;

  for iRepeat := 1 to 2 do
  begin
    for tCont := Low(tblInfo) to High(tblInfo) do
    begin

      tbInfo := @tblInfo[tCont];
      SetFldPfx(tbInfo.pfx);

      X := 2;
      if  DBType = Cfg_Db then
        X := 1;

      if (tbInfo.group = X) or (tbInfo.group = 9) then
        Continue; //exclude table

      if ( (iRepeat = 1) and (tbInfo.arc > 0) ) or
         ( (iRepeat > 1) and (tbInfo.arc < 1) ) then
        Continue; //for the first loop if not archive db the goto next db


      lbStep.Caption := 'Check table ' + tbInfo.GetTableName;
      Gauge1.Progress := Gauge1.Progress + 1;
      Application.ProcessMessages;

     { qry.SQL.Clear;
      TmpStr := 'reorg Table ' + tbInfo.getTableName;
      qry.SQL.Add('Call Sysproc.admin_cmd ( ' + quotedstr(TmpStr)  + ')'  );
      try
        qry.ExecSQL;
      except
      end;   }

      qry.SQL.Clear;
      SqlQryText := ' SELECT distinct TYPE FROM SYSCAT.TABLES ' +
                    ' WHERE TABNAME = ''' + (UpperCase(tbInfo.GetTableName)) + ''''
                    + ' AND TABSCHEMA = ' + QuotedStr(DMib.m_MainDB.CurrentSchema);
      qry.SQL.Add(SqlQryText);

      qry.Open;

      if qry.EOF then
      begin
        CreateNewTbl(qry, tbInfo, lbStep);
        Gauge1.Progress := Gauge1.Progress + 1;
        qry.Connection.Commit;

        Continue;
      end;

      //check the list
      for i := 0 to listTblDrop.Count-1 do
      begin
        if UpperCase(listTblDrop[i]) = UpperCase(tbinfo.GetTableName) then
        begin
          listTblDrop.Delete(i);
          Break;
        end;
      end;

      {$ifdef WEBSERVICE}
      if (tbInfo.GetTableName = 'SCDM_BALANCE_HEADER') or (tbInfo.GetTableName = 'SCDM_MATERIAL') or
         (tbInfo.GetTableName = 'SCDM_PROD_REQ') or (tbInfo.GetTableName = 'SCDM_PROD_REQCONN') or
         (tbInfo.GetTableName = 'SCDM_PROD_REQHDR') or (tbInfo.GetTableName = 'SCDM_PROD_SCHED_PROGRESS') or
         (tbInfo.GetTableName = 'SCDM_PROD_SCHED') or (tbInfo.GetTableName = 'SCDM_PROD_SCHEDS_MCM') or
         (tbInfo.GetTableName = 'SCDM_PROD_STEP') or (tbInfo.GetTableName = 'SCDM_PROD_STEP_TIMES') or
         (tbInfo.GetTableName = 'SCDM_PRODUCED_ARTICLE') or (tbInfo.GetTableName = 'SCDM_PRODUCTS') or
         (tbInfo.GetTableName = 'SCDM_PROP_PROD') or (tbInfo.GetTableName = 'SCDM_PROD_STEP_BATCH_SIZE') then
      begin
        continue;
      end;
      {$endif}

      if tbInfo.GetTableName = 'SCDC_BIN_FILTER' then
      begin
        //BF_DEPENDING_ON_NEXTHANDLEDSTEP
        if qry.Connection.ExecSQLScalar('select count(colname) from syscat.columns '
                    +' where tabname = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and  colname = ' + QuotedStr('BF_DEPENDING_ON_NEXTHANDLEDSTEP')
                    +' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema)) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_NEXTHANDLEDSTEP to '
          + CreateFld(tbInfo.pfx,fli_FiltDependingOnNextHandledStep) );
          qry.Connection.Commit;
        end;

        //BF_DEPENDING_ON_PREVHANDLEDSTEP
        if qry.Connection.ExecSQLScalar('select count(colname) from syscat.columns '
                    +' where tabname = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and  colname = ' + QuotedStr('BF_DEPENDING_ON_PREVHANDLEDSTEP')
                    +' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema)) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_PREVHANDLEDSTEP to '
          + CreateFld(tbInfo.pfx,fli_FiltDependingOnPrevHandledStep) );
          qry.Connection.Commit;
        end;

        //BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST
        if qry.Connection.ExecSQLScalar('select count(colname) from syscat.columns '
                    +' where tabname = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and  colname = ' + QuotedStr('BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST')
                    +' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema)) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_NEXTHANDLEDLINKEDREQUEST to '
          + CreateFld(tbInfo.pfx,fli_filtDependingOnNextHandledLinkedRequest) );
          qry.Connection.Commit;
        end;

        //BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST
        if qry.Connection.ExecSQLScalar('select count(colname) from syscat.columns '
                    +' where tabname = ' + QuotedStr(UpperCase(tbInfo.GetTableName))
                    +' and  colname = ' + QuotedStr('BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST')
                    +' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema)) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_BIN_FILTER'
          + ' rename column BF_DEPENDING_ON_PREVHANDLEDLINKEDREQUEST to '
          + CreateFld(tbInfo.pfx,fli_filtDependingOnPrevHandledLinkedRequest) );
          qry.Connection.Commit;
        end;
      end;

      if tbInfo.GetTableName = 'SCDC_EXCG_WKST_SRVLOAD' then
      begin
        if qry.Connection.ExecSQLScalar('SELECT count(*) FROM SYSIBM.SYSCOLUMNS WHERE TBNAME = '+QuotedStr('SCDC_EXCG_WKST_SRVLOAD')
          +' AND KEYSEQ > 0'
          +' and TBCREATOR = ' +QuotedStr(DMib.m_MainDB.CurrentSchema)) > 0 then
        begin
          qry.ExecSQL('Alter Table SCDC_EXCG_WKST_SRVLOAD drop PRIMARY KEY ');
          qry.Connection.Commit;
        end;
      end;

      //check the structure
      qry.SQL.Clear;
      SqlQryText := ' select tabname, colname, typename, length, scale, default, nulls, identity, generated, ' +
                    ' remarks, keyseq from syscat.columns ' +
                    ' where tabname = ''' + (UpperCase(tbInfo.GetTableName)) + ''''
                    + ' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema);
      qry.SQL.Add(SqlQryText);

      qry.Open;

      for X := Low(recField) to High(recField) do
      begin
        recField[X].iOpType := -99;
        recField[X].sField  := '';
        recField[X].sType   := '';
        recField[X].iDef    := -1;
        recField[X].bNull   := false;
      end;

      X := 0;
      while not qry.Eof do
      begin
         if qry.FieldByName('typename').Asstring = 'VARCHAR' then
         begin
           sFldTyp := 'VARCHAR('+IntToStr(qry.FieldByName('length').AsInteger) +')';
         end
         else if qry.FieldByName('typename').Asstring = 'SMALLINT' then
         begin
           sFldTyp := 'SMALLINT';
         end
         else if qry.FieldByName('typename').Asstring = 'INTEGER' then
         begin
           sFldTyp := 'INTEGER';
         end
         else if qry.FieldByName('typename').Asstring = 'CHAR' then
         begin
           sFldTyp := 'CHAR('+IntToStr(qry.FieldByName('length').AsInteger) +')';
         end
         else if qry.FieldByName('typename').Asstring = 'TIMESTAMP' then
         begin
           sFldTyp := 'TIMESTAMP';
         end
         else if qry.FieldByName('typename').Asstring = 'DECIMAL' then
         begin
           sFldTyp := 'DECIMAL('+
                       IntToStr(qry.FieldByName('LENGTH').AsInteger) +','+
                       IntToStr(ABS(qry.FieldByName('SCALE').AsInteger))+ ')';
         end
         else if qry.FieldByName('typename').Asstring = 'CHARACTER' then
           sFldTyp := 'CHAR('+IntToStr(qry.FieldByName('LENGTH').AsInteger) +')'
         else if qry.FieldByName('typename').Asstring = 'BIGINT' then
         begin
           sFldTyp := 'INTEGER'
         end else
           ShowMessage('ERROR NEW TYPE!! CALL DATATEX');

        recField[X].iOpType := 5 ;
        recField[X].sField  := Trim(qry.FieldByName('COLNAME').AsString);
        recField[X].sType   := sFldTyp;
        recField[X].iDef    := -1;
        if qry.FieldByName('NULLS').AsString = 'Y' then
          recField[X].bNull := false
        else
          recField[X].bNull := true;
        Inc( X );
        qry.Next;
      end;

      for I := 0 to tbInfo.nrfld-1 do
      begin

        sKey := CreatePfxFld(tbInfo.struct[I].fInfo);

        if ContainsText(sKey, 'ABSUNIQUEID') then
          sKey := CreateFld('', tbInfo.struct[I].fInfo);


        bFound := False;
        for X := Low(recField) to High(recField) do
        begin
          if ((recField[X].sField) = sKey) or ('"' + (recField[X].sField + '"') = sKey) then
          begin
            bFound := True;
            Break;
          end;
        end;

        //add field
        if not bFound then
        begin

          for X := Low(recField) to High(recField) do
            if recField[X].iOpType = -99 then
              Break;

          recField[X].iOpType := 1;
          recField[X].sField  := sKey;
          recField[X].sType   := CreateFldType(tbInfo.struct[I].fInfo);

          if ContainsText(recField[X].sField, 'IDENTIFIER')  then
            recField[X].iDef := StrToInt(IniAppGlobals.Identifier)
          else
            recField[X].iDef    := tbInfo.struct[I].defval;

        //  recField[X].iDef    := tbInfo.struct[I].defval;
          recField[X].bNull   := tbInfo.struct[I].notnull;
          Continue;
        end;

        //change type and also the not null attribute
        if recField[X].sType <> CreateFldType(tbInfo.struct[I].fInfo) then
        begin
          recField[X].iOpType := 2;
          recField[X].sType   := CreateFldType(tbInfo.struct[I].fInfo);

          if recField[X].bNull <> tbInfo.struct[I].notnull then
          begin
            recField[X].iOpType := 4;
            recField[X].bNull   := tbInfo.struct[I].notnull;
          end;
          Continue;
        end;

        //change only not nulla attribute
        if recField[X].bNull <> tbInfo.struct[I].notnull then
        begin
          recField[X].iOpType := 3;
          recField[X].bNull   := tbInfo.struct[I].notnull;
          Continue;
        end;
        // if also in the loop the field is ok
          recField[X].iOpType := 0;
      end;

      qry.Close;

      listField.Clear;
      for X := Low(recField) to High(recField) do
      begin
        case recField[X].iOpType of
            0: Continue;
            1: begin
                listField.Add('ADD ' + recField[X].sField + ' ' + recField[X].sType);

                if recField[X].iDef = -2 then  // avi 12.01.25 (to make default -1 in table OVERRIDE_STEP_PARAMETERS/PDO_SETUP)
                  listField.Add(' DEFAULT '+ IntToStr(-1))

                else if recField[X].iDef > -1 then
                  listField.Add(' DEFAULT '+ IntToStr(recField[X].iDef));

                if recField[X].bNull then
                  listField.Add(' NOT NULL');

             //   ListField.Add(',');
               end;
            2: listField.Add('ALTER COLUMN ' + recField[X].sField + ' SET DATA TYPE ' + recField[X].sType + ' ');
            3: begin
                 SysFld.Close;
                 SysFld.SQL.Clear;
                 SysFld.SQL.Add(' ALTER TABLE ' + tbInfo.HostName);
                 if recField[X].bNull then
                   SysFld.SQL.Add('ALTER COLUMN ' + recField[X].sField + ' SET NOT NULL')
                 else
                   SysFld.SQL.Add('ALTER COLUMN ' + recField[X].sField + ' DROP NOT NULL');
                 SysFld.ExecSQL;
              //   SysFld.Connection.Commit;
               end;
            4: begin
                 SysFld.Close;
                 SysFld.SQL.Clear;
                 SysFld.SQL.Add(' ALTER TABLE ' + tbInfo.HostName);
                 if recField[X].bNull then
                   SysFld.SQL.Add('ALTER COLUMN ' + recField[X].sField + ' SET NOT NULL')
                 else
                   SysFld.SQL.Add('ALTER COLUMN ' + recField[X].sField + ' DROP NOT NULL');
                 SysFld.ExecSQL;
              //   SysFld.Connection.Commit;
               end;
            5: listField.Add('DROP column "' + recField[X].sField + '",');
          -99: Break;
        end;
      end;

      sysIdx.Close;
      sysIdx.SQL.Clear;
      sysIdx.SQL.Add(' select * from SYSCAT.INDEXES where tabname = ''' + UpperCase(tbInfo.GetTableName) +''''
        + ' and tabschema = ' +QuotedStr(DMib.m_MainDB.CurrentSchema));
      sysIdx.Open;

      ColNames := '';
      if not sysIdx.Eof then
        ColNames := sysIdx.FieldByName('COLNAMES').AsString;

      ColNamesStrList.Clear;
      TmpStr := '';

      I := 0;
      J := 0;

      if Length(ColNames) > 1 then
      begin
        while ColNames[J] <> '+' do
        begin
          Inc(J);
        end;


        for I := J to Length(ColNames) do
        begin
          if (ColNames[I] = '+') then
          begin
            if (TmpStr <> '') then
            begin
              ColNamesStrList.Add(TmpStr);
              TmpStr := '';
            end
            else
              continue;
          end;

          if (ColNames[I] <> '+') then
          begin
            TmpStr := TmpStr + ColNames[I];
            if I = Length(ColNames) then
            begin
              ColNamesStrList.Add(TmpStr);
              TmpStr := '';
            end
            else
              continue;
          end
          else
          begin
            if TmpStr <> '' then
              ColNamesStrList.Add(TmpStr)
          end;
        end;

      end;


      if listField.Count > 0 then
      begin
        lbStep.Caption := 'ALTER TABLE ' + tbinfo.GetTableName;
        Application.ProcessMessages;

        qry.Close;
        qry.SQL.Clear;
        qry.SQL.Add('ALTER TABLE ' + tbinfo.GetTableName ) ;

        qry.SQL.AddStrings(listField);

        sKey := qry.SQL.Strings[qry.SQL.Count-1];
        if sKey[length(sKey)] = ',' then
        begin
          sKey[length(sKey)] := ' ';
          qry.SQL.Delete(qry.SQL.Count-1);
          qry.SQL.Add(sKey);
        end;

        try
          qry.ExecSQL;
        except
          ShowMessage(tbinfo.GetTableName);
        end;
        qry.Close;

        qry.SQL.Clear;
        TmpStr := 'reorg Table ' + tbInfo.GetTableName;
        qry.SQL.Add('Call Sysproc.admin_cmd ( ' + quotedstr(TmpStr)  + ')'  );

        try
          qry.ExecSQL;
        except
        end;

        qry.Close;

        qry.Connection.Commit;

        sysIdx.Close;
        sysIdx.Open;

        lbStep.Caption := '';
        Application.ProcessMessages;
      end;

      //Find primaty key for all db
      J := 0;
      Z := 0;
      bFound := False;
      sFldKey := '';

      if ColNamesStrList.count > 0 then
      begin

        for I := 0 to tbInfo.nrfld - 1 do
        begin
          if tbInfo.struct[I].nrkey = 1 then
          begin
            sKey := CreatePfxFld(tbInfo.struct[I].fInfo);
            sFldKey := sFldKey + sKey + ',';
            if J >= ColNamesStrList.count then
              bFound :=True
            else
             if sKey <> ColNamesStrList.Strings[J] then
               bFound :=True;

            inc(J);
          //  sysIdx.Next;
            inc(Z);
          end;
        end;

      end;

    //  if Z <> sysIdx.RecordCount then
      if z <> ColNamesStrList.count then
      begin
        bFound :=True;
       // Z := sysIdx.RecordCount;
      end;

      qry.Close;

      if (sFldKey <> '') and bFound then
      begin
        sFldKey[length(sFldKey)] := ' ' ;

        if Z > 0 then
        begin
          qry.SQL.Clear;
        //  qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' drop CONSTRAINT ');
        //  qry.SQL.Add(sysIdx.FieldByName('INDNAME').AsString);
    {      qry.SQL.Add('delete from SYSCAT.INDEXES where tabname = ''' + UpperCase(tbInfo.GetTableName) +'''');
          qry.ExecSQL;
          qry.Close;  }
        end;

        qry.SQL.Clear;
        qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' DROP PRIMARY KEY ');
        try
        qry.ExecSQL;
        except
        //  qry.SQL.Clear;
        end;

        for W := 0 to ColNamesStrList.count - 1 do
        begin
          qry.SQL.Clear;
        //  qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' ALTER COLUMN ' + ColNamesStrList[W] + ' DROP NOT NULL ');
          qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' ALTER COLUMN ' + ColNamesStrList[W] + ' set NOT NULL ');
          qry.ExecSQL;
        end;


        qry.SQL.Clear;
      //  qry.SQL.Add('Reorg TABLE '+ tbInfo.GetTableName);

        TmpStr := 'reorg Table ' + tbInfo.GetTableName;

        qry.SQL.Add('Call Sysproc.admin_cmd ( ' + quotedstr(TmpStr)  + ')'  );

        qry.ExecSQL;

        qry.SQL.Clear;
        qry.SQL.Add('ALTER TABLE '+ tbInfo.GetTableName + ' add ');
        qry.SQL.Add('PRIMARY KEY (' + sFldKey + ')');
        try
          qry.ExecSQL;
        except
        end;
        qry.Close;
      end;

      if iRepeat > 1 then
      begin
        try
          qry.Connection.Commit;

        except
          Showmessage(_('The table ') + tbInfo.GetTableName + _(' cannot be converted! Table will be to re-created'));

          qry.Connection.Rollback;

          qry.Close;
          qry.SQL.Clear;
          qry.SQL.Add('DROP TABLE '+ tbInfo.GetTableName);
          qry.ExecSQL;
          qry.Close;

          qry.Connection.Commit;

          CreateNewTbl(qry, tbInfo, lbStep);

          qry.Connection.Commit;
        end;
      end;
    end;

    sysIdx.Close;

    if iRepeat = 1 then
    begin
      try
        qry.Connection.Commit;
      except
        Showmessage(_('The ARCHIVE table cannot be converted! Function stopped!!!'));
        qry.Connection.Rollback;
        Break;
      end;
    end;

  end;

  qry.Close;
  sysIdx.Close;
  sysFld.Close;

  if iRepeat > 1 then
  begin
    DropTable(qry, listTblDrop, lbStep, Gauge1);
    try
      qry.Connection.Commit;
    except
    end;
  end;

  listTblDrop.Free;
  listField.Free;

  {
  if DBType = Main_DB then
  begin
    DropView(qry, lbStep);
    CreateIndex(qry, lbStep);
    //CreateView(qry, lbStep);
  end;
  }

  Gauge1.Progress :=  100;

  qry.Connection.Commit;

  qry.Free;
  sysIdx.Free;
  sysFld.Free;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.UpdateLocalCal;
var
  qry, QryInsert:        TMqmQuery;
  CalList:    TStringList;
  I : Integer;
  tbInfoCalendar, tbInfoCal :     PTblInfo;
  TmpStr : string;
begin
  CalList := TstringList.Create;
  qry := CreateQuery(Main_DB);
  QryInsert := CreateQuery(Main_DB);
  tbInfoCalendar := @tblInfo[table(tbl_calendar)];
  tbInfoCal := @tblInfo[table(tbl_cal)];

  if IniAppGlobals.DownloadTo = '0' then
  begin
    TmpStr := 'reorg Table ' + tbInfoCalendar.getTableName;
    qry.SQL.Add('Call Sysproc.admin_cmd ( ' + quotedstr(TmpStr)  + ')'  );
    qry.ExecSQL;
  end;

  qry.SQL.Clear;
  qry.SQL.Add('select distinct ' + CreateFld(tbInfoCalendar.pfx, fli_CalCod) +  ' from ' + tbInfoCalendar.getTableName + WHERE_IDF_Condition(CreateFld(tbInfoCalendar.pfx, fli_IDENTIFIER)));
  qry.Open;
  while not qry.eof do
  begin
    CalList.add(qry.FieldByName(CreateFld(tbInfoCalendar.pfx, fli_CalCod)).AsString);
    qry.Next
  end;

  for I := 0 to CalList.Count - 1 do
  begin
    qry.SQL.Clear;
    qry.SQL.Add('select ' + CreateFld(tbInfoCal.pfx, fli_CalCod) + ' from ' + tbInfoCal.getTableName + ' where ' +  CreateFld(tbInfoCal.pfx, fli_CalCod) + ' = ' + QuotedStr(CalList.Strings[I]));
    qry.Open;
    if qry.Eof then
    begin
      QryInsert.SQL.Text := 'INSERT INTO ' + tbInfoCal.getTableName + ' ( ' + CreateFld(tbInfoCal.pfx, fli_IDENTIFIER) + ' , ' + CreateFld(tbInfoCal.pfx, fli_CalCod) + ' , ' + CreateFld(tbInfoCal.pfx, fli_SDescr) + ' , ' + CreateFld(tbInfoCal.pfx, fli_EfficiencyOnWcOrResLevel) + ') VALUES (' +
                  IniAppGlobals.Identifier + ', ' +
                  QuotedStr(CalList.Strings[I]) + ', ' +
                  QuotedStr(CalList.Strings[I]) + ', ' +
                  QuotedStr('0') + ')';
      QryInsert.ExecSQL;
    end;
  end;

  qry.Close;
  qry.Connection.commit;
  QryInsert.Free;
  Qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.DropTable(qry: TMqmQuery; listTable:TStrings; lbText:TLabel;
                                  progbar: TGauge);
var
  I : integer;
begin

  {$ifdef WEBSERVICE}
    Exit;
  {$endif}

  if listTable.Count <= 0 then Exit;

  progbar.ForeColor := $000080FF; //orange);
  progbar.MaxValue := listTable.Count;
  progbar.Progress := 0;
  for I := 0 to listTable.Count - 1 do
  begin
    lbText.Caption := 'drop table ' + listTable[I];
    Application.ProcessMessages;
    qry.SQL.Clear;
    qry.SQL.Add('drop table '+listTable[I]);
    try
      qry.ExecSQL;
    except
    end;
    qry.Close;
    progbar.Progress := Gauge1.Progress + 1;
  end;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.DropView(qry: TMqmQuery ; lbText:TLabel);
var
  HdrView : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    HdrView := TableHdrView
  else
    HdrView := 'SCDM_' + TableHdrView;

  if assigned(lbText) then
    lbText.Caption := 'drop View ' + HdrView;

  Application.ProcessMessages;
  qry.SQL.Clear;
  try
    qry.SQL.Add('drop View ' + HdrView);
    qry.ExecSQL;
  except
  end;;
  qry.Close;
end;

//----------------------------------------------------------------------------//

procedure TCreateTables.CreateIndex(qry: TMqmQuery ; lbText:TLabel);
var
  tbInfo : ^TTblInfo;
begin
//  try


 // Qry.Transaction := CreateTransaction(Main_DB);
 // Qry.Transaction.StartTransaction;

    tbInfo := @tblInfo[table(tbl_prod_reqhdr)];
    lbText.Caption := 'Create Index ' + tbinfo.GetTableName + 'SRVCODE';
    qry.SQL.Clear;

    try
      qry.SQL.Add('Drop Index ' + tbInfo.GetTableName + 'SRVCODE');
      qry.ExecSQL;
    except
    end;

    qry.SQL.Clear;
    qry.SQL.Add('Create Index ' + '"' + tbInfo.GetTableName + 'SRVCODE' + '"' + ' ON' + '"' + tbInfo.GetTableName + '"' +
         '(' + '"' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + '"' + ' ,' +
         '"' + CreateFld(tbInfo.pfx, fli_Serving_Code) + '"' +')');
    try
      qry.ExecSQL;
    except
    end;
    //

    tbInfo := @tblInfo[table(tbl_balance_detail)];
    lbText.Caption := 'Create Index ' + tbinfo.GetTableName;
    qry.SQL.Clear;

    try
      qry.SQL.Add('Drop Index ' + tbInfo.GetTableName);
      qry.ExecSQL;
    except
    end;

    qry.SQL.Clear;
    qry.SQL.Add('Create Index ' + '"' + tbInfo.GetTableName + '"' + ' ON' + '"' + tbInfo.GetTableName + '"' +
         '(' + '"' + CreateFld(tbInfo.pfx, fli_ProdType) + '"' + ' ,' +
         '"' + CreateFld(tbInfo.pfx, fli_ProdCode) + '"' + ',' +
         '"' + CreateFld(tbInfo.pfx, fli_netGroupCode) + '"' + ',' +
         '"' + CreateFld(tbInfo.pfx, fli_occupyCode) + '"' + ',' +
         '"' + CreateFld(tbInfo.pfx, fli_DueDate) + '"' + ')');
    try
      qry.ExecSQL;
    except
    end;

    tbInfo := @tblInfo[table(tbl_balance_header)];
    lbText.Caption := 'Create Index ' + tbinfo.GetTableName;
    qry.SQL.Clear;

    try
      qry.SQL.Add('Drop Index ' + tbInfo.GetTableName);
      qry.ExecSQL;
    except
    end;

    qry.SQL.Clear;

    qry.SQL.Add('Create Index ' + '"' + tbInfo.GetTableName + '"' + ' ON' + '"' + tbInfo.GetTableName + '"' +
         '(' + '"' + CreateFld(tbInfo.pfx, fli_ProdType) + '"' + ' ,' +
         '"' + CreateFld(tbInfo.pfx, fli_ProdCode) + '"' + ',' +
         '"' + CreateFld(tbInfo.pfx, fli_netGroupCode) + '"' + ',' +
         '"' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + '"' + ',' +
         '"' + CreateFld(tbInfo.pfx, fli_DueDate) + '"' + ')');

    try
      qry.ExecSQL;
    except
    end;

    tbInfo := @tblInfo[table(tbl_material)];
    lbText.Caption := 'Create Index ' + tbinfo.GetTableName;
    qry.SQL.Clear;

    try
      qry.SQL.Add('Drop Index ' + tbInfo.GetTableName);
      qry.ExecSQL;
    except
    end;

    qry.SQL.Clear;
    qry.SQL.Add('Create Index ' + '"' + tbInfo.GetTableName + '"' + ' ON' + '"' + tbInfo.GetTableName + '"' +
         '(' + '"' + CreateFld(tbInfo.pfx, fli_ProdType) + '"' + ' ,' +
         '"' + CreateFld(tbInfo.pfx, fli_ProdCode) + '"' + ')');
    try
      qry.ExecSQL;
    except
    end;

    lbText.Caption := 'Create Index ' + tbinfo.GetTableName + 'BYREQ';
    qry.SQL.Clear;

    try
      qry.SQL.Add('Drop Index ' + tbInfo.GetTableName + 'BYREQ');
      qry.ExecSQL;
    except
    end;

    qry.SQL.Clear;
    qry.SQL.Add('Create Index ' + '"' + tbInfo.GetTableName + 'BYREQ' + '"' + ' ON' + '"' + tbInfo.GetTableName + '"' +
         '(' + '"' + CreateFld(tbInfo.pfx, fli_preqNo) + '"' + ' ,' +
         '"' + CreateFld(tbInfo.pfx, fli_pstepId) + '"' + ')');

    try
      qry.ExecSQL;
    except
    end;

    qry.Connection.Commit;
  //  Qry.Transaction.commit;
//  except
//  end;

  qry.Close;
end;

//----------------------------------------------------------------------------//

procedure TCreateTables.CreateView(qry: TMqmQuery ; lbText:TLabel);
var
  HdrView : string;
  tbInfoRqdr, tbInfoPrArt : ^TTblInfo;
begin
  tbInfoRqdr := @tblInfo[table(tbl_prod_reqHdr)];
  tbInfoPrArt := @tblInfo[table(tbl_produced_article)];

  if IniAppGlobals.DownloadTo = '2' then
    HdrView := TableHdrView
  else
    HdrView := 'SCDM_' + TableHdrView;

  if assigned(lbText) then
    lbText.Caption := 'Create View ' + HdrView;

  qry.SQL.Clear;

  qry.SQL.Add('CREATE VIEW ' + HdrView + ' AS SELECT PH_IDENTIFIER, PH_TYPE_PROD, PA_PRODUCT_CODE FROM ');

  qry.SQL.Add(tbInfoRqdr.GetTableName + ' ,  ' + tbInfoPrArt.GetTableName + ' WHERE PH_PREQ_NO = PA_PREQ_NO AND PH_IDENTIFIER = PA_IDENTIFIER');
//  qry.SQL.Add('PROD_REQHDR, PRODUCED_ARTICLE WHERE PH_PREQ_NO = PA_PREQ_NO');

  qry.ExecSQL;
end;

//----------------------------------------------------------------------------//

procedure TCreateTables.CreateMQM_Cfg_Tables;
var
  qry:        TMqmQuery;
  listTables: TStrings;
  tbInfo:     PTblInfo;//^TTblInfo;
  vProgBar:   Variant;
  ttbl   :    table;
begin
  listTables := TstringList.Create;
  DropAllCfgStoredProc;

  qry := CreateQuery(Cfg_DB);

//  GetMqmDb(Cfg_DB).GetTableNames(listTables, False);

  for ttbl := Low(table) to High(table) do
  begin
    tbInfo := @tblInfo[table(ttbl)];
    if (tbInfo.group = 1) then continue;
    listTables.Add(tbInfo.GetTableName);
  end;

//  tbInfo := @tblInfo[tbl_Licence];
//  listTables.Add(tbInfo.GetLicTableName(true));

//  tbInfo := @tblInfo[tbl_Licence2];
//  listTables.Add(tbInfo.GetLicTableName(true));

  lbStep.Caption := '';
  lbStep.Visible := True;
  Application.ProcessMessages;

  DropTable(qry, listTables, lbStep, Gauge1);

  qry.connection.Commit;

// ----------------------------------------------------------------------------------------------

  if IniAppGlobals.DownloadTo = '2' then
  begin

    qry.SQL.Clear;
    qry.SQL.Add('DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = ''UPD_GEN'';');
    qry.ExecSQL;
    qry.Close;
    qry.SQL.Clear;

    // ----------------------------------------------------------------------------------------------

    qry.SQL.Add('CREATE GENERATOR UPD_GEN');
    qry.ExecSQL;
    qry.Close;

  end;

// ----------------------------------------------------------------------------------------------

  vProgBar := High(tblInfo);

  Gauge1.ForeColor := clHighlight;
  Gauge1.Visible := True;
  Gauge1.MaxValue := vProgBar;

  Gauge1.Progress := 0;
  for ttbl := Low(table) to High(table) do
  begin
    tbInfo := @tblInfo[table(ttbl)];
    if (tbInfo.group = 1) then
      Continue; //exclude main table;

    SetFldPfx(tbInfo.pfx);

    CreateNewTbl(qry, tbInfo, lbStep);

    Gauge1.Progress := Gauge1.Progress + 1;
  end;

{  tbInfo := @tblInfo[tbl_Licence];
  SetFldPfx(tbInfo.pfx);
  CreateNewTblLic(True, qry, tbInfo, lbStep);

  tbInfo := @tblInfo[tbl_Licence2];
  SetFldPfx(tbInfo.pfx);
  CreateNewTblLic(True, qry, tbInfo, lbStep);  }

//  qry.connection.Commit;

 // tbInfo := @tblInfo[tbl_cfg_exchg_glob];
 // qry.SQL.Clear;

 // qry.SQL.Add(' INSERT INTO ' + tbInfo.GetTableName + '( CEG_LAST_UPD,CEG_SL_OP,CEG_SL_ON) values (' + '0' + ', ' + '0' + ' ,' + '0' + ')');

{  qry.SQL.Add('insert into ' +  tbInfo.GetTableName + '(');
  qry.SQL.Add('CEG_LAST_UPD,');
  qry.SQL.Add('CEG_SL_OP,');
  qry.SQL.Add('CEG_SL_ON');
  qry.SQL.Add(') values (');
  qry.SQL.Add('0,');
  qry.SQL.Add('''0''');
  qry.SQL.Add(',');
  qry.SQL.Add('''0''');
//  qry.SQL.Add('0');
  qry.SQL.Add(');');           }

//  qry.ExecSQL;
  qry.Close;

  qry.connection.Commit;

  Gauge1.Progress :=  100;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.CreateMQM_Main_Tables;
var
  qry:        TMqmQuery;
  listTables: TStrings;
  tbInfo:     PTblInfo;//^TTblInfo;
  vProgBar:   Variant;
  ttbl   :    table;
begin
  listTables := TstringList.Create;
  DropAllMainStoredProc;

  qry := CreateQuery(Main_DB);

//  qry.Transaction.StartTransaction;

//  GetMqmDb(Main_DB).GetTableNames(listTables, False);

  for ttbl := Low(table) to High(table) do
  begin
    tbInfo := @tblInfo[table(ttbl)];
    if (tbInfo.group = 2) then continue;
    listTables.Add(tbInfo.GetTableName);
  end;

  tbInfo := @tblInfo[tbl_Licence];
  listTables.Add(tbInfo.GetLicTableName(false));

  tbInfo := @tblInfo[tbl_Licence2];
  listTables.Add(tbInfo.GetLicTableName(false));

  Gauge1.Progress := 0;

  lbStep.Caption := '';
  lbStep.Visible := True;
  Application.ProcessMessages;

  DropView(qry, lbStep);
  DropTable(qry, listTables, lbStep, Gauge1);
  qry.connection.Commit;

  lbStep.Caption := '';
  Application.ProcessMessages;

  vProgBar := High(tblInfo);

  Gauge1.ForeColor := clHighlight;
  Gauge1.Visible := True;

  Gauge1.MaxValue := vProgBar;
  Gauge1.Progress := 0;
  for ttbl := Low(table) to High(table) do
  begin
    tbInfo := @tblInfo[table(ttbl)];
    if (tbInfo.group = 2) then
      Continue; //exclude cfg table

    SetFldPfx(tbInfo.pfx);

    CreateNewTbl(qry, tbInfo, lbStep);

    Gauge1.Progress := Gauge1.Progress + 1;
  end;

{  tbInfo := @tblInfo[tbl_Licence];
  SetFldPfx(tbInfo.pfx);
  CreateNewTblLic(false, qry, tbInfo, lbStep);

  tbInfo := @tblInfo[tbl_Licence2];
  SetFldPfx(tbInfo.pfx);
  CreateNewTblLic(false, qry, tbInfo, lbStep);   }

  CreateIndex(qry, lbStep);
  CreateView(qry, lbStep);

  CheckFilters;

  if IniAppGlobals.DownloadTo = '2' then
  begin

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = ''GRP_GEN'';');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('CREATE GENERATOR GRP_GEN');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = ''CAP_RES_GEN'';');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('CREATE GENERATOR CAP_RES_GEN');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = ''SPLIT_FAMILY_CODE'';');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('CREATE GENERATOR SPLIT_FAMILY_CODE');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = ''NEW_REQ_NO'';');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

    qry.SQL.Clear;
    qry.SQL.Add('CREATE GENERATOR NEW_REQ_NO');
    qry.ExecSQL;
    qry.Close;
    Gauge1.Progress := Gauge1.Progress + 1;

  // ----------------------------------------------------------------------------------------------

  end;

  Gauge1.Progress := 100;
  qry.Connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.CrtMainDBClick(Sender: TObject);
var
  errStr: string;
begin
  Screen.Cursor := crHourGlass;
  Panel1.Enabled := False;
  m_DatabaseCreate := true;

  if MessageDlg(_('This operation will delete all local data. Do you want to continue?'), mtConfirmation,
    [mbyes,mbno],0) = mrYes then
  begin

    if not GetPassword then
    begin
      ModalResult := idAbort;
      Exit;
    end;

    Gauge1.Visible := True;
    Gauge1.Progress := 0;

    if not IsLocalDbConnected then
       LocalDbConnect(false);

    CreateMQM_Main_Tables();
    CreateStoredForMain;

    InsertDefaults;

 {   SaveLicenceMcm(s_licBytesMcm, errStr);
    if SaveLicenceMqm(s_licBytes, errStr) then
    begin
      Showmessage(_('Configuration database creation completed'));
      Gauge1.Visible := False;
      lbStep.Visible := False;
    end
    else
      Showmessage(errStr);   }

    Showmessage(_('Main database creation completed'));
    Gauge1.Visible := False;
    lbStep.Visible := False;

  end;


  Panel1.Enabled := True;
  Screen.Cursor := crDefault;
end;

//----------------------------------------------------------------------------//

procedure TCreateTables.CrtCfgDBClick(Sender: TObject);
var
  errStr: string;
begin
  Screen.Cursor := crHourGlass;
  Panel1.Enabled := False;
  m_DatabaseCreate := true;

  if MessageDlg(_('This operation will delete all local data. Do you want to continue?'), mtConfirmation,
    [mbyes,mbno],0) = mrYes then
  begin

    if not GetPassword then
    begin
      ModalResult := idAbort;
      Exit;
    end;

    Gauge1.Visible := True;
    Gauge1.Progress := 0;

    if not IsLocalDbConnected then
       LocalDbConnect(false);

    CreateMQM_Cfg_Tables;
    CreateStoredForCfg;

    InsertDefaultValues;
   // SaveLicenceMcm(true, s_licBytesMcm, errStr);
   // if SaveLicenceMqm(true, s_licBytes, errStr) then
   // begin
    Showmessage(_('Configuration database creation completed'));
      Gauge1.Visible := False;
      lbStep.Visible := False;
  //  end
  //  else
  //    Showmessage(errStr);
  //  Showmessage(_('Configuration database creation completed'));
  end;

  Panel1.Enabled := True;
  Screen.Cursor := crDefault;
end;

//----------------------------------------------------------------------------//

procedure TCreateTables.UpdMainDBClick(Sender: TObject);
var
  errStr: string;

begin
  Screen.Cursor := crHourGlass;
  Panel1.Enabled := False;

  if MessageDlg(_('This operation will update all local data. Do you want to continue?'), mtConfirmation,
    [mbyes,mbno],0) = mrYes then
  begin

    if not GetPassword then
    begin
      ModalResult := idAbort;
      Exit;
    end;

    Gauge1.Visible := True;
    Gauge1.Progress := 0;

    if not IsLocalDbConnected then
      LocalDbConnect(false);

    if IniAppGlobals.DownloadTo = '2' then
      UpdateDB_Interbase(Main_DB)
    else if IniAppGlobals.DownloadTo = '1' then
      UpdateDB_Oracle(Main_DB)
    else if IniAppGlobals.DownloadTo = '0' then
      UpdateDB_DB2(Main_DB);

    CreateStoredForMain;
  	UpdateLocalCal;
    Application.ProcessMessages;
    lbStep.Caption := 'Creating Filters';
    Application.ProcessMessages;
    CheckFilters;
    SaveLicenceMcm(s_licBytesMcm, errStr);
    if SaveLicenceMqm(s_licBytes, errStr) then
    begin
      Gauge1.Visible := False;
      lbStep.Visible := False;
      Showmessage(_('Main database update completed'));
    end
    else
      Showmessage(errStr);

    Gauge1.Visible := False;
    lbStep.Visible := False;
  //  Showmessage(_('Main database update completed'));
  end;

  Panel1.Enabled := True;
  Screen.Cursor := crDefault;
end;

Procedure TCreateTables.InsertColumns(cTable : String);
var a : Integer;
    dssFilCol: TFDQuery;
    IBTables,dsColumns : TFDQuery;
begin

  dsColumns := TFDQuery.Create(nil);
  dsColumns.Connection := DMib.m_MainDB;

  if IniAppGlobals.DownloadTo = '2' then   // If local is IB
  begin
    dsColumns.Close;
    dsColumns.SQL.Text := 'select r.rdb$Relation_ID as "ID_Table", f.rdb$field_name as "Column"'
      + ' from rdb$relation_fields f '
      + ' join rdb$relations r on f.rdb$relation_name = r.rdb$relation_name  '
      + ' and r.rdb$view_blr is null '
      + ' and (r.rdb$system_flag is null or r.rdb$system_flag = 0)  '
      + ' where f.rdb$relation_name = '+ QuotedStr(Trim(cTable))
      + ' order by 1, f.rdb$field_position;';
    dsColumns.Open;

    while not dsColumns.Eof  do
    begin
      a := DMib.m_MainDB.ExecSQLScalar('select count(*) from Filters_Col where ID_Table =' + QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString))
        +' and cColumn = ' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
        +' and IDENTIFIER = ' + IniAppGlobals.Identifier);

      if a = 0 then
      begin
        if AnsiRightStr(dsColumns.FieldByName('Column').asString,10) = 'IDENTIFIER' then
        begin
          DMib.m_MainDB.ExecSQL('Insert into Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
          +' Values('+ QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString)) + ',' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
          + ',0, ' +IniAppGlobals.Identifier+ ')') ;

          DMib.m_MainDB.ExecSQL('Update FILTERS set cSQL =' + QuotedStr('Select * from ' + cTable + ' Where '
            + dsColumns.FieldByName('Column').asString + '=' + QuotedStr(IniAppGlobals.Identifier))
            + ' where cTable = '+QuotedStr(cTable) + ' and IDENTIFIER = '+IniAppGlobals.Identifier );
        end else
          DMib.m_MainDB.ExecSQL('Insert into Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
          +' Values('+ QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString)) + ',' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
          + ',1, ' +IniAppGlobals.Identifier+')');
      end;


      dsColumns.Next;
    end;

    dsColumns.Free;

  //  dssFilCol.Refresh;
  end;

  if IniAppGlobals.DownloadTo = '1' then   // If local is Oracle
  begin
    var schema := ReplaceStr(DMib.m_MainDB.CurrentSchema, '"', '');

    dsColumns.Close;
    dsColumns.SQL.Text := 'Select distinct o.object_ID as "ID_Table",ca.column_name as "Column" '
                          + ' from SYS.USER_TAB_COLUMNS ca '
                          +'  inner join ALL_OBJECTS o on ca.table_name = o.object_name '
                          +' where ca.table_name = '+ QuotedStr(Trim(cTable))
                          + ' AND OWNER = ' + QuotedStr(schema);
    dsColumns.Open;

    while not dsColumns.Eof  do
    begin
      a := DMib.m_MainDB.ExecSQLScalar('select count(*) from SCDM_Filters_Col where ID_Table =' + QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString))
        +' and cColumn = ' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
        +' and Identifier = ' + IniAppGlobals.Identifier);

      if a = 0 then
      begin
        if AnsiRightStr(dsColumns.FieldByName('Column').asString,10) = 'IDENTIFIER' then
        begin
          DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
            +' Values('+ QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString)) + ',' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
            + ',0, '+IniAppGlobals.Identifier+')');

          DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS set cSQL =' + QuotedStr('Select * from ' + cTable + ' Where '
            + dsColumns.FieldByName('Column').asString + '=' + QuotedStr(IniAppGlobals.Identifier))
            + ' where cTable = '+QuotedStr(cTable) + ' and Identifier = ' +IniAppGlobals.Identifier);
        end  else
          DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
          +' Values('+ QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString)) + ',' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
          + ',1, '+IniAppGlobals.Identifier +')');

      end;

      dsColumns.Next;
    end;

    dsColumns.Free;
  //  dssFilCol.Refresh;

  end;

  if IniAppGlobals.DownloadTo = '0' then   // If local is DB2
  begin
    dsColumns.Close;
    dsColumns.SQL.Text := 'select distinct t.tableID as "ID_Table",c.colname as "Column" '
                          +' from syscat.tables t'
	                        +' inner join syscat.columns c on t.tabname = c.tabname'
                          +' where t.tabname = '+ QuotedStr(Trim(cTable))
                          +' AND t.TABSCHEMA = ' + QuotedStr(DMib.m_MainDB.CurrentSchema);
    dsColumns.Open;

    while not dsColumns.Eof  do
    begin
      a := DMib.m_MainDB.ExecSQLScalar('select count(*) from SCDM_Filters_Col where ID_Table =' + QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString))
      +' and cColumn = ' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
      +' and Identifier = '+IniAppGlobals.Identifier);

      if a = 0 then
      begin
        if AnsiRightStr(dsColumns.FieldByName('Column').asString,10) = 'IDENTIFIER' then
        begin
          DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
            +' Values('+ QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString)) + ',' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
            + ',0, '+IniAppGlobals.Identifier+')');

          DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS set cSQL =' + QuotedStr('Select * from ' + cTable + ' Where '
            + dsColumns.FieldByName('Column').asString + '=' + QuotedStr(IniAppGlobals.Identifier))
            + ' where cTable = '+QuotedStr(cTable) +' and Identifier = '+IniAppGlobals.Identifier );

       end else
          DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
          +' Values('+ QuotedStr(TRIM(dsColumns.FieldByName('ID_Table').asString)) + ',' + QuotedStr(TRIM(dsColumns.FieldByName('Column').asString))
          + ',1, '+IniAppGlobals.Identifier+')');
      end;


      dsColumns.Next;
    end;

    dsColumns.Free;
  //  dssFilCol.Refresh;

  end;
end;

procedure TCreateTables.InsertDefaults;
var _ds : TFDQuery;
i,y : Integer;
begin

  _ds := TFDQuery.Create(nil);
  _ds.Connection := DMib.m_MainDB;

  for i := 0 to 50 do
  begin
    with _ds do
    begin
      for y := 0 to 3 do
      begin
        SQL.Clear;

        if IniAppGlobals.downloadTo = '2' then
          sql.add('Insert into GENERATE_NUM(GN_GENCODE, GN_GENNUMBER, GN_IDENTIFIER)')
        else
          sql.add('Insert into SCDM_GENERATE_NUM(GN_GENCODE, GN_GENNUMBER, GN_IDENTIFIER)');

        case y of
          0:
            sql.add('values('+ QuotedStr('REQNUMBER') +', ' + '0' +', '+ IntToStr(i) +')');
          1:
            sql.add('values('+ QuotedStr('GROUPNUMBER') +', ' + '0' +', '+ IntToStr(i)+')');
          2:
            sql.add('values('+ QuotedStr('CAPRESNUMBER') +', ' + '0' +', '+ IntToStr(i)+')');
          3:
            sql.add('values('+ QuotedStr('GRPNUMBERMCM') +', ' + '0' +', '+ IntToStr(i)+')');
        end;


        ExecSQL;
      end;
    end;
  end;

end;

Procedure TCreateTables.InsertSettings;
var a : Integer;
    dssFil: TFDQuery;
    dsFil: TDataSource;
    dsFilCol: TDataSource;
    dssFilCol: TFDQuery;
    IBTables,dsColumns : TFDQuery;
begin

  IBTables := TFDQuery.Create(nil);
  IBTables.Connection := DMib.m_MainDB;

  if IniAppGlobals.DownloadTo = '2' then   // If local is IB
  begin
    IBTables.ExecSQL('delete from FILTERS where Identifier = ' + INiappglobals.Identifier);
    IBTables.ExecSQL('delete from FILTERS_COL where Identifier = ' + INiappglobals.Identifier);
    IBTables.Close;
    IBTables.SQL.Text := 'select r.rdb$Relation_ID as "ID", r.rdb$relation_name as Name, f.rdb$field_name as "cColumn" '
      + '  from rdb$relation_fields f '
      +' join rdb$relations r on f.rdb$relation_name = r.rdb$relation_name and r.rdb$view_blr is null'
      +' and (r.rdb$system_flag is null or r.rdb$system_flag = 0)'
      +' order by r.rdb$relation_name, f.rdb$field_position;';
    IBTables.Open;

    while not IBTables.Eof  do
    begin

     if AnsiRightStr(IBTables.FieldByName('cColumn').AsString,10) = 'IDENTIFIER' then
     begin
        DMib.m_MainDB.ExecSQL('Insert into Filters (ID,cTable,bActive,cSQL,Identifier) '
        +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString))
          + ',' + QuotedStr(TRIM(IBTables.FieldByName('Name').asString))
          + ', 0,'
          + QuotedStr('Select * from ' +TRIM(IBTables.FieldByName('Name').asString) + ' where '+IBTables.FieldByName('cColumn').AsString +' = '+IniAppGlobals.Identifier)+','
          + IniAppGlobals.Identifier+')');

      DMib.m_MainDB.ExecSQL('Insert into Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
            +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString)) + ',' + QuotedStr(TRIM(IBTables.FieldByName('cColumn').asString))
            + ',0, '+IniAppGlobals.Identifier+')');
     end else
     begin
      DMib.m_MainDB.ExecSQL('Insert into Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
          +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString)) + ',' + QuotedStr(TRIM(IBTables.FieldByName('cColumn').asString))
          + ',1, '+IniAppGlobals.Identifier +')');
     end;

      IBTables.Next;
    end;
      IBTables.Free;
  end;

  if IniAppGlobals.DownloadTo = '1' then   // If local is Oracle
  begin
    var schema := ReplaceStr(DMib.m_MainDB.CurrentSchema, '"', '');
    IBTables.ExecSQL('delete from SCDM_FILTERS where Identifier = ' + INiappglobals.Identifier);
    IBTables.ExecSQL('delete from SCDM_FILTERS_COL where Identifier = ' + INiappglobals.Identifier);
    IBTables.Close;
    IBTables.SQL.Text := 'Select distinct Object_ID as ID, OBJECT_name as Name, column_name as cColumn'
      +' from SYS.ALL_OBJECTS a'
      +' inner join SYS.USER_TAB_COLUMNS c on a.object_name  = c.table_name'
          + ' where object_Name like '+'''SCDM%'''+' and object_type = '+'''TABLE'''+' '
          + ' AND OWNER = ' + QuotedStr(schema);

    IBTables.Open;

    while not IBTables.Eof  do
    begin

     if AnsiRightStr(IBTables.FieldByName('cColumn').AsString,10) = 'IDENTIFIER' then
     begin
        DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters (ID,cTable,bActive,cSQL,Identifier) '
        +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString))
          + ',' + QuotedStr(TRIM(IBTables.FieldByName('Name').asString))
          + ', 0,'
          + QuotedStr('Select * from ' +TRIM(IBTables.FieldByName('Name').asString) + ' where '+IBTables.FieldByName('cColumn').AsString +' = '+IniAppGlobals.Identifier)+','
          + IniAppGlobals.Identifier+')');

      DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
            +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString)) + ',' + QuotedStr(TRIM(IBTables.FieldByName('cColumn').asString))
            + ',0, '+IniAppGlobals.Identifier+')');
     end else
     begin
      DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
          +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString)) + ',' + QuotedStr(TRIM(IBTables.FieldByName('cColumn').asString))
          + ',1, '+IniAppGlobals.Identifier +')');
     end;

      IBTables.Next;
    end;
      IBTables.Free;
  end;

  if IniAppGlobals.DownloadTo = '0' then   // If local is DB2
  begin
    IBTables.ExecSQL('delete from SCDM_FILTERS where Identifier = ' + INiappglobals.Identifier);
    IBTables.ExecSQL('delete from SCDM_FILTERS_COL where Identifier = ' + INiappglobals.Identifier);
    IBTables.Close;
    IBTables.SQL.Text := 'select distinct tableID as ID, t.tabname as Name, colname as cColumn '
      +' from syscat.tables t '
      +' inner join syscat.columns c on t.tabname = c.tabname'
                      + ' where t.tabname like '+'''SCDM%'''+' and type = '+'''T'''
                      + ' AND t.TABSCHEMA = ' + QuotedStr(DMib.m_MainDB.CurrentSchema);
    IBTables.Open;

    while not IBTables.Eof  do
    begin

     if AnsiRightStr(IBTables.FieldByName('cColumn').AsString,10) = 'IDENTIFIER' then
     begin
        DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters (ID,cTable,bActive,cSQL,Identifier) '
        +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString))
          + ',' + QuotedStr(TRIM(IBTables.FieldByName('Name').asString))
          + ', 0,'
          + QuotedStr('Select * from ' +TRIM(IBTables.FieldByName('Name').asString) + ' where '+IBTables.FieldByName('cColumn').AsString +' = '+IniAppGlobals.Identifier)+','
          + IniAppGlobals.Identifier+')');

      DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
            +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString)) + ',' + QuotedStr(TRIM(IBTables.FieldByName('cColumn').asString))
            + ',0, '+IniAppGlobals.Identifier+')');
     end else
     begin
      DMib.m_MainDB.ExecSQL('Insert into SCDM_Filters_Col (ID_Table,cColumn,bVIsible,Identifier) '
          +' Values('+ QuotedStr(TRIM(IBTables.FieldByName('ID').asString)) + ',' + QuotedStr(TRIM(IBTables.FieldByName('cColumn').asString))
          + ',1, '+IniAppGlobals.Identifier +')');
     end;

      IBTables.Next;
    end;

      IBTables.Free;
  end;

//  dssFil.refresh;
 // dssFilCol.refresh;

end;

procedure TCreateTables.CheckFilters;
begin

  InsertSettings;

  if IniAppGlobals.DownloadTo = '2' then   // If local is IB
  begin

    //Update Caption for Forms
      // GENERAL
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Product types'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ARTICLE_TYPE'' ' );
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Unit of measure'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''UNIT'' ' );
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Calendar'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''CAL'' ' );
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Production demand template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PRODUCTIONDEMANDTEMPLATE'' ' );
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Production times level'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PRODUCTION_TIMES_LEVEL'' ' );
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Production times'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PRODUCTION_TIMES'' ' );
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Production Progress Template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PRODUCTIONPROGRESSTEMPLATE'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Logical warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''LOGICALWAREHOUSE'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Production demand counter'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PRODUCTIONDEMANDCOUNTER'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Item type template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEMTYPETEMPLATE'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Learning curve'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''LEARNING_CURVE'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Item stock'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEM_STOCK'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Items stock changes'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEMSSTOCKCHANGES'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Items Stock Exception'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEMSSTOCKEXCEPTIONS'' ');

      //Environment
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Items stock'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEMSSTOCK'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1, cCaption = ''Work station'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''WKST'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Work stations work centers'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''WKS_WKC''');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Work center'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''WKC'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PROC'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Work center process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''WKC_PROC'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Resources'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''RES'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Resource category'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''RESCAT'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Work center category'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''WKC_CATEGORY'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Alternative work center and process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ALT_WKC'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Subresources'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''RES_SUB'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Alternative warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ALTERNATIVEWAREHOUSE'' ');

      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Items Stock Exception'', cSQL = '+ QuotedStr('Select * from ITEMSSTOCKEXCEPTIONS where ITE_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+'  where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEMSSTOCKEXCEPTIONS'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Items stock changes'', cSQL = '+QuotedStr('Select * from ITEMSSTOCKCHANGES where ITC_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEMSSTOCKCHANGES'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Work center category definition by date'', cSQL = '+QuotedStr('Select * from CATEGORY_DATES_INFO where CD_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''CATEGORY_DATES_INFO'' ');

      //Properties
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Item type logical warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''ITEMTYPELOGICALWAREHOUSE'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Properties'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PROP'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Resource properties'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PROP_RES'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Property retrieve value'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''PROPERTY_RTV_VALUE'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Resource to occupation compatibility rules'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''RULE_RES_TO_OCC'' ');

      //Materials
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Occupation to occupation compatibility rules'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''RULE_OCC_TO_OCC'' ');

      // Priorities and dependencies
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Material Supply Header'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''MATERIAL_SUP_HEADER'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Work center priority'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''WKC_PRIORITY'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Material Tolerance Types'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''MATERIAL_TOLERANCE_TYPE'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Work center dependency'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''WKC_DEPENDENCY'' ');
      DMib.m_MainDB.ExecSQL('Update FILTERS  Set bActive = 1,  cCaption = ''Material Supply Detail'', cSQL = '+QuotedStr('Select * from MATERIAL_SUP_DETAIL where MD_IDENTIFIER = ' + QuotedStr(IniAppGlobals.Identifier)) + ' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''MATERIAL_SUP_DETAIL'' ');

  end;

  if IniAppGlobals.DownloadTo = '1' then   // If local is Oracle
  begin

    //Update Caption for Forms
      // GENERAL
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Product types'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ARTICLE_TYPE'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Unit of measure'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_UNIT'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Calendar'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_CAL'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production demand template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTIONDEMANDTEMPLATE'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production times level'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTION_TIMES_LEVEL'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production times'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTION_TIMES'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production Progress Template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTIONPRGRESTEMPLATE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Logical warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_LOGICALWAREHOUSE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production demand counter'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTIONDEMANDCOUNTER'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Item type template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMTYPETEMPLATE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Learning curve'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_LEARNING_CURVE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Item stock'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEM_STOCK'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Items stock changes'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKCHANGES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Items Stock Exception'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKEXCEPTIONS'' ');

      //Environment
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Items stock'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCK'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Work station'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKST'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work stations work centers'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKS_WKC''');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_PROC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resources'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resource category'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RESCAT'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center category'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_CATEGORY'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Alternative work center and process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ALT_WKC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Subresources'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RES_SUB'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Alternative warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ALTERNATIVEWAREHOUSE'' ');

      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Items Stock Exception'', cSQL = '+ QuotedStr('Select * from SCDM_ITEMSSTOCKEXCEPTIONS where ITE_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+'  where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKEXCEPTIONS'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Items stock changes'', cSQL = '+QuotedStr('Select * from SCDM_ITEMSSTOCKCHANGES where ITC_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKCHANGES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center category definition by date'', cSQL = '+QuotedStr('Select * from SCDM_CATEGORY_DATES_INFO where CD_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_CATEGORY_DATES_INFO'' ');


      //Properties
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Item type logical warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMTYPELOGICALWAREHOUSE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Properties'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROP'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resource properties'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROP_RES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Property retrieve value'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROPERTY_RTV_VALUE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resource to occupation compatibility rules'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RULE_RES_TO_OCC'' ');

      //Materials
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Occupation to occupation compatibility rules'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RULE_OCC_TO_OCC'' ');

      // Priorities and dependencies
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Material Supply Header'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_MATERIAL_SUP_HEADER'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center priority'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_PRIORITY'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Material Tolerance Types'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_MATERIAL_TOLERANCE_TYPE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center dependency'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_DEPENDENCY'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Material Supply Detail'', cSQL = '+QuotedStr('Select * from SCDM_MATERIAL_SUP_DETAIL where MD_IDENTIFIER = ' + QuotedStr(IniAppGlobals.Identifier)) + ' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_MATERIAL_SUP_DETAIL'' ');
   //end;
  end;

  if IniAppGlobals.DownloadTo = '0' then   // If local is DB2
  begin
    //Update Caption for Forms
      // GENERAL
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Product types'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ARTICLE_TYPE'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Unit of measure'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_UNIT'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Calendar'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_CAL'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production demand template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTIONDEMANDTEMPLATE'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production times level'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTION_TIMES_LEVEL'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production times'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTION_TIMES'' ' );
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production Progress Template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTIONPRGRESTEMPLATE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Logical warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_LOGICALWAREHOUSE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Production demand counter'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PRODUCTIONDEMANDCOUNTER'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Item type template'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMTYPETEMPLATE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Learning curve'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_LEARNING_CURVE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Item stock'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEM_STOCK'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Items stock changes'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKCHANGES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Items Stock Exception'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKEXCEPTIONS'' ');

      //Environment
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Items stock'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCK'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1, cCaption = ''Work station'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKST'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work stations work centers'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKS_WKC''');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_PROC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resources'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resource category'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RESCAT'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center category'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_CATEGORY'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Alternative work center and process'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ALT_WKC'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Subresources'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RES_SUB'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Alternative warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ALTERNATIVEWAREHOUSE'' ');

      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Items Stock Exception'', cSQL = '+ QuotedStr('Select * from SCDM_ITEMSSTOCKEXCEPTIONS where ITE_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+'  where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKEXCEPTIONS'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Items stock changes'', cSQL = '+QuotedStr('Select * from SCDM_ITEMSSTOCKCHANGES where ITC_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMSSTOCKCHANGES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center category definition by date'', cSQL = '+QuotedStr('Select * from SCDM_CATEGORY_DATES_INFO where CD_IDENTIFIER = '+QuotedStr(IniAppGlobals.Identifier))+' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_CATEGORY_DATES_INFO'' ');


      //Properties
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Item type logical warehouse'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_ITEMTYPELOGICALWAREHOUSE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Properties'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROP'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resource properties'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROP_RES'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Property retrieve value'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_PROPERTY_RTV_VALUE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Resource to occupation compatibility rules'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RULE_RES_TO_OCC'' ');

      //Materials
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Occupation to occupation compatibility rules'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_RULE_OCC_TO_OCC'' ');

      // Priorities and dependencies
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Material Supply Header'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_MATERIAL_SUP_HEADER'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center priority'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_PRIORITY'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Material Tolerance Types'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_MATERIAL_TOLERANCE_TYPE'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Work center dependency'' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_WKC_DEPENDENCY'' ');
      DMib.m_MainDB.ExecSQL('Update SCDM_FILTERS  Set bActive = 1,  cCaption = ''Material Supply Detail'', cSQL = '+QuotedStr('Select * from SCDM_MATERIAL_SUP_DETAIL where MD_IDENTIFIER = ' + QuotedStr(IniAppGlobals.Identifier)) + ' where IDENTIFIER = ' +IniAppGlobals.Identifier+' and cTable = ''SCDM_MATERIAL_SUP_DETAIL'' ');

  end;

end;

//----------------------------------------------------------------------------//

procedure TCreateTables.UpdCfgDBClick(Sender: TObject);
var
  errStr: string;
begin
  Screen.Cursor := crHourGlass;
  Panel1.Enabled := False;

  if MessageDlg(_('This operation will update all local data. Do you want to continue?'), mtConfirmation,
    [mbyes,mbno],0) = mrYes then
  begin

    if not GetPassword then
    begin
      ModalResult := idAbort;
      Exit;
    end;

    Gauge1.Visible := True;
    Gauge1.Progress := 0;

    if not IsLocalDbConnected then
       LocalDbConnect(false);

    if IniAppGlobals.DownloadTo = '2' then
      UpdateDB_Interbase(Cfg_DB)
    else if IniAppGlobals.DownloadTo = '1' then
      UpdateDB_Oracle(Cfg_DB)
    else if IniAppGlobals.DownloadTo = '0' then
      UpdateDB_DB2(Cfg_DB);

    CreateStoredForCfg;

    UpdateDefaultValues;
  //  SaveLicenceMcm(true, s_licBytesMcm, errStr);
 //   if SaveLicenceMqm(true, s_licBytes, errStr) then
  //  begin
      Gauge1.Visible := False;
      lbStep.Visible := False;
      Showmessage(_('Configuration database update completed'));
  //  end
  //  else
  //    Showmessage(errStr);
  end;

  Panel1.Enabled := True;
  Screen.Cursor := crDefault;
end;

//----------------------------------------------------------------------------//

procedure TCreateTables.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  m_DatabaseCreate := false;
end;

procedure TCreateTables.FormShow(Sender: TObject);
begin
  Panel1.Enabled := True;
end;

end.



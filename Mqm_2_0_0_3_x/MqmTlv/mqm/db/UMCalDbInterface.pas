unit UMCalDbInterface;

interface

uses
  SysUtils, Dialogs ,
  DMSrvPC,
  DateUtils,
  comctrls,
  UMCommon;

  function UpdateCalDb(ProgBar: TMqmProgBar): boolean;
  procedure RefreshCalFromDb(ProgBar: TMqmProgBar);

implementation

uses
  UGBaseCal,
  UGShiftCal,
  UMtblDesc,
  UGlicensing,
  System.Classes,
  Forms,
  UMGlobal;

//----------------------------------------------------------------------------//

function UpdateCalDb(ProgBar: TMqmProgBar): boolean;
var
  i, CalElemCount : integer;
  CalCount : integer;
  Cal : TPGCALshift;
  lic: TRecLicVers1;
  strErr: string;
  qry:    TMqmQuery;
  tbiCal:      ^TTblInfo;
  CalElem : TPGCALElem;
  SqlString : string;
  CalName : string;
begin
  Result := true;

  if not DecodeLicVers1(lic, s_licBytes, strErr) then exit;
  if lic.instType = INST_CUST_DEMO then exit;

  qry := CreateQuery(Main_DB);

  tbiCal := @tblInfo[tbl_calendar];
//  SetFldPfx(tbiCal.pfx);

  CalCount := ObjPGCAL_Count;

  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;
  for i := 0 to CalCount -1 do
  begin
    Application.ProcessMessages;
    Cal := TPGCALshift(ObjPGCAL_ByNum(i));
    if (Cal.GetKey = 'VOID') or Cal.IsResCal then
      Continue
    else
    begin

      with qry do
      begin
        if Assigned(ProgBar) then
        //  ProgBar.SetMax(High(Cal.m_calendar));
          ProgBar.SetPosition(High(Cal.m_calendar));

        for CalElemCount := Low(Cal.m_calendar) to High(Cal.m_calendar) do
        begin
          Application.ProcessMessages;

          CalElem := Cal.m_calendar[CalElemCount];

          if not CalElem.DateModified then
            continue
          else
          begin
            if Assigned(ProgBar) then
              ProgBar.SetPosition(CalElemCount);
            tbiCal := @tblInfo[tbl_ResCal];
            if Cal.m_IsEfficiencyAndCalBothOnResLvl then
            begin
              if CalElem.DateNew then
              begin
                SqlString := ' insert into ' + tbiCal.GetTableName +
                 '("RCA_IDENTIFIER","RCA_CAL","RCA_CAL_DATE","RCA_RSC_CODE","RCA_PROG_WRK_HR",' +
                 '"RCA_SH1_START","RCA_SH1_END","RCA_SH2_START","RCA_SH2_END",' +
                 '"RCA_SH3_START","RCA_SH3_END","RCA_SH4_START","RCA_SH4_END" ) ' +
                 ' values (' +
                 IniAppGlobals.Identifier + ',' +
                 QuotedStr(Cal.GetCalName_ResEffBothLvl) + ',' +
                 ConvertDateFormatDb2Oracle((Cal.m_startDate + CalElemCount), true,true) + ',' +
                 QuotedStr(Cal.GetResKey) + ',' +
                 StringReplace(FloatToStr(CalElem.JPRGWH), ',','.', [rfReplaceAll, rfIgnoreCase]) + ',' +
                 //FloatToStr(CalElem.JPRGWH) + ',' +
                 FloatToStr(Trunc(CalElem.shift[1].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[1].start + CalElem.shift[1].dur)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[2].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[2].start + CalElem.shift[2].dur)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[3].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[3].start + CalElem.shift[3].dur)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[4].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[4].start + CalElem.shift[4].dur)) + ')';
                SQL.Clear;
                SQL.Add(SqlString);
              end
              else
              begin
                SqlString := ' update ' + tbiCal.GetTableName + ' set ' +
                         //'"RCA_PROG_WRK_HR" = ' + FloatToStr(CalElem.JPRGWH) + ', ' +
                         '"RCA_PROG_WRK_HR" = ' + StringReplace(FloatToStr(CalElem.JPRGWH), ',','.', [rfReplaceAll, rfIgnoreCase]) + ',' +
                         '"RCA_SH1_START" = ' + FloatToStr(Trunc(CalElem.shift[1].start)) + ', ' +
                         '"RCA_SH1_END" = ' + FloatToStr(Trunc(CalElem.shift[1].start + CalElem.shift[1].dur)) + ', ' +
                         '"RCA_SH2_START" = ' + FloatToStr(Trunc(CalElem.shift[2].start)) + ', ' +
                         '"RCA_SH2_END" = ' +  FloatToStr(Trunc(CalElem.shift[2].start + CalElem.shift[2].dur)) + ', ' +
                         '"RCA_SH3_START" = ' + FloatToStr(Trunc(CalElem.shift[3].start)) + ', ' +
                         '"RCA_SH3_END" = ' + FloatToStr(Trunc(CalElem.shift[3].start + CalElem.shift[3].dur)) + ' , '  +
                         '"RCA_SH4_START" = ' + FloatToStr(Trunc(CalElem.shift[4].start)) + ', ' +
                         '"RCA_SH4_END" = ' + FloatToStr(Trunc(CalElem.shift[4].start + CalElem.shift[4].dur)) + ' ';
                SQL.Clear;
                SQL.Add(SqlString);
                SQL.Add(' where ');
                SQL.Add(CreateFld(tbiCal.pfx,fli_CalCod)       + ' = ''' + Cal.GetCalName_ResEffBothLvl + ''' and ');
                SQL.Add(CreateFld(tbiCal.pfx,fli_rsc)       + ' = ''' + Cal.GetResKey + ''' and ');
                SQL.Add(CreateFld(tbiCal.pfx,fli_CalDate)     + ' = ' + ConvertDateFormatDb2Oracle((Cal.m_startDate + CalElemCount), true,true));
                SQL.Add(AND_IDF_Condition(CreateFld(tbiCal.pfx, fli_Identifier)));
              end;
            end
            else
            begin
              tbiCal := @tblInfo[tbl_calendar];
              if CalElem.DateNew then
              begin
                SqlString := ' select 1 DummyAttr from ' + tbiCal.GetTableName;
                SQL.Clear;
                SQL.Add(SqlString);
                SQL.Add(' where ');
                SQL.Add(CreateFld(tbiCal.pfx,fli_CalCod)       + ' = ''' + Cal.GetKey + ''' and ');
                SQL.Add(CreateFld(tbiCal.pfx,fli_CalDate)     + ' = ' + ConvertDateFormatDb2Oracle((Cal.m_startDate + CalElemCount), true,true));
                SQL.Add(AND_IDF_Condition(CreateFld(tbiCal.pfx, fli_Identifier)));
                Open;
                if not EOF then
                begin
                  CalElem.DateNew := false;
                end;
                Close;
              end;
              if CalElem.DateNew then
              begin
                SqlString := ' insert into ' + tbiCal.GetTableName +
                 '("CA_IDENTIFIER","CA_CAL","CA_CAL_DATE","CA_PROG_WRK_HR",' +
                 '"CA_SH1_START","CA_SH1_END","CA_SH2_START","CA_SH2_END",' +
                 '"CA_SH3_START","CA_SH3_END","CA_SH4_START","CA_SH4_END" ) ' +
                 ' values (' +
                 IniAppGlobals.Identifier + ',' +
                 QuotedStr(Cal.GetKey) + ',' +
                 ConvertDateFormatDb2Oracle((Cal.m_startDate + CalElemCount), true,true) + ',' +
                 //FloatToStr(CalElem.JPRGWH) + ',' +
                 StringReplace(FloatToStr(CalElem.JPRGWH), ',','.', [rfReplaceAll, rfIgnoreCase]) + ',' +
                 FloatToStr(Trunc(CalElem.shift[1].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[1].start + CalElem.shift[1].dur)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[2].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[2].start + CalElem.shift[2].dur)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[3].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[3].start + CalElem.shift[3].dur)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[4].start)) + ',' +
                 FloatToStr(Trunc(CalElem.shift[4].start + CalElem.shift[4].dur)) + ')';
                SQL.Clear;
                SQL.Add(SqlString);
              end
              else
              begin
                SqlString := ' update ' + tbiCal.GetTableName + ' set ' +
                         //'"CA_PROG_WRK_HR" = ' + FloatToStr(CalElem.JPRGWH) + ', ' +
                         '"CA_PROG_WRK_HR" = ' + StringReplace(FloatToStr(CalElem.JPRGWH), ',','.', [rfReplaceAll, rfIgnoreCase]) + ',' +
                         '"CA_SH1_START" = ' + FloatToStr(Trunc(CalElem.shift[1].start)) + ', ' +
                         '"CA_SH1_END" = ' + FloatToStr(Trunc(CalElem.shift[1].start + CalElem.shift[1].dur)) + ', ' +
                         '"CA_SH2_START" = ' + FloatToStr(Trunc(CalElem.shift[2].start)) + ', ' +
                         '"CA_SH2_END" = ' +  FloatToStr(Trunc(CalElem.shift[2].start + CalElem.shift[2].dur)) + ', ' +
                         '"CA_SH3_START" = ' + FloatToStr(Trunc(CalElem.shift[3].start)) + ', ' +
                         '"CA_SH3_END" = ' + FloatToStr(Trunc(CalElem.shift[3].start + CalElem.shift[3].dur)) + ' , '  +
                         '"CA_SH4_START" = ' + FloatToStr(Trunc(CalElem.shift[4].start)) + ', ' +
                         '"CA_SH4_END" = ' + FloatToStr(Trunc(CalElem.shift[4].start + CalElem.shift[4].dur)) + ' ';
                SQL.Clear;
                SQL.Add(SqlString);
                SQL.Add(' where ');
                SQL.Add(CreateFld(tbiCal.pfx,fli_CalCod)       + ' = ''' + Cal.GetKey + ''' and ');
                SQL.Add(CreateFld(tbiCal.pfx,fli_CalDate)     + ' = ' + ConvertDateFormatDb2Oracle((Cal.m_startDate + CalElemCount), true,true));
                SQL.Add(AND_IDF_Condition(CreateFld(tbiCal.pfx, fli_Identifier)));
              end;
            end;

            try
              ExecSQL;
            except
              on E: Exception do
              begin
                MessageDlg(e.Message, mtError, [mbok], 0);
                //ApplicationShowException(E);
//                Qry.Transaction.Rollback;
              end;
            end;

            Application.ProcessMessages;
            Close;
            Cal.m_calendar[CalElemCount].DateModified := false;
            Cal.m_calendar[CalElemCount].DateNew := false;
            CalElem.DateModified := false;
            CalElem.DateNew := false;

          end;
        end;
      end;
    end;
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);

  Qry.Transaction.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure RefreshCalFromDb(ProgBar: TMqmProgBar);
var
  i: integer;
  CalCount : integer;
  Cal : TPGCALshift;
  qry:    TMqmQuery;
  tbiCal:      ^TTblInfo;
  CalElem : PTPGCALElem;
  SuffixTblName: string;
begin

  // This function is not in use - to make it used as a refresh we need to :
  // 1. re-write this part to build prgwh from scratch.
  // 2. Support calendar on resource level.
  // 3. Support refresh on calendar efficiency.
  // 4. After refresh of calendar - we need to run tha reorgenize.

  tbiCal := @tblInfo[tbl_calendar];
//  SetFldPfx(tbiCal.pfx);

  qry := CreateQuery(Main_DB);
  CalCount := ObjPGCAL_Count;

  if Assigned(ProgBar) then
    ProgBar.SetMax(High(Cal.m_calendar));

  for i := 0 to CalCount -1 do
  begin

    Cal := TPGCALshift(ObjPGCAL_ByNum(i));
    if Cal.GetKey = 'VOID' then
      Continue
    else
    begin

      with qry do
      begin
        SQL.Clear;
        SQL.Add('select ');
        SQL.Add(CreateFld(tbiCal.pfx, fli_CalDate)     + ','); //Kcaldt
        SQL.Add(CreateFld(tbiCal.pfx, fli_Prog_Wrk_Hr) + ','); //KPRGHW
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH1_start)   + ','); //KINZT1
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH1_end)     + ','); //KFINT1
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH2_start)   + ','); //KINZT2
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH2_end)     + ','); //KFINT2
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH3_start)   + ','); //KINZT3
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH3_end)     + ','); //KFINT3
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH4_start)   + ','); //KINZT4
        SQL.Add(CreateFld(tbiCal.pfx, fli_SH4_end)); //KFINT4
        SQL.Add(' from ' + tbiCal.GetTableName);
        SQL.Add(' where (' + CreateFld(tbiCal.pfx, fli_CalCod) + ' = ');
        SQL.Add('''' + Cal.GetKey + '''');
        if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
           SQL.Add(') and (' + CreateFld(tbiCal.pfx, fli_CalDate) + ' >= ' + ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true))
        else
          SQL.Add(') and (' + CreateFld(tbiCal.pfx, fli_CalDate) + ' >= ''' + FormatDateMMDDYYYYWithSlash(DBAppGlobals.StDateForPlan) + '''');
        SQL.Add(AND_IDF_Condition(CreateFld(tbiCal.pfx, fli_Identifier)));
        SQL.Add(') order by ' + CreateFld(tbiCal.pfx, fli_CalDate));
        Open;

        while not EOF do
        begin
          CalElem := Cal.GetShiftCalDay(FieldByName(CreateFld(tbiCal.pfx, fli_CalDate)).AsDateTime);

          if Assigned(CalElem) and not CalElem.DateModified then
          begin
            CalElem.JPRGWH := FieldByName(CreateFld(tbiCal.pfx, fli_Prog_Wrk_Hr)).AsFloat;

            CalElem.shift[1].start := FieldByName(CreateFld(tbiCal.pfx, fli_SH1_start)).AsInteger;
            CalElem.shift[1].dur   := FieldByName(CreateFld(tbiCal.pfx, fli_SH1_end)).AsInteger - CalElem.shift[1].start;

            CalElem.shift[2].start := FieldByName(CreateFld(tbiCal.pfx, fli_SH2_start)).AsInteger;
            CalElem.shift[2].dur   := FieldByName(CreateFld(tbiCal.pfx, fli_SH2_end)).AsInteger - CalElem.shift[2].start;

            CalElem.shift[3].start := FieldByName(CreateFld(tbiCal.pfx, fli_SH3_start)).AsInteger;
            CalElem.shift[3].dur   := FieldByName(CreateFld(tbiCal.pfx, fli_SH3_end)).AsInteger - CalElem.shift[3].start;

            CalElem.shift[4].start := FieldByName(CreateFld(tbiCal.pfx, fli_SH4_start)).AsInteger;
            CalElem.shift[4].dur   := FieldByName(CreateFld(tbiCal.pfx, fli_SH4_end)).AsInteger - CalElem.shift[4].start;

            CalElem.JNUMWH := (CalElem.shift[1].dur +
                               CalElem.shift[2].dur +
                               CalElem.shift[3].dur +
                               CalElem.shift[4].dur)/60;

          end;

          qry.Next

        end;
      end;

      if Assigned(ProgBar) then
        ProgBar.SetPosition(i);

    end;
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);

  qry.Free;

end;

//----------------------------------------------------------------------------//

end.

unit UMProdSortList;

interface

uses UMProdMemory;

  function SortPR(Item1, Item2: Pointer) : integer;
  function SortPH(Item1, Item2: Pointer) : integer;
  function SortPD(Item1, Item2: Pointer) : integer;
  function SortPP(Item1, Item2: Pointer) : integer;
  function SortPI(Item1, Item2: Pointer) : integer;
  function SortEC(Item1, Item2: Pointer) : integer;
  function SortIC(Item1, Item2: Pointer) : integer;
  function SortSB(Item1, Item2: Pointer) : integer;
  function SortSP(Item1, Item2: Pointer) : integer;
  function SortST(Item1, Item2: Pointer) : integer;
  function SortMT(Item1, Item2: Pointer) : integer;
  function SortPA(Item1, Item2: Pointer) : integer;

implementation

//----------------------------------------------------------------------------//

function SortPR(Item1, Item2: Pointer) : integer;
var
  MQMPR1 : PTMQMPR;
  MQMPR2 : PTMQMPR;
begin
  MQMPR1 := PTMQMPR(Item1);
  MQMPR2 := PTMQMPR(Item2);
  if MQMPR1.PR_PREQ_NO < MQMPR2.PR_PREQ_NO then
    Result := -1
  else if (MQMPR1.PR_PREQ_NO = MQMPR2.PR_PREQ_NO) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPH(Item1, Item2: Pointer) : integer;
var
  MQMPH1 : PTMQMPH;
  MQMPH2 : PTMQMPH;
begin
  MQMPH1 := PTMQMPH(Item1);
  MQMPH2 := PTMQMPH(Item2);
  if MQMPH1.PH_PREQ_NO < MQMPH2.PH_PREQ_NO then
    Result := -1
  else if (MQMPH1.PH_PREQ_NO = MQMPH2.PH_PREQ_NO) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPD(Item1, Item2: Pointer) : integer;
var
  MQMPD1 : PTMQMPD;
  MQMPD2 : PTMQMPD;
begin
  MQMPD1 := PTMQMPD(Item1);
  MQMPD2 := PTMQMPD(Item2);
  if (MQMPD1.PD_PREQ_NO < MQMPD2.PD_PREQ_NO) then
    Result := -1
  else if (MQMPD1.PD_PREQ_NO = MQMPD2.PD_PREQ_NO) then
  begin
    if (MQMPD1.PD_PSTEP_ID < MQMPD2.PD_PSTEP_ID) then
      Result := -1
    else if (MQMPD1.PD_PSTEP_ID = MQMPD2.PD_PSTEP_ID) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPP(Item1, Item2: Pointer) : integer;
var
  MQMPP1 : PTMQMPP;
  MQMPP2 : PTMQMPP;
begin
  MQMPP1 := PTMQMPP(Item1);
  MQMPP2 := PTMQMPP(Item2);

  if MQMPP1.PP_PREQ_NO < MQMPP2.PP_PREQ_NO then
     Result := -1
  else if (MQMPP1.PP_PREQ_NO = MQMPP2.PP_PREQ_NO) then
  begin
    if (MQMPP1.PP_PSTEP_ID < MQMPP2.PP_PSTEP_ID) then
       Result := -1
    else if (MQMPP1.PP_PSTEP_ID = MQMPP2.PP_PSTEP_ID) then
    begin
      if (MQMPP1.PP_PROPERTY < MQMPP2.PP_PROPERTY) then
        Result := -1
      else if (MQMPP1.PP_PROPERTY = MQMPP2.PP_PROPERTY) then
      begin
        if (MQMPP1.PP_RSC_CODE < MQMPP2.PP_RSC_CODE) then
          Result := -1
        else if (MQMPP1.PP_RSC_CODE > MQMPP2.PP_RSC_CODE) then
          Result := 1
        else
          Result := 0;
      end
      else
        Result := 1
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPI(Item1, Item2: Pointer) : integer;
var
  MQMPI1 : PTMQMPI;
  MQMPI2 : PTMQMPI;
begin
  MQMPI1 := PTMQMPI(Item1);
  MQMPI2 := PTMQMPI(Item2);
  if (MQMPI1.PI_PREQ_NO < MQMPI2.PI_PREQ_NO) then
    Result := -1
  else if (MQMPI1.PI_PREQ_NO = MQMPI2.PI_PREQ_NO) then
  begin
    if (MQMPI1.PI_PSTEP_ID < MQMPI2.PI_PSTEP_ID) then
      Result := -1
    else if (MQMPI1.PI_PSTEP_ID = MQMPI2.PI_PSTEP_ID) then
    begin
      if (MQMPI1.PI_INFO_TYPE < MQMPI2.PI_INFO_TYPE) then
         Result := -1
      else if (MQMPI1.PI_INFO_TYPE = MQMPI2.PI_INFO_TYPE) then
      begin
        if (MQMPI1.PI_INFO_LINE_NUM < MQMPI2.PI_INFO_LINE_NUM) then
          Result := -1
        else if (MQMPI1.PI_INFO_LINE_NUM = MQMPI2.PI_INFO_LINE_NUM) then
          Result := 0
        else
          Result := 1;
      end
      else
        Result := 1;
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//------------------------------------------------------------------------

function SortEC(Item1, Item2: Pointer) : integer;
var
  MQMEC1 : PTMQMEC;
  MQMEC2 : PTMQMEC;
begin
  MQMEC1 := PTMQMEC(Item1);
  MQMEC2 := PTMQMEC(Item2);
  if MQMEC1.EC_PREQ_NO < MQMEC2.EC_PREQ_NO then
    Result := -1
  else if (MQMEC1.EC_PREQ_NO = MQMEC2.EC_PREQ_NO) then
  begin
    if (MQMEC1.EC_CONNE_KEY < MQMEC2.EC_CONNE_KEY) then
      Result := -1
    else if (MQMEC1.EC_CONNE_KEY = MQMEC2.EC_CONNE_KEY) then
      Result := 0
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortIC(Item1, Item2: Pointer) : integer;
var
  MQMIC1 : PTMQMIC;
  MQMIC2 : PTMQMIC;
begin
  MQMIC1 := PTMQMIC(Item1);
  MQMIC2 := PTMQMIC(Item2);
  if MQMIC1.IC_PREQ_NO < MQMIC2.IC_PREQ_NO then
    Result := -1
  else if (MQMIC1.IC_PREQ_NO = MQMIC2.IC_PREQ_NO) then
  begin
    if (MQMIC1.IC_PREV_PREQ_NO < MQMIC2.IC_PREV_PREQ_NO) then
      Result := -1
    else if (MQMIC1.IC_PREV_PREQ_NO = MQMIC2.IC_PREV_PREQ_NO) then
      Result := 0
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortSB(Item1, Item2: Pointer) : integer;
var
  MQMSB1 : PTMQMSB;
  MQMSB2 : PTMQMSB;
begin
  MQMSB1 := PTMQMSB(Item1);
  MQMSB2 := PTMQMSB(Item2);
  if MQMSB1.SB_PREQ_NO < MQMSB2.SB_PREQ_NO then
    Result := -1
  else if (MQMSB1.SB_PREQ_NO = MQMSB2.SB_PREQ_NO) then
  begin
    if (MQMSB1.SB_PSTEP_ID < MQMSB2.SB_PSTEP_ID) then
      Result := -1
    else if (MQMSB1.SB_PSTEP_ID = MQMSB2.SB_PSTEP_ID) then
    begin
      if (MQMSB1.SB_BCH_UM < MQMSB2.SB_BCH_UM) then
        Result := -1
      else if (MQMSB1.SB_BCH_UM = MQMSB2.SB_BCH_UM) then
        Result := 0
      else
        Result := 1;
    end
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortSP(Item1, Item2: Pointer) : integer;
var
  MQMSP1 : PTMQMSP;
  MQMSP2 : PTMQMSP;
begin
  MQMSP1 := PTMQMSP(Item1);
  MQMSP2 := PTMQMSP(Item2);

  if MQMSP1.SP_PREQ_NO < MQMSP2.SP_PREQ_NO then
     Result := -1
  else if (MQMSP1.SP_PREQ_NO = MQMSP2.SP_PREQ_NO) then
  begin
    if (MQMSP1.SP_PSTEP_ID < MQMSP2.SP_PSTEP_ID) then
       Result := -1
    else if (MQMSP1.SP_PSTEP_ID = MQMSP2.SP_PSTEP_ID) then
    begin
      if (MQMSP1.SP_PSUBST_ID < MQMSP2.SP_PSUBST_ID) then
        Result := -1
      else if (MQMSP1.SP_PSUBST_ID = MQMSP2.SP_PSUBST_ID) then
      begin
        if (MQMSP1.SP_REPROC_NO < MQMSP2.SP_REPROC_NO) then
          Result := -1
        else if (MQMSP1.SP_REPROC_NO > MQMSP2.SP_REPROC_NO) then
          Result := 1
        else
          Result := 0;
      end
      else
        Result := 1
    end
    else
      Result := 1;
  end
  else
    Result := 1;

end;

//----------------------------------------------------------------------------//

function SortST(Item1, Item2: Pointer) : integer;
var
  MQMST1 : PTMQMST;
  MQMST2 : PTMQMST;
begin
  MQMST1 := PTMQMST(Item1);
  MQMST2 := PTMQMST(Item2);

  if MQMST1.ST_PREQ_NO < MQMST2.ST_PREQ_NO then
     Result := -1
  else if (MQMST1.ST_PREQ_NO = MQMST2.ST_PREQ_NO) then
  begin
    if (MQMST1.ST_PSTEP_ID < MQMST2.ST_PSTEP_ID) then
       Result := -1
    else if (MQMST1.ST_PSTEP_ID = MQMST2.ST_PSTEP_ID) then
    begin
      if (MQMST1.ST_WKCNTER < MQMST2.ST_WKCNTER) then
        Result := -1
      else if (MQMST1.ST_WKCNTER = MQMST2.ST_WKCNTER) then
      begin
        if (MQMST1.ST_WKCT_PROC < MQMST2.ST_WKCT_PROC) then
          Result := -1
        else if (MQMST1.ST_WKCT_PROC = MQMST2.ST_WKCT_PROC) then
        begin
          if (MQMST1.ST_RES_CATEGORY < MQMST2.ST_RES_CATEGORY) then
            Result := -1
          else if (MQMST1.ST_RES_CATEGORY = MQMST2.ST_RES_CATEGORY) then
          begin
            if (MQMST1.ST_RSC_CODE < MQMST2.ST_RSC_CODE) then
              Result := -1
            else if (MQMST1.ST_RSC_CODE = MQMST2.ST_RSC_CODE) then
            begin
              if MQMST1.ST_SETUP_TIME_Mechin_Code < MQMST2.ST_SETUP_TIME_Mechin_Code then
                Result := -1
              else if (MQMST1.ST_SETUP_TIME_Mechin_Code = MQMST2.ST_SETUP_TIME_Mechin_Code) then
                Result := 0
              else
                Result := 1
            end
            else
              Result := 1;
          end
          else
            Result := 1;
        end
        else
          Result := 1;
      end
      else
        Result := 1
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortMT(Item1, Item2: Pointer) : integer;
var
  MQMMT1 : PTMQMMT;
  MQMMT2 : PTMQMMT;
begin
  MQMMT1 := PTMQMMT(Item1);
  MQMMT2 := PTMQMMT(Item2);

  if MQMMT1.MT_PROD_REQ_Nr < MQMMT2.MT_PROD_REQ_Nr then
     Result := -1
  else if (MQMMT1.MT_PROD_REQ_Nr = MQMMT2.MT_PROD_REQ_Nr) then
  begin
    if (MQMMT1.MT_PSTEP_ID < MQMMT2.MT_PSTEP_ID) then
       Result := -1
    else if (MQMMT1.MT_PSTEP_ID = MQMMT2.MT_PSTEP_ID) then
    begin
//      if (MQMMT1.MT_ORG_STEP < MQMMT2.MT_ORG_STEP) then
//         Result := -1
//      else if (MQMMT1.MT_ORG_STEP = MQMMT2.MT_ORG_STEP) then
//      begin
        if (MQMMT1.MT_WKCTR_CODE < MQMMT2.MT_WKCTR_CODE) then
          Result := -1
        else if (MQMMT1.MT_WKCTR_CODE = MQMMT2.MT_WKCTR_CODE) then
        begin
          if (MQMMT1.MT_RES_CAT_CODE < MQMMT2.MT_RES_CAT_CODE) then
            Result := -1
          else if (MQMMT1.MT_RES_CAT_CODE = MQMMT2.MT_RES_CAT_CODE) then
          begin
            if (MQMMT1.MT_RES_CODE < MQMMT2.MT_RES_CODE) then
              Result := -1
            else if (MQMMT1.MT_RES_CODE = MQMMT2.MT_RES_CODE) then
            begin
              if (MQMMT1.MT_MACHIN_SETUP_CODE < MQMMT2.MT_MACHIN_SETUP_CODE) then
                Result := -1
              else if (MQMMT1.MT_MACHIN_SETUP_CODE = MQMMT2.MT_MACHIN_SETUP_CODE) then
              begin
                if (MQMMT1.MT_ALTERNATIVE_CODE < MQMMT2.MT_ALTERNATIVE_CODE) then
                  Result := -1
                else if (MQMMT1.MT_ALTERNATIVE_CODE = MQMMT2.MT_ALTERNATIVE_CODE) then
                begin
                  if (MQMMT1.MT_PROD_TYPE < MQMMT2.MT_PROD_TYPE) then
                    Result := -1
                  else if (MQMMT1.MT_PROD_TYPE = MQMMT2.MT_PROD_TYPE) then
                  begin
                    if (MQMMT1.MT_PROD_CODE < MQMMT2.MT_PROD_CODE) then
                      Result := -1
                    else if (MQMMT1.MT_PROD_CODE = MQMMT2.MT_PROD_CODE) then
                    begin
                      if (MQMMT1.MT_NET_GROUP_CODE < MQMMT2.MT_NET_GROUP_CODE) then
                        Result := -1
                      else if (MQMMT1.MT_NET_GROUP_CODE = MQMMT2.MT_NET_GROUP_CODE) then
                      begin
                        if (MQMMT1.MT_ISSUE_CODE < MQMMT2.MT_ISSUE_CODE) then
                           Result := -1
                        else if (MQMMT1.MT_ISSUE_CODE = MQMMT2.MT_ISSUE_CODE) then
                        begin
                          if (MQMMT1.MT_SEQ_ISSUED < MQMMT2.MT_SEQ_ISSUED) then
                             Result := -1
                          else if (MQMMT1.MT_SEQ_ISSUED = MQMMT2.MT_SEQ_ISSUED) then
                            Result := 0
                          else
                            Result := 1
                        end
                        else
                          Result := 1;
                      end
                      else
                        Result := 1;
                    end
                    else
                      Result := 1;
                  end
                  else
                    Result := 1;
                end
                else
                  Result := 1
              end
              else
                Result := 1;
            end
            else
              Result := 1;
          end
          else
            Result := 1;
        end
//        else
//          Result := 1;
 //     end
      else
        Result := 1;
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPA(Item1, Item2: Pointer) : integer;
var
  MQMPA1 : PTMQMPA;
  MQMPA2 : PTMQMPA;
begin
  MQMPA1 := PTMQMPA(Item1);
  MQMPA2 := PTMQMPA(Item2);
  if (MQMPA1.PA_PROD_REQ_NR < MQMPA2.PA_PROD_REQ_NR) then
    Result := -1
  else if (MQMPA1.PA_PROD_REQ_NR = MQMPA2.PA_PROD_REQ_NR) then
  begin
    if (MQMPA1.PA_SEQUENCE < MQMPA2.PA_SEQUENCE) then
      Result := -1
    else if (MQMPA1.PA_SEQUENCE = MQMPA2.PA_SEQUENCE) then
    begin
      if (MQMPA1.PA_PROD_CODE < MQMPA2.PA_PROD_CODE) then
         Result := -1
      else if (MQMPA1.PA_PROD_CODE = MQMPA2.PA_PROD_CODE) then
      begin
        if (MQMPA1.PA_NET_GROUP_Code < MQMPA2.PA_NET_GROUP_Code) then
          Result := -1
        else if (MQMPA1.PA_NET_GROUP_Code = MQMPA2.PA_NET_GROUP_Code) then
          Result := 0
        else
          Result := 1;
      end
      else
        Result := 1;
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

end.

unit UMlearningCurve;

interface

implementation

uses Classes,SysUtils;

type

  TLearningCurve = record
    Code       : string;
    _1th       : integer;
    _1th_Prcnt : integer;
    _2th       : integer;
    _2th_Prcnt : integer;
    _3th       : integer;
    _3th_Prcnt : integer;
    _4th       : integer;
    _4th_Prcnt : integer;
    _5th       : integer;
    _5th_Prcnt : integer;

  end;
  PTLearningCurve = ^TLearningCurve;

var
  List_LearningCurve : TList;

//----------------------------------------------------------------------------//

procedure InitialCurveList;
var
  I,J : Integer;
  LearningCurve : PTLearningCurve;
begin

  for J := 0 to  8  do
  begin

    new(LearningCurve);
    List_LearningCurve.Add(LearningCurve);
    LearningCurve.Code     := 'LRNCV' + IntToStr(J);

    for I := 1 to 5 do
    begin
      LearningCurve._1th    := random(20);
      if LearningCurve._1th = 0 then
         LearningCurve._1th := 2;
      LearningCurve._2th    := random(20);
      if LearningCurve._2th = 0 then
        LearningCurve._2th := 2;
      LearningCurve._3th    := random(20);
      if LearningCurve._3th = 0 then
         LearningCurve._3th := 2;
      LearningCurve._4th    := random(20);
      if LearningCurve._4th  = 0 then
         LearningCurve._4th := 2;
      LearningCurve._5th    := random(20);
      if LearningCurve._5th = 0 then
         LearningCurve._5th := 2;

      LearningCurve._1th_Prcnt := random(100);
      if LearningCurve._1th_Prcnt = 0 then
         LearningCurve._1th_Prcnt := 10;
      LearningCurve._2th_Prcnt := random(100);
      if LearningCurve._2th_Prcnt = 0 then
         LearningCurve._2th_Prcnt := 10;
      LearningCurve._3th_Prcnt := random(100);
      if LearningCurve._3th_Prcnt = 0 then
         LearningCurve._3th_Prcnt := 10;
      LearningCurve._4th_Prcnt := random(100);
      if LearningCurve._4th_Prcnt = 0 then
         LearningCurve._4th_Prcnt := 10;
      LearningCurve._5th_Prcnt := random(100);
      if LearningCurve._5th_Prcnt = 0 then
         LearningCurve._5th_Prcnt := 10;

    end;

  end;


end;

//----------------------------------------------------------------------------//

procedure FreeList;
var
  I : integer;
begin
  for I := 0 to List_LearningCurve.Count - 1 do
    Dispose(PTLearningCurve(List_LearningCurve[I]));
  List_LearningCurve.Free;
end;

//----------------------------------------------------------------------------//

initialization
  List_LearningCurve := TList.Create;

  InitialCurveList;

finalization
  FreeList;

end.

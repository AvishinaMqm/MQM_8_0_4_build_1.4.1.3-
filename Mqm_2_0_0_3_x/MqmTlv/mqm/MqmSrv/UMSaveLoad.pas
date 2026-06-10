unit UMSaveLoad;

interface

uses
  UMTblDesc;

const
{$ifdef MILANDEV}
//  AS400Speclib = 'kasar/';
//  AS400Speclib = 'TESMQMD/';
  AS400Speclib = '';
//  AS400Speclib = '';
{$else}
  AS400Speclib = '';
{$endif}
type

  TLinkDataType = (TLD_string, TLD_integer, TLD_float, TLD_date, TLD_dateTime,
                   TLD_calConv);

  TQryLinkRec = record
    fldPC:   fldId;
    fldAS:   string;
    fldType: TLinkDataType;
  end;


implementation


end.

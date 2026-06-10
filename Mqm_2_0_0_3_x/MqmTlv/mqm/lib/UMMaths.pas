unit UMMaths;

interface

  uses SysUtils;

  type
  TMdTokenType = (
    ttUnknown, ttEOS, ttWhite, ttNumber, ttMinus, ttPlus, ttMult, ttDiv, ttLeftParenthesis, ttRightParenthesis);

  type
  TMdTokenizer = class
  private
    FSource: string;
    FDecimalChar: char;
    FTokenType: TMdTokenType;
    FTokenStart: integer;
    FTokenLength: integer;
    FNextCharPos: integer;
    function GetToken: string;
    procedure SetSource(const value: string);
  protected
    procedure MoveByOneChar;
    procedure Reset;
  public
    constructor create;
    function NextToken: TMdTokenType; virtual;
    function NextTrueToken: TMdTokenType;
    property DecimalChar: char read FDecimalChar write FDecimalChar;
    property Source: string read FSource write SetSource;
    property TokenStart: integer read FTokenStart;
    property TokenLength: integer read FTokenLength;
    property Token: string read GetToken;
    property TokenType: TMdTokenType read FTokenType;
  end;

  function DoMath(const source: string): Double;

implementation

var
  tokenizer: TMdTokenizer;

function isWhite(c: char): boolean;
begin
  result := c <= ' ';
end;

function isDigit(c: char): boolean;
begin
  result := (c >= '0') and (c <= '9');
end;

constructor TMdTokenizer.create;
begin
  inherited Create;
  FDecimalChar := FormatSettings.DecimalSeparator;
  Reset;
end;

function TMdTokenizer.GetToken: string;
begin
  result := copy(FSource, FTokenStart, FTokenLength)
end;

procedure TMdTokenizer.MoveByOneChar;
begin
  inc(FNextCharPos);
  inc(FTokenLength);
end;

function TMdTokenizer.NextTrueToken: TMdTokenType;
begin
  repeat
    result := NextToken;
  until result <> ttWhite;
end;

function TMdTokenizer.NextToken: TMdTokenType;

  procedure GetWhite;
  begin
    result := ttWhite;
    while (FNextCharPos <= length(FSource)) and isWhite(FSource[FNextCharPos]) do
      MoveByOneChar;
  end;

  procedure GetNumber;
  begin
    result := ttNumber;

    while (FNextCharPos <= length(FSource)) and isDigit(FSource[FNextCharPos]) do
      MoveByOneChar;

    if (FNextCharPos <= length(FSource)) and (FSource[FNextCharPos] = DecimalChar) then
      MoveByOneChar;
    while (FNextCharPos <= length(FSource)) and isDigit(FSource[FNextCharPos]) do
      MoveByOneChar;

    if (FNextCharPos <= length(FSource)) and (upcase(FSource[FNextCharPos]) = 'E') then begin
      MoveByOneChar;

      {$IFDEF UNICODE}
      if (FNextCharPos <= length(FSource)) and (CharInSet(FSource[FNextCharPos], ['-','+'])) then
      {$ELSE}
      if (FNextCharPos <= length(FSource)) and (FSource[FNextCharPos] in ['-','+']) then
      {$ENDIF}
        MoveByOneChar;

      while (FNextCharPos <= length(FSource)) and isDigit(FSource[FNextCharPos]) do
        MoveByOneChar;
    end;
  end;

  procedure GetOperator(c: char);
  begin
    MoveByOneChar; {skip c}
    case c of
      '(': result := ttLeftParenthesis;
      ')': result := ttRightParenthesis;
      '*': result := ttMult;
      '+': result := ttPlus;
      '-': result := ttMinus;
      '/': result := ttDiv;
    else
      result := ttUnknown;
    end;
  end;

var
  c: char;
begin
  // move past current token
  FTokenStart := FNextCharPos;
  FTokenLength := 0;
  if FNextCharPos > length(FSource) then
    result := ttEOS
  else begin
    c := FSource[FTokenStart];
    if isWhite(c) then
      GetWhite
    else if isDigit(c) then
      GetNumber
    else
      GetOperator(c);
  end;
  FTokenType := result;
end;

procedure TMdTokenizer.Reset;
begin
  FTokenStart := 1;
  FTokenLength := 0;
  FNextCharPos := 1;
  FTokenType := ttUnknown;
end;

procedure TMdTokenizer.SetSource(const value: string);
begin
  FSource := value;
  Reset;
end;


///////////////

function ParserDecimalChar: char;
begin
  result := tokenizer.DecimalChar;
end;

function SetParserDecimalChar(value: char): char;
begin
  result := tokenizer.DecimalChar;
  tokenizer.DecimalChar := value;
end;

function StrToNumber(const value: string): Double;
var
  p: integer;
  s: string;
begin
  s := value;
  if upcase(s[length(s)]) <> 'E' then begin
    if ParserDecimalchar <> FormatSettings.DecimalSeparator then begin
      p := pos(ParserDecimalChar, s);
      while p > 0 do begin
        s[p] := FormatSettings.DecimalSeparator;
        p := pos(ParserDecimalChar, s);
      end;
    end;
    try
      result := StrToFloat(s);
      exit;
    except

    end;
  end;
  //RaiseParseException(peInvalidNumber);
end;

function Factor: Double; forward;

function Term: Double;
begin
  result := Factor;
  repeat
    if Tokenizer.TokenType = ttMult then
    begin

      Tokenizer.NextTrueToken;
      result := result * Factor;
    end
    else if Tokenizer.TokenType = ttDiv then
    begin

      Tokenizer.NextTrueToken;
      result := result / Factor;
    end
    else
      exit;

  until false;
end;

function Expression: Double;
begin

  result := Term;
  repeat
    if Tokenizer.TokenType = ttPlus then
    begin

      Tokenizer.NextTrueToken;
      result := result + Term;
    end
    else if Tokenizer.TokenType = ttMinus then
    begin
      Tokenizer.NextTrueToken;
      result := result - Term;
    end
    else
      exit;
  until false;
end;

function Factor: Double;
begin

  result := 0;
  if Tokenizer.TokenType = ttNumber then begin
    result := StrToNumber(Tokenizer.Token);
    Tokenizer.NextTrueToken;
  end
  else if Tokenizer.TokenType = ttPlus then begin
    Tokenizer.NextTrueToken;  // skip and ignore leading '+'
    result := Factor;
  end
  else if Tokenizer.TokenType = ttMinus then begin
    Tokenizer.NextTrueToken;  // skip '-'
    result := - Factor;       // unary -
  end
  else if Tokenizer.TokenType = ttLeftParenthesis then begin
    Tokenizer.NextTrueToken;  // skip '('
    result := Expression;

  {  if Tokenizer.TokenType <> ttRightParenthesis then begin
      RaiseParseException(peExpectedRightPar);
    end;   }

    Tokenizer.NextTrueToken; // skip ')'

  end;
 { else if Tokenizer.TokenType = ttEOS then
    RaiseParseException(peUnexpectedEOS)
  else
    RaiseParseException(peUnexpectedElement); }
end;


function DoMath(const source: string): Double;
begin
  tokenizer.Source := source;
  tokenizer.NextTrueToken;
  result := Expression;

 { if (Tokenizer.TokenType <> ttEOS) then
    RaiseParseException(peExpectedEOS);  }
end;

initialization
  tokenizer := TMdTokenizer.create;

finalization
  tokenizer.free;

end.

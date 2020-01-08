unit UNumToText;

interface

uses SysUtils, dialogs;

type
TArrString2to9 = array [2..9] of string;
TArrString0to19 = array [0..19] of string;
TArrString1to9 = array [1..9] of string;
TNumToText = class(TObject)
  public function convert(D: string): string;//D represents a number as d1d2d3...dn

  private function convert2Digit(D: string): string;//D represents d1d2
  private function simpleFigure(D:string): string;
  private function tens(d:string):string;
  private function tensAnd(d:string):string;
  private function hundreds(d:string):string;
  private function hundredsAnd(d:string):string;
  private function convert2DigitAdv(D:string): string;
  private function convert3Digit(D:string): string;//D represents d1d2d3
  private function convert6Digit(D:string): string;//D represents d1d2d3d4d5d6

  protected procedure validate(num:integer);virtual;
  protected function THOUSANDS:string;virtual;
  protected function THOUSANDS_AND:string;virtual;
  protected function CTens:TArrString2to9;virtual;
  protected function CTensAnd:TArrString2to9;virtual;
  protected function CFigures:TArrString0to19;virtual;
  protected function CHundreds:TArrString1to9;virtual;
  protected function CHundredsAnd:TArrString1to9;virtual;
  protected function CDivider:string;virtual;
end;

implementation

{ TNumToText }

function TNumToText.convert(D: string): string;
var n, D_Int:integer;
begin
 D_Int:=strtoint(D);
 validate(D_Int);
 D:=inttostr(D_Int);
 n:=length(D);
 if n<=2 then result:=convert2Digit(D)//0..99
 else if n=3 then result:=convert3Digit(D)//100..999
 else if ((n>3)and(n<=6)) then result:=convert6Digit(D)//1000..9999
 else raise Exception.Create('خارج از محدوده');
end;

function TNumToText.convert2Digit(D: string): string;
var n:integer;
begin
 n:=strtoint(D);
 if n<=19 then result:=simpleFigure(D)//0..19
 else result:=convert2DigitAdv(D);//20..99
end;

function TNumToText.convert2DigitAdv(D: string): string;
var n:integer;
begin
 n:=strtoint(D[2]);
 if n=0 then result:=tens(D[1])//20,30,...,90
 else result:=tensAnd(D[1])+CDivider+simpleFigure(D[2]);//21,22,...,29,31,32,...,99
end;

function TNumToText.convert3Digit(D: string): string;
var n:integer;
begin
 n:=strtoint(D[2]+D[3]);
 if (n=0) then result:=hundreds(D[1])//100,200,300,...,900
 else result:=hundredsAnd(D[1])+CDivider+convert2Digit(D[2]+D[3]);//101,102,103,...,199,201,202,...,999
end;

//Note that D can be 1,000 or 12,000 or 123,000 which means that it not necessarily 6 digits
function TNumToText.convert6Digit(D: string): string;
var lowest3Digits, highest3Digits:string;
begin
 lowest3Digits:=copy(D, length(D)-2, 3);//d4d5d6
 highest3Digits:=copy(D, 1, length(D)-3);//d1d2d3
 if strtoint(lowest3Digits)=0 then
  result:=convert(highest3Digits)+CDivider+THOUSANDS//1000,2000,...,9000
 else
  //1001,1002,1003,...,1999,2001,2002,...,9999
  result:=convert(highest3Digits)+CDivider+THOUSANDS_AND+CDivider+convert(lowest3Digits);
end;

function TNumToText.hundreds(d: string): string;
var n:integer;
begin
 n:=strtoint(D);
 result:=CHundreds[n];
end;

function TNumToText.hundredsAnd(d: string): string;
var n:integer;
begin
 n:=strtoint(D);
 result:=CHundredsAnd[n];
end;

function TNumToText.simpleFigure(D: string): string;
var n:integer;
begin
 n:=strtoint(D);
 result:=CFigures[n];
end;

function TNumToText.tens(d:string): string;
var n:integer;
begin
 n:=strtoint(D);
 result:=CTens[n];
end;

function TNumToText.tensAnd(d: string): string;
var n:integer;
begin
 n:=strtoint(D);
 result:=CTensAnd[n];
end;


//Constant functions for returning the text or voice files
function TNumToText.THOUSANDS: string;
begin
 result:='هزار';
end;

function TNumToText.THOUSANDS_AND: string;
begin
 result:='هزار و';
end;

function TNumToText.CTens: TArrString2to9;
const ARR: TArrString2to9 = ('بيست','سي','چهل','پنجاه','شصت','هفتاد',
     'هشتاد','نود');
begin
 result:=ARR;
end;


function TNumToText.CTensAnd: TArrString2to9;
const ARR: TArrString2to9 = ('بيست و','سي و','چهل و','پنجاه و','شصت و','هفتاد و',
     'هشتاد و','نود و');
begin
 result:=ARR;
end;

function TNumToText.CFigures: TArrString0to19;
const ARR: TArrString0to19 = ('صفر','يک','دو','سه','چهار','پنج',
     'شش','هفت','هشت','نه','ده','يازده','دوازده','سيزده',
     'چهارده','پانزده','شانزده','هفده','هيجده','نوزده');
begin
 result:=ARR;
end;

function TNumToText.CHundreds: TArrString1to9;
const ARR: TArrString1to9 = ('يکصد','دويست','سيصد','چهارصد','پانصد','ششصد',
     'هفتصد','هشتصد', 'نهصد');
begin
 result:=ARR;
end;

function TNumToText.CHundredsAnd: TArrString1to9;
const ARR: TArrString1to9 = ('يکصد و','دويست و','سيصد و','چهارصد و','پانصد و',
     'ششصد و','هفتصد و','هشتصد و', 'نهصد و');
begin
 result:=ARR;
end;

function TNumToText.CDivider: string;
begin
 result:=' ';
end;

procedure TNumToText.validate(num: integer);
begin
 if ((num<0)or(num>999999)) then
  raise Exception.Create('عدد بايستي بين 1 تا 999999 باشد');
end;

end.

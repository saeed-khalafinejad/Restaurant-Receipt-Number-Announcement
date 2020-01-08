unit UNumToVoice;

interface

uses UNumToText, MPlayer, classes, Windows, dialogs, forms, SysUtils;

Type TNumToVoice = class(TNumToText)
  private mPlayer:TMediaPlayer;
  playList:TStrings;//List of files to be played. Each entry contains several files separated by * mark.
  protected procedure validate(num:integer);override;
  protected function THOUSANDS:string;override;
  protected function THOUSANDS_AND:string;override;
  protected function CTens:TArrString2to9;override;
  protected function CTensAnd:TArrString2to9;override;
  protected function CFigures:TArrString0to19;override;
  protected function CHundreds:TArrString1to9;override;
  protected function CHundredsAnd:TArrString1to9;override;
  protected function CDivider:string;override;
  public procedure playVoiceStr(filesStr:string;mutex:Cardinal);
  public constructor create(aHandle:HWND);reintroduce;
  public destructor destroy();override;
end;

implementation

uses Controls, UVoicePlayerThread, uspeech;

function TNumToVoice.THOUSANDS: string;
begin
 result:='0.wav';//not supported.
end;

function TNumToVoice.THOUSANDS_AND: string;
begin
 result:='0.wav';//not supported.
end;

function TNumToVoice.CTens: TArrString2to9;
const ARR: TArrString2to9 = ('20.wav','30.wav','40.wav','50.wav','60.wav','70.wav',
     '80.wav','90.wav');
begin
 result:=ARR;
end;

function TNumToVoice.CTensAnd: TArrString2to9;
const ARR: TArrString2to9 = ('20_v.wav','30_v.wav','40_v.wav','50_v.wav','60_v.wav',
     '70_v.wav','80_v.wav','90_v.wav');
begin
 result:=ARR;
end;

function TNumToVoice.CFigures: TArrString0to19;
const ARR: TArrString0to19 = ('0.wav','1.wav','2.wav','3.wav','4.wav','5.wav',
     '6.wav','7.wav','8.wav','9.wav','10.wav','11.wav','12.wav','13.wav',
     '14.wav','15.wav','16.wav','17.wav','18.wav','19.wav');
begin
 result:=ARR;
end;

function TNumToVoice.CHundreds: TArrString1to9;
const ARR: TArrString1to9 = ('100.wav','200.mp3','300.mp3','400.mp3','500.mp3',
     '600.mp3','700.mp3','800.mp3', '900.mp3');
begin
 result:=ARR;
end;

function TNumToVoice.CHundredsAnd: TArrString1to9;
const ARR: TArrString1to9 = ('100_v.wav','200_v.mp3','300_v.mp3','400_v.mp3',
     '500_v.mp3','600_v.mp3','700_v.mp3','800_v.mp3', '900_v.mp3');
begin
 result:=ARR;
end;

function TNumToVoice.CDivider: string;
begin
 result:='*';
end;

procedure TNumToVoice.playVoiceStr(filesStr: string;mutex:Cardinal);
var t:TVoicePlayerThread;
begin
 playList.Add(filesStr);
 t:=TVoicePlayerThread.create(playList, mPlayer, mutex);
 t.Resume;
end;

constructor TNumToVoice.create(aHandle:HWND);
begin
 inherited create();
 playList:=TStringList.Create; 
 mPlayer:=TMediaPlayer.CreateParented(aHandle);
 mPlayer.Visible:=false;
 mPlayer.FileName:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'numVoices\0.wav';
 mPlayer.Open;
end;

destructor TNumToVoice.destroy;
begin
  playList.Free;
  mPlayer.Free();
  inherited;
end;

procedure TNumToVoice.validate(num: integer);
begin
 if ((num<0)or(num>999)) then
  raise Exception.Create('⁄œœ »«Ì” Ì »Ì‰ 1  « 999 »«‘œ');
end;

end.

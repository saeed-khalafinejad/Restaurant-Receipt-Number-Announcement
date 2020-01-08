unit UVoicePlayerThread;

interface

uses MPlayer, classes, Windows, dialogs, forms, SysUtils;

type
  TVoicePlayerThread = class(TThread)
  private
    { Private declarations }
    filesStrList:TStrings;//play list: each entry is separated by * mark.
    //For example, 100_v.wav*1.wav is 101.
    mPlayer:TMediaPlayer;
    mutex:Cardinal;
    procedure playVoices();
  protected
    procedure Execute; override;
  public constructor create(filesStrList:TStrings;mPlayer:TMediaPlayer;mutex:Cardinal);reintroduce;
  end;

implementation

uses uspeech;

{ TVoicePlayerThread }

constructor TVoicePlayerThread.create(filesStrList: TStrings;
  mPlayer: TMediaPlayer;mutex:Cardinal);
begin
 inherited create(true);
 FreeOnTerminate:=true;
 self.mutex:=mutex;
 self.filesStrList:=filesStrList;
 self.mPlayer:=mPlayer;
end;

procedure TVoicePlayerThread.Execute;
begin
 while WaitForSingleObject(mutex, 3000) = WAIT_TIMEOUT do ;
 playVoices;
 ReleaseMutex(mutex);
end;

procedure TVoicePlayerThread.playVoices;
var voicesDir, filesStr:string;
    voiceFiles:TStrings;
    i:integer;
begin
 voicesDir:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'numVoices\';
 filesStr:=filesStrList.Strings[0];
 filesStrList.Delete(0);
 filesStr:='number.wav*'+filesStr;
 voiceFiles := TStringList.Create;
 try
    ExtractStrings(['*'], [], PChar(filesStr), voiceFiles);
    for i:=0 to voiceFiles.Count-1 do
    begin
     mPlayer.Close;
     mPlayer.FileName:=voicesDir+voiceFiles[i];
     mPlayer.Open;
     mPlayer.Wait:=true;
     mPlayer.Play;
    end;
 finally
    voiceFiles.Free;
 end;
end;

end.

program pAnnounce;

uses
  Forms,
  uspeech in 'uspeech.pas' {frmSpeech},
  UNumToText in 'UNumToText.pas',
  UNumToVoice in 'UNumToVoice.pas',
  UVoicePlayerThread in 'UVoicePlayerThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSpeech, frmSpeech);
  Application.Run;
end.

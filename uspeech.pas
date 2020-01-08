unit uspeech;
{
Copyright <2018> <Saeed Khalafinejad>

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MPlayer, OleCtnrs, UNumToVoice, Buttons, ExtCtrls;

type
  TfrmSpeech = class(TForm)
    edtNum: TEdit;
    BtnSpeech: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn0: TBitBtn;
    btnBackspace: TBitBtn;
    btnClear: TBitBtn;
    Bevel1: TBevel;
    lstOlds: TListBox;
    btnRepeat: TBitBtn;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnInc: TBitBtn;
    btnDec: TBitBtn;
    chkInc: TCheckBox;
    procedure btnAlphabetClick(Sender: TObject);
    procedure btnSpeechClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnIncClick(Sender: TObject);
    procedure btnDecClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnBackspaceClick(Sender: TObject);
    procedure btnRepeatClick(Sender: TObject);
    procedure edtNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    n2v:TNumToVoice;
    mutex:Cardinal;
    function incNumber():boolean;
    function decNumber():boolean;
    procedure initializeMutex();
    procedure finalizeMutex();
  public
    { Public declarations }
  end;

var
  frmSpeech: TfrmSpeech;

implementation

uses UNumToText;

{$R *.dfm}

procedure TfrmSpeech.btnAlphabetClick(Sender: TObject);
var n2t:TNumToText;
begin
 n2t:=TNumToText.Create;
 try
   MessageDlg(n2t.convert(EdtNum.Text), mtInformation, [mbok], 0);
 finally
  n2t.Free;
 end;
end;

procedure TfrmSpeech.btnSpeechClick(Sender: TObject);
var voicesStr:string;
begin
 try
  strtoint(edtNum.Text)
 except
  begin
    MessageDlg('‘„«—Â Ê«—œ ‘œÂ ’ÕÌÕ ‰„Ì»«‘œ', mtError, [mbok], 0);
    exit;
  end;
 end;

 try
   voicesStr:=n2v.convert(edtNum.Text);
   n2v.playVoiceStr(voicesStr, mutex);
   if lstOlds.Items.IndexOf(edtNum.Text)=-1 then
    lstOlds.Items.Insert(0, edtNum.Text);
   if lstOlds.Items.Count>15 then lstOlds.Items.Delete(15);
   try lstOlds.Selected[0]:=true; except end;
   if chkInc.Checked then
    if not incNumber then edtNum.Text:='1';
 except
  on e:Exception do
  begin
   MessageDlg('Œÿ«ÌÌ œ— —Ê‰œ ò«— ÅÌ‘ ¬„œ'+#13+#10+e.Message, mtError, [mbok], 0);
  end;
 end;
end;

procedure TfrmSpeech.FormCreate(Sender: TObject);
begin
 n2v:=TNumToVoice.Create(Handle);
 initializeMutex;
end;

procedure TfrmSpeech.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 n2v.Free;
 finalizeMutex();
end;

procedure TfrmSpeech.BitBtn1Click(Sender: TObject);
begin
 if (length(edtNum.Text)<3) then
 begin
  edtNum.Text:=edtNum.Text+inttostr((sender as TBitBtn).Tag);
 end else
 begin
  edtNum.Text:=inttostr((sender as TBitBtn).Tag);
 end;
end;

procedure TfrmSpeech.btnIncClick(Sender: TObject);
begin
 if not incNumber then
 begin
  MessageDlg('›ﬁÿ «„ò«‰ «⁄·«‰ «⁄œ«œ 1  « 999 ÊÃÊœ œ«—œ', mtInformation, [mbOK], 0);
 end;
end;

function TfrmSpeech.incNumber: boolean;
var n:integer;
begin
 try n:=strtoint(edtNum.Text); except n:=0 end;
 if n<999 then
 begin
  n:=n+1;
  edtNum.Text:=inttostr(n);
  result:=true;
 end else
 begin
  result:=false;
 end;
end;

function TfrmSpeech.decNumber: boolean;
var n:integer;
begin
 try n:=strtoint(edtNum.Text); except n:=0 end;
 if n>1 then
 begin
  n:=n-1;
  edtNum.Text:=inttostr(n);
  result:=true;
 end else
 begin
  result:=false;
 end;
end;

procedure TfrmSpeech.btnDecClick(Sender: TObject);
begin
 if not decNumber then MessageDlg('«„ò«‰ ò„ ò—œ‰ ÊÃÊœ ‰œ«—œ', mtInformation, [mbOK], 0);
end;

procedure TfrmSpeech.btnClearClick(Sender: TObject);
begin
 edtNum.Text:='';
end;

procedure TfrmSpeech.btnBackspaceClick(Sender: TObject);
var s:string;
begin
 s:=edtNum.Text;
 if length(s)>0 then
 begin
  delete(s, length(s),1);
  edtNum.Text:=s;
 end;
end;

procedure TfrmSpeech.btnRepeatClick(Sender: TObject);
var voicesStr:string;
begin
 try
   if lstOlds.Items.Count=0 then
   begin
    MessageDlg('ÂÌç ‘„«—Â «Ì œ— ·Ì”  «⁄·«‰ Â«Ì ﬁ»·Ì ÊÃÊœ ‰œ«—œ', mtWarning, [mbok], 0);
    exit;
   end;
   if lstOlds.ItemIndex=-1 then
   begin
    MessageDlg('«“ «⁄·«‰ Â«Ì ﬁ»·Ì Ìò ‘„«—Â —« «‰ Œ«» ‰„«ÌÌœ', mtWarning, [mbok], 0);
    exit;
   end;
   voicesStr:=n2v.convert(lstOlds.Items.Strings[lstOlds.itemIndex]);
   n2v.playVoiceStr(voicesStr, mutex);
 except
  on e:Exception do
  begin
   MessageDlg('Œÿ«ÌÌ œ— —Ê‰œ ò«— ÅÌ‘ ¬„œ'+#13+#10+e.Message, mtError, [mbok], 0);
  end;
 end;
end;

procedure TfrmSpeech.finalizeMutex;
begin
  CloseHandle(mutex);
end;

procedure TfrmSpeech.initializeMutex;
begin
  Mutex := CreateMutex(nil, false, PAnsiChar('Announcement-RestKasabeh-01258967-5784-04-253'));
  if Mutex = 0 then RaiseLastOSError;
end;

procedure TfrmSpeech.edtNumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_Down then btnDecClick(btnDec)
  else if key=VK_Up then btnIncClick(btnInc);
end;

end.

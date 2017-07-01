unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uFindString, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    btnFindString: TButton;
    ledFolderPath: TLabeledEdit;
    ledFindStr: TLabeledEdit;
    btnOpenDlg: TBitBtn;
    BitBtn2: TBitBtn;
    btnStop: TButton;
    lbFileList: TListBox;
    memTest: TMemo;
    lText: TLabel;
    lJob: TLabel;
    procedure btnFindStringClick(Sender: TObject);
    procedure btnOpenDlgClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1      : TForm1;
  FindString : TFindsString;

implementation

{$R *.dfm}

uses
  FileCtrl, uFormats;

procedure TForm1.btnFindStringClick(Sender: TObject);
begin
  with FindString do
  begin
    if GetFiles(ledFolderPath.Text, lbFileList.Items) then
      StartSearch( ledFindStr.Text, lbFileList.Items)
    else
      ShowMessage('В даному каталозі файлів не знайжено (:');
  end;
end;

procedure TForm1.btnOpenDlgClick(Sender: TObject);
var
  Options  : TSelectDirOpts;
  ChosenDir: string;
begin
  // Установка начального каталог
  ChosenDir := 'C:\';
  if SelectDirectory(ChosenDir, Options, 0) then
    ledFolderPath.text := ChosenDir;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  FindString.StopSearch;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ledFolderPath.Text := ExtractFilePath(ParamStr(0)) + 'Test';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  btnStop.Click;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
 d: TSearchUTF16;
begin
  d := TSearchUTF16.Create(ExtractFilePath(ParamStr(0))+ 'Test\' + '3.exe');
  try
    if d.Search( ledFindStr.Text ) then
     ShowMessage('Ура!');
  finally
    FreeAndNil( d );
  end;
end;

initialization
  FindString := TFindsString.Create;

finalization
  FreeAndNil( FindString );
end.


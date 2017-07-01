program ProjFindStr;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1},
  uFindString in 'uFindString.pas',
  uProcedure in 'uProcedure.pas',
  uFormats in 'uFormats.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

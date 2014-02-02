program google_universal_analytics_test;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FrmMain},
  UForm1 in 'UForm1.pas' {Form1},
  UForm2 in 'UForm2.pas' {Form2},
  Analytics in 'analytics\Analytics.pas',
  HitType in 'analytics\HitType.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Google Universal Analytics Test';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

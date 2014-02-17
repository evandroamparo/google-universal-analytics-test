unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Analytics, REST.Client,
  IPPeerClient;

type
  TFrmMain = class(TForm)
    BtnForm1: TButton;
    BtnForm2: TButton;
    procedure BtnForm1Click(Sender: TObject);
    procedure BtnForm2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ActiveFormChange(Sender: TObject);
  private
    FAnalyticsTracker: TAnalyticsTracker;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses UForm1, UForm2, System.SysUtils, HitType;

const
  ID_FILE = 'config.txt';

procedure TFrmMain.ActiveFormChange(Sender: TObject);
begin
  if (Screen.ActiveForm <> nil) and (Screen.ActiveForm <> self) then
  begin
    FAnalyticsTracker.FormShow(Screen.ActiveForm);
  end;
end;

procedure TFrmMain.BtnForm1Click(Sender: TObject);
begin
  Form1.ShowModal;
end;

procedure TFrmMain.BtnForm2Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAnalyticsTracker.SessionEnd;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  Config: TStringList;
begin
  Config := TStringList.Create;
  try
    try
      Config.LoadFromFile(ID_FILE);
      FAnalyticsTracker := TAnalyticsTracker.Create(Config.Values['trackingid'],
        Config.Values['clientid'], Application.Title, '1.0');
      FAnalyticsTracker.SessionStart;
      BtnForm1.Enabled := true;
      BtnForm2.Enabled := true;
      Screen.OnActiveFormChange := ActiveFormChange;
    finally
      Config.Free;
    end;
  except
    on E: EFOpenError do
      Application.MessageBox(PWideChar((Format('Arquivo não encontrado: %s',
        [ID_FILE]))), 'Analytics', MB_ICONERROR);
  end;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FAnalyticsTracker.Free;
end;

end.

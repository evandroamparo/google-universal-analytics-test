unit Analytics;

interface

uses HitType, REST.Client, Vcl.Forms, System.Classes;

type
  TAnalyticsTracker = class
  private
    FTrackingID: string;
    FClientID: string;
    FHttpClient: TRESTClient;
    FAppName: string;
    FAppVersion: string;
    FFiels: TStringList;
    const PROTOCOL_VERSION = '1';
    const BASE_URL = 'http://www.google-analytics.com/collect';
    const BASE_URL_HTTPS = 'https://ssl.google-analytics.com/collect';
  public
    const SESSION_CONTROL = 'sc';
    const HIT_TYPE = 't';
    const SCREEN_NAME = 'cd';
    constructor Create(TrackingID, ClientID, AppName, AppVersion: string);
    destructor Destroy; override;

    procedure SetField(Name, Value: string);
    procedure Track;
    procedure SessionStart;
    procedure SessionEnd;
    procedure FormShow(Form: TForm);
  end;

implementation

uses
  System.SysUtils, REST.Types, Vcl.Dialogs;


{ TAnalyticsTracker }

constructor TAnalyticsTracker.Create(TrackingID, ClientID, AppName, AppVersion: string);
begin
  if Trim(TrackingID) = '' then
    raise Exception.Create('Invalid tracking ID');

  if Trim(ClientID) = '' then
    raise Exception.Create('Invalid client ID');

  if Trim(AppName) = '' then
    raise Exception.Create('Invalid app name');

  FTrackingID := TrackingID;
  FClientID := ClientID;
  FAppName := AppName;
  FAppVersion := AppVersion;
  FHttpClient := TRESTClient.Create(BASE_URL);
  FFiels := TStringList.Create;
//  FHttpClient.ProxyPort := 8888;
//  FHttpClient.ProxyServer := 'localhost';
end;

destructor TAnalyticsTracker.Destroy;
begin
  FFiels.Free;
  FHttpClient.Free;
end;

procedure TAnalyticsTracker.FormShow(Form: TForm);
begin
  SetField(HIT_TYPE, 'pageview');
  SetField(SCREEN_NAME, Form.Caption);
  Track;
end;

procedure TAnalyticsTracker.SessionEnd;
begin
//  SetField(HIT_TYPE, 'appview');
  SetField(SESSION_CONTROL, 'end');
  Track;
end;

procedure TAnalyticsTracker.SessionStart;
begin
//  SetField(HIT_TYPE, 'appview'); // verificar se é necessário enviar algo com SESSION_CONTROL
  SetField(SESSION_CONTROL, 'start');
  Track;
end;

procedure TAnalyticsTracker.SetField(Name, Value: string);
begin
  FFiels.Add(Name + '=' + Value);
end;

procedure TAnalyticsTracker.Track;
var
  Request: TRESTRequest;
  I: Integer;
begin
  Request := TRESTRequest.Create(nil);
  try
    Request.Method := TRESTRequestMethod.rmPOST;
    Request.AddParameter('v', PROTOCOL_VERSION);
    Request.AddParameter('tid', FTrackingID);
    Request.AddParameter('cid', FClientID);
    Request.AddParameter('an', FAppName);
    Request.AddParameter('av', FAppVersion);

    for I := 0 to FFiels.Count - 1 do
       Request.AddParameter(FFiels.Names[i], FFiels.ValueFromIndex[i]);

    Request.Client := FHttpClient;
    Request.Execute;
    FFiels.Clear;
  finally
    Request.Free;
  end;
end;

end.

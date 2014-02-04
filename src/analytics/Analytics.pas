unit Analytics;

interface

uses HitType, REST.Client, Vcl.Forms;

type
  TAnalyticsTracker = class
  private
    FTrackingID: string;
    FClientID: string;
    FHttpClient: TRESTClient;
    FAppName: string;
    FAppVersion: string;
    const PROTOCOL_VERSION = '1';
    const BASE_URL = 'http://www.google-analytics.com/collect';
    const BASE_URL_HTTPS = 'https://ssl.google-analytics.com/collect';
  public
    constructor Create(TrackingID, ClientID, AppName, AppVersion: string);
    destructor Destroy; override;
    
    procedure Track(HitType: THitType; Value: string);
    procedure FormShow(Form: TForm);
    procedure FormClose(Form: TForm);
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
  FHttpClient := TRESTClient.Create(BASE_URL_HTTPS);
//  FHttpClient.ProxyPort := 8888;
//  FHttpClient.ProxyServer := 'localhost';
end;

destructor TAnalyticsTracker.Destroy;
begin
  FHttpClient.Free;
end;

procedure TAnalyticsTracker.FormClose(Form: TForm);
begin

end;

procedure TAnalyticsTracker.FormShow(Form: TForm);
begin

end;

procedure TAnalyticsTracker.Track(HitType: THitType; Value: string);
var
  Request: TRESTRequest;
begin
  Request := TRESTRequest.Create(nil);
  try
    Request.Method := TRESTRequestMethod.rmPOST;
    Request.AddParameter('v', PROTOCOL_VERSION);
    Request.AddParameter('tid', FTrackingID);
    Request.AddParameter('cid', FClientID);
    Request.AddParameter('t', 'appview');
    Request.AddParameter('an', FAppName);
    Request.AddParameter('av', FAppVersion);
    Request.AddParameter('cd', Value);
    Request.Client := FHttpClient;
    Request.Execute;
  finally
    Request.Free;
  end;
end;

end.

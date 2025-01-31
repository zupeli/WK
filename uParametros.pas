unit uParametros;

interface

type
  TParametro = class

  private
    FPort: String;
    FCaminhoDll: String;
    FDatabase: String;
    FServer: String;
    FPassword: String;
    FUserName: String;
//  class var UserName   : string;
//  class var Server     : string;
//  class var Database   : string;
//  class var CaminhoDll : string;
//  class var Porta       : string;
//  class var Password   : string;

    procedure SetPort(const Value: String);
    procedure SetCaminhoDll(const Value: String);
    procedure setDatabase(const Value: String);
    procedure setServer(const Value: String);
    procedure setPassword(const Value: String);
    procedure SetUserName(const Value: String);

  Public
//   class procedure setUserName(pParam :string);
//   class procedure setDatabase(pParam :string);
//   class procedure setServer(pParam :string);
//   class procedure setPort(pParam :string);
//   class procedure setPassword(pParam :string);
//   class procedure setCaminhoDll(pParam :string);

   property UserName   : String  read FUserName    write SetUserName;
   property Port       : String  read FPort        write SetPort;
   property Database   : String  read FDatabase    write setDatabase;
   property Server     : String  read FServer      write setServer;
   property Password   : String  read FPassword    write setPassword;
   property CaminhoDll : String  read FCaminhoDll  write SetCaminhoDll;

  end;

implementation

{ TParametro }

procedure TParametro.SetCaminhoDll(const Value: String);
begin
  FCaminhoDll := Value;
end;

procedure TParametro.setDatabase(const Value: String);
begin
  FDatabase := Value;
end;

procedure TParametro.setPassword(const Value: String);
begin
  FPassword := Value;
end;

procedure TParametro.SetPort(const Value: String);
begin
  FPort := Value;
end;


procedure TParametro.setServer(const Value: String);
begin
  FServer := Value;
end;

procedure TParametro.SetUserName(const Value: String);
begin
  FUserName := Value;
end;

end.

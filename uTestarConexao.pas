unit uTestarConexao;

interface

type
  TConexao = class

   Public
     function StatusConexao:string;
  end;

implementation

uses
  System.SysUtils, uDataModule;

function TConexao.StatusConexao:string;
var
  DM : TDM;
begin
  DM := TDM.Create(nil);

  if DM.FDConnection.Connected then
  begin
    Result := 'Status Conexao: Conectado';
  end
  else
  begin
    result := 'Status Conexao: Desconectado';
  end;
  FreeAndNil(DM);
end;

end.

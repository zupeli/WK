{ok}
unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, IniFiles, Vcl.StdCtrls, uParametros, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, Vcl.ExtCtrls;

type
  TfrPrincipal = class(TForm)
    lbStatus: TLabel;
    btnPedido: TBitBtn;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    btPedidosCliente: TBitBtn;
    cdsPedidoCliente: TClientDataSet;
    dtsPedidoCliente: TDataSource;
    cdsPedidoClienteid_cliente: TIntegerField;
    cdsPedidoClienteds_nome: TStringField;
    cdsPedidoClienteds_produto: TStringField;
    cdsPedidoClienteid_pedido: TIntegerField;
    cdsPedidoClienteqt_item: TIntegerField;
    Button1: TButton;
    cdsPedidoClientevl_unitario: TStringField;
    cdsPedidoClientevl_total: TStringField;
    cdsPedidoClientedt_pedido: TDateTimeField;
    lb_cliente: TLabel;
    TotalGeral: TPanel;
    TotalUnitario: TPanel;
    TotalQtd: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPedidoClick(Sender: TObject);
    procedure btPedidosClienteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cdsPedidoClientedt_pedidoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FIdCliente: integer;
    FNomeCliente: string;
    procedure conexaoIni;
    function getCaminhoINI: string;
    procedure conexao;
    procedure getCliente;
    procedure Pedido(pIdCliente : integer);
    procedure PedidosCliente(pIdCliente: integer);
    { Private declarations }
  public
    { Public declarations }
    property IdCliente   : integer  read FIdCliente    write FIdCliente;
    property NomeCliente : string   read FNomeCliente  write FNomeCliente;
  end;

var
  frPrincipal: TfrPrincipal;
  fObjParam : TParametro;

implementation

{$R *.dfm}

uses
  Vcl.Dialogs, uCliente, uPedido, uPedidosCliente, uTestarConexao;

function TfrPrincipal.getCaminhoINI:string;
var
  vArquivoINI : TIniFile;
  vCaminhoAux : string;
begin
  vCaminhoAux := ExtractFilePath(Application.ExeName);
  Result      := '';

  vCaminhoAux := ExcludeTrailingPathDelimiter(ExtractFileDir(ExtractFilePath(vCaminhoAux)));
  vCaminhoAux := ExcludeTrailingPathDelimiter(ExtractFileDir(ExtractFilePath(vCaminhoAux)));
  vCaminhoAux := ExcludeTrailingPathDelimiter(ExtractFileDir(ExtractFilePath(vCaminhoAux)));
  vCaminhoAux := IncludeTrailingPathDelimiter(vCaminhoAux);
  if FileExists(vCaminhoAux + 'conexao.ini') then
  begin
    Result := vCaminhoAux + 'conexao.ini';
  end;

end;


procedure TfrPrincipal.getCliente;
var
 vObjCliente : TfrmCliente;
begin
 vObjCliente := TfrmCliente.Create(nil);

  try
    vObjCliente.ShowModal;
    IdCliente   := vObjCliente.IdCliente;
    NomeCliente := vObjCliente.NomeCliente;
    if FIdCliente > 0 then
    begin
      // Buscar os pedidos do cliente.
      PedidosCliente(IdCliente);
      lb_cliente.Visible := True;
      lb_cliente.Caption := 'Cliente selecionado: ' + FNomeCliente;
    end;
  finally
    FreeAndNil(vObjCliente);
  end;
end;


procedure TfrPrincipal.PedidosCliente(pIdCliente: integer);
var
  vObjCliente : TCLiente;
  vQtd   : Integer;
  vVlTot : Extended;
  vVlUni : Extended;

begin
  vObjCliente := TCLiente.Create;
  try
    cdsPedidoCliente.Data := vObjCliente.getPedidosCliente(pIdCliente);
    vObjCliente.getTotalizadorCliente(pIdCliente, vQtd, vVlTot, vVlUni);
    TotalQtd.Caption       := IntToStr(vQtd);
    TotalUnitario.Caption  := FormatFloat('R$ #.##', vVlUni);
    TotalGeral.Caption     := FormatFloat('R$ #.##', vVlTot);
  finally
    FreeAndNil(vObjCliente);
  end;
end;

procedure TfrPrincipal.Pedido(pIdCliente : integer);
var
 vObjPedido : TfrmPedido;
begin
 vObjPedido := TfrmPedido.Create(nil);

 try
   vObjPedido.IdCliente   := pIdCliente;
   vObjPedido.NomeCliente := FNomeCliente;
   vObjPedido.ShowModal;
 finally
   FreeAndNil(vObjPedido);
 end;
end;

procedure TfrPrincipal.btnPedidoClick(Sender: TObject);
begin
  if FIdCliente = 0 then
  begin
    getCliente;
  end;

  if FIdCliente > 0 then
  begin
    Pedido(FIdCliente);
    PedidosCliente(IdCliente); // Atualizar os pedidos do cliente
  end;

end;

procedure TfrPrincipal.conexaoIni;
var
  ArquivoINI: TIniFile;
  vCaminhoINI : string;
begin
  vCaminhoINI := getCaminhoINI;
  if vCaminhoINI <> '' then
  begin
    try
      ArquivoINI  := TIniFile.Create(vCaminhoINI);
      fObjParam.UserName   := ArquivoINI.ReadString('MYSQL', 'username', ''); 
      fObjParam.Server     := ArquivoINI.ReadString('MYSQL', 'server',   ''); 
      fObjParam.Database   := ArquivoINI.ReadString('MYSQL', 'database', ''); 
      fObjParam.Password   := ArquivoINI.ReadString('MYSQL', 'password', ''); 
      fObjParam.Port       := ArquivoINI.ReadString('MYSQL', 'port',     ''); 
      fObjParam.CaminhoDll := ArquivoINI.ReadString('MYSQL', 'dll',      ''); 
    Except
      MessageDlg('Erro ao ler o arquivo de conexão INI.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK],0);
    end;
    ArquivoINI.Free;
    
  end
  else
  begin
    MessageDlg('Arquivo de coneção INI não foi encontrado na pasta!', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK],0);
  end;

  try
   Conexao;    
  except
    MessageDlg('Não foi possivel estabelecer conexão!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK],0);
  end;
end;

procedure TfrPrincipal.btPedidosClienteClick(Sender: TObject);
begin
  getCliente;
end;

procedure TfrPrincipal.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TfrPrincipal.cdsPedidoClientedt_pedidoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if (Sender.AsString <> '') and (Sender.Value <> null) then
  begin
    Text := FormatDateTime('dd/mm/yyyy', Sender.Value);
  end;
end;

procedure TfrPrincipal.conexao;
var
  vObjConn : TConexao;
begin
  vObjConn := TConexao.Create;
  try
    lbStatus.Caption := vObjConn.StatusConexao;
  finally
    FreeAndNil(vObjConn);
  end;
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  fObjParam := TParametro.Create;  
end;

procedure TfrPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fObjParam);
end;

procedure TfrPrincipal.FormShow(Sender: TObject);
begin
  cdsPedidoCliente.CreateDataSet;
  conexaoIni;
end;

end.

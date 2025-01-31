program PedidosVenda;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frPrincipal},
  uDataModule in 'uDataModule.pas' {DM: TDataModule},
  uParametros in 'uParametros.pas',
  uCliente in 'uCliente.pas' {frmCliente},
  uPedido in 'uPedido.pas' {frmPedido},
  uPedidosCliente in 'uPedidosCliente.pas',
  uTestarConexao in 'uTestarConexao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.

unit uPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Datasnap.DBClient;

type
  TfrmPedido = class(TForm)
    btSalvar: TButton;
    btCancelar: TButton;
    GroupBox1: TGroupBox;
    DBGridProdutos: TDBGrid;
    gbxPedido: TGroupBox;
    DBGridItensPedido: TDBGrid;
    cdsProdutos: TClientDataSet;
    dtsProdutos: TDataSource;
    cdsProdutosid_produto: TIntegerField;
    cdsProdutosds_produto: TStringField;
    cdsProdutosqt_produto: TIntegerField;
    btAddItem: TButton;
    btRemoverItem: TButton;
    edProduto: TEdit;
    edQtdProduto: TEdit;
    edValorProduto: TEdit;
    cdsProdutosvl_produto: TStringField;
    edCodigoProduto: TEdit;
    cdsItens: TClientDataSet;
    dtsItens: TDataSource;
    cdsItensid_produto: TIntegerField;
    cdsItensds_produto: TStringField;
    cdsItensqt_produto: TIntegerField;
    cdsItensvl_unitario: TFloatField;
    cdsItensvl_total: TFloatField;
    DBGridTotalizador: TDBGrid;
    cdsSoma: TClientDataSet;
    dtsSoma: TDataSource;
    cdsSomaid_pedido: TIntegerField;
    cdsSomads_produto: TStringField;
    cdsSomaqt_produto: TIntegerField;
    cdsSomavl_unitario: TFloatField;
    cdsSomavl_total: TFloatField;
    procedure btCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridProdutosCellClick(Column: TColumn);
    procedure edQtdProdutoChange(Sender: TObject);
    procedure btAddItemClick(Sender: TObject);
    procedure edQtdProdutoExit(Sender: TObject);
    procedure edCodigoProdutoChange(Sender: TObject);
    procedure edCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodigoProdutoClick(Sender: TObject);
    procedure btRemoverItemClick(Sender: TObject);
    procedure DBGridItensPedidoColEnter(Sender: TObject);
    procedure DBGridItensPedidoDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGridProdutosDblClick(Sender: TObject);
    procedure cdsItensqt_produtoValidate(Sender: TField);
    procedure cdsItensvl_unitarioValidate(Sender: TField);
    procedure btSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridItensPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridItensPedidoKeyPress(Sender: TObject; var Key: Char);
  private
    FIdCliente: integer;
    FNomeCliente: string;
    procedure getProdutos;
    function converterFloat(pValor: String): Extended;
    function recalcularValorTotal(pVlProduto: extended;
      pQtdProduto: integer): string;
    procedure limpar;
    procedure Totalizador;
    procedure atualizarEstoque(pIdProduto, pQtdProduto : integer; pAdicao : boolean);
    procedure adicionarItens;
    procedure InserirItensPedido;
    procedure removerItemSelecionado;
    { Private declarations }
  public
    { Public declarations }
    property IdCliente   : integer  read FIdCliente    write FIdCliente;
    property NomeCliente : string   read FNomeCliente  write FNomeCliente;
  end;

var
  frmPedido: TfrmPedido;

implementation

uses
  uPedidosCliente;

{$R *.dfm}

Procedure TfrmPedido.Totalizador;
var
  vQtd : integer;
  vVlUnitario : Extended;
  vVlTotal    : Extended;
begin
  if (not cdsItens.IsEmpty) then
  begin
    vQtd        := 0;
    vVlUnitario := 0;
    vVlTotal    := 0;

    cdsItens.First;
    cdsItens.DisableConstraints;
    while not cdsItens.Eof do
    begin
      vQtd        := vQtd         + cdsItensqt_produto.AsInteger;
      vVlUnitario := vVlUnitario + cdsItensvl_unitario.AsFloat;
      vVlTotal    := vVlTotal    + cdsItensvl_total.AsFloat;
      cdsItens.Next;
    end;
    cdsItens.EnableConstraints;
    cdsSoma.EmptyDataSet;
    cdsSoma.Append;
    cdsSomads_produto.AsString  := 'SOMATÓRIO TOTAL:';
    cdsSomaqt_produto.AsInteger := vQtd;
    cdsSomavl_unitario.AsFloat  := vVlUnitario;
    cdsSomavl_total.AsFloat     := vVlTotal;
    cdsSoma.Post;

  end;
end;

procedure TfrmPedido.btAddItemClick(Sender: TObject);
begin
  adicionarItens;
end;

procedure TfrmPedido.adicionarItens;
begin
  if StrToIntDef(edQtdProduto.Text,1) > (cdsProdutosqt_produto.AsInteger) then
  begin
    MessageDlg('A quantidade informada é maior que a disponível no estoque!', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK],0);
    exit;
  end;

  if StrToIntDef(edQtdProduto.Text,0) > 0 then
  begin
    if (edProduto.Text <> '') and (not cdsProdutos.IsEmpty) then
    begin
      cdsItens.Append;
      cdsItensid_produto.AsInteger := cdsProdutosid_produto.AsInteger;
      cdsItensds_produto.AsString  := cdsProdutosds_produto.AsString;
      cdsItensqt_produto.AsInteger := StrToIntDef(edQtdProduto.Text,1);
      cdsItensvl_unitario.AsFloat  := converterFloat(cdsProdutosvl_produto.AsString);
      cdsItensvl_total.AsFloat     := StrToFloatDef(edValorProduto.Text,0);
      cdsItens.Post;

      atualizarEstoque(cdsProdutosid_produto.AsInteger, StrToIntDef(edQtdProduto.Text,1), False);
      getProdutos;
      Totalizador;
    end;
  end;
end;

procedure TfrmPedido.atualizarEstoque(pIdProduto, pQtdProduto : integer; pAdicao : boolean);
var
  vOjbProdutos : TProdutos;
begin
  vOjbProdutos := TProdutos.Create;
  try
    vOjbProdutos.AtualizarEstoqueProduto(pIdProduto, pQtdProduto, pAdicao);
  finally
    FreeAndNil(vOjbProdutos);
  end;
end;


procedure TfrmPedido.btCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPedido.removerItemSelecionado;
begin
  if not cdsItens.IsEmpty then
  begin
    if MessageDlg(pchar('Deseja remover o item "' + cdsItensds_produto.AsString + '" ?'), TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],0) = mrYes then
    begin
      atualizarEstoque(cdsItensid_produto.AsInteger, cdsItensqt_produto.AsInteger, True);
      cdsItens.Delete;
      Totalizador;
      getProdutos;
    end;
  end;
end;

procedure TfrmPedido.btRemoverItemClick(Sender: TObject);
begin
  removerItemSelecionado;
end;

procedure TfrmPedido.btSalvarClick(Sender: TObject);
begin
  InserirItensPedido;
end;

procedure TfrmPedido.DBGridItensPedidoColEnter(Sender: TObject);
begin
  if DBGridItensPedido.SelectedIndex = 2 then
  begin
    DBGridItensPedido.Columns[2].ReadOnly := False;
    DBGridItensPedido.Columns[3].ReadOnly := False;
    //DBGridItensPedido.Options := DBGridItensPedido.Options + [dgEditing];
  end
  else
  begin
    DBGridItensPedido.Columns[0].ReadOnly := True;
    DBGridItensPedido.Columns[1].ReadOnly := True;
    DBGridItensPedido.Columns[4].ReadOnly := True;
  end;

end;

procedure TfrmPedido.DBGridItensPedidoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Rect.Top = TStringGrid(DBGridItensPedido).CellRect(0, TStringGrid(DBGridItensPedido).Row).Top then
  begin
    DBGridItensPedido.Canvas.FillRect(Rect);
    DBGridItensPedido.Canvas.Font.Color  := clWhite;
    DBGridItensPedido.Canvas.Brush.Color := clHighlight;
    DBGridItensPedido.DefaultDrawDataCell(Rect, Column.Field, State)
  end;
end;

procedure TfrmPedido.DBGridItensPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if DBGridItensPedido.SelectedIndex in [2,3] then
  begin
    if (cdsItens.State In [dsEdit]) then
    begin
      if (key = vk_up) or (key = vk_down) then
      begin
        atualizarEstoque(cdsItensid_produto.AsInteger, cdsItensqt_produto.AsInteger, True);
        cdsItensvl_total.AsFloat := StrToFloatDef(recalcularValorTotal(cdsItensvl_unitario.AsFloat, cdsItensqt_produto.AsInteger),0);
        cdsItens.Post;
        getProdutos;
        Totalizador;
      end;
    end;
  end;

  if (key = vk_delete) then
  begin
    key := VK_ESCAPE;
    removerItemSelecionado;
  end;
end;

procedure TfrmPedido.DBGridItensPedidoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then  // enter
  begin
    if DBGridItensPedido.SelectedIndex in [2,3] then
    begin
      if (cdsItens.State In [dsEdit]) then
      begin
        cdsItensvl_total.AsFloat := StrToFloatDef(recalcularValorTotal(cdsItensvl_unitario.AsFloat, cdsItensqt_produto.AsInteger),0);
        cdsItens.Post;
        atualizarEstoque(cdsItensid_produto.AsInteger, cdsItensqt_produto.AsInteger, True);
        getProdutos;
        Totalizador;
      end;
    end;
  end;

end;

procedure TfrmPedido.DBGridProdutosCellClick(Column: TColumn);
begin
  cdsProdutos.Tag      := 1;
  edCodigoProduto.Text := cdsProdutosid_produto.AsString;
  edProduto.Text       := cdsProdutosds_produto.AsString;
  edQtdProduto.Text    := '1';
  edValorProduto.Text  := FormatFloat('#.##', converterFloat(cdsProdutosvl_produto.AsString));
end;

procedure TfrmPedido.DBGridProdutosDblClick(Sender: TObject);
begin
  adicionarItens;
end;

procedure TfrmPedido.cdsItensqt_produtoValidate(Sender: TField);
begin
  if sender.AsString = '' then
  begin
    Abort;
  end;
end;

procedure TfrmPedido.cdsItensvl_unitarioValidate(Sender: TField);
begin
  if sender.AsString = '' then
  begin
    Abort;
  end;
end;

function TfrmPedido.converterFloat(pValor : String):Extended;
var
  vValor : string;
begin
  vValor := StringReplace(pValor, '.', ',', [rfReplaceAll]);
  Result := StrToFloatDef(vValor,0);
end;

procedure TfrmPedido.edCodigoProdutoChange(Sender: TObject);
begin
  if cdsProdutos.Tag = 0 then
  begin
    cdsProdutos.Filtered := False;
    if edCodigoProduto.Text <> '' then
    begin
      cdsProdutos.Filter := 'id_produto = ' + edCodigoProduto.Text;
      cdsProdutos.Filtered := True;
    end
    else
    begin
      edProduto.Text      := '';
      edQtdProduto.Text   := '';
      edValorProduto.Text := '';
    end;
  end;
end;

procedure TfrmPedido.edCodigoProdutoClick(Sender: TObject);
begin
  cdsProdutos.Tag      := 0;
end;

procedure TfrmPedido.edCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edCodigoProduto.Text <> '' then
  begin
    if Key = VK_RETURN then
    begin
      edProduto.Text      := cdsProdutosds_produto.AsString;
      edQtdProduto.Text   := '1';
      edValorProduto.Text := FormatFloat('#.##', converterFloat(cdsProdutosvl_produto.AsString));
      edQtdProduto.SetFocus;
    end;
  end;
end;

function TfrmPedido.recalcularValorTotal(pVlProduto : extended; pQtdProduto : integer):string;
begin
  Result := '';
  if pQtdProduto <> 0 then
  begin
    if pQtdProduto > 0 then
    begin
      Result := FloatToStr(pVlProduto * pQtdProduto);
    end;
  end;
end;

procedure TfrmPedido.edQtdProdutoChange(Sender: TObject);
var
  vValorProduto : Extended;
begin
  if edProduto.Text <> '' then
  begin
    vValorProduto := converterFloat(cdsProdutosvl_produto.AsString);
    edValorProduto.Text := recalcularValorTotal(vValorProduto, StrToIntDef(edQtdProduto.Text,0));
  end;
end;

procedure TfrmPedido.edQtdProdutoExit(Sender: TObject);
begin
  if edQtdProduto.Text = '' then
  begin
    edQtdProduto.Text := '1';
  end;

  if StrToIntDef(edQtdProduto.Text,1) > (cdsProdutosqt_produto.AsInteger) then
  begin
    MessageDlg('A quantidade informada é maior que a disponível no estoque!', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK],0);
    edQtdProduto.SetFocus;
  end;
end;

procedure TfrmPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not cdsItens.IsEmpty then
  begin
    cdsItens.First;
    while not cdsItens.Eof do
    begin
      atualizarEstoque(cdsItensid_produto.AsInteger, cdsItensqt_produto.AsInteger, True);
      cdsItens.Next;
    end;
    cdsItens.EmptyDataSet;
  end;
end;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  IdCliente := 0;
  cdsProdutos.CreateDataSet;
  cdsItens.CreateDataSet;
  cdsSoma.CreateDataSet;
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  cdsProdutos.EmptyDataSet;
  cdsItens.EmptyDataSet;
  cdsSoma.EmptyDataSet;
end;

procedure TfrmPedido.FormShow(Sender: TObject);
begin
  Caption := Caption + ' - ' + FNomeCliente;
  getProdutos;
end;

Procedure TfrmPedido.limpar;
begin
  cdsProdutos.Filtered := False;
  edProduto.Text       := '';
  edCodigoProduto.Text := '';
  edValorProduto.Text  := '';
  edQtdProduto.Text    := '';
end;

procedure TfrmPedido.getProdutos;
var
  vOjbProdutos : TProdutos;
  vRec : integer;
begin
  vRec := 1;
  if not cdsProdutos.IsEmpty then
  begin
    vRec := cdsProdutos.RecNo;
  end;

  limpar;
  vOjbProdutos := TProdutos.Create;
  try
    cdsProdutos.Data  := vOjbProdutos.getProdutos;
    cdsProdutos.RecNo := vRec;
  finally
    FreeAndNil(vOjbProdutos);
  end;
end;

procedure TfrmPedido.InserirItensPedido;
var
  vOjbPedidos : TPedidos;
begin
  vOjbPedidos := TPedidos.Create;

  try
    vOjbPedidos.inserirPedido(FIdCliente, cdsSomavl_total.AsFloat, cdsItens.Data);
    FreeAndNil(vOjbPedidos);
    MessageDlg('Pedido inserido com sucesso!', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0);
    cdsItens.EmptyDataSet;
    cdsSoma.EmptyDataSet;
  except
    MessageDlg('Erro ao inserir o pedido!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK],0);
  end;


end;

end.

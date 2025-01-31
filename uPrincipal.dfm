object frPrincipal: TfrPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Principal'
  ClientHeight = 406
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object lbStatus: TLabel
    Left = 8
    Top = 377
    Width = 108
    Height = 20
    Caption = 'Status Conexao'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb_cliente: TLabel
    Left = 474
    Top = 16
    Width = 142
    Height = 20
    Alignment = taRightJustify
    Caption = 'Cliente selecionado: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object btnPedido: TBitBtn
    Left = 143
    Top = 16
    Width = 129
    Height = 65
    Caption = 'Novo Pedido'
    TabOrder = 0
    OnClick = btnPedidoClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 87
    Width = 612
    Height = 281
    Caption = 'Pedidos do Cliente'
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 9
      Top = 18
      Width = 596
      Height = 227
      DataSource = dtsPedidoCliente
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'id_pedido'
          Title.Alignment = taCenter
          Title.Caption = 'Pedido'
          Width = 45
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'id_cliente'
          Title.Alignment = taCenter
          Title.Caption = 'Cliente'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'ds_nome'
          Title.Caption = 'Cliente'
          Width = 105
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ds_produto'
          Title.Caption = 'Produto'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dt_pedido'
          Title.Caption = 'Dt.Pedido'
          Width = 70
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'qt_item'
          Title.Alignment = taCenter
          Title.Caption = 'Qtd.'
          Width = 50
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'vl_unitario'
          Title.Alignment = taRightJustify
          Title.Caption = 'Vl.Unitario'
          Width = 70
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'vl_total'
          Title.Alignment = taRightJustify
          Title.Caption = 'Vl.Total'
          Width = 90
          Visible = True
        end>
    end
    object TotalGeral: TPanel
      Left = 492
      Top = 251
      Width = 88
      Height = 24
      Caption = 'R$ 0,00'
      TabOrder = 1
    end
    object TotalUnitario: TPanel
      Left = 418
      Top = 251
      Width = 68
      Height = 24
      Caption = 'R$ 0,00'
      TabOrder = 2
    end
    object TotalQtd: TPanel
      Left = 363
      Top = 251
      Width = 50
      Height = 24
      Caption = '0'
      TabOrder = 3
    end
  end
  object btPedidosCliente: TBitBtn
    Left = 8
    Top = 16
    Width = 129
    Height = 65
    Caption = 'Pedidos do Cliente'
    TabOrder = 2
    OnClick = btPedidosClienteClick
  end
  object Button1: TButton
    Left = 545
    Top = 373
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = Button1Click
  end
  object cdsPedidoCliente: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 184
    Top = 280
    object cdsPedidoClienteid_cliente: TIntegerField
      FieldName = 'id_cliente'
    end
    object cdsPedidoClienteds_nome: TStringField
      FieldName = 'ds_nome'
      Size = 200
    end
    object cdsPedidoClienteds_produto: TStringField
      FieldName = 'ds_produto'
      Size = 200
    end
    object cdsPedidoClienteid_pedido: TIntegerField
      FieldName = 'id_pedido'
    end
    object cdsPedidoClienteqt_item: TIntegerField
      FieldName = 'qt_item'
    end
    object cdsPedidoClientevl_unitario: TStringField
      FieldName = 'vl_unitario'
      Size = 15
    end
    object cdsPedidoClientevl_total: TStringField
      FieldName = 'vl_total'
      Size = 15
    end
    object cdsPedidoClientedt_pedido: TDateTimeField
      FieldName = 'dt_pedido'
      OnGetText = cdsPedidoClientedt_pedidoGetText
    end
  end
  object dtsPedidoCliente: TDataSource
    DataSet = cdsPedidoCliente
    Left = 272
    Top = 280
  end
end

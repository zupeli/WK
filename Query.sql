create database baseDados;

CREATE TABLE clientes (
 id_cliente integer primary key auto_increment,
 ds_nome varchar(150) NOT NULL,
 ds_cidade varchar(200) NOT NULL,
 ds_uf varchar(2) NOT NULL 
 );
 
insert into clientes (ds_nome, ds_cidade, ds_uf) values('Fulano', 'Ruo de Janeiro', 'RJ');
insert into clientes (ds_nome, ds_cidade, ds_uf) values('Sousa', 'São Paulo', 'SP');
insert into clientes (ds_nome, ds_cidade, ds_uf) values('Maria', 'Vila Velha', 'ES');
 
 
CREATE TABLE produtos(
 id_produto integer primary key auto_increment,
 ds_produto varchar(200) NULL,
 qt_produto int NULL,
 vl_produto decimal(9,2)
 );
 
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Abacaxi', 47, 18.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Acerola', 36, 18.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Amora', 19, 20.30);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Banana', 55, 15.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Beterraba', 26, 15.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Caju', 65, 12.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Cenoura', 48, 18.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Coco', 12, 19.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Cupuaçu', 5, 25.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Frutas Vermelhas', 32, 25.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Limão', 77, 15.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Maça', 15, 18.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Mamão', 15, 18.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Manga', 15, 18.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Maracujá', 52, 15.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Melancia', 5, 19.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Melão', 14, 19.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Morango', 41, 19.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Tamarindo', 36, 22.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Uva', 88, 16.50);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Goiaba', 20, 15.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Laranja', 99, 12.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Tangerina', 30, 15.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Pessego', 15, 19.90);
 insert into produtos (ds_produto, qt_produto, vl_produto) values('Suco de Pera', 40, 19.90);
 
create table pedidos(
    id_pedido    integer primary key auto_increment,
	id_cliente   integer,    
	dt_pedido    datetime,
	vl_total     decimal(9,2),	
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);


create table pedido_item(
    id_item      integer primary key auto_increment,
    id_pedido    integer,
	id_produto   integer,
	qt_item      integer,
	vl_unitario  decimal(9,2),
	vl_total     decimal(9,2),
	
	FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
	FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);
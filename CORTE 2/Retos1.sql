## crear una tabla llamada tienda_online y seleccionala para usarla 
create database tienda_online;
use tienda_online;

create table Producto(
idProducto int auto_increment primary key,
nombreProducto varchar(45) not null,
precioProducto double not null,
stockProducto int not null,
fechaCreacion datetime default current_timestamp);

create table Clientes(
idCliente int primary key auto_increment,
nombreCliente varchar(100) not null,
emailCliente varchar(120) unique,
telefonoCliente varchar(10));

create table Pedidos(
idPedido int primary key auto_increment,
idClienteFK int,
fechaPedido datetime,
totalPedido double not null);

## realciones entre pedidos y clientes
alter table Pedidos
add constraint FKClientePedidos
foreign key (idClienteFK)
references Clientes(idCliente);

SHOW CREATE TABLE Clientes;
SHOW CREATE TABLE Pedidos;


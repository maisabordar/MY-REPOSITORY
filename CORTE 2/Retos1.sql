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
idCliente int not null,
nombreCliente varchar(100) not null,
emailCliente varchar(120) not null,
telefonoCliente varchar(10));

create table Pedidos(
idPedido int not null,
idClienteFK int,
fechaPedido datetime,
totalPedido double not null);

## realciones entre pedidos y clientes
alter table Clientes
add constraint 
foreign key
references ;

alter table seguros
add constraint FKSegurosAutomovil
foreign key(idAutomovilFK)
references automovil(idauto);
alter table Producto 
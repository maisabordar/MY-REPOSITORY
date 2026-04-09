create database if not exists tiendaOnline;
use tiendaOnline;

## sentencia: es un transacción
## 0. es crear la estructura de la BD (modelo físico-diccionario de datos)
## 1. DATOS PUROS O LIMPIOS (ETL)
## 2. Manipulacion de datos (hacer registros, consultar registros, modificar registros, eliminar registros)
## un logica transaccional (sentencias) (indicacion orden una petición transacción) MySQL SQL

## trabajar sobre el contenido
## Transaccional: Crear-Insertar Agregar registros (insert)
## Modificar actualizar (Update)
## Consultas sobre la BD (Select)
## Eliminar (Delete)

create table clientes(
idCliente int primary key auto_increment,
nombreCliente varchar(100) not null,
emailCliente varchar(150) unique,
ciudad varchar(80) null,
creado_en datetime default now()
);

create table productos(
idProducto int primary key auto_increment,
nombreProducto varchar(120) not null,
precioProducto decimal(10,2),
## toma 10 cifras antes del decimal y luego del decimal dos cifras
stockProducto int default 0,
categoriaProducto varchar(60)
);

## la tabla pedido no se puede pedri antes que las otras porque no habría con quien generar relación
create table pedido(
idPedido int primary key auto_increment,
cantidadProducto int not null,
fechaPedido date,
idClienteFK int,
idProductoFK int,
foreign key (idClienteFK) references clientes(idCliente),
foreign key (idProductoFK) references productos(idProducto)
);

create table cliente_cbackup (
idClienBack int primary key auto_increment,
nombreCliente varchar(100) ,
emailCliente varchar(150),
copiado_en datetime default now()
);

## select consulta general de las tablas 
select * from clientes;

select * from productos;

select * from pedido;


-- Inserciones insert into nombre_tabla (campos1,campo2,campo3,...) values (valor1,valor2,valor3,...)
-- si el campo es varchar va entre comillas
-- si el campo es autoincrement s debe enviar el campo sin valor ''
-- si el campo es una fecha debe revisar el formato


describe clientes;
## insert into clientes(idCliente,nombreCliente,emailCliente,ciudad, creado_en) 
## idCliente ' ' pq es autoincrementado, y como lo deje en valor va '' 
## creado_en no se pone pq por default ya esta, toma la fecha de hoy 
## insert into clientes(idCliente,nombreCliente,emailCliente,ciudad) values ('','Ana Garcia','ana@mail.com','Madrid');
insert into clientes(nombreCliente,emailCliente,ciudad) values ('Pedro Perez','pedro@mail.com','Barcelona');
 select * from clientes;
## varias inserciones
describe productos;
insert into productos (nombreProducto,precioProducto,stockProducto,categoriaProducto)
values ('Laptop Pro',1200000,15,'Electrónica'), 
('Mouse USB',50000,80,'Accesorios'),
('Monitor 32"',500000,20,'Electrónica'),
('Teclados',100000,35,'Accesorios');

select * from productos;

insert into cliente_backup (nombreCliente,emailCliente)
select nombreCliente,emailCliente
from clientes
where creado_en<'2026-03-26';

rename table cliente_cbackup to cliente_backup;

select * from cliente_backup;

describe cliente_backup;

-- Update 
-- update nombreTabla set columna1=valor1,columna2=valor2,.... where condicion
select * from clientes;
-- Actualizar un campo
update clientes
set ciudad='Valencia'
where idCliente=1;

-- Actualizar varios campos
select * from productos;

update productos
set
precioProducto=1099000,
stockProducto=10
where idProducto=1;

update productos
set precioProducto=precioProducto * 1.10
where categoriaProducto='Accesorios';

select * from clientes;
delete from clientes 
where idCliente=2;

select * from productos;
delete from productos
where stockProducto=0 AND categoriaProducto='Descatalogado';

/* INSERT
1. Inserta 3 clientes nuevos con nombre, email y ciudad
2. Inserta 2 productos con nombre, precio, stock y categoría
3. Inserta 1 pedido vinculando un cliente y un producto recién creados
UPDATE
4. Cambia la ciudad de uno de tus clientes insertados
5. Aumenta en 5 unidades el stock de uno de tus productos
6. Modifica el precio del segundo producto aplicando un descuento del 10%
DELETE
7. Elimina el pedido que creaste en el punto 3
8. Elimina el cliente cuya ciudad cambiaste en el punto 4
9. Elimina todos los productos con stock menor a 3

*/


insert into clientes(nombreCliente,emailCliente,ciudad)
values ('Sara Florian', 'sara@mail.com','Cali'), 
('Daniela Mejia','dani@mail.com','Guajira'),
('Ivanna Castro','nanna@mail.com','Valledupar'),
('Daniela Silva','danny@mail.com','Chía');
select * from clientes;

insert into productos(nombreProducto,precioProducto,stoProdT,categoriaProducto)
values ('Audifonos',2500000,6,'Accesorios'), 
('Adaptador USB',80000,45,'Accesorios');

select * from productos;

insert into pedidos;

select * from pedidos;
 
update clientes
set ciudad='Bogotá'
where idCliente=3;

update productos
set precioProducto=precioProducto * 1.10
where categoriaProducto='Accesorios';

SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;

use tiendaOnline;
describe productos;
alter table productos change stockProducto stoProdT int;

## sentencias para consultas
select * from productos;
select nombreProducto, stoProdT from productos;
## alias
## no cambia el nombre de la tabla, solo de manera visual
select nombreProducto as Nombre_producto, stoProdT as stock from productos;

select nombreProducto, stoProdT from productos where idProducto=1;
select nombreProducto as Nombre_Producto, stoProdT as stock from productos where stoProdT > 10;

select nombreProducto as Nombre_Producto, stoProdT as stock
from productos
where stoProdT < 50 and nombreProducto= 'Laptop Pro';

## select campos from nombre_tabla order by campo_a_ordenar formaOrden(ASC DESC)
select nombreProducto as Nombre_Producto, stoProdT as stock
from productos order by nombreProducto DESC;
select nombreProducto as Nombre_Producto, stoProdT as stock
from productos order by nombreProducto ASC;

select nombreProdcuto as Nombre_Producto, stoProdT as stock from productos where stoProdT >= 25 or idProdcuto=1;

## Between
## rango >> and
select * from productos;
select nombreProducto as Nombre_Producto, precioProducto as precio
 from productos where precioProducto between 500000 and 1000000 and stoProdT>3 order by precioProducto;

## Like >> incian que terminen o qeu contengan caracteres
## que incien
select * from productos where nombreProducto like 'm%';
## que contenga
## not >> los que no contegan
select * from productos where nombreProducto not like '%a%';
## que termine
## asc limit que limite en caso de tener muchos "producto"
select * from productos where nombreProducto like '%os' order by precioProducto asc limit 2;

## Tarea
## Carga de archivos 
## clientes
load data local infile '/Users/isabella/Downloads/clientes_real.csv'
into table clientes
fields terminated by ',' 
lines terminated by '/n'
ignore 1 rows;

## productos
load data local infile '/Users/isabella/Downloads/productos_real.csv '
into table productos
fields terminated by ',' 
lines terminated by '\n'
ignore 1 rows;

## pedidos
load data local infile '/Users/isabella/Downloads/pedidos_real.csv'
into table pedidos
fields terminated by ',' enclosed by ','
lines terminated by '/n'
ignore 1 rows;

set foreing_key_checks=0;
set foreing_key_checks=1;

describe clientes;
describe productos;
describe pedidos;

## Consulta
/* Obtener los nombres de los clientes que hayan realizado pedidos de productos 
pertenecientes a la categoría "Tecnologia" y cuyo precio sea menor al promedio 
de precios de todos los productos, utilizando subconsultas. */

select * from productos group by categoriaProducto;

select categoriaProducto,
count(*) as Cantidad,
avg (precioProducto) as promedioMedio
from productos
group by categoriaProducto
having avg (precioProducto)>50000;

## no se esta cambiando el tipo de datos 
select format (precioProducto,2,'es_CO') as precio
from prodcutos;

select * from clientes;
select
count(*) as Total,
avg(precioProducto) as PromedioPreciom,
max(precioProducto) as PrecioMaximo,
min(precioProducto) as PrecioMinimo,
sum(stoProT) as StockTotal
from productos;

describe clientes;

select nombreCliente as noombre,
upper(nombreCliente) AS NombreMayuscula,
concat('nombre Cliente: ',nombreCliente, 'email cliente: ',emailCliente) as concatenar
from clientes;

## Subconsulta
/* la consulta que mas se usa Select
	ademas puedo hacer una consulta dentro de una consulta 
    1. se lee la consulta exterior y luego la interior
    2. puede tener clausulas
    ejemplo: select col1, col2
			 from tabla_Principal
    (clusula)where columna operador
			(subconsulta)select col1, col2
						from tabla_Principal
				(clusula)where columna operador;
	3. tipos de subconsultas
		Escalar (devuleve un unico valor de fila o columna)
        de fila (devuelve una sola fila con varias columnas) Row()
        de tabla (devuleve una tabla, varios registros y varios campos, varias filas y varias columnas) from ()
        correlacional
        
*/

create table empleados(
idEmpleado int primary key auto_increment,
nombreEmpleado varchar(100) unique,
deptoId varchar(120) unique,
salario int(10));
 
ALTER TABLE empleados MODIFY idEmpleado INT NOT NULL;
ALTER TABLE empleados DROP PRIMARY KEY;
ALTER TABLE empleados ADD PRIMARY KEY (idEmpleado);
ALTER TABLE empleados MODIFY deptoId VARCHAR(120);
ALTER TABLE empleados DROP INDEX deptoId;
SHOW CREATE TABLE empleados;

create table producto(
idProducto int primary key auto_increment,
precioProducto decimal(10,2),
categoria varchar(80));

ALTER TABLE producto MODIFY precioProducto INT NOT NULL;

create table departamento(
idDepartamento int primary key auto_increment,
nombreDepartamento varchar(80));

ALTER TABLE departamento MODIFY idDepartamento INT NOT NULL;
ALTER TABLE departamento DROP PRIMARY KEY;

#Registrar 5 datos en empleados, 3 departamentos y 5 productos.
insert into empleados (idEmpleado, nombreEmpleado, deptoId, salario)
values 
('202938171', 'Juan Robles' , 'administracion' ,'10000000'), 
('458490345','Henry Quintero', 'finanzas' ,'8000000'),
('345867129', 'Constanza Villamarin' , 'servicio al cliente' ,'3000000'),
('879456132','Maria Cardozo' ,'servicio al cliente' ,'3000000'), 
('84629473','Carmen Vargas' ,'facturacion' ,'4500000');
select * from empleados;

insert into producto (precioProducto, categoria)
values
('20000','tecnologia'),
('3000000', 'tenologia'),
('50000', 'alimentos'),
('30000', 'aseo'),
('100000', 'asep');
select * from producto;

insert into departamento (idDepartamento, nombreDepartamento)
values
('111', 'administracion'),
('112', 'fianazas'),
('113', 'servicio al cliente'),
('114', 'facturacion');
DELETE FROM departamento
WHERE nombreDepartamento = 'fianazas';
DELETE FROM departamento
WHERE idDepartamento = 111
LIMIT 1; ##solo borra un elemento, sino se borran todos los elmentos que se ecuentran asi
DELETE FROM departamento
WHERE idDepartamento = 113
LIMIT 1;
DELETE FROM departamento
WHERE idDepartamento = 114;
insert into departamento (idDepartamento, nombreDepartamento)
values ('114', 'facturacion');
select * from departamento;


select nombreEmpleado, salario
from empleados
where salario>
	(select AVG(salario)
     from empleados);

## where_in
select nombreEmpleado, salario
from empleados
where deptoId in
	(select idDepartamento
     from departamento
     where nombreDepartamento in ('servicio al cliente')); 
     
SELECT * FROM departamento;
SELECT DISTINCT deptoId FROM empleados;

## tabla derivada, temporal, no se crea en la base de datos
select deptoId,prom_salario
from
	(select deptoId,AVG(salario)as prom_salario
    from empleados
    group by deptoId) as promedios
where prom_salario > 3000000;

## desviacion 
select precioProducto
from   (select precioProducto,
        AVG(precioProducto) as prom_precio,
		STDDEV(precioProducto) as desv_precio
        from producto
        group by precioProducto);
        
select nombreProducto, precioProducto as Producto, categoriaProducto
from productos
where precioProducto > (select AVG(precioProducto)from productos);

select * from productos;

create table pedidos(
idPedido int auto_increment primary key,
idCliente int not null,
fechaPedido datetime default now(),
estado enum('pediente','a timepo','entregado'),
total decimal(12,2) default 0,
foreign key (idEmpleado) references empleados(idempelado)
);



create table detalle_pedido (
  idDetalle int primary key auto_increment,
  idPedidoFK int not null,
  idProductoFK int not null,
  cantidad int not null,
  precioUnitario decimal(10,2) not null,
  subtotal decimal(10,2) generated always as (cantidad * precioUnitario) stored,

  constraint FKDetallePedido
    foreign key (idPedidoFK) references pedidos(idPedido)
    on update cascade
    on delete cascade,
    
    constraint FKDetalleProducto
		foreign key (idProductoFK) references productos(idProducto)
    );


INSERT INTO pedidos (idEmpleado, estado)
VALUES
(1, 'pendiente'),
(2, 'enviado');

select * from pedidos;

INSERT INTO detalle_pedido (idPedidoFK, idProductoFK, cantidad, precioUnitario)
VALUES
(1, 1, 1, 1200000),
(1, 2, 2, 50000);

INSERT INTO detalle_pedido (idPedidoFK, idProductoFK, cantidad, precioUnitario)
VALUES
(2, 4, 1, 3800000),
(2, 5, 1, 100000);

select * from detalle_pedido;

##Tarea 

select nombre_Producto, categoriaProducto, precioProducto from productos
where precioProducto > 
	(select avg(precioProducto) from productos)
    order by (precioProducto) desc; 
    
select * from productos;
    
    select avg(precioProducto) from productos;
    
    ##pedido con nombre del empleado
select 
	p.idPedido,
    e. nombreEmpleado
from pedidos p 
inner join empleados e on p.idEmpleado = e.idEmpleados;

##Utilizando varios joins mostrar el detalle de los pedidos y el empleado asignado 
select 
	e.nombreEmpleado,
    p.idPedido,
    p.fecha_pedido,
    p.estado,
    pr.nombre_producto,
    dp.cantidad,
    dp.precioUnitario,
    dp.subtotal
from detalle_pedido dp
inner join pedidos p on dp.idPedidoFK = p.idPedido
inner join empleados e on p.idEmpleado = e.idEmpleados
inner join productos pr on dp.idProductoFK = pr.idProducto;

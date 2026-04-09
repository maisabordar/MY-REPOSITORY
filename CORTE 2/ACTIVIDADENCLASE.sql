## ACTIVIDAD
use tiendaOnline;

DELIMITER //
create procedure cancelarPedido(
		in p_id_empleado int,
        in p_id_empleado int,
        in p_cantidad int,
        out p_id_pedido int,
        out p_mensaje varchar(200)
) 
BEGIN
	declare v_stock int;
    declare v_precio decimal(10.2);
    declare v_total decimal(10.2);
    ## mensaje por si hay algun error
		declare exit handler for sqlexception
        BEGIN
			rollback;
            set p_mensaje='error: proceso invalido';
		end;
        ## validar disponibilidad de stock
        select estado into v_count, v_estado
        from pedido where id_producto=p_id_producto and id_cliente=p_id-cliente;
        if v_count=0 then
			set p_mensaje=concat('El pedido no existe o no pertence al cliente', v_stock);
		else 
			START TRANSACTION;
			update pedido
			set    estado = 'cancelado'
			where  id_pedido = p_id_pedido;
			## stock
			update producto p
			inner join detalle_pedido dp on dp.id_producto = p.id_producto
			set	p.stock = p.stock + dp.cantidad
			where dp.id_pedido = p_id_pedido;
			SELECT COUNT(*) INTO v_productos
			from   detalle_pedido
			where  id_pedido = p_id_pedido;	
			START TRANSACTION;
			set v_total=v_precio*p_cantidad;
			## crear pedido ->
			insert into pedido(id_empleado,total)values(p_id_empleado,v_total);
			set p_id_pedido=last_insert_id();
			## insertar detalle
			insert into detalle_pedido(id_pedido, id_producto, cantidad, precio_unit)
			values(p_id_pedido,p_id_producto,p_cantidad,v_precio);
			## descontar del stock
			update producto
			set stock = stock - p_cantidad
			where id_producto=p_id_producto;
        
			commit;
			## registrar un mensaje de la base de datos
            set p_mensaje=concat('pedido #',id_pedido,'canceladp correctamente');
		end if;
        
END//
DELIMITER ;

## pruebas
CALL cancelarPedido(3, 7, @msg);
SELECT @msg;

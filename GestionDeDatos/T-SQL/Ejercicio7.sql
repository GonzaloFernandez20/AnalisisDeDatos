/* 7. Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por
las ventas entre esas fechas. La tabla se encuentra creada y vacía.*/


create table Ventas(
    codigo char(8),
    detalle char(50),
    cant_movimientos decimal(6),
    precio_venta decimal (12,2),
    renglon int,
    ganancia decimal (12,2)
);
go


create proc completar_tabla_ventas(@desde smalldatetime, @hasta smalldatetime)
as
begin

    declare @producto char(8), @prod_detalle char(50), @cant_movimientos decimal(6), @precio_venta decimal(12,2), @ganancia decimal (12,2)
    declare  @renglon int
    declare c_ventas cursor for select prod_codigo, prod_detalle,
                                    sum(item_cantidad),
                                    avg(item_precio),
                                    sum(item_cantidad*item_precio) - sum(item_cantidad)*prod_precio
                                from Item_Factura
                                join Producto on prod_codigo = item_producto
                                join Factura on item_numero+item_tipo+item_sucursal = fact_numero+fact_tipo+fact_sucursal
                                where fact_fecha >= @desde and fact_fecha <= @hasta
                                group by prod_codigo, prod_detalle, prod_precio

    open c_ventas
    fetch c_ventas into @producto, @prod_detalle, @cant_movimientos, @precio_venta, @ganancia
    set @renglon = 0

    while @@FETCH_STATUS = 0
        begin
            set @renglon += 1
            insert into Ventas values (@producto, @prod_detalle, @cant_movimientos, @precio_venta, @renglon, @ganancia)

            fetch c_ventas into @producto, @prod_detalle, @cant_movimientos, @precio_venta, @ganancia
        end

    close c_ventas
    deallocate c_ventas
    return
end
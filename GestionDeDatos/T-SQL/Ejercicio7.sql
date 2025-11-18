/* Ej 7 Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por
las ventas entre esas fechas. La tabla se encuentra creada y vacía.*/

create procedure ej_t7 @desde DATETIME, @hasta DATETIME
AS
begin 
    declare @renglon int, @producto char(8), @detalle char(50), @precio_prom numeric(12,4), @cantidad numeric(12,2), @ganancia numeric(12,2) 
    declare c1 cursor for 
    select prod_codigo, prod_Detalle, sum(item_cantidad), avg(item_precio), sum(item_precio*item_cantidad)-sum(item_cantidad)*prod_precio
    from Item_Factura join factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
    join producto on prod_codigo = item_producto
    where fact_fecha >= @desde and fact_fecha <= @hasta
    group by prod_codigo, prod_detalle, prod_precio
    open c1 
    fetch next into  @producto, @detalle,  @cantidad, @precio_prom, @ganancia
    select @renglon = 1
    while @@FETCH_STATUS = 0
    begin 
        insert ventas values (@producto, @detalle,  @cantidad, @precio_prom, @renglon, @ganancia)
        select @renglon = @renglon + 1
        fetch next into  @producto, @detalle,  @cantidad, @precio_prom, @ganancia
    END
    close c1
    deallocate c1
    RETURN
end
go 
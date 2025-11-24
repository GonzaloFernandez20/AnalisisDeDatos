/* 14. Agregar el/los objetos necesarios para que si un cliente compra un producto
compuesto a un precio menor que la suma de los precios de sus componentes
que imprima la fecha, que cliente, que productos y a qué precio se realizó la
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma
de los componentes. */

create function calculo_precios_componentes(@producto char(8))
returns int
as
begin

    declare @suma_componentes decimal(12,2); set @suma_componentes = 0;
    declare @componente char(8)
    declare c_producto cursor for select comp_componente from Composicion where comp_producto = @producto

    open c_producto
    fetch next from c_producto into @componente

    while @@FETCH_STATUS = 0
        begin
            set @suma_componentes += (select sum(comp_cantidad*prod_precio) from Composicion
                                      join Producto on prod_codigo = comp_producto  
                                      where comp_producto = @producto) + dbo.calculo_precios_componentes(@componente)
            fetch next from c_producto into @componente
        end

    close c_producto
    deallocate c_producto
    return @suma_componentes
end
go

create trigger trig_control_producto on Item_Factura instead of insert
as
begin

    declare @fact_fecha smalldatetime, @item_producto char(8), @item_precio decimal(12,2), @fact_cliente char(4), @item_tipo char(1), @item_numero char(4), @item_sucursal char(8), @item_cantidad decimal(12,2)


    declare c_item cursor for select fact_fecha, i.item_producto, i.item_precio, fact_cliente, i.item_tipo, i.item_numero, i.item_sucursal, i.item_cantidad
                              from inserted i
                              join Factura on i.item_numero+i.item_tipo+i.item_sucursal = fact_numero+fact_tipo+fact_sucursal


    open c_item 
    fetch next from c_item into @fact_fecha, @item_producto , @item_precio, @fact_cliente, @item_tipo, @item_numero, @item_sucursal, @item_cantidad

    while @@FETCH_STATUS = 0
        begin
            if @item_precio < dbo.calculo_precios_componentes(@item_producto) / 2
                begin
                    fetch next from c_item into @fact_fecha, @item_producto , @item_precio, @fact_cliente, @item_tipo, @item_numero, @item_sucursal, @item_cantidad
                    continue
                end

            if @item_precio < dbo.calculo_precios_componentes(@item_producto)
                begin
                    SELECT @fact_fecha AS fecha,
                           @fact_cliente AS cliente,
                           @item_producto AS producto,
                           @item_precio AS precio;
                end
            insert into Item_Factura values(@item_tipo, @item_sucursal, @item_numero, @item_producto, @item_cantidad, @item_precio)
            fetch next from c_item into @fact_fecha, @item_producto , @item_precio, @fact_cliente, @item_tipo, @item_numero, @item_sucursal, @item_cantidad
        end
end
go

select comp_producto, dbo.calculo_precios_componentes(comp_producto) from Composicion go
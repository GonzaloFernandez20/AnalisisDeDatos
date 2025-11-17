/* 2. Realizar una función que dado un artículo y una fecha, retorne el stock que 
existía a esa fecha */

create function stock_en_fecha(@producto char(8), @fecha datetime2(6)) 
returns numeric(12,2)
as
begin

    declare @cantidad_actual numeric(12,2)

    select @cantidad_actual = sum(stoc_cantidad) from STOCK where stoc_producto = @producto

    set @cantidad_actual += ( select sum(item_cantidad)
                              from Item_Factura
                              join Factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
                              where item_producto = @producto and fact_fecha >= @fecha
                            )
    return @cantidad_actual
end
go

-- CONSULTAS AUXILIARES

/*
select item_producto, dbo.stock_en_fecha(item_producto, '10/01/2011')
from Item_Factura
where item_producto = '00001121'


select sum(item_cantidad) from Item_Factura where item_producto = '00001121'

select sum(item_cantidad)
from Item_Factura
join Factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
where item_producto = '00001121' and fact_fecha <= '10/01/2011'

drop function dbo.stock_en_fecha
*/
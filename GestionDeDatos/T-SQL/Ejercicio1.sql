/*  1. Hacer una función que dado un artículo y un deposito devuelva un string que
indique el estado del depósito según el artículo. Si la cantidad almacenada es 
menor al límite retornar 'OCUPACION DEL DEPOSITO XX %' siendo XX el 
% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
'DEPOSITO COMPLETO'. */

create function obtener_estado_deposito (@articulo char(8), @deposito char(2)) returns char(50)
as
begin
    declare @punto_maximo numeric (12,2)
    declare @stock numeric (12,2)

    select @punto_maximo = stoc_stock_maximo,
           @stock = stoc_cantidad
    from STOCK 
    where stoc_producto = @articulo and stoc_deposito = @deposito

    if @stock = @punto_maximo return 'DEPOSITO COMPLETO'

    return 'OCUPACION DEL DEPOSITO %' + CONVERT(VARCHAR(20), @stock * 100 / @punto_maximo);
end 
GO

-- CONSULTAS AUXILIARES

/* select depo_detalle, prod_detalle, isnull(dbo.obtener_estado_deposito(stoc_producto, depo_codigo),0)
from STOCK
join DEPOSITO on depo_codigo = stoc_deposito
join Producto on prod_codigo = stoc_producto
-- where stoc_producto = '00000102'
order by depo_detalle */
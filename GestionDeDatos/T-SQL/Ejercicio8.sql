/* 8. Realizar un procedimiento que complete la tabla Diferencias de precios, para los
productos facturados que tengan composición y en los cuales el precio de
facturación sea diferente al precio del cálculo de los precios unitarios por 
cantidad de sus componentes, se aclara que un producto que compone a otro, 
también puede estar compuesto por otros y así sucesivamente, la tabla se debe 
crear y está formada por las siguientes columnas.
*/

create table Diferencia_de_Precios
(
    art_codigo                char(8),
    art_detalle               char(50),
    art_cantidad_articulos    decimal(12,2),
    art_precio_compuesto      decimal(12,2),
    art_precio                decimal(12,2)
);
go

-------------------------------------------------------------------------------------------
create function calcular_precio_compuesto (@producto char(8))
returns decimal(12,2)
as
begin

    -- CASO BASE
    if (select count(*) from Composicion where comp_producto = @producto) = 0
        return (select prod_precio from Producto where prod_codigo = @producto)


    -- OPERACION DEL CURSOR
    declare @componente char(8), @cantidad decimal(12,2), @precio_producto decimal(12,2)
    declare cursor_comp cursor for select comp_componente, comp_cantidad
                                   from Composicion 
                                   where comp_producto = @producto

    open cursor_comp
    fetch next from cursor_comp into @componente, @cantidad

    set @precio_producto = 0
    while @@FETCH_STATUS = 0
        begin
            set @precio_producto = @precio_producto + @cantidad * dbo.calcular_precio_compuesto(@componente)
            fetch next from cursor_comp into @componente, @cantidad
        end

    close cursor_comp
    deallocate cursor_comp

    return @precio_producto
end
go

-------------------------------------------------------------------------------------------
-- AHORA LA PARTE CLAVE DEL EJERCICIO
-------------------------------------------------------------------------------------------
GO

create procedure completar_tabla
as
begin

    insert into dbo.Diferencia_de_Precios
        select prod_codigo, 
               prod_detalle, 
               (select count(*) from Composicion where comp_producto = prod_codigo), 
               dbo.calcular_precio_compuesto(prod_codigo), 
               item_precio
        from Item_Factura 
        join Producto on prod_codigo = item_producto
        where prod_codigo in (select comp_producto from Composicion) and
            item_precio <> dbo.calcular_precio_compuesto(prod_codigo)
        -- group by prod_codigo, prod_detalle, item_precio
end

/*
-- FUNCIONES AUXILIARES

drop function dbo.calcular_precio_compuesto

select prod_codigo, prod_precio, dbo.calcular_precio_compuesto(prod_codigo)
from Producto
where prod_precio <> dbo.calcular_precio_compuesto(prod_codigo)

select prod_precio, dbo.calcular_precio_compuesto(prod_codigo)
from Producto
where prod_codigo = '00001104'

*/
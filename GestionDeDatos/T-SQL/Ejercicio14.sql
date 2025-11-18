/* 14. Agregar el/los objetos necesarios para que si un cliente compra un producto
compuesto a un precio menor que la suma de los precios de sus componentes
que imprima la fecha, que cliente, que productos y a qué precio se realizó la
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma
de los componentes. */


create trigger ej_t14 on item_factura instead of insert 
AS
begin 
    declare @tipo char(1),@sucursal char(4), @numero char(8), @cliente char(6), @fecha datetime, @cantidad numeric(12,2), @producto char(8), @precio numeric(12,4) 
    declare c1 cursor for select item_tipo,item_sucursal, item_numero, fact_cliente, fact_fecha, item_producto, item_precio, item_cantidad 
                            from inserted join factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
    open c1
    fetch c1 into @tipo,@sucursal, @numero, @cliente, @fecha, @producto, @precio, @cantidad 
    while @@fetch_status = 0
    begin 
        if @precio > dbo.ej_f14(@producto) / 2
            begin 
            if @precio < dbo.ej_f14(@producto) 
                begin 
                    print 'FECHA: '+@fecha+' CLIENTE: '+@cliente+'PRODUCTO: '+@producto+ 'PRECIO: '+@precio
                    insert item_factura values(@tipo,@sucursal,@numero,@producto,@cantidad, @precio)
                end
            else 
                insert item_factura values(@tipo,@sucursal,@numero,@producto,@cantidad, @precio)
            end 
        fetch c1 into @tipo,@sucursal, @numero, @cliente, @fecha, @producto, @precio, @cantidad
    end 
    close c1
    DEALLOCATE c1
END
GO


alter function ej_f14 (@producto char(8))
returns numeric(12,4)
as
BEGIN
    declare @suma numeric(12,4), @comp char(8)
    declare c1 cursor for select comp_componente from composicion where comp_producto = @producto     
    select @suma = (select isnull(sum(comp_cantidad*prod_precio),0) from composicion join producto on comp_componente = prod_codigo
                            where comp_producto = @producto)
    open c1
    fetch c1 into @comp
    while @@FETCH_STATUS = 0
    begin 
        select @suma = @suma + dbo.ej_f14(@comp)
        fetch c1 into @comp
    END
    close c1
    deallocate c1
    return @suma
END
go 
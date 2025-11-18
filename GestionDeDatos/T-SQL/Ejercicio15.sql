/* 15. Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.*/

CREATE function ej_t15 (@producto char(8))
returns numeric(12,4)
as
BEGIN
    If (select count(*) from composicion where comp_producto = @producto) > 0
    begin
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
    end    
    else 
        select @suma = prod_precio from producto where prod_codigo = @producto
return @suma
END
GO
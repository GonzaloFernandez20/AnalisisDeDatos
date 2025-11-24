/* 15. Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.*/

create function calcular_precio(@producto char(8))
returns decimal(12,2)
as
begin
    declare @precio decimal(12,2)
    set @precio = (select prod_precio from Producto where prod_codigo = @producto)

    declare @suma decimal(12,2); set @suma = @precio;

    if exists (select comp_producto from Composicion where comp_producto = @producto)
        begin
            declare @componente char(8)
            declare c1 cursor for select comp_componente from Composicion where comp_producto = @producto
            open c1
            fetch c1 into @componente
            while @@FETCH_STATUS = 0
                begin
                    set @suma += dbo.calcular_precio(@componente)
                    fetch c1 into @componente
                end
            close c1
            deallocate c1
        end
    
    return @suma
end
go



select prod_codigo, prod_detalle, prod_precio, dbo.calcular_precio(prod_codigo)
from Producto
where prod_codigo in (select comp_producto from Composicion)
/* 20. Crear el/los objeto/s necesarios para mantener actualizadas las comisiones del
vendedor.
El cálculo de la comisión está dado por el 5% de la venta total efectuada por ese
vendedor en ese mes, más un 3% adicional en caso de que ese vendedor haya
vendido por lo menos 50 productos distintos en el mes. */

create trigger ej_t20 on factura for insert, delete  
AS
begin
    declare @comision numeric(5,2), @vendedor numeric(6), @monto numeric(12,2), @año numeric(4), @mes NUMERIC(2)
    if (select count(*) from inserted) > 0
        declare c1 cursor for select fact_vendedor, year(fact_fecha), month(fact_fecha), sum(fact_total) from inserted 
                                    group by fact_Vendedor, Year(fact_fecha), month(fact_fecha)
    else 
        declare c1 cursor for select fact_vendedor, year(fact_fecha), month(fact_fecha), sum(fact_total)*(-1) from deleted
                                    group by fact_Vendedor, Year(fact_fecha), month(fact_fecha)
    open c1 
    fetch next into @vendedor, @monto, @año, @mes  
    while @@FETCH_STATUS = 0 
    begin 
        if (select count(distinct item_producto) from item_factura join factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero 
            where fact_vendedor = @vendedor and year(fact_fecha) = @año and month(fact_fecha) = @mes) >= 50
            select @comision = 0.08
        else 
            select @comision = 0.05      
        update empleado set empl_comision = @monto +  ((select sum(fact_total) from factura 
                                            where year(fact_fecha) = @año and month(fact_fecha) = @mes 
                                                and fact_vendedor = @vendedor) * @comision)  
        where empl_codigo = @vendedor 
    end  
    close c1 
    deallocate c1 
end 
go 

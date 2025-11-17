/* 4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año. */

create procedure mejor_empleado @vendedor_estrella numeric(12,2) output
as
begin
    update Empleado
    set empl_comision = ( select isnull(sum(fact_total),0)
                          from Factura
                          where empl_codigo = fact_vendedor and
                                year(fact_fecha) = (select max(year(fact_fecha)) from Factura)
                        )

    set @vendedor_estrella = (select top 1 empl_codigo
                              from Empleado
                              order by empl_comision desc
                             )
    return
end
go

-- select top 1 @vendedor_estrella = empl_codigo from Empleado order by empl_comision desc

-- OPCION USANDO CURSORES, SOLO PARA PROBAR QUE ONDA...
create procedure mejor_empleado_con_cursor @vendedor_estrella numeric(12,2) output
as
begin

    declare @empleado numeric(12,2)
    declare cursor_empleado cursor for select empl_codigo from Empleado
    open cursor_empleado
    fetch next from cursor_empleado into @empleado

    while @@FETCH_STATUS = 0
        begin
            update Empleado
            set empl_comision = ( select isnull(sum(fact_total),0)
                                  from Factura
                                  where fact_vendedor = @empleado and
                                        year(fact_fecha) = (select max(year(fact_fecha)) from Factura)
                                )
            WHERE empl_codigo = @empleado;
            fetch next from cursor_empleado into @empleado
        end
    close cursor_empleado
    deallocate cursor_empleado

    set @vendedor_estrella = (select top 1 empl_codigo
                              from Empleado
                              order by empl_comision desc
                             )
    return
end
go
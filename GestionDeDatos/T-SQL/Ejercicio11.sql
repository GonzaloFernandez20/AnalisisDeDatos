/* 11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo. */

alter function cant_empleados_a_cargo(@empl_jefe numeric(6))
returns int
as
begin
    declare @cant_empleados int; set @cant_empleados = 0
    declare @empleado numeric(6)
    declare c_empleados cursor for select empl_codigo from Empleado where empl_jefe = @empl_jefe

    open c_empleados
    fetch next from c_empleados into @empleado

    while @@FETCH_STATUS = 0
        begin 
            set @cant_empleados += 1 + dbo.cant_empleados_a_cargo(@empleado)
            fetch next from c_empleados into @empleado
        end

    close c_empleados
    deallocate c_empleados
    return @cant_empleados
end
go


select empl_jefe, dbo.cant_empleados_a_cargo(empl_jefe) from Empleado group by empl_jefe
/* 13. Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
"Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de
sus empleados totales (directos + indirectos)". Se sabe que en la actualidad dicha
regla se cumple y que la base de datos es accedida por n aplicaciones de
diferentes tipos y tecnologías */

-- Se habla de que hay una regla que se cumple. Seguro es un trigger

-- funcion que dado un empleado me devuelva el 20% del salario de sus empleados 

create function chequeo_salarios(@jefe numeric(6))
returns numeric(12,2)
as
begin

    declare @empleado numeric(6)
    declare @salarios numeric(12,2); set @salarios = 0

    declare c_empleado cursor for select empl_codigo from Empleado where empl_jefe = @jefe
    open c_empleado
    fetch next from c_empleado into @empleado

    while @@FETCH_STATUS = 0
        begin
            set @salarios += (select empl_salario from Empleado where empl_codigo = @empleado) + 
                              dbo.chequeo_salarios(@empleado)
            fetch next from c_empleado into @empleado
        end

    close c_empleado
    deallocate c_empleado
    return @salarios
end
go

--select empl_jefe, dbo.chequeo_salarios(empl_jefe) from Empleado group by empl_jefe



create trigger trig_chequeo_salarios on Empleado for delete, update
as
begin
    if (select count(*) from inserted) = 0
        begin
            if exists (select 1 from deleted d where (select empl_salario from Empleado where empl_jefe = d.empl_jefe) > dbo.chequeo_salarios(d.empl_jefe)*0.2)
                ROLLBACK
        end
    else 
        begin
            if exists (select 1 from inserted d where (select empl_salario from Empleado where empl_jefe = d.empl_jefe) > dbo.chequeo_salarios(d.empl_jefe)*0.2)
                ROLLBACK
        end
end
go
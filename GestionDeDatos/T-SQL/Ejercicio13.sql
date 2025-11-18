/* 13 Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de
sus empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha
regla se cumple y que la base de datos es accedida por n aplicaciones de
diferentes tipos y tecnologías */

create trigger ej_t13 on empleado for delete, update
AS
begin 
    if (select count(*) from inserted) = 0
        begin
        if exists (select 1 from deleted d where (select empl_salario from empleado where empl_jefe = d.empl_jefe)
                                             > dbo.ej_f13(d.empl_jefe) * 0.2)
            ROLLBACK                                        
        end 
    ELSE
        begin 
        if exists (select 1 from inserted d where (select empl_salario from empleado where empl_jefe = d.empl_jefe)
                                             > dbo.ej_f13(d.empl_jefe) * 0.2)
            ROLLBACK                                        
        end

END
go 

create function ej_f13 (@jefe numeric(6))
returns numeric(12,2)
as 
begin
    declare @empleado numeric(6), @salarios numeric(12,2) 
    select @salarios = 0
    declare c1 cursor for select empl_codigo from empleado where empl_jefe = @jefe
    open c1
    fetch c1 into @empleado 
    while @@FETCH_STATUS = 0
    begin  
        select @salarios = @salarios + (select empl_salario from empleado where empl_codigo = @empleado) + dbo.ej_f13(@empleado)   
        fetch c1 into @empleado 
    end 
    close c1
    deallocate c1
    return @salarios 
end
go
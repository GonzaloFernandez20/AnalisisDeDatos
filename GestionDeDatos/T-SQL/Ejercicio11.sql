/* ej 11 Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo. */

alter function ej_t11 (@jefe numeric(6))
returns int 
as 
begin
    declare @empleado numeric(6), @cantidad int 
    select @cantidad = 0
    declare c1 cursor for select empl_codigo from empleado where empl_jefe = @jefe
    open c1
    fetch c1 into @empleado 
    while @@FETCH_STATUS = 0
    begin  
        select @cantidad = @cantidad + 1 + dbo.ej_t11(@empleado)   
        fetch c1 into @empleado 
    end 
    close c1
    deallocate c1
    return @cantidad 
end
go
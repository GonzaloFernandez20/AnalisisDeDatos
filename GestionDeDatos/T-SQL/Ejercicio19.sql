/* 19. Cree el/los objetos de base de datos necesarios para que se cumpla la siguiente
regla de negocio automáticamente “Ningún jefe puede tener menos de 5 años de
antigüedad y tampoco puede tener más del 50% del personal a su cargo
(contando directos e indirectos) a excepción del gerente general”. Se sabe que en
la actualidad la regla se cumple y existe un único gerente general. */


create trigger ej_t19 on empleado for insert, delete, UPDATE
AS
begin 
    if EXISTS (select 1 from empleado where empl_codigo in 
                    (select empl_jefe from empleado) and 
        (DATEDIFF(year, empl_ingreso, getdate()) > 5 or 
        dbo.ej_t11(empl_codigo) > (select count(*)/2 from empleado)))
    begin 
        print 'no cumple la regla'
        ROLLBACK
    end
end 
go 
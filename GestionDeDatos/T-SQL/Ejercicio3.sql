/* 3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado 
en caso que sea necesario. Se sabe que debería existir un único gerente general 
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado 
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por 
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la 
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla 
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad 
de empleados que había sin jefe antes de la ejecución. */

/* Tenemos que usar un procedimiento porque necesitamos modificar la tabla en caso que sea necesario, 
   pero, como debemos devolver un valor, le pasamos una variable output para dejar ahi el valor guardado */


alter procedure ej3 @cantidad int output
as 
begin
    select @cantidad = count(*) from Empleado where empl_jefe is null

    declare @gerente_gral numeric(12,2)

    set @gerente_gral = (select top 1 empl_codigo
                         from Empleado where empl_jefe is null
                         order by empl_salario desc, empl_ingreso asc
                        )

    update Empleado 
    set empl_jefe = @gerente_gral 
    where empl_jefe is null and empl_codigo <> @gerente_gral
    return
end
go



begin
    declare @cantidad int
    exec dbo.ej3 @cantidad
    print @cantidad
end
go
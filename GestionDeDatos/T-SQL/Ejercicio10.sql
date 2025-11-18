/* 10. Crear el/los objetos de base de datos que ante el intento de borrar un artículo
verifique que no exista stock y si es así lo borre en caso contrario que emita un
mensaje de error.*/


create TRIGGER EJ_T10 ON PRODUCTO INSTEAD OF DELETE
AS
BEGIN
	if exists(select * from STOCK join deleted on stoc_producto = prod_codigo where stoc_cantidad > 0)
		begin
			raiserror ('El artículo posee stock, no se puede eliminar',1,1)
		end
	delete from STOCK where stoc_producto IN (SELECT prod_codigo from deleted)
	delete from Composicion where comp_producto IN (SELECT prod_codigo from deleted);
	delete from Producto where prod_codigo IN (select prod_codigo from deleted)
end
go 
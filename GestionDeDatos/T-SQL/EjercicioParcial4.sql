/*Implementar el/los objetos necesarios para implementar la siguiente restricción en línea:
Cuando se inserta en una venta un COMBO, nunca se deberá guardar el producto COMBO, sino, la descomposición de sus componentes.
 Nota: Se sabe que actualmente todos los artículos guardados de ventas están descompuestos en sus componentes.*/

 /*ACLARACIONES*/
 /*Se debe crear un trigger para poder automatizar el chequeo pedido cada vez que se inserta, no un stored procedure porque debería llamarse y tampoco una función porque
 no busca retornar nada, sólo causar efecto*/
 /*Sería correcto que no se inserte el combo, sino en lugar de insertar el combo se inserten sus componentes, también podría utilizarse un FOR/AFTER pero considero que es preferible
 no insertar antes que insertar algo erroneo y luego borrarlo*/
 /*NO se contemplan combos dentro de otros combos, se toman los componentes como productos atómicos*/

 CREATE TRIGGER changeComboiTemForComponents ON item_Factura INSTEAD OF INSERT 
 as
 BEGIN
	DECLARE @PRECIO DECIMAL(12,2)
	DECLARE @ITEMCANT DECIMAL(12,2)
	DECLARE @PRODUCTOID CHAR(8)
	DECLARE @FACTURAID CHAR(8)
	DECLARE @TIPO CHAR(1)
	DECLARE @SUCURSAL CHAR(4)

	DECLARE NUEVOS CURSOR FOR SELECT item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio FROM inserted

	OPEN NUEVOS
	
	FETCH NEXT FROM NUEVOS INTO @TIPO, @SUCURSAL, @FACTURAID, @PRODUCTOID, @ITEMCANT, @PRECIO

	WHILE @@FETCH_STATUS = 0
	BEGIN
	 if (exists(select 1 FROM COMPOSICION where comp_producto = @PRODUCTOID)) --ES COMBO
		INSERT INTO Item_Factura SELECT @TIPO, @SUCURSAL, @FACTURAID, c1.comp_componente, c1.comp_cantidad, prod_precio FROM COMPOSICION C1
			inner join Producto on prod_codigo = comp_componente where c1.comp_producto = @PRODUCTOID
		
	ELSE
		INSERT INTO Item_Factura VALUES(@TIPO, @SUCURSAL, @FACTURAID, @PRODUCTOID, @ITEMCANT, @PRECIO)


	FETCH NEXT FROM NUEVOS INTO @TIPO, @SUCURSAL, @FACTURAID, @PRODUCTOID, @ITEMCANT, @PRECIO
	END

	CLOSE NUEVOS
	DEALLOCATE NUEVOS
END

--PRUEBA, EL '00001104' ES UN COMBO DE 2 PRODUCTOS
  INSERT INTO Item_Factura VALUES ('A', '0003', '00089605', '00001104', 1, 100)


--EN SU LUGAR SE DEBEN INSERTAR LOS PRODUCTOS '00001109' Y '00001123'
 SELECT * FROM Item_Factura  WHERE ITEM_NUMERO = '00089605' ORDER BY item_numero

 --Efectivamente, a los 3 registros previos con esa factura se le agregan los 2 nuevos productos mencionados.
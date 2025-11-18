/* 16. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi
hasta agotar los depositos posibles. En ultima instancia se dejara stock negativo
en el ultimo deposito que se desconto. */

CREATE OR ALTER TRIGGER venta_reduce_stock ON Item_Factura AFTER INSERT
AS
BEGIN
	DECLARE 
	@producto char(8),
	@cantidad decimal(12,2);
	DECLARE c_inserted CURSOR FOR
	SELECT i.item_producto, i.item_cantidad
	FROM Inserted i;
	OPEN c_inserted;
	FETCH NEXT FROM c_inserted INTO @producto, @cantidad;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.descontar_stock @producto, @cantidad;
		FETCH NEXT FROM c_inserted INTO @producto, @cantidad;
	END
	CLOSE c_inserted;
	DEALLOCATE c_inserted;
END
go 

CREATE OR ALTER PROCEDURE descontar_stock(@producto char(8), @cantidad decimal(12,2)) 
AS 
BEGIN
	DECLARE @depo char(2), 
	@restante decimal(12,2) = @cantidad,
	@deposito char(8),
	@stock_actual decimal(12,2);
	DECLARE c_depositos CURSOR FOR
	SELECT stoc_deposito, stoc_cantidad
	FROM STOCK
	WHERE stoc_producto = @producto
	ORDER BY stoc_cantidad DESC;
	OPEN c_depositos;
	FETCH NEXT FROM c_depositos INTO @deposito, @stock_actual;
	WHILE @@FETCH_STATUS = 0 AND @restante > 0
	BEGIN
		DECLARE @descuento decimal(12,2) = 
			CASE
			WHEN @stock_actual >= @restante THEN @restante
			ELSE @stock_actual
		END;
		UPDATE STOCK
		SET stoc_cantidad = stoc_cantidad - @descuento
		WHERE stoc_producto = @producto AND stoc_deposito = @deposito;
		SET @restante -= @descuento;
        select @depo = @deposito
        FETCH NEXT FROM c_depositos INTO @deposito, @stock_actual;
	END
	CLOSE c_depositos;
	DEALLOCATE c_depositos;
	IF @restante > 0
	BEGIN
		UPDATE STOCK
		SET stoc_cantidad = stoc_cantidad - @restante
		WHERE stoc_producto = @producto
		AND stoc_deposito = @depo
	END
END
GO
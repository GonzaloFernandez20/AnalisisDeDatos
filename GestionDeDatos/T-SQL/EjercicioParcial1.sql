/* Dado el contexto inflacionario se tiene que aplicar un control en el cual nunca 
se permita vender un producto a un precio que no este entre 0% y 5% del precio de
venta del producto el mes anterior, ni tampoco que este mas de 50% del precio del 
mismo producto que hace 12 meses atras.
Aquellos productos nuevos o que no tuvieron ventas en meses anteriores no debe 
considerar esta regla ya que no hay precio de referencia. */


create trigger control_venta on Item_Factura after insert
as
begin

    declare @precio decimal(12,2), @producto char(8), @fecha_venta smalldatetime, @sucursal char(4), @numero char(8), @tipo char(1)
    declare @precio_mes_pasado decimal(12,2) 
    declare @precio_anio_pasado decimal(12,2) 

    declare cursor_factura cursor for select item_precio, item_producto, fact_fecha from inserted join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
    open cursor_factura
    fetch next from cursor_factura into @precio, @producto, @fecha_venta

    while @@FETCH_STATUS = 0
        BEGIN
            select @precio_mes_pasado = avg(item_precio)
            from Item_Factura
            join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
            where item_producto = @producto and 
                  month(fact_fecha) = month(@fecha_venta) - 1
                  
            if @precio_anio_pasado is null or (ABS(@precio - @precio_mes_pasado) * 100.0 / @precio_mes_pasado) > 5
                begin
                    print ' restriccion inflacionaria '
                    rollback
                end

            select @precio_anio_pasado = avg(item_precio)
            from Item_Factura
            join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
            where item_producto = @producto and 
                  year(fact_fecha) = year(@fecha_venta) - 1

            if @precio_anio_pasado is null or (ABS(@precio - @precio_anio_pasado) * 100.0 / @precio_anio_pasado) > 50
                begin
                    print ' restriccion inflacionaria '
                    rollback
                end

            fetch next from cursor_factura into @precio, @producto, @fecha_venta
        END
    close cursor_factura
    deallocate cursor_factura
end
go




CREATE TRIGGER unTrigger ON Item_Factura
FOR insert
AS BEGIN
    DECLARE @PROD char(6), @FECHA SMALLDATETIME, @PRECIO decimal(12,2), 
	@SUCURSAL char(4), @NUM char(8), @TIPO char(1)
    DECLARE c1 CURSOR FOR
	select fact_numero, fact_sucursal, fact_tipo from inserted 
	join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo

	OPEN c1
	FETCH NEXT FROM c1 INTO  @NUM, @SUCURSAL ,@TIPO

	WHILE @@FETCH_STATUS = 0
	BEGIN


	    DECLARE c2 CURSOR FOR 
		select item_producto, fact_fecha, item_precio from inserted
		join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
		where fact_numero+fact_sucursal+fact_tipo = @NUM + @SUCURSAL + @TIPO

		OPEN c2
		FETCH NEXT FROM c2 INTO @PROD, @FECHA, @PRECIO

		WHILE @@FETCH_STATUS = 0
		BEGIN


		      IF EXISTS(select 1 from Item_Factura where item_producto = @PROD 
			  and item_numero+item_sucursal+item_tipo <> @NUM+@SUCURSAL+@TIPO)
			  BEGIN 
			        IF EXISTS( select 1 from Item_Factura 
		            join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
		            where item_producto = @PROD and DATEDIFF(MONTH, @FECHA, fact_fecha) = 1 and @PRECIO > item_precio * 1.05)
	                BEGIN 
		               Delete Item_Factura
			           where item_numero = @NUM and item_sucursal = @SUCURSAL and item_tipo = @TIPO

			           Delete Factura
			           where fact_numero = @NUM and fact_sucursal = @SUCURSAL and fact_tipo = @TIPO

				    CLOSE c2
				    DEALLOCATE c2
			        END

			       IF EXISTS( select 1 from Item_Factura 
		           join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
		           where item_producto = @PROD and DATEDIFF(YEAR, @FECHA, fact_fecha) = 1 and @PRECIO > item_precio * 1.5)
	               BEGIN 
		              Delete Item_Factura
			          where item_numero = @NUM and item_sucursal = @SUCURSAL and item_tipo = @TIPO

			          Delete Factura
			          where fact_numero = @NUM and fact_sucursal = @SUCURSAL and fact_tipo = @TIPO

				   CLOSE c2
				   DEALLOCATE c2
			       END
			  END

		      FETCH NEXT FROM c2 INTO @PROD, @FECHA, @PRECIO
		END
		
	    FETCH NEXT FROM c1 INTO @PROD, @FECHA, @PRECIO, @NUM, @SUCURSAL ,@TIPO   
	END

	CLOSE c1
	DEALLOCATE c1
END


-- SOLUCION REINOSA
go
CREATE OR ALTER FUNCTION precio_diferencia_meses(@producto char(8), @fecha smalldatetime, @meses int) 
RETURNS decimal(12,2)
AS
BEGIN
	DECLARE @precio_historico decimal(12,2);

	SET @precio_historico = (
		SELECT TOP 1 item_precio
		FROM Item_Factura
		JOIN Factura 
		ON fact_sucursal + fact_tipo + fact_numero = item_sucursal + item_tipo + item_numero
		WHERE item_producto = @producto
		AND fact_fecha BETWEEN DATEADD(MONTH, -@meses, @fecha) 
		AND DATEADD(MONTH, -@meses + 1, @fecha)
		ORDER BY fact_fecha DESC
	)

	RETURN @precio_historico;
END
GO

CREATE TRIGGER control_precios ON Item_factura AFTER INSERT
AS
BEGIN
	DECLARE 
		@vendido char(8),
		@precio decimal(12,2),
		@precio_mes_anterior decimal(12,2),
		@precio_anio_anterior decimal(12,2);

	DECLARE c_inserted CURSOR FOR
	SELECT item_producto, item_precio
	FROM inserted;

	OPEN c_inserted; 
	FETCH NEXT FROM c_inserted INTO @vendido, @precio;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @precio_mes_anterior = dbo.precio_diferencia_meses(@vendido, GETDATE(), 1);
		SET @precio_anio_anterior = dbo.precio_diferencia_meses(@vendido, GETDATE(), 12);

		IF @precio_mes_anterior IS NOT NULL OR @precio_anio_anterior IS NOT NULL
		BEGIN
			IF @precio < @precio_mes_anterior
			OR @precio > @precio_mes_anterior * 1.05
			BEGIN
				RAISERROR('NO CUMPLE REGLA DE PRECIOS CON MES ANTERIOR', 16, 1);
            END
			IF @precio > @precio_anio_anterior * 1.5
			BEGIN
				RAISERROR('NO CUMPLE REGLA DE PRECIOS CON AÑO ANTERIOR', 16, 1);
			END
		END

		FETCH NEXT FROM c_inserted INTO @vendido, @precio;
	END

	CLOSE c_inserted;
	DEALLOCATE c_inserted;
END
GO
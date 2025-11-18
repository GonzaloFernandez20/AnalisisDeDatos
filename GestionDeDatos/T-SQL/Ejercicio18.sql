/* 18. Sabiendo que el limite de credito de un cliente es el monto maximo que se le
puede facturar mensualmente, cree el/los objetos de base de datos necesarios
para que dicha regla de negocio se cumpla automaticamente. No se conoce la
forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas */

create trigger ej_t18 on factura for insert 
AS
begin
   	if exists (select i2.fact_cliente from Cliente join inserted i2 on i2.fact_cliente = clie_codigo 
			where clie_limite_credito < 
            (select sum(fact_total)+(select sum(fact_total) from factura where clie_codigo = fact_cliente
										 AND year(fact_fecha) = year(i2.fact_fecha) and month(fact_fecha) = month(i2.fact_fecha))  
			from inserted where fact_cliente = clie_codigo))

    begin
        Print 'SUPERA EL LIMITE DE CREDITO'
        ROLLBACK
    end 
end 
go 

CREATE TRIGGER ej_t18_io ON FACTURA INSTEAD OF INSERT
AS
BEGIN
	DECLARE  @TIPO char(1),@SUCURSAL char(4),@NUMERO char(8),@FECHA smalldatetime,@VENDEDOR numeric(6,0),@TOTAL decimal(12,2),@TOTALIMP decimal(12,2),@CLIENTE char(6)
	DECLARE cursorCompra CURSOR FOR SELECT * FROM inserted 
	OPEN cursorCompra
	FETCH NEXT FROM cursorCompra INTO @TIPO,@SUCURSAL,@NUMERO,@FECHA,@VENDEDOR,@TOTAL,@TOTALIMP,@CLIENTE
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@TOTAL + (SELECT SUM(fact_total) FROM Factura WHERE fact_cliente = @CLIENTE AND MONTH(fact_fecha) = MONTH(@FECHA)) > 
		(SELECT clie_limite_credito FROM Cliente WHERE clie_codigo = @CLIENTE))
			print 'no puede comprar por mayor que su limite credito.'
		ELSE
			INSERT INTO Factura VALUES ( @TIPO,@SUCURSAL,@NUMERO,@FECHA,@VENDEDOR,@TOTAL,@TOTALIMP,@CLIENTE)
		FETCH NEXT FROM cursorCompra INTO @TIPO,@SUCURSAL,@NUMERO,@FECHA,@VENDEDOR,@TOTAL,@TOTALIMP,@CLIENTE
	END
	CLOSE cursorCompra
	DEALLOCATE cursorCompra
END
go 
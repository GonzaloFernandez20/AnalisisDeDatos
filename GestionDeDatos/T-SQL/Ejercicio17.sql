/* 17. Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto
que se debe almacenar en el deposito y que el stock maximo es la maxima
cantidad de ese producto en ese deposito, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio se cumpla automaticamente. No se
conoce la forma de acceso a los datos ni el procedimiento por el cual se
incrementa o descuenta stock */

create trigger ej_t17 on stock after insert, update 
as 
begin 
    if (select count(*) from inserted where stoc_cantidad < stoc_punto_reposicion or stoc_cantidad> stoc_stock_maximo) > 0
    BEGIN 
        PRINT 'SUPERA LA REGLA DE STOCK'
        ROLLBACK 
    END
END
go 

create trigger ej_t17_io on stock instead of insert, update 
as 
begin 
    declare @producto char(8), @cantidad numeric(12,2), @reposicion numeric(12,2), @maximo numeric(12,2), 
        @deposito char(2),@detalle char(40),@proxima DATETIME
    declare c1 cursor for select stoc_producto, stoc_cantidad, stoc_punto_reposicion, stoc_stock_maximo
                            stoc_deposito, stoc_detalle, stoc_proxima_reposicion from inserted 
    open c1
    fetch next into @producto, @cantidad, @reposicion, @maximo, @deposito,@detalle,@proxima   
    while @@FETCH_STATUS = 0
    BEGIN
        IF (SELECT COUNT(*) FROM deleted) = 0   -- INSERT
        BEGIN 
            if (@cantidad >= @reposicion and @cantidad <= @maximo)
                INSERT STOCK values (@cantidad, @reposicion,@maximo,@detalle,@proxima, @producto,@deposito)
            else 
                PRINT 'EL PRODUCTO '+@PRODUCTO+'SUPERA LA REGLA DE STOCK'
        END
        ELSE                    --UPDATE
            if (@cantidad >= @reposicion and @cantidad <= @maximo)
                update stock set stoc_cantidad = @cantidad, stoc_stock_maximo = @maximo,
                    stoc_detalle = @detalle, stoc_proxima_reposicion = @proxima, stoc_producto = @producto,
                    stoc_deposito = @deposito, stoc_punto_reposicion = @reposicion 
                where stoc_deposito = @deposito and stoc_producto = @producto
            else 
                PRINT 'EL PRODUCTO '+@PRODUCTO+'SUPERA LA REGLA DE STOCK'
        fetch next into @producto, @cantidad, @reposicion, @maximo 
    END
    close c1
    DEALLOCATE c1 
END
go 
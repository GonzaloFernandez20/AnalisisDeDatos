/* 16. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi
hasta agotar los depositos posibles. En ultima instancia se dejara stock negativo
en el ultimo deposito que se desconto. */

create or alter procedure actualizacion_stock (@producto char(8), @cantidad decimal(12,2))
as
begin 
	declare @stoc_cantidad decimal(12,2), @deposito char(2)
	declare @cant_restante decimal(12,2)
	declare @ultimo_deposito char(2)

	declare c_depositos cursor for select stoc_deposito, stoc_cantidad
								   from STOCK
								   join DEPOSITO on depo_codigo = stoc_deposito
								   where stoc_producto = @producto
								   order by stoc_cantidad desc

	open c_depositos
	fetch next from c_depositos into @deposito, @stoc_cantidad

	set @cant_restante = @cantidad

	while @@FETCH_STATUS = 0 and @cant_restante > 0
		begin
			if @stoc_cantidad < @cant_restante
				begin
					update STOCK
					set stoc_cantidad = 0
					where stoc_deposito = @deposito and stoc_producto = @producto;

					set @cant_restante -= @stoc_cantidad
					fetch next from c_depositos into @deposito, @stoc_cantidad
				end
			else --stoc_cantidad > @cant_restante
				begin
					update STOCK
					set stoc_cantidad -= @cant_restante
					where stoc_deposito = @deposito and stoc_producto = @producto;

					set @cant_restante = 0
					fetch next from c_depositos into @deposito, @stoc_cantidad
				end
			set @ultimo_deposito = @deposito
		end

	if @cant_restante > 0
		begin
			update STOCK
			set stoc_cantidad -= @cant_restante
			where stoc_deposito = @ultimo_deposito and stoc_producto = @producto;
		end
end
go



create or alter trigger trig_actualizacion_stock on Item_Factura after insert
as
begin
	declare @producto char(8), @cantidad decimal(12,2)
	declare c_articulos cursor for select item_producto, item_cantidad from inserted
	open c_articulos
	fetch next from c_articulos into @producto, @cantidad

	while @@FETCH_STATUS = 0
		begin
			exec dbo.actualizacion_stock @producto, @cantidad
			fetch next from c_articulos into @producto, @cantidad
		end
	close c_articulos
	deallocate c_articulos
end
go
/* 9. Crear el/los objetos de base de datos que ante alguna modificación de un ítem de 
factura de un artículo con composición realice el movimiento de sus 
correspondientes componentes */

-- Como dice ante alguna modificacion sabemos que es un trigger.

create trigger modificar_componentes on Item_Factura after insert, delete
as
begin
    declare @componente char(8) , @cantidad decimal(12,2), @deposito char(8)

    if (select count(*) from inserted) > 0
        begin
            declare c1 cursor for select comp_componente, comp_cantidad*item_cantidad from inserted join Composicion on item_producto = comp_producto
            open c1
            fetch c1 into @componente, @cantidad
            while @@FETCH_STATUS = 0
            begin
                select @deposito = (select top 1 stoc_deposito from STOCK where stoc_producto = @componente order by stoc_cantidad desc)
                if @deposito is null
                    begin
                        print 'No hay stock del producto'
                        ROLLBACK
                    end
                else update stock set stoc_cantidad = stoc_cantidad - @cantidad where stoc_producto = @componente and stoc_deposito = @deposito

                fetch c1 into @componente, @cantidad
            end
        end
    else
        begin
            declare c1 cursor for select comp_componente, comp_cantidad*item_cantidad from inserted join Composicion on item_producto = comp_producto
            open c1
            fetch c1 into @componente, @cantidad
            while @@FETCH_STATUS = 0
            begin
                select @deposito = (select top 1 stoc_deposito from STOCK where stoc_producto = @componente order by stoc_cantidad desc)
                if @deposito is null
                    begin
                        print 'No hay stock del producto'
                        ROLLBACK
                    end
                else update stock set stoc_cantidad = stoc_cantidad + @cantidad where stoc_producto = @componente and stoc_deposito = @deposito

                fetch c1 into @componente, @cantidad
            end
        end
    close c1
    deallocate c1
end
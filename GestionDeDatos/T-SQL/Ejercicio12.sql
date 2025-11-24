/* 12. Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnologías. No se conoce la cantidad de niveles de composición existentes.*/

create trigger trig_chequeo_productos on Composicion for insert
as
begin
    if exists(select * from Composicion where dbo.chequeo_productos(comp_producto, comp_componente) = 1)
        ROLLBACK
end
go


create function chequeo_productos(@producto char(8), @componente char(8))
returns int
as
begin
    -- caso base
    if @producto = @componente return 1
    -- caso recursivo
    declare @comp_aux char(8)
    declare c_producto cursor for select comp_componente from Composicion where comp_componente = @producto

    open c_producto
    fetch c_producto into @comp_aux

    while @@FETCH_STATUS = 0 
        begin
            if dbo.chequeo_productos(@producto, @comp_aux) = 1 return 1
            else fetch c_producto into @comp_aux
        end

    close c_producto
    deallocate c_producto
    return 0
end
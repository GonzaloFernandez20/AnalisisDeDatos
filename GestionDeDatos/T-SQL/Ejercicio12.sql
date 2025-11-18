/* 12 Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnologías. No se conoce la cantidad de niveles de composición existentes.*/


create trigger ej_t12 on composicion for insert
as 
begin 
     if exists (select * from inserted where dbo.ej_f12(comp_producto, comp_componente) = 1)
        ROLLBACK
end 
go 


create function ej_f12 (@producto char(8), @componente char(8))
returns int 
as
BEGIN
    declare @comp char(8)
    if @producto = @componente 
        return 1
    declare c1 cursor for select comp_componente from composicion where comp_producto = @componente      
    open c1
    fetch c1 into @comp
    while @@FETCH_STATUS = 0
    begin 
        if dbo.ej_f12(@producto, @comp) = 1
            return 1    
        fetch c1 into @comp
    END
    close c1
    deallocate c1
    return 0
END
go 
/*
Sabiendo que si un producto no es vendido en un depósito determinado entonces no posee registros en él.
Se requiere una consulta SQL que, para todos los productos que se quedaron sin stock en un depósito (cantidad 0 o nula) y poseen un stock mayor al punto de reposición en otro depósito, devuelva:

- Código de producto
- Detalle del producto
- Domicilio del depósito sin stock
- Cantidad de depósitos con un stock superior al punto de reposición

La consulta debe ser ordenada por el código de producto.


Nota: No se permite el uso de sub-selects en el FROM.
*/

select prod_codigo, prod_detalle, dep.depo_domicilio,
       (select count(*)
        from STOCK stk2
        join DEPOSITO dep2 on dep2.depo_codigo = stk2.stoc_deposito
        where stk2.stoc_producto = stk1.stoc_producto
                and dep2.depo_codigo != dep.depo_codigo
                and stk2.stoc_cantidad > stk1.stoc_punto_reposicion 
       )
from STOCK stk1
join Producto on prod_codigo = stk1.stoc_producto
join DEPOSITO dep on dep.depo_codigo = stk1.stoc_deposito
where (stk1.stoc_cantidad = 0 or stoc_cantidad is null)
      and EXISTS (select 1 
                  from STOCK where stoc_producto = prod_codigo 
                  and stoc_cantidad > stoc_punto_reposicion
                  and stoc_deposito <> depo_codigo
                 )
order by stk1.stoc_producto desc



-- FUNCION AUXILIAR PARA CHEQUEAR VERICIDAD
select depo_domicilio, stoc_cantidad
from STOCK
join DEPOSITO on depo_codigo = stoc_deposito
where stoc_producto = '00000173'
group by depo_domicilio, stoc_cantidad, stoc_producto
order by stoc_producto desc  
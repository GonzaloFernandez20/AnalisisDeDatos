/*
1. Realizar una consulta SQL que retorne para todas las zonas que tengan 3 (tres) o más depósitos:
    - Detalle Zona
    - Cantidad de Depósitos x Zona
    - Cantidad de Productos distintos compuestos en sus depósitos
    - Producto más vendido en el año 2012 que tenga stock en al menos uno de sus depósitos
    - Mejor encargado perteneciente a esa zona (El que más vendió en la historia)

El resultado deberá ser ordenado por monto total vendido del encargado descendente.

NOTA: No se permite el uso de sub-selects en el FROM ni funciones definidas por el usuario para este punto.
*/

select Zona.*, 
       count(dep.depo_codigo) as cant_depositos,
       -------------------------
       (select count(stoc_producto)
        from STOCK 
        join DEPOSITO on stoc_deposito = depo_codigo
        where stoc_producto in (select comp_producto from Composicion) 
              and depo_zona = zona.zona_codigo
       ) as prod_distintos_compuestos,
       -------------------------
       (select top 1 item_producto
        from Factura
        join Item_Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
        where year(fact_fecha) = 2012
              and item_producto in (select stoc_producto
                                    from STOCK 
                                    join DEPOSITO on stoc_deposito = depo_codigo
                                    where depo_zona = zona.zona_codigo 
                                          and stoc_cantidad > 0
                                   )
        group by item_producto
        order by sum(item_cantidad) desc
       ) as prod_estrella_de_zona,
       -------------------------
       (select top 1 fact_vendedor
        from Factura 
        join Item_Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
        where fact_vendedor in (select depo_encargado
                                from DEPOSITO
                                where depo_zona = zona.zona_codigo
                               )
        group by fact_vendedor
        order by sum(fact_total) desc
       ) as mejor_encargado
from Zona zona
join DEPOSITO dep on dep.depo_zona = zona.zona_codigo
group by zona.zona_codigo, zona.zona_detalle
having count(dep.depo_codigo) >= 3
order by mejor_encargado desc

-- Da el mismo resultado hacerlo asi que hacerlo como esta abajo

/* order by (select top 1 sum(fact_total)
          from Factura 
          join Item_Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
          where fact_vendedor in (select depo_encargado
                                  from DEPOSITO
                                  where depo_zona = zona.zona_codigo
                                 )
          group by fact_vendedor
          order by sum(fact_total) desc
         ) desc */


/* CONSULTAS AUXILIARES USADAS:
select top 1 item_producto, sum(item_cantidad)
from item_factura
join factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
where year(fact_fecha) = 2012
group by item_producto
order by sum(item_cantidad) desc

select count(stoc_producto)
        from STOCK 
        join DEPOSITO on stoc_deposito = depo_codigo
        where stoc_producto in (select comp_producto from Composicion) 
              and depo_zona = zona.zona_codigo
        --group by depo_zona

select fact_vendedor, sum(fact_total)
from Factura 
join Item_Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
where fact_vendedor in (select depo_encargado
                        from DEPOSITO
                        where depo_zona = '010'
                        )
group by fact_vendedor
order by sum(fact_total) desc

select * from Empleado

select depo_codigo, depo_encargado
from DEPOSITO
order by depo_encargado


select Zona.*, dep.depo_codigo
from Zona zona
join DEPOSITO dep on dep.depo_zona = zona.zona_codigo
order by zona.zona_detalle
*/
/*
25. Realizar una consulta SQL que para cada año y familia muestre :

    a. Año
    b. El código de la familia más vendida en ese año.
    c. Cantidad de Rubros que componen esa familia.
    d. Cantidad de productos que componen directamente al producto más vendido de 
    esa familia.
    e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa familia.
    f. El código de cliente que más compro productos de esa familia.
    g. El porcentaje que representa la venta de esa familia respecto al total de venta del año.

El resultado deberá ser ordenado por el total vendido por año y familia en forma descendente.
*/


select year(fprincipal.fact_fecha) as anio, 
       pprincipal.prod_familia,
       (select count(distinct prodAux.prod_rubro)
        from Producto prodAux
        where prodAux.prod_familia = pprincipal.prod_familia 
       ) as cant_rubros,
       count(distinct concat(fact_numero, '-', fact_sucursal, '-', fact_tipo)) as cant_facturas,
       (select clie_razon_social
        from Cliente
        where clie_codigo = (select top 1 f2.fact_cliente
                                from Factura f2
                                join Item_Factura i2 on f2.fact_numero+f2.fact_tipo+f2.fact_sucursal = i2.item_numero+i2.item_tipo+i2.item_sucursal
                                join Producto p2 on p2.prod_codigo = i2.item_producto
                                where p2.prod_familia = pprincipal.prod_familia and year(f2.fact_fecha) = year(fprincipal.fact_fecha)
                                group by f2.fact_cliente
                                order by sum(i2.item_cantidad) desc
                            )
       ) as mejor_cliente,
       sum(iprincipal.item_cantidad * iprincipal.item_precio) * 100 / ( select sum(i3.item_cantidad * i3.item_precio)
                                                                        from Item_Factura i3
                                                                        join Factura f3 on f3.fact_numero+f3.fact_tipo+f3.fact_sucursal = i3.item_numero+i3.item_tipo+i3.item_sucursal
                                                                        where year(f3.fact_fecha) = year(fprincipal.fact_fecha)
                                                                      ) as porcentaje_venta
from Producto pprincipal
join Item_Factura iprincipal on iprincipal.item_producto = pprincipal.prod_codigo
join Factura fprincipal on iprincipal.item_tipo+iprincipal.item_sucursal+iprincipal.item_numero = fprincipal.fact_tipo+fprincipal.fact_sucursal+fprincipal.fact_numero 
group by pprincipal.prod_familia, year(fprincipal.fact_fecha)
having prod_familia IN (select top 1 prod.prod_familia
                       from Producto prod
                       join Item_Factura item on item.item_producto = prod.prod_codigo
                       join Factura fact on item.item_tipo+item.item_sucursal+item.item_numero = fact.fact_tipo+fact.fact_sucursal+fact.fact_numero
                       where year(fact.fact_fecha) = year(fprincipal.fact_fecha)
                       group by year(fact.fact_fecha), prod.prod_familia
                       order by sum(item.item_cantidad) desc
                       ) 
order by sum(iprincipal.item_cantidad * iprincipal.item_precio) desc


/*
Me queda hacer: d. Cantidad de productos que componen directamente al producto más vendido de esa familia.
*/

-- Query auxiliar
select fami_detalle, count(distinct prod_codigo)
from Familia 
join Producto on fami_id = prod_familia
group by fami_detalle
order by 2 desc
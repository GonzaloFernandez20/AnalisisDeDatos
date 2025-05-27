/* Mostrar nombre de producto, cantidad de clientes distintos que lo compraron, importe 
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del 
producto y stock actual del producto en todos los depósitos. Se deberán mostrar 
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán 
ordenarse de mayor a menor por monto vendido del producto. */

/* OPCION 1: se toman en cuenta solo aquellos productos que tuvieron operaciones en 2012, pero restringiendo sus operaciones solamente a ese anio */

select prod_detalle, count (distinct fact_cliente) cant_clientes, 
        avg(item_precio) promedio_pagado, 
        (select count(distinct stoc_deposito) from stock where prod_codigo = stoc_producto) cant_deposito,
        (select sum(stoc_cantidad) from stock where stoc_producto = prod_codigo) stock_total
from Item_Factura
join factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal and year(fact_fecha) = 2012
join producto on prod_codigo = item_producto
group by prod_detalle, prod_codigo
order by SUM(item_precio * item_cantidad) desc


/* OPCION 2: se toman en cuenta aquellos productos que tuvieron operaciones en 2012, pero toma los registros de todos los anios, 
es decir, solo elimina aquellos productos que no tuvieron operaciones en 2012 */

select prod_detalle, count (distinct fact_cliente) cant_clientes, 
        avg(item_precio) promedio_pagado, 
        (select count(distinct stoc_deposito) from stock where prod_codigo = stoc_producto) cant_deposito,
        (select sum(stoc_cantidad) from stock where stoc_producto = prod_codigo) stock_total
from Item_Factura
join factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
join producto on prod_codigo = item_producto
where prod_codigo in (select item_producto 
                      from item_factura 
                      join factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
                      where year(fact_fecha) = 2012
                      )
group by prod_detalle, prod_codigo
order by SUM(item_precio * item_cantidad) desc
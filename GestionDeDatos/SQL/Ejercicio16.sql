/* Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran 
en  la  empresa,  se  pide  una  consulta  SQL  que  retorne  aquellos  clientes  cuyas  compras  
son inferiores a 1/3 del monto de ventas del producto que más se vendió en el 2012. 
 
Además mostrar 
 
1. Nombre del Cliente 
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente. 
3.  Código  de  producto  que  mayor  venta  tuvo  en  el  2012  (en  caso  de  existir  más  de  1, 
mostrar solamente el de menor código) para ese cliente. */


select clie_razon_social, 
        isnull(sum(item_cantidad), 0) unid_compradas,
        (select top 1 item_producto
         from factura
         join item_Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal and year(fact_fecha) = 2012
         where fact_cliente = clie_codigo
         group by item_producto
         order by sum(item_cantidad) desc
         ) producto_estrella
from cliente
join factura on fact_cliente = clie_codigo
join item_Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal and year(fact_fecha) = 2012
group by clie_codigo, clie_razon_social
having isnull((select sum(fact_total - fact_total_impuestos) from factura where fact_cliente = clie_codigo),0) < (  select top 1 sum(item_precio*item_cantidad)
                                                                                                                    from item_factura
                                                                                                                    join factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
                                                                                                                    where year(fact_fecha) = 2012
                                                                                                                    group by item_producto
                                                                                                                    order by sum(fact_total) desc) / 3
order by 2 desc


/* PRODUCTO QUE MAS SE VENDIO EN 2012 */
select top 1 sum(fact_total)
from item_factura
join factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
where year(fact_fecha) = 2012
group by item_producto
order by sum(fact_total) desc
/* PARCIAL 15/11/2022
Realizar una consulta SQL que permita saber los clientes que compraron todos los rubros disponibles del sistema en el 2012.
De estos clientes, mostrar siempre para el 2012:
		- El código de cliente
		- Codigo y nombre del producto que en cantidades más compro
		- Cantidad de productos distintos comprados por el cliente
		- Cantidad de productos con composicion comprados por el cliente

El resultado debera ser ordenado primero por razon social del cliente y luego los clientes que compraron entre un 20% y 30% del tottal factura en el 2012
*/

select clie.clie_codigo,
        -------------------------
       (select top 1 item_producto
        from Item_Factura
        join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
        where fact_cliente = clie.clie_codigo
        group by item_producto   
        order by sum(item_cantidad) desc
       ) as cod_producto_estrella,
        -------------------------
       (select top 1 prod_detalle
        from Item_Factura
        join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
        join Producto on prod_codigo = item_producto
        where fact_cliente = clie.clie_codigo
        group by prod_detalle  
        order by sum(item_cantidad) desc
       ) as cod_producto_estrella,
        -------------------------
       count(distinct prod.prod_codigo) as prod_distintos_comprados,
        -------------------------
       (select count(distinct comp_producto+comp_componente)
        from Item_Factura
        join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
        join Composicion on comp_producto = item_producto
        where fact_cliente = clie.clie_codigo
       ) as prod_distintos_con_comp
From Factura fact
join Item_Factura item on item.item_numero = fact.fact_numero
                       and item.item_tipo = fact.fact_tipo
                       and item.item_sucursal = fact.fact_sucursal
                       and year(fact.fact_fecha) = 2012
join Producto prod on prod.prod_codigo = item.item_producto
join Cliente clie on clie.clie_codigo = fact.fact_cliente
group by clie.clie_codigo
having count(distinct prod.prod_rubro) = (select count (distinct prod_rubro)
                                          from Producto 
                                          join Item_Factura on prod_codigo = item_producto
                                          join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
                                          where year(fact_fecha) = 2012   
                                         ) - 15 -- Esto esta asi para que devuelva algo
order by clie.clie_razon_social
/*        (select prod_detalle from Producto where prod_codigo = (select top 1 item_producto
                                                               from Item_Factura
                                                               join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
                                                               where fact_cliente = clie.clie_codigo
                                                               group by item_producto   
                                                               order by sum(item_cantidad) desc
                                                              )
       ) as det_producto_estrella,
       
 */


/* (select count(item_cantidad)
from Item_Factura
join Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
join Composicion on comp_producto = item_producto
where fact_cliente = clie.clie_codigo
      and item_producto in (select * from Composicion)
) as prod_distintos_con_comp */
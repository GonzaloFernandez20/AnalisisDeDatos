/* 
Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:

    DETALLE_RUBRO: Detalle del rubro
    VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
    PROD1: Código del producto más vendido de dicho rubro
    PROD2: Código del segundo producto más vendido de dicho rubro
    CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30  días

La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por cantidad de productos diferentes vendidos del rubro.
*/


---------------------------------------------------------------------

select rubr_id, 
       rubr_detalle,
       (
        select sum(item_cantidad*item_precio) ventas
        from Producto
        join Item_Factura on item_producto = prod_codigo
        where prod_rubro = rubr_id
       )as total_ventas,
       (select top 1 prod_detalle
            from Producto
            right join Item_Factura on item_producto = prod_codigo
            where prod_rubro = rubr_id 
            group by prod_detalle, prod_codigo
            order by sum(item_cantidad) desc                 
       ) mas_vendido,
       (SELECT clie_razon_social 
            FROM Cliente WHERE clie_codigo = (   SELECT top 1 fact_cliente 
                                                FROM Factura
                                                JOIN Item_Factura ON fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
                                                join Producto on prod_codigo = item_producto
                                                WHERE fact_fecha >= DATEADD(DAY, -30, CONVERT(datetime, '2012-07-16 00:00:00', 120))
                                                        and prod_rubro = rubr_id
                                                GROUP BY fact_cliente, prod_rubro
                                                ORDER BY SUM(item_cantidad) DESC
                                            )
        ) as mejor_cliente
from Rubro
group by rubr_id, rubr_detalle
--order by () desc



---------------------------------------------------------------------





/* Suma de las ventas en pesos de productos vendidos de dicho rubro */

select rubr_id, rubr_detalle, sum(item_cantidad*item_precio) ventas
from Producto
join Item_Factura on item_producto = prod_codigo
join Rubro on rubr_id = prod_rubro
group by rubr_id, rubr_detalle
order by 3 asc
  
select rubr_detalle, Item_Factura.*
from Producto
join Item_Factura on item_producto = prod_codigo
join Rubro on rubr_id = prod_rubro
where rubr_id = '0006'

/* Código del producto más vendido de dicho rubro */

select rubr_id, rubr_detalle, (
                               select top 1 prod_detalle
                               from Producto
                               right join Item_Factura on item_producto = prod_codigo
                               where prod_rubro = rubr_id 
                               group by prod_detalle, prod_codigo
                               order by sum(item_cantidad) desc
                              )
from Rubro


/* Código del cliente que compro más productos del rubro en los últimos 30  días */

select rubr_id, rubr_detalle, (SELECT clie_razon_social 
                                   FROM Cliente WHERE clie_codigo = (   SELECT top 1 fact_cliente 
                                                                        FROM Factura
                                                                        JOIN Item_Factura ON fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
                                                                        join Producto on prod_codigo = item_producto
                                                                        WHERE fact_fecha >= DATEADD(DAY, -30, CONVERT(datetime, '2012-07-16 00:00:00', 120))
                                                                              and prod_rubro = rubr_id
                                                                        GROUP BY fact_cliente, prod_rubro
                                                                        ORDER BY SUM(item_cantidad) DESC
                                                                    )
                              )
from Rubro



select fact_fecha
from Factura
order by fact_fecha DESC
/*


select rubr_id, rubr_detalle, (select top 1 prod_detalle
                               from Producto
                               where prod_rubro = rubr_id and
                                     prod_codigo = (
                                                    select top 1 item_producto
                                                    from Item_Factura
                                                    group by item_producto
                                                    order by sum(item_cantidad) desc
                                                   )
                              
                              )
from Rubro

/* Código del producto más vendido de dicho rubro */

*/
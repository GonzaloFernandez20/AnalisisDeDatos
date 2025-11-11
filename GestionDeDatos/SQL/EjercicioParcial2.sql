/* PARCIAL 01-07-2025
1. Realizar una consulta SQL que muestre aquellos clientes que en 2
años consecutivos compraron.
De estos clientes mostrar
	1. El código de cliente.
	2. El nombre del cliente.
	3. El numero de rubros que compro el cliente.
	4. La cantidad de productos con composición que compro el cliente en el 2012.

El resultado deberá ser ordenado por cantidad de facturas del cliente en toda la historia, de manera ascendente.

Nota: No se permiten select en el from, es decir, select ... from (select ...) as T,
*/

select fact.fact_cliente as codigo_cliente,
       clie.clie_razon_social as nombre_cliente,
       count(distinct prod_rubro) as cant_rubros,
       (select count(distinct c.comp_componente)
        from Item_Factura i 
        join Composicion c on c.comp_producto = i.item_producto
        join Factura f on i.item_tipo+i.item_sucursal+i.item_numero = f.fact_tipo+f.fact_sucursal+f.fact_numero
                       and f.fact_cliente = fact.fact_cliente
                       and year(f.fact_fecha) = 2012
       ) as cant_prod_compuestos_2012
from Factura fact
join Cliente clie on clie.clie_codigo = fact.fact_cliente
join Item_Factura item on item.item_numero = fact.fact_numero
                       and item.item_tipo = fact.fact_tipo
                       and item.item_sucursal = fact.fact_sucursal
join Producto on prod_codigo = item.item_producto
where exists (select f_aux.fact_cliente
              from Factura f_aux
              where f_aux.fact_cliente = fact.fact_cliente 
                    and year(f_aux.fact_fecha) = year(fact.fact_fecha))
      and exists (select f_aux.fact_cliente
                  from Factura f_aux
                  where year(f_aux.fact_fecha) = year(fact.fact_fecha) + 1
                        and f_aux.fact_cliente = fact.fact_cliente
                 )
group by fact.fact_cliente, clie.clie_razon_social
order by count(fact.fact_sucursal+fact.fact_tipo+fact.fact_numero) asc

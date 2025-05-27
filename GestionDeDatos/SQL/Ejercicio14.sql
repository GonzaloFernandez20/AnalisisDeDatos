/*  Escriba una consulta que retorne una  estadística de ventas por  cliente. Los campos que 
debe retornar son: 
 
Código del cliente 
Cantidad de veces que compro en el último año 
Promedio por compra en el último año 
Cantidad de productos diferentes que compro en el último año 
Monto de la mayor compra que realizo en el último año 
 
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en 
el último año. 
No se deberán visualizar NULLs en ninguna columna */

/* SOLUCION */

select  fact_cliente cliente, 
        count(distinct fact_numero) cant_compras, 
        avg(fact_total) promedio_compras, 
        max(fact_total) maxima_compra, 
        count(distinct item_producto) productos_diferentes
from factura
join item_factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
where year(fact_fecha) = (select max(year(fact_Fecha)) from Factura)
group by fact_cliente
order by count(fact_cliente) desc



/* CONSULTAS AUXILIARES */
select count(distinct item_producto) 
from Item_Factura 
join factura f1 on f1.fact_numero+f1.fact_tipo+f1.fact_sucursal = item_numero+item_tipo+item_sucursal
where f1.fact_cliente = '01634'

/*  Escriba una consulta que retorne una  estadística de ventas por cliente. Los campos que 
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

select clie_codigo, 
       clie_razon_social, 
       count(f1.fact_cliente) cant_compras,
       AVG(f1.fact_total) promedio_compras,
       ISNULL(cant_productos.prod_distintos, 0) AS cant_productos,
       max(f1.fact_total) mayor_compra
from Cliente
join Factura f1 on f1.fact_cliente = clie_codigo and year(fact_fecha) = 2012
left join(
           select f2.fact_cliente, count(distinct(item_producto)) prod_distintos
           from Factura f2
           join Item_Factura on f2.fact_numero+f2.fact_tipo+f2.fact_sucursal = item_numero+item_tipo+item_sucursal
           where year(fact_fecha) = 2012
           group by f2.fact_cliente
         ) as cant_productos on cant_productos.fact_cliente = clie_codigo
group by clie_codigo, clie_razon_social, cant_productos.prod_distintos
order by 3 desc

/*
select clie_codigo, 
       clie_razon_social, 
       count(fact_cliente) cant_compras,
       AVG(fact_total) promedio_compras,
       count(distinct(item_producto)) cant_productos,
       max(fact_total) mayor_compra
from Cliente
join Factura on fact_cliente = clie_codigo and year(fact_fecha) = 2012
join item_factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal -> Esto te rompio la atomicidad porque multiplico todo por la cant de productos de una factura
group by clie_codigo, clie_razon_social
order by 3 desc
*/

/* -------------------------------------------------------------------- */

/* Cantidad de veces que un cliente compro en un anio (2012) */

select clie_codigo, clie_razon_social, count(fact_cliente) cant_compras
from Cliente
join Factura on fact_cliente = clie_codigo and year(fact_fecha) = 2012
group by clie_codigo, clie_razon_social
order by 3 desc

/* Promedio por compra en el último año  */

select clie_codigo, clie_razon_social, AVG(fact_total) promedio_compras
from Cliente
join Factura on fact_cliente = clie_codigo and year(fact_fecha) = 2012
group by clie_codigo, clie_razon_social
order by 3 desc

/* Cantidad de productos diferentes que compro en el último año  */

select clie_codigo, clie_razon_social, count(distinct(item_producto)) cant_productos
from Cliente
join Factura on fact_cliente = clie_codigo and year(fact_fecha) = 2012
join item_factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
group by clie_codigo, clie_razon_social
order by 3 desc

/* Monto de la mayor compra que realizo en el último año  */

select clie_codigo, clie_razon_social, max(fact_total) mayor_compra
from Cliente
join Factura on fact_cliente = clie_codigo and year(fact_fecha) = 2012
group by clie_codigo, clie_razon_social
order by 3 desc



/* CONSULTAS AUXILIARES */
select count(distinct item_producto) 
from Item_Factura 
join factura f1 on f1.fact_numero+f1.fact_tipo+f1.fact_sucursal = item_numero+item_tipo+item_sucursal
where f1.fact_cliente = '01634'

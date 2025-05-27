USE GD2015C1

select fact_fecha, count(*) as cant_ventas, sum(fact_total) as total_facturado, max(fact_total) as venta_maxima, min(fact_total) as venta_minima, avg(fact_total) as promedio
from Factura
group by fact_fecha


select fact_cliente, count(*) as cant_ventas, sum(fact_total) as total_facturado, max(fact_total) as venta_maxima, min(fact_total) as venta_minima, avg(fact_total) as promedio
from Factura
group by fact_cliente
having sum(fact_total) > 10000
order by sum(fact_total) ASC


SELECT clie_codigo, clie_razon_social, COUNT(*), sum(f1.fact_total)
FROM Cliente
JOIN Factura f1 ON clie_codigo = f1.fact_cliente
WHERE YEAR(f1.fact_fecha) = 2012
GROUP BY clie_codigo, clie_razon_social
ORDER BY sum(f1.fact_total) DESC


SELECT clie_codigo, clie_razon_social, COUNT(fact_numero), sum(ISNULL(fact_total, 0))
FROM Cliente
LEFT JOIN Factura ON clie_codigo = fact_cliente
GROUP BY clie_codigo, clie_razon_social
ORDER BY sum(fact_total) DESC

-- COMANDO CASE (Similar al switch en C)
/* select *
case nota when 8 then 'BUENO' when 9 then 'EXCELENTE' when 10 then 'SOBRESALIENTE'
else 'NORMAL' end */

SELECT clie_codigo, clie_razon_social, 
case COUNT(fact_numero) when 0 then 'NADA' else 'MUCHO' end Cant_facturas, 
ISNULL((sum(fact_total)), 0)
FROM Cliente
LEFT JOIN Factura ON clie_codigo = fact_cliente
--WHERE YEAR(fact_fecha) = 2012
GROUP BY clie_codigo, clie_razon_social
ORDER BY sum(fact_total) DESC 


-- 2:05:29 

/* Realizar una consulta que muestre para todos los articulos: Codigo, Detalle y Cantidad de articulos que lo componen. Mostrar solo aquellos
articulos para los cuales el stock promedio por deposito sea mayor a 100 */

SELECT prod_codigo, prod_detalle, comp_cantidad
FROM Producto
JOIN Composicion ON comp_producto = prod_codigo 


-- SUBCONSULTAS: 




/* Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
producto y stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.*/

SELECT prod_detalle, COUNT(DISTINCT fact_cliente) AS clientes_que_compraron, AVG(item_precio) AS importe_promedio,
(SELECT COUNT(stoc_deposito) FROM STOCK WHERE stoc_producto = prod_Codigo) AS depositos_con_stock,
(SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = prod_codigo) AS stock_total FROM Producto
JOIN Item_Factura ON item_producto = prod_codigo
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
WHERE prod_codigo in (select item_producto from item_factura join factura 
        ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
        where year(fact_fecha) = 2012)
GROUP BY prod_codigo, prod_detalle
ORDER BY SUM(item_precio * item_cantidad) DESC

/* Realizar una consulta que retorne para cada producto que posea composición nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deberán mostrar los productos que estén
compuestos por más de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.*/


select p1.prod_detalle, p1.prod_precio, sum(p2.prod_precio*comp_cantidad)  
from composicion join producto p1 on p1.prod_codigo = comp_producto join producto p2 on p2.prod_codigo = comp_componente
group by p1.prod_detalle, p1.prod_precio
having count(*) >= 2
order by count(*) DESC


/* Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que
debe retornar son:

Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año

Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
No se deberán visualizar NULLs en ninguna columna */

Select clie_codigo, count(fact_numero), avg(isnull(fact_total,0)), (select count(distinct item_producto) item_producto from item_factura join factura on item_tipo+item_sucursal+item_numero 
                                                                    = fact_tipo+fact_sucursal+fact_numero
                                                                    where fact_cliente =clie_codigo and year(fact_fecha) =
                                                                    (select max(year(fact_Fecha)) from Factura)),
    max(isnull(fact_total,0)) 
from cliente left join factura on fact_cliente = clie_codigo and 
year(fact_fecha) = (select max(year(fact_Fecha)) from Factura)
group by clie_codigo
order by 2


/* Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:

PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2 */

select p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_Detalle, count(*)
from producto p1 join item_factura i1 on prod_codigo = item_producto join item_factura i2 
    on i1.item_tipo+i1.item_sucursal+i1.item_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero 
    join producto p2 on p2.prod_codigo = i2.item_producto 
where p1.prod_codigo < p2.prod_codigo
group by p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_Detalle 
having count(*) > 500

/* Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas compras
son inferiores a 1/3 del monto de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.*/

select clie_razon_social, sum(isnull(item_cantidad,0)), isnull((select top 1 item_producto from item_factura join factura on 
                                                fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero   
                                                where clie_codigo = fact_cliente and year(fact_fecha) = 2012
                                                group by item_producto
                                                order by sum(item_cantidad) desc, item_producto), 'Ninguno')                     
from cliente join factura on clie_codigo = fact_cliente left join item_factura on 
    fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero and 
    year(fact_fecha) = 2012    
group by clie_razon_social, clie_codigo 
having isnull((select sum(fact_total - fact_total_impuestos) from factura where fact_cliente = clie_codigo),0) < (select top 1 sum(item_precio*item_cantidad) from item_factura join factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero   
                                                where year(fact_fecha) = 2012
                                                group by item_producto
                                                order by sum(item_cantidad) desc) / 3
                                                order by 2 desc

/* Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.

La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo*/


select str(year(f1.fact_fecha),4)+right('00'+ltrim(str(Month(f1.fact_fecha),2)),2), prod_codigo, prod_detalle, sum(item_cantidad), 
    (select sum(i2.item_cantidad) from factura f2 join item_factura i2 on f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
    where year(f2.fact_fecha) = year(f1.fact_fecha)-1 and month(f2.fact_fecha) = month(f1.fact_fecha) and prod_codigo = i2.item_producto),
    count(distinct item_tipo+item_sucursal+item_numero)
from factura f1 join item_factura on f1.fact_tipo+f1.fact_sucursal+f1.fact_numero = item_tipo+item_sucursal+item_numero join Producto on prod_codigo = item_producto
group by year(f1.fact_fecha),Month(f1.fact_fecha), prod_codigo, prod_detalle
order by 1, prod_codigo 
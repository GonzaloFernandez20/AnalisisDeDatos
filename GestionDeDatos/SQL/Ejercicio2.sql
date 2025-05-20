/* Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por 
cantidad vendida. */

USE GD2025C1

SELECT prod_codigo, prod_detalle, SUM(item_cantidad) AS Cantidad_Vendida
FROM Producto
JOIN Item_Factura ON item_producto = prod_codigo
JOIN Factura ON fact_numero = item_numero
WHERE YEAR(fact_fecha) = 2012
GROUP BY prod_codigo, prod_detalle
ORDER BY SUM(item_cantidad) DESC


/*  CONSULTA OPTIMIZADA:

WHERE YEAR(fact_fecha) = 2012 ----> WHERE fact_fecha >= '2012-01-01' AND fact_fecha < '2013-01-01'

  ** El uso de YEAR(fact_fecha) = 2012 en el WHERE puede afectar la eficiencia de la consulta si fact_fecha está indexada. 
     Esto se debe a que aplicar YEAR() sobre una columna impide que el índice se use correctamente.

SELECT p.prod_codigo, p.prod_detalle, SUM(i.item_cantidad) AS Cantidad_Vendida
FROM Producto p
JOIN Item_Factura i ON i.item_producto = p.prod_codigo
JOIN Factura f ON f.fact_numero = i.item_numero
WHERE f.fact_fecha >= '2012-01-01' 
  AND f.fact_fecha < '2013-01-01'
GROUP BY p.prod_codigo, p.prod_detalle
ORDER BY Cantidad_Vendida DESC;
*/

/* VARIANTE:
select item_producto, 
       (select prod_detalle 
        from producto 
        where prod_codigo = item_producto)
from item_factura 
join factura 
    on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
--join Producto on item_producto = prod_codigo
where year(fact_fecha) = 2012
group by item_producto
order by sum(item_cantidad)

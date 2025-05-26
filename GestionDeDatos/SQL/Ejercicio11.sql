/* Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán 
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga, 
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para 
el año 2012. */

SELECT fami_detalle, COUNT(DISTINCT prod_codigo) Prod_Vendidos, SUM(item_cantidad*item_precio) Total_Ventas
FROM Familia
JOIN Producto ON fami_id = prod_familia
JOIN Item_Factura ON item_producto = prod_codigo
GROUP BY fami_id, fami_detalle
HAVING fami_id IN (  SELECT prod_familia
                     FROM producto 
                     JOIN Item_Factura on prod_codigo = item_producto
                     JOIN Factura on fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
                     WHERE YEAR(fact_fecha) = 2012
                     GROUP BY prod_familia
                     HAVING SUM(item_cantidad*item_precio) > 20000
                  )
ORDER BY 2 DESC



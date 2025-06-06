/* Realizar  una  consulta que  muestre  código  de artículo, detalle  y  cantidad  de  egresos  de 
stock  que  se  realizaron  para  ese  artículo  en  el  año  2012  (egresan  los  productos  que 
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011. */

USE GD2015C1
/* Forma correcta de hacerlo, comparando directamente con el resultado de mediante una subconsulta traer el mismo articulo pero del anio anterior */
SELECT prod_codigo, prod_detalle, SUM(item_cantidad)
FROM Producto
JOIN Item_Factura on prod_codigo = item_producto
JOIN Factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero /* Joineamos por la PK completa, entonces a lo sumo va a traer filas en una relacion 1 a 1 */
WHERE YEAR(fact_fecha) = 2012
GROUP BY prod_codigo, prod_detalle
HAVING SUM(item_cantidad) > (SELECT sum(item_cantidad)
                             FROM Item_Factura
                             JOIN Factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
                             WHERE YEAR(fact_fecha) = 2011 AND item_producto = prod_codigo
                             )
ORDER BY 1


/* SELECT 
    prod_codigo, prod_detalle,
    SUM(CASE WHEN YEAR(fact_fecha) = 2012 THEN item_cantidad END) AS egresos_2012,
    SUM(CASE WHEN YEAR(fact_fecha) = 2011 THEN item_cantidad END) AS egresos_2011
FROM Producto
JOIN Item_Factura ON item_producto = prod_codigo
JOIN Factura ON fact_numero = item_numero
GROUP BY prod_codigo, prod_detalle
HAVING SUM(CASE WHEN YEAR(fact_fecha) = 2012 THEN item_cantidad END)
     > SUM(CASE WHEN YEAR(fact_fecha) = 2011 THEN item_cantidad END) */


/* Alternativa usando subconsultas:
SELECT prod_codigo, prod_detalle, 
       (SELECT SUM(item_cantidad) 
        FROM Item_Factura 
        JOIN Factura ON fact_numero = item_numero 
        WHERE YEAR(fact_fecha) = 2012 AND item_producto = prod_codigo) AS egresos_2012
FROM Producto
JOIN Item_Factura ON item_producto = prod_codigo
JOIN Factura ON fact_numero = item_numero
GROUP BY prod_codigo, prod_detalle
HAVING (SELECT SUM(item_cantidad) 
        FROM Item_Factura 
        JOIN Factura ON fact_numero = item_numero 
        WHERE YEAR(fact_fecha) = 2012 AND item_producto = prod_codigo) 
     > (SELECT SUM(item_cantidad) 
        FROM Item_Factura 
        JOIN Factura ON fact_numero = item_numero 
        WHERE YEAR(fact_fecha) = 2011 AND item_producto = prod_codigo);

Esta opcion es mas intuitiva pero menos eficiente, porque tiene que hacer 2 consultas por cada producto, duplicando el tiempo de ejecucion.
*/
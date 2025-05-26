/* Generar  una  consulta  que  muestre  para  cada  artículo  código,  detalle,  mayor  precio 
menor precio  y  %  de la  diferencia  de precios (respecto  del  menor Ej.:  menor precio = 
10,  mayor  precio  =12  =>  mostrar  20  %).  Mostrar  solo  aquellos  artículos  que  posean 
stock. */

USE GD2015C1

SELECT prod_codigo, prod_detalle, 
       MIN(item_precio) AS Precio_minimo, 
       MAX(item_precio) AS Precio_maximo, 
       CONCAT(FORMAT(((MAX(item_precio) - MIN(item_precio)) / MIN(item_precio)) * 100, 'N2'), '%') AS Diferencia_Porcentaje
FROM Producto
JOIN Item_Factura ON item_producto = prod_codigo
WHERE prod_codigo IN (SELECT stoc_producto FROM STOCK GROUP BY stoc_producto HAVING SUM(stoc_cantidad) > 0) /* -> Con esto conservamos la atomicidad de la consulta */
--JOIN STOCK ON stoc_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
-- HAVING SUM(stoc_cantidad) > 0 -> En este caso puntual esto podria estar aca y evitar el subselect pero solo funciona porque el min y el max no se ven afectados, si hubiera un SUM ya no funciona porque la atomicidad fue comprometida (Multiplica la cantidad en stock por la cantidad de depositos donde hay stock, el join con stock compromente en este caso)
ORDER BY prod_codigo ASC

/*  
[...] mayor  precio menor precio  y  %  de la  diferencia  de precios [...] ->
lo que se me ocurre es comparar todas las facturas a lo largo de los años para un producto y revisar la variacion de precio */


/* 
    Sentencia para traer un producto facturado en un año especifico
SELECT * FROM Item_Factura
JOIN Factura ON fact_numero = item_numero
WHERE YEAR(fact_fecha) = 2012 AND item_producto = '00001415' */

/*
JOIN Item_Factura ON item_producto = prod_codigo
WHERE stoc_cantidad > 0
GROUP BY prod_codigo, prod_detalle

Creo que en este caso no es necesario el where porque el JOIN es restrictivo respecto a traer productos que no tengan existencias en stock, creo...

-> Actualizacion desde un futuro cercano: Ojo con los JOINs porque es verdad que son restrictivos, pero modifican la cantidad de filas que traen, especialmente si no se agrupa por PK estricta. 
*/
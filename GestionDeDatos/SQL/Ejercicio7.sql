/* Generar  una  consulta  que  muestre  para  cada  artículo  código,  detalle,  mayor  precio 
menor precio  y  %  de la  diferencia  de precios (respecto  del  menor Ej.:  menor precio = 
10,  mayor  precio  =12  =>  mostrar  20  %).  Mostrar  solo  aquellos  artículos  que  posean 
stock. */

USE GD2025C1

SELECT prod_codigo, prod_detalle, 
       MIN(item_precio) AS Precio_minimo, 
       MAX(item_precio) AS Precio_maximo, 
       CONCAT(FORMAT(((MAX(item_precio) - MIN(item_precio)) / MIN(item_precio)) * 100, 'N2'), '%') AS Diferencia_Porcentaje
FROM Producto
JOIN STOCK ON stoc_producto = prod_codigo
JOIN Item_Factura ON item_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
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
*/
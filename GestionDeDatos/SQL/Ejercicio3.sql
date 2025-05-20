/* Realizar  una  consulta que  muestre  código  de producto, nombre  de producto  y  el stock 
total,  sin  importar  en  que  deposito  se  encuentre,  los  datos  deben  ser  ordenados  por 
nombre del artículo de menor a mayor. */

USE GD2025C1

SELECT prod_codigo, prod_detalle, COALESCE(SUM(stoc_cantidad), 0)  AS Cantidad_stock
FROM Producto
LEFT JOIN STOCK ON stoc_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
ORDER BY prod_detalle ASC


/* COALESCE(SUM(stoc_cantidad), 0) reemplaza los valores null por 0 
   SUM(ISNULL(stoc_cantidad, 0)) -> Un poco mejor, mas clara la sintaxis
*/
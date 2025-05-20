/* Mostrar para  todos los  rubros  de artículos  código, detalle,  cantidad  de artículos  de  ese 
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que 
tengan un stock mayor al del artículo '00000000' en el depósito '00'. */

USE GD2015C1

SELECT rubr_id, rubr_detalle, COUNT(DISTINCT(prod_codigo)) AS Cant_articulos, SUM(ISNULL(stoc_cantidad,0)) AS Stock_rubro
FROM Rubro
LEFT JOIN Producto ON prod_rubro = rubr_id AND prod_codigo IN (SELECT stoc_producto 
                                                               FROM STOCK GROUP BY stoc_producto 
                                                               HAVING SUM(stoc_cantidad) > (SELECT ISNULL(stoc_cantidad, 0) 
                                                                                            FROM STOCK
                                                                                            WHERE stoc_producto = '00000000' AND stoc_deposito = '00' 
                                                                                            )
                                                               )
LEFT JOIN STOCK ON stoc_producto = prod_codigo 
GROUP BY rubr_id, rubr_detalle
ORDER BY 4

/*
Esta es la manera correcta de hacerlo, donde directamente en el join ya unimos la tabla producto con 
una tabla ya filtrada con la condicion que queremos aplicar.
*/


/*

INCORRECTAS:

 SELECT rubr_id, rubr_detalle, COUNT(DISTINCT(prod_codigo)) AS Cant_articulos, SUM(ISNULL(stoc_cantidad,0)) AS Stock_rubro
FROM Rubro
JOIN Producto ON prod_rubro = rubr_id
JOIN STOCK ON stoc_producto = prod_codigo
WHERE stoc_cantidad > ( SELECT stoc_cantidad
                        FROM STOCK
                        JOIN Producto ON prod_codigo = stoc_producto
                        WHERE prod_codigo = '00000000' AND stoc_deposito = '00')
GROUP BY rubr_id, rubr_detalle
ORDER BY rubr_id ASC */

/* Alternativa:

SELECT rubr_id, rubr_detalle, 
       COUNT(DISTINCT prod_codigo) AS Cant_articulos, 
       SUM(s.stoc_cantidad) AS Stock_rubro
FROM Rubro 
JOIN Producto  ON prod_rubro = rubr_id
JOIN STOCK s ON s.stoc_producto = prod_codigo
JOIN STOCK art_referencia ON art_referencia.stoc_producto = '00000000' AND art_referencia.stoc_deposito = '00'
WHERE s.stoc_cantidad > art_referencia.stoc_cantidad
GROUP BY rubr_id, rubr_detalle
ORDER BY rubr_id ASC

En lugar de usar un WHERE con un subquery, agregamos un JOIN adicional a la misma tabla STOCK, 
pero filtrando directamente por el producto '00000000' en el depósito '00'.
*/
/* Mostrar para  todos los  rubros  de artículos  código, detalle,  cantidad  de artículos  de  ese 
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que 
tengan un stock mayor al del artículo '00000000' en el depósito '00'. */

USE GD2025C1

SELECT rubr_id, rubr_detalle, COUNT(DISTINCT(prod_codigo)) AS Cant_articulos, SUM(stoc_cantidad) AS Stock_rubro
FROM Rubro
JOIN Producto ON prod_rubro = rubr_id
JOIN STOCK ON stoc_producto = prod_codigo
WHERE stoc_cantidad > ( SELECT stoc_cantidad
                        FROM STOCK
                        JOIN Producto ON prod_codigo = stoc_producto
                        WHERE prod_codigo = '00000000' AND stoc_deposito = '00')
GROUP BY rubr_id, rubr_detalle
ORDER BY rubr_id ASC


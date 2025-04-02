/* Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de 
artículos  que  lo  componen.  Mostrar  solo  aquellos  artículos  para  los  cuales  el  stock 
promedio por depósito sea mayor a 100. */

SELECT prod_codigo, prod_detalle, AVG(stoc_cantidad) AS promedio_stock, SUM(comp_cantidad) as Total_componentes
FROM Producto
LEFT JOIN STOCK ON stoc_producto = prod_codigo
JOIN DEPOSITO ON stoc_deposito = depo_codigo
LEFT JOIN Composicion ON comp_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
HAVING AVG(stoc_cantidad) > 100



/*
SUM(comp_cantidad) as Total_componentes  ----> Son pocos los productos compuestos, por lo que la mayoria de los valores son null

Si quiero filtrar usando una función agregada (AVG(), SUM(), etc.), tiene que ser en el HAVING, porque esas funciones solo se calculan después de agrupar
*/
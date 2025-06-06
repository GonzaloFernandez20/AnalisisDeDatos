/* Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de 
artículos  que  lo  componen.  Mostrar  solo  aquellos  artículos  para  los  cuales  el  stock 
promedio por depósito sea mayor a 100. */

SELECT prod_codigo, prod_detalle, AVG(stoc_cantidad) AS promedio_stock, COUNT(DISTINCT comp_componente) as Total_componentes
FROM Producto
/*LEFT JOIN STOCK ON stoc_producto = prod_codigo -> Esta mal porque no igual por PK lo que hace que traiga resultados demas, salvo que use el DISTINCT. El LEFT esta demas*/
JOIN STOCK ON stoc_producto = prod_codigo
JOIN DEPOSITO ON stoc_deposito = depo_codigo
LEFT JOIN Composicion ON comp_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
HAVING AVG(stoc_cantidad) > 100
 


/*
COUNT(comp_componente) as Total_componentes  ----> Son pocos los productos compuestos, por lo que la mayoria de los valores son null

Si quiero filtrar usando una función agregada (AVG(), SUM(), etc.), tiene que ser en el HAVING, porque esas funciones solo se calculan después de agrupar
*/

SELECT prod_codigo, prod_detalle, COUNT(comp_componente) as Total_componentes
FROM Producto
LEFT JOIN Composicion ON comp_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle


SELECT prod_codigo, prod_detalle, COUNT(comp_componente) as Total_componentes
FROM Producto
LEFT JOIN Composicion ON comp_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
HAVING prod_codigo IN (SELECT stoc_producto FROM STOCK GROUP BY stoc_producto HAVING AVG(stoc_cantidad) > 100)

/* El DISTINCT en un COUNT te puede salvar errores de duplicados, no asi en un sum, si yo necesitara
saber la suma de stock en todos los depositos, ahi me puede sumar duplicados si: no agrupo por toda la pk o no hago el sub select */



SELECT prod_codigo, prod_detalle, COUNT(comp_componente) as Total_componentes
FROM Producto
LEFT JOIN Composicion ON comp_producto = prod_codigo
WHERE prod_codigo IN (SELECT stoc_producto FROM STOCK GROUP BY stoc_producto HAVING AVG(stoc_cantidad) > 100)
GROUP BY prod_codigo, prod_detalle

/* Podria hacer esto pero es mucho menos performante porque al hacer la subconsulta en el where, aumento exponencialmente la cantidad de 
operaciones que hace. Al hacerla en el having, comparo contra la que quedo del where, reduciendo la 
cantidad de comparaciones significativamente. 
Siempre en el having voy a tener menos filas, lo mejor es buscar que la consulta compare con la menor cantidad de filas posibles.
Ademas es preferible usar una consulta estatica (No depende de valores fue de la consulta)
*/
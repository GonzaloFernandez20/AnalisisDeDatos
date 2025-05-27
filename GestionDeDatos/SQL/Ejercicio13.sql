/* Realizar  una  consulta que retorne para  cada producto  que posea  composición: nombre 
del producto, precio  del producto, precio de la sumatoria de los precios por la cantidad 
de  los  productos  que  lo  componen.  Solo  se  deberán  mostrar  los  productos  que  estén 
compuestos  por  más  de  2  productos  y  deben  ser  ordenados  de  mayor  a  menor  por 
cantidad de productos que lo componen. */


select p1.prod_detalle, p1.prod_precio, sum(p2.prod_precio*comp_cantidad)
from Composicion
join producto p1 on p1.prod_codigo = comp_producto
join producto p2 on p2.prod_codigo = comp_componente
group by p1.prod_detalle, p1.prod_precio
having count(*) >= 2
order by p1.prod_detalle, p1.prod_precio desc
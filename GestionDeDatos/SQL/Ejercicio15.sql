/*  Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos 
(en  la  misma  factura)  más  de  500 veces.  El  resultado  debe  mostrar  el código y 
descripción  de  cada  uno  de  los  productos  y  la  cantidad  de  veces  que  fueron  vendidos 
juntos.  El  resultado  debe  estar  ordenado  por  la  cantidad  de  veces  que  se  vendieron 
juntos dichos productos. Los distintos pares no deben retornarse más de una vez. 
 
Ejemplo de lo que retornaría la consulta: 
  
PROD1 DETALLE1 PROD2 DETALLE2 VECES 
1731 MARLBORO KS 1718 PHILIPS MORRIS KS 507 
1718 PHILIPS MORRIS KS 1705 PHILIPS MORRIS BOX 10 562  */

/*

Desglose del ejercicio:
Parte 1: Obtener los pares de productos que existen en el sistema, representa el producto cartesiano entre productos sacando la combinacion de un producto consigo mismo.
    select *  
    from Item_Factura prod1
    join Item_Factura prod2 on prod1.item_tipo+prod1.item_sucursal+prod1.item_numero = prod2.item_tipo+prod2.item_sucursal+prod2.item_numero and prod1.item_producto < prod2.item_producto

Parte 2: Obtener los pares de productos de una Factura en especifico. 
    select fact_numero, prod1.item_producto, prod2.item_producto
    from Item_Factura prod1
    join Item_Factura prod2 on prod1.item_tipo+prod1.item_sucursal+prod1.item_numero = 
                            prod2.item_tipo+prod2.item_sucursal+prod2.item_numero and 
                            prod1.item_producto < prod2.item_producto
    join Factura on fact_tipo+fact_sucursal+fact_numero = prod1.item_tipo+prod1.item_sucursal+prod1.item_numero
    where fact_numero = 00089684

Paso 3: Sumar directamente los pares.
agrupamos los pares de productos y contamos la cantidad de veces que se repite ese par. 

*/

select
    p1.prod_codigo,
    p1.prod_detalle,
    p2.prod_codigo,
    p2.prod_detalle, 
    count(*) as veces
from Item_Factura prod1
join Item_Factura prod2 on prod1.item_tipo+prod1.item_sucursal+prod1.item_numero = 
                           prod2.item_tipo+prod2.item_sucursal+prod2.item_numero and 
                           prod1.item_producto > prod2.item_producto /* -> Esto me asegura no traer el mismo par con los valores cambiados. */
join Factura on fact_tipo+fact_sucursal+fact_numero = prod1.item_tipo+prod1.item_sucursal+prod1.item_numero
join Producto p1 on p1.prod_codigo = prod1.item_producto
join Producto p2 on p2.prod_codigo = prod2.item_producto
group by p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
having count(*) > 500

/*  Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos 
(en  la  misma  factura)  más  de  500 veces.  El  resultado  debe  mostrar  el código y 
descripción  de  cada  uno  de  los  productos  y  la  cantidad  de  veces  que  fueron  vendidos 
juntos.  El  resultado  debe  estar  ordenado  por  la  cantidad  de  veces  que  se  vendieron 
juntos dichos productos. Los distintos pares no deben retornarse más de una vez. 
 
Ejemplo de lo que retornaría la consulta: 
  
PROD1 DETALLE1 PROD2 DETALLE2 VECES 
1731 MARLBORO KS 1718 PHILIPS MORRIS KS 507 
1718 PHILIPS MORRIS KS 1705 PHILIPS MORRIS BOX 10 562  */

select prod1.prod_codigo, prod1.prod_detalle,
       prod2.prod_codigo, prod2.prod_detalle,
       count(prod1.prod_codigo + prod2.prod_codigo) as veces
from Item_Factura item1
join Item_Factura item2 on item2.item_numero = item1.item_numero
                        and item2.item_tipo = item1.item_tipo
                        and item2.item_sucursal = item1.item_sucursal
                        and item2.item_producto < item1.item_producto -- Con esto rompemos la simetria y evitamos pares iguales pero inversos
join Factura fact on fact.fact_numero = item2. item_numero
                  and fact.fact_tipo = item2.item_tipo
                  and fact.fact_sucursal = item2.item_sucursal
join Producto prod1 on item1.item_producto = prod1.prod_codigo
join Producto prod2 on item2.item_producto = prod2.prod_codigo
group by prod1.prod_codigo, prod1.prod_detalle,
                           prod2.prod_codigo, prod2.prod_detalle
having count(prod1.prod_codigo + prod2.prod_codigo) > 500
order by 5 desc

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

--------------------------------------------------------------------------------------------------------
--Solucion del profe
select p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_Detalle, count(*)
from producto p1 join item_factura i1 on prod_codigo = item_producto join item_factura i2 
    on i1.item_tipo+i1.item_sucursal+i1.item_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero 
    join producto p2 on p2.prod_codigo = i2.item_producto 
where p1.prod_codigo < p2.prod_codigo
group by p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_Detalle 
having count(*) > 500
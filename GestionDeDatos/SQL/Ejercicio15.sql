/*  Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos 
(en  la  misma  factura)  más  de  500 veces.  El  resultado  debe  mostrar  el código y 
descripción  de  cada  uno  de  los  productos  y  la  cantidad  de  veces  que  fueron  vendidos 
juntos.  El  resultado  debe  estar  ordenado  por  la  cantidad  de  veces  que  se  vendieron 
juntos dichos productos. Los distintos pares no deben retornarse más de una vez. 
 
Ejemplo de lo que retornaría la consulta: 
  
PROD1 DETALLE1 PROD2 DETALLE2 VECES 
1731 MARLBORO KS 1718 PHILIPS MORRIS KS 507 
1718 PHILIPS MORRIS KS 1705 PHILIPS MORRIS BOX 10 562  */


select prod_1.item_producto
from item_factura prod_1
join item_factura prod_2 on prod_1.item_numero+prod_1.item_tipo+prod_1.item_sucursal = prod_2.item_numero+prod_2.item_tipo+prod_2.item_sucursal 


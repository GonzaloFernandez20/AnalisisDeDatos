/* Mostrar  para  el  o  los  artículos  que  tengan  stock  en  todos  los  depósitos,  nombre  del 
artículo, stock del depósito que más stock tiene. */

select prod_detalle , MAX(stoc_cantidad) 
from producto join stock on prod_codigo = stoc_producto
group by prod_detalle 
having count(*) = (select count(*) from deposito)

/* Solucion mejor encaminada */
select prod_detalle, (select top 1 depo_detalle from STOCK join DEPOSITO on depo_codigo = stoc_deposito
					  where stoc_producto = prod_codigo )
from Producto join STOCK ON stoc_producto = prod_codigo
where stoc_cantidad > 0 /* Aca filtramos que solo traiga productos donde haya stock */
group by prod_detalle, prod_codigo
having count(*) = ((select count (*) from DEPOSITO))

/* Solucion alternativa 1 */   
SELECT prod_codigo, prod_detalle, MAX(stoc_cantidad) AS Stock_maximo 
FROM Producto
JOIN STOCK ON stoc_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
HAVING SUM(stoc_cantidad) >= (SELECT COUNT(depo_detalle) FROM DEPOSITO)
ORDER BY prod_codigo ASC

/* Solucion alternativa 2*/
select prod_detalle, (select top 1 depo_detalle from STOCK join DEPOSITO on depo_codigo = stoc_deposito
					  where stoc_producto = prod_codigo )
from Producto
where (select count(depo_codigo)
	   from STOCK join DEPOSITO on depo_codigo = stoc_deposito
	   where stoc_producto = prod_codigo ) = ((select count (*) from DEPOSITO))


/* 
    Consulta para obtener todos los depositos donde aparece un producto: 

SELECT prod_codigo, prod_detalle, depo_detalle, stoc_cantidad
FROM Producto
JOIN STOCK ON stoc_producto = prod_codigo
JOIN DEPOSITO ON depo_codigo = stoc_deposito
WHERE prod_codigo = '00001415' */

/* SELECT * FROM DEPOSITO */

/* HAVING COUNT(DISTINCT stoc_deposito) = (SELECT COUNT(*) FROM DEPOSITO)
Usando este comando me arroja como resultado que ningun producto esta en todos los depositos (?)
 */


SELECT prod_codigo, prod_detalle
FROM Producto
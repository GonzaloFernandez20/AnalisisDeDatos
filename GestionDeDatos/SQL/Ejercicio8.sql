/* Mostrar  para  el  o  los  artículos  que  tengan  stock  en  todos  los  depósitos,  nombre  del 
artículo, stock del depósito que más stock tiene. */

SELECT prod_codigo, prod_detalle, MAX(stoc_cantidad) AS Stock_maximo 
FROM Producto
JOIN STOCK ON stoc_producto = prod_codigo
JOIN DEPOSITO ON depo_codigo = stoc_deposito
GROUP BY prod_codigo, prod_detalle
HAVING COUNT(stoc_producto) = (SELECT COUNT(depo_detalle) FROM DEPOSITO)
ORDER BY prod_codigo ASC


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

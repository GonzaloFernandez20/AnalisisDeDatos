/*  Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos 
vendidos  en  la  historia.  Además  mostrar  de  esos  productos,  quien  fue  el  cliente  que 
mayor compra realizo. */

SELECT prod_codigo, prod_detalle, (SELECT clie_razon_social 
                                   FROM Cliente WHERE clie_codigo = (   SELECT top 1 fact_cliente 
                                                                        FROM Factura
                                                                        JOIN Item_Factura ON fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
                                                                        WHERE prod_codigo = item_producto
                                                                        GROUP BY fact_cliente 
                                                                        ORDER BY SUM(item_cantidad) DESC
                                                                    )
                                    )
FROM Producto
WHERE prod_codigo IN (SELECT TOP 10 item_producto
                      FROM Item_Factura
                      GROUP BY item_producto
                      ORDER BY SUM(item_cantidad) desc)
                      or prod_codigo IN
                      (SELECT TOP 10 item_producto
                      FROM Item_Factura
                      GROUP BY item_producto
                      ORDER BY SUM(item_cantidad))


/* PRODUCTOS MAS VENDIDOS */
SELECT TOP 10 item_producto
FROM Item_Factura
GROUP BY item_producto
ORDER BY SUM(item_cantidad) desc


/* PRODUCTOS MENOS VENDIDOS */
SELECT TOP 10 item_producto, SUM(item_cantidad) 
FROM Item_Factura
GROUP BY item_producto
ORDER BY SUM(item_cantidad)


/* LOS 10 CLIENTES MAS COMPRADORES DE UN PRODUCTO */
SELECT top 10 clie_razon_social, item_producto, sum(item_cantidad)
FROM Cliente
JOIN Factura ON clie_codigo = fact_cliente
JOIN Item_Factura ON fact_numero+fact_tipo+fact_sucursal = item_numero+item_tipo+item_sucursal
GROUP BY clie_razon_social, item_producto
ORDER BY sum(item_cantidad) DESC

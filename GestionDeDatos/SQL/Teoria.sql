/*
La tabla Composicion dentro de este modelo busca mediante la columna comp_producto representar al combo (Composicion de productos) y mediante su columna comp_componente a los productos que integran el combo.
La diferencia es que los productos que perteneces a comp_producto son productos virtuales que sirven al momento de facturar una venta, pero no son reales porque en realidad el producto real son aquellos productos que integran el combo.

Con esta consulta podemos ver los productos que vienen en combo.

SELECT Composicion.*, prod.prod_detalle, comp.prod_detalle
FROM Composicion
join Producto prod on prod.prod_codigo = comp_producto
join Producto comp on comp.prod_codigo = comp_componente
*/
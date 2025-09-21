/*
Escriba una consulta que retorne una estadística de ventas por año y mes para cada producto.
La consulta debe retornar:

    PERIODO: Año y mes de la estadística con el formato YYYYMM
    PROD: Código de producto
    DETALLE: Detalle del producto
    CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
    VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo pero del año anterior
    CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el periodo

La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por periodo y código de producto.
*/

select 
    CONCAT( YEAR(f_actual.fact_fecha), '-', RIGHT('0' + CAST(MONTH(f_actual.fact_fecha) AS varchar(2)), 2) ) AS periodo,
    prod_codigo, 
    sum(i_actual.item_cantidad) cantidad_vendida,
    sum(i_previo.item_cantidad) ventas_anio_anterior
from Producto
join Item_Factura i_actual on i_actual.item_producto = prod_codigo
join Factura f_actual on f_actual.fact_tipo+f_actual.fact_sucursal+f_actual.fact_numero = i_actual.item_tipo+i_actual.item_sucursal+i_actual.item_numero

join Item_Factura i_previo on i_previo.item_producto = prod_codigo
join Factura f_previa on f_previa.fact_tipo+f_previa.fact_sucursal+f_previa.fact_numero = i_previo.item_tipo+i_previo.item_sucursal+i_previo.item_numero
                         and year(f_previa.fact_fecha) = year(f_actual.fact_fecha) - 1
                         and month(f_previa.fact_fecha) = month(f_actual.fact_fecha)
where prod_codigo = '00001121'
group by 
    prod_codigo, 
    CONCAT(YEAR(f_actual.fact_fecha), '-', RIGHT('0' + CAST(MONTH(f_actual.fact_fecha) AS varchar(2)), 2))
order by periodo, prod_codigo


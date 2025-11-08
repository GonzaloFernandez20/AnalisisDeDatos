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
    prod.prod_codigo, prod.prod_detalle,
    sum(i_actual.item_cantidad) as cant_vendida,
    (select sum(i_previo.item_cantidad)
     from Item_Factura i_previo
     join Factura f_previo on f_previo.fact_tipo+f_previo.fact_sucursal+f_previo.fact_numero = i_previo.item_tipo+i_previo.item_sucursal+i_previo.item_numero
     where year(f_previo.fact_fecha) = year(f_previo.fact_fecha) - 1
           and month(f_previo.fact_fecha) = month(f_previo.fact_fecha)
           and prod.prod_codigo = i_previo.item_producto
    ) as ventas_periodo_ant,
    count(distinct concat(f_actual.fact_numero, '-', f_actual.fact_sucursal, '-', f_actual.fact_tipo)) as cant_facturas
from Producto prod
join Item_Factura i_actual on i_actual.item_producto = prod.prod_codigo
join Factura f_actual on f_actual.fact_tipo+f_actual.fact_sucursal+f_actual.fact_numero = i_actual.item_tipo+i_actual.item_sucursal+i_actual.item_numero
--where prod_codigo = '00000102'
group by 
    CONCAT(YEAR(f_actual.fact_fecha), '-', RIGHT('0' + CAST(MONTH(f_actual.fact_fecha) AS varchar(2)), 2)), 
    prod.prod_codigo, prod.prod_detalle
order by 1 desc, prod.prod_codigo 

-------------------------------------------------------------------------------------------------------------------------
--Solucion del profe

select str(year(f1.fact_fecha),4)+right('00'+ltrim(str(Month(f1.fact_fecha),2)),2), 
       prod_codigo, 
       prod_detalle, 
       sum(item_cantidad), 
       (select sum(i2.item_cantidad) 
        from factura f2 
        join item_factura i2 on f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
        where year(f2.fact_fecha) = year(f1.fact_fecha)-1  
              and month(f2.fact_fecha) = month(f1.fact_fecha) 
              and prod_codigo = i2.item_producto),
        count(distinct item_tipo+item_sucursal+item_numero)
from factura f1 
join item_factura on f1.fact_tipo+f1.fact_sucursal+f1.fact_numero = item_tipo+item_sucursal+item_numero 
join Producto on prod_codigo = item_producto
where prod_codigo = '00000102'
group by year(f1.fact_fecha), Month(f1.fact_fecha), prod_codigo, prod_detalle
order by 1 desc, prod_codigo

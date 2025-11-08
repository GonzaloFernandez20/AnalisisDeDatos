/*
21. Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al 
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta 
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. Se 
considera que una factura es incorrecta cuando la diferencia entre el total de la factura 
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de 
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar 
son:

    - Año
    - Clientes a los que se les facturo mal en ese año
    - Facturas mal realizadas en ese año
*/


-- la cantidad de clientes a los que se les facturo de manera incorrecta al menos una factura y que cantidad de facturas se realizaron de manera incorrecta.


/*
Se considera que una factura es incorrecta cuando la diferencia entre el total de la factura 
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de 
los costos de cada uno de los items de dicha factura.
*/

select year(fact_fecha) anio, 
       count(distinct fact_cliente) cant_clientes,
       count(distinct fact_numero+fact_tipo+fact_sucursal) facturas_incorrectas
from Factura 
join Item_Factura on item_numero = fact_numero
                  and item_tipo = fact_tipo
                  and item_sucursal = fact_sucursal
group by year(fact_fecha)
having count(fact_numero) > 0
       and sum(fact_total - fact_total_impuestos) - sum(item_cantidad * item_precio) > 1
order by 1 desc
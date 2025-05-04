USE GD2015C1

select fact_fecha, count(*) as cant_ventas, sum(fact_total) as total_facturado, max(fact_total) as venta_maxima, min(fact_total) as venta_minima, avg(fact_total) as promedio
from Factura
group by fact_fecha


select fact_cliente, count(*) as cant_ventas, sum(fact_total) as total_facturado, max(fact_total) as venta_maxima, min(fact_total) as venta_minima, avg(fact_total) as promedio
from Factura
group by fact_cliente
having sum(fact_total) > 10000
order by sum(fact_total) ASC


SELECT clie_codigo, clie_razon_social, COUNT(*), sum(f1.fact_total)
FROM Cliente
JOIN Factura f1 ON clie_codigo = f1.fact_cliente
WHERE YEAR(f1.fact_fecha) = 2012
GROUP BY clie_codigo, clie_razon_social
ORDER BY sum(f1.fact_total) DESC


SELECT clie_codigo, clie_razon_social, COUNT(fact_numero), sum(ISNULL(fact_total, 0))
FROM Cliente
LEFT JOIN Factura ON clie_codigo = fact_cliente
GROUP BY clie_codigo, clie_razon_social
ORDER BY sum(fact_total) DESC

-- COMANDO CASE (Similar al switch en C)
/* select *
case nota when 8 then 'BUENO' when 9 then 'EXCELENTE' when 10 then 'SOBRESALIENTE'
else 'NORMAL' end */

SELECT clie_codigo, clie_razon_social, 
case COUNT(fact_numero) when 0 then 'NADA' else 'MUCHO' end Cant_facturas, 
ISNULL((sum(fact_total)), 0)
FROM Cliente
LEFT JOIN Factura ON clie_codigo = fact_cliente
--WHERE YEAR(fact_fecha) = 2012
GROUP BY clie_codigo, clie_razon_social
ORDER BY sum(fact_total) DESC 

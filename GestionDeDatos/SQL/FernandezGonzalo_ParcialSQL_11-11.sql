use GD2015C1

/*
PARCIAL 11/11/2025 - SQL - FERNANDEZ BOGARIN LUIS GONZALO - LEGAJO: 2087364

1. Mostrar la siguiente informacion para todos los vendedores:
	- Codigo del vendedor
	- Codigo de Familia de producto que mas se facturo para ese vendedor
	- Cantidad de envases de productos diferentes facturados de esa familia y vendedor
	- Cantidad total de productos vendidos para esa familia y ese vendedor

Se debera considerar los vendedores que tengan mas de 100 clientes asignados y se debera mostrar 
la informacion ordenada por cantidad maxima de clientes de cada vendedor.
*/

select emp.empl_codigo,
	   -------------------------------
	   (select top 1 prod_familia
	    from Factura
		join Item_Factura on item_numero = fact_numero
						  and item_tipo = fact_tipo
						  and item_sucursal = fact_sucursal
		join Producto on prod_codigo = item_producto
		where fact_vendedor = emp.empl_codigo
		group by prod_familia
		order by sum(item_precio * item_cantidad) desc /*ACLARACION 1*/
	   ) as familia_mas_vendida,
	   -------------------------------
	   (select sum(prod_envase)
		from Producto
		where prod_codigo in (select prod_codigo
								from Factura
								join Item_Factura on item_numero = fact_numero
												  and item_tipo = fact_tipo
												  and item_sucursal = fact_sucursal
								join Producto on prod_codigo = item_producto
								where fact_vendedor = emp.empl_codigo
									  and prod_familia = (select top 1 prod_familia
															from Factura
															join Item_Factura on item_numero = fact_numero
																			  and item_tipo = fact_tipo
																			  and item_sucursal = fact_sucursal
															join Producto on prod_codigo = item_producto
															where fact_vendedor = emp.empl_codigo
															group by prod_familia
															order by sum(item_precio * item_cantidad) desc
														 )
							 ) /*ACLARACION 2*/
	   ) as cant_envases_diferentes,
	   -------------------------------
	   (select sum(item_cantidad)
	    from Factura
		join Item_Factura on item_numero = fact_numero
							and item_tipo = fact_tipo
							and item_sucursal = fact_sucursal
	    join Producto on prod_codigo = item_producto
	    where prod_familia = (select top 1 prod_familia
							  from Factura
							  join Item_Factura on item_numero = fact_numero
												and item_tipo = fact_tipo
												and item_sucursal = fact_sucursal
							  join Producto on prod_codigo = item_producto
							  where fact_vendedor = emp.empl_codigo
							  group by prod_familia
							  order by sum(item_precio * item_cantidad) desc
							 ) 
		      and fact_vendedor = emp.empl_codigo  
	   ) as cant_productos_vendidos
	   -------------------------------
from Cliente clie
join Empleado emp on clie.clie_vendedor = emp.empl_codigo
group by emp.empl_codigo
having count(distinct clie.clie_codigo) > 100
order by count(distinct clie.clie_codigo) desc


/* ACLARACION 1: Entiendo que familia que mas se facturo es aquella que mas plata recaudo, por ende comparo sabiendo cuanta plata generaron los productos de esa familia (sum(item_precio * item_cantidad)) */
/* ACLARACION 2: trayendo los codigos de producto de esta manera me evito los duplicados */



/*
NOTA: SQL 6. SUM de envases es la suma de los codigos y no la cantidad de envases. Te complicaste con tantos subquerys.
*/
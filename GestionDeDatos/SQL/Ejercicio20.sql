/*
20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012.
    -> Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje 2012. 

El puntaje de cada empleado se calculara de la siguiente manera: 
    - para los que hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas 
      que superen los 100 pesos que haya vendido en el año, 
    - para los que tengan menos de 50 facturas en el año el calculo del puntaje sera el 50% de cantidad de 
      facturas realizadas por sus subordinados directos en dicho año.
*/


-- OPCION CORRECTA:
select top 3
       emp.empl_codigo,
       emp.empl_apellido,
       emp.empl_nombre,
       year(emp.empl_ingreso) as anio_ingreso,
       case 
           when count(distinct concat(fact.fact_numero, '-', fact.fact_sucursal, '-', fact.fact_tipo)) >= 50
               then (
                   select count(*) 
                   from Factura fact_aux
                   where fact_aux.fact_vendedor = emp.empl_codigo
                         and fact_aux.fact_total > 100
                         and year(fact_aux.fact_fecha) = 2011
               )
           else (
                   select count(*) / 2
                   from Empleado emp_sub
                   join Factura fact_aux on fact_aux.fact_vendedor = emp_sub.empl_codigo
                   where emp_sub.empl_jefe = emp.empl_codigo
                         and year(fact_aux.fact_fecha) = 2011
               )
       end as puntaje_2011,
       case 
           when count(distinct concat(fact.fact_numero, '-', fact.fact_sucursal, '-', fact.fact_tipo)) >= 50
               then (
                   select count(*) 
                   from Factura fact_aux
                   where fact_aux.fact_vendedor = emp.empl_codigo
                         and fact_aux.fact_total > 100
                         and year(fact_aux.fact_fecha) = 2012
               )
           else (
                   select count(*) / 2
                   from Empleado emp_sub
                   join Factura fact_aux on fact_aux.fact_vendedor = emp_sub.empl_codigo
                   where emp_sub.empl_jefe = emp.empl_codigo
                         and year(fact_aux.fact_fecha) = 2012
               )
       end as puntaje_2012
from Empleado emp
left join Factura fact on fact.fact_vendedor = emp.empl_codigo and year(fact.fact_fecha) = 2012
group by emp.empl_codigo, emp.empl_apellido, emp.empl_nombre, emp.empl_ingreso
order by puntaje_2012 desc;




-- OPCION INCORRECTA, ME LIMITA PODER OBTENER LOS 3 MEJORES DEL 2012
select emp1.empl_codigo, 
       emp1.empl_apellido, 
       emp1.empl_nombre, 
       year(emp1.empl_ingreso) as anio_ingreso,
       (select count(*)
        from Factura fact_aux 
        where fact_aux.fact_vendedor = emp1.empl_codigo
              and fact_aux.fact_total > 100
              and year(fact_aux.fact_fecha) = 2011
       ) as puntaje_2011,
       (select count(*)
        from Factura fact_aux 
        where fact_aux.fact_vendedor = emp1.empl_codigo
              and fact_aux.fact_total > 100
              and year(fact_aux.fact_fecha) = 2012
       ) as puntaje_2012
from Empleado emp1
join Factura fact1 on fact1.fact_vendedor = emp1.empl_codigo
where year(fact1.fact_fecha) = 2012
group by emp1.empl_codigo, 
         emp1.empl_apellido, 
         emp1.empl_nombre, 
         emp1.empl_ingreso
having count(distinct concat(fact1.fact_numero, '-', fact1.fact_sucursal, '-', fact1.fact_tipo)) >= 50

union all -------------------------------------------------------------------------

select emp2.empl_codigo, 
       emp2.empl_apellido, 
       emp2.empl_nombre, 
       emp2.empl_ingreso,
       (select count(*) / 2
        from Empleado emp_sub
        join Factura fact_aux on fact_aux.fact_vendedor = emp_sub.empl_codigo
             and year(fact_aux.fact_fecha) = 2011
        where emp_sub.empl_jefe = emp2.empl_codigo 
       ) as puntaje_2011,
       (select count(*) / 2
        from Empleado emp_sub
        join Factura fact_aux on fact_aux.fact_vendedor = emp_sub.empl_codigo
             and year(fact_aux.fact_fecha) = 2012
        where emp_sub.empl_jefe = emp2.empl_codigo 
       ) as puntaje_2012
from Empleado emp2
left join Factura fact2 on fact2.fact_vendedor = emp2.empl_codigo and year(fact2.fact_fecha) = 2012
group by emp2.empl_codigo, emp2.empl_apellido, emp2.empl_nombre, emp2.empl_ingreso
having count(distinct concat(fact2.fact_numero, '-', fact2.fact_sucursal, '-', fact2.fact_tipo)) < 50

---------------------------------------------------------------
-- PROBLEMON: 

select emp2.empl_codigo, 
       emp2.empl_apellido, 
       emp2.empl_nombre, 
       emp2.empl_ingreso,
       (select count(*)
        from Factura fact2
        where fact2.fact_vendedor = emp2.empl_codigo
        and year(fact2.fact_fecha) = 2012
       ) as cant
from Empleado emp2
left join Factura fact2 on fact2.fact_vendedor = emp2.empl_codigo 
where year(fact2.fact_fecha) = 2012 ---------------->
group by emp2.empl_codigo, emp2.empl_apellido, emp2.empl_nombre, emp2.empl_ingreso
having count(distinct concat(fact2.fact_numero, '-', fact2.fact_sucursal, '-', fact2.fact_tipo)) < 50

/*
Un LEFT JOIN incluye todas las filas del lado izquierdo (Empleado), incluso si no hay coincidencias en Factura.

Pero si ponés una condición sobre una columna de la tabla derecha (Factura) en el WHERE, esa condición elimina las filas donde esa columna es NULL.
Y justamente, los empleados sin facturas tienen todos los campos de Factura en NULL.

Resultado: el LEFT JOIN se comporta igual que un INNER JOIN.
Los empleados sin facturas desaparecen.
*/
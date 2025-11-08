/* Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados. */

SELECT e2.empl_codigo AS Codigo_empleado, 
       RTRIM(e2.empl_nombre)+' '+e2.empl_apellido AS Empleado,
       e2.empl_jefe AS Codigo_jefe,
       COUNT(depo_codigo) AS Depositos_asignados
FROM Empleado e2 /*JEFE*/
LEFT JOIN DEPOSITO ON depo_encargado = e2.empl_codigo or depo_encargado = e2.empl_jefe
GROUP BY e2.empl_codigo, e2.empl_nombre, e2.empl_apellido, e2.empl_jefe
ORDER BY e2.empl_codigo

select empl_jefe, empl_codigo, rtrim(empl_apellido)+' '+rtrim(empl_nombre), count(*)  
from Empleado join DEPOSITO on empl_codigo = depo_encargado or empl_jefe = depo_encargado 
group by empl_jefe, empl_codigo, empl_apellido, empl_nombre

/*
SELECT e1.empl_codigo AS Codigo_jefe,
       e2.empl_codigo AS Codigo_empleado, 
       RTRIM(e2.empl_nombre)+' '+e2.empl_apellido AS Empleado,
       COUNT(depo_codigo) AS Depositos_asignados
FROM Empleado e1 JEFES
JOIN Empleado e2 ON e1.empl_codigo = e2.empl_jefe EMPLEADOS
JOIN DEPOSITO ON depo_encargado = e1.empl_codigo
WHERE e1.empl_codigo IN (SELECT empl_jefe FROM Empleado)
GROUP BY e1.empl_codigo, e2.empl_codigo, e2.empl_nombre, e2.empl_apellido
ORDER BY e1.empl_codigo


Esta solucion tiene como enfoque al Jefe, mostrando sus empleados, pero me da dudas de como se hace en el tema de los depositos.
*/
/* Ejemplo de creacion de una vista */
CREATE VIEW vista_facturas AS
SELECT fact_tipo+'-'+fact_sucursal+'-'+fact_numero factura, fact_fecha, clie_razon_social, empl_apellido, fact_total
FROM Factura
JOIN Cliente ON clie_codigo = fact_cliente
JOIN Empleado ON empl_codigo = fact_vendedor
GO /* -> Punto de corte, opcional pero necesario para que no tire error*/

/* Se creo una vista (Tabla Virtual) que va a guardar el medio de acceso a esos datos.
El select de la vista esta listo para ser ejecutado al momento de ser llamado */

SELECT clie_razon_social, empl_apellido vendedor
FROM vista_facturas
WHERE clie_razon_social LIKE 'MORE%'

/* Se ejecuto el select de la vista y con ese nuevo universo se siguio con la consulta.
Como los datos los trae en tiempo de ejecucion, si luego modifico esos datos en su tabla
original, al volver a realizar la vista voy a ver los cambios reflejados.  */

/*
SELECT fact_tipo+'-'+fact_sucursal+'-'+fact_numero factura, fact_fecha, clie_razon_social, empl_apellido, fact_total INTO Tabla1
FROM Factura
JOIN Cliente ON clie_codigo = fact_cliente
JOIN Empleado ON empl_codigo = fact_vendedor 
*/
/* Al usar el INTO, guardo el resultado del SELECT en una nueva tabla que creo (Tabla1) */
 
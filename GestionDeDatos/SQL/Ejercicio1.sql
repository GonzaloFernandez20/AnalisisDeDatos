/* Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o 
igual a $ 1000 ordenado por código de cliente. */

USE GD2015C1

SELECT clie_codigo AS Codigo, clie_razon_social AS 'Razon Social', clie_limite_credito AS Limite
FROM Cliente
WHERE clie_limite_credito >= 1000
ORDER BY clie_codigo ASC
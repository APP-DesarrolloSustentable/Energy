/*
Este query te trae el consumo total de un año dado un id_grupo y una fecha.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_año $$
CREATE PROCEDURE consumo_total_año(g_id INT, dia DATE)
BEGIN

    SELECT  SUM(consumo_electrico) AS Consumo_Año
    FROM    consumo
    WHERE   YEAR(fecha)=YEAR(dia)
            AND id_grupo=g_id;

END $$
DELIMITER ;

COMMIT;

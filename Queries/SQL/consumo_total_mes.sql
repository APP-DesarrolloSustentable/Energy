/*
Este query te trae el consumo total del mes dado un id_grupo y una fecha.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_mes $$
CREATE PROCEDURE consumo_total_mes(g_id INT, dia DATE)
BEGIN

    SELECT  SUM(consumo_electrico) AS Consumo_Mes
    FROM    consumo
    WHERE   MONTH(fecha)=MONTH(dia)
            AND YEAR(fecha)=YEAR(dia)
            AND id_grupo=g_id;

END $$
DELIMITER ;

COMMIT;

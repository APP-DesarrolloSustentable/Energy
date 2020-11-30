/*
Este query te trae el consumo total del mes dado un id_grupo y una fecha.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_mes $$
CREATE PROCEDURE consumo_mes(g_id INT, mes DATE)
BEGIN

    SELECT  SUM(consumo_electrico) AS Consumo_Mes
    FROM    consumo
    WHERE   MONTH(fecha)=MONTH(mes)
            AND YEAR(fecha)=YEAR(mes);

END $$
DELIMITER ;

COMMIT;

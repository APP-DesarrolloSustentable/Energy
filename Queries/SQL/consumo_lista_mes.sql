/*
Este query te trae el consumo total del mes dado un id_grupo y una fecha.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_lista_mes $$
CREATE PROCEDURE consumo_lista_mes(g_id INT, dia DATE)
BEGIN

    SELECT  fecha, consumo_electrico
    FROM    consumo
    WHERE   MONTH(fecha)=MONTH(dia)
            AND YEAR(fecha)=YEAR(dia)
            AND id_grupo=g_id;

END $$
DELIMITER ;

COMMIT;

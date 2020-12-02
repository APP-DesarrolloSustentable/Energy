/*
Este query te trae el consumo total del mes dado un id_grupo y una fecha.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_lista_mes $$
CREATE PROCEDURE consumo_lista_mes(g_id INT, mes DATE)
BEGIN

    SELECT  fecha, consumo_electrico
    FROM    consumo
    WHERE   MONTH(fecha)=MONTH(mes)
            AND YEAR(fecha)=YEAR(mes);

END $$
DELIMITER ;

COMMIT;

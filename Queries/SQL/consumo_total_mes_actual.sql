/*
Este query te trae el consumo total del mes actual dado un id_grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_mes_actual $$
CREATE PROCEDURE consumo_total_mes_actual(g_id INT)
BEGIN

    CALL consumo_total_mes(g_id, CURDATE());

END $$
DELIMITER ;

COMMIT;

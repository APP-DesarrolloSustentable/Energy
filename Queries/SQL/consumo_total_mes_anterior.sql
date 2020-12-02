/*
Este query te trae el consumo total del mes anterior dado un id_grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_mes_anterior $$
CREATE PROCEDURE consumo_total_mes_anterior(g_id INT)
BEGIN

    CALL consumo_total_mes(g_id, DATE_ADD(CURDATE(), INTERVAL -1 MONTH));

END $$
DELIMITER ;

COMMIT;

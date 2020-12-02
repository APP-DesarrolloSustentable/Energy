/*
Este query te trae el consumo total del año anterior dado un id_grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_año_anterior $$
CREATE PROCEDURE consumo_total_año_anterior(g_id INT)
BEGIN

    CALL consumo_total_año(g_id, DATE_ADD(CURDATE(), INTERVAL -1 YEAR));

END $$
DELIMITER ;

COMMIT;

/*
Este query te trae el consumo total del año actual dado un id_grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_año_actual $$
CREATE PROCEDURE consumo_total_año_actual(g_id INT)
BEGIN

    CALL consumo_total_año(g_id, CURDATE());

END $$
DELIMITER ;

COMMIT;

/*
Este query te trae el consumo total del año actual agrupado por meses, dado un
id_grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_año_actual_por_mes $$
CREATE PROCEDURE consumo_total_año_actual_por_mes(g_id INT)
BEGIN

    CALL consumo_total_año_por_mes(g_id, CURDATE());

END $$
DELIMITER ;

COMMIT;

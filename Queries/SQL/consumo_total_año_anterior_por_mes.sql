/*
Este query te trae el consumo total del año anterior agrupado por meses, dado
un id_grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_año_anterior_por_mes $$
CREATE PROCEDURE consumo_total_año_anterior_por_mes(g_id INT)
BEGIN

    CALL consumo_total_año_por_mes(g_id, DATE_ADD(CURDATE(), INTERVAL -1 YEAR));

END $$
DELIMITER ;

COMMIT;

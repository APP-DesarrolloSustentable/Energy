/*
Este query te trae el consumo total del mes actual dado un id_grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_lista_mes_actual $$
CREATE PROCEDURE consumo_lista_mes_actual(g_id INT)
BEGIN

    CALL consumo_lista_mes(g_id, CURDATE());

END $$
DELIMITER ;

COMMIT;

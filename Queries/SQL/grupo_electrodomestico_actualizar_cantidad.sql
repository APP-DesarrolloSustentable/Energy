/*
Actualiza la cantidad de electrodomésticos registrados en un grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS grupo_electrodomestico_actualizar_cantidades $$
CREATE PROCEDURE grupo_electrodomestico_actualizar_cantidades
(g_id INT, e_id INT, cant INT)
BEGIN

    UPDATE  grupo_electrodomestico
    SET     cantidad=cant
    WHERE   id_grupo=g_id
            AND id_electrodomestico=e_id;

END $$
DELIMITER ;

COMMIT;

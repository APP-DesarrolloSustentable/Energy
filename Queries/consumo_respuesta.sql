/*
Este query recibe el grupo y el total de la suma de watts (ya antes
calculados), crea un registro de Consumo y actualiza la puntuación del Grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_respuesta $$
CREATE PROCEDURE consumo_respuesta(g_id INT, total INT)
BEGIN

    SET @registro = (
        SELECT	id_consumo
        FROM 	consumo
        WHERE	id_grupo=g_id
                AND fecha=CURDATE()
        );

        IF (@registro IS NULL) THEN
    		INSERT INTO consumo(consumo_electrico, fecha, id_grupo)
    		VALUES (total, CURDATE(),g_id);

    		SET @actuales = (SELECT puntos FROM grupo WHERE id_grupo=g_id);

    		UPDATE	grupo
    		SET		puntos=@actuales+10
    		WHERE	id_grupo=g_id;
    	ELSE
    		UPDATE 	consumo
    		SET		consumo_electrico=total
    		WHERE	id_consumo=@registro;
    	END IF;

END $$
DELIMITER ;

COMMIT;

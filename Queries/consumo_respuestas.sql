/*
Este query manda todas las opciones elegidas por un usuario al responder
preguntas, crea un registro de Consumo y actualiza la puntuación del Grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_respuestas $$
CREATE PROCEDURE consumo_respuestas()
BEGIN

	SET @g_id = 17;

	CREATE TEMPORARY TABLE respuestas(
		valor INT,
		id MEDIUMINT NOT NULL AUTO_INCREMENT,
		PRIMARY KEY (id)
		);


	/* Una lista de las opciones que escogió el usuario. */
	INSERT INTO respuestas(valor)
    VALUES
    	(2)/*,
        (2),
        (3),
        (2)*/
	;


	/* Esto consigue una lista de los IDs de las preguntas. */

	CREATE TEMPORARY TABLE idees(
		id_pregunta INT,
		id MEDIUMINT NOT NULL AUTO_INCREMENT,
		PRIMARY KEY (id)
		);

	CREATE TEMPORARY TABLE pgts
		SELECT 	pregunta.id_pregunta
		FROM	grupo_electrodomestico,
				electrodomestico,
				electrodomestico_pregunta,
				pregunta
		WHERE
				grupo_electrodomestico.id_grupo = @g_id
				AND grupo_electrodomestico.id_electrodomestico = electrodomestico.id_electrodomestico
				AND electrodomestico.id_electrodomestico = electrodomestico_pregunta.id_electrodomestico
				AND electrodomestico_pregunta.id_pregunta = pregunta.id_pregunta;

	INSERT INTO idees (id_pregunta) SELECT id_pregunta FROM pgts;

	SET @tamaño := (SELECT COUNT(*) FROM respuestas);
	SET @suma := 0;
	SET @i := 1;

	loop_suma: WHILE @i <= @tamaño DO
		SET	@preg := (SELECT id_pregunta FROM idees WHERE id=@i);

		SET @opcion := (SELECT valor FROM respuestas WHERE id=@i);

		SET @watts := (
			SELECT	CASE
						WHEN 	@opcion=1
						THEN	valor_1

						WHEN	@opcion=2
						THEN	valor_2

						ELSE	valor_3
					END
			FROM	pregunta
			WHERE	id_pregunta=@preg
			);

		SET @suma := @suma + @watts;

		SET @i := @i + 1;
	END WHILE loop_suma;


	SET @registro = (
		SELECT	id_consumo
		FROM 	consumo
		WHERE	id_grupo=@g_id
				AND fecha=CURDATE()
		);


	IF (@registro IS NULL) THEN
		INSERT INTO consumo(consumo_electrico, fecha, id_grupo)
		VALUES (@suma, CURDATE(), @g_id);

		SET @actuales = (SELECT puntos FROM grupo WHERE id_grupo=@g_id);

		UPDATE	grupo
		SET		puntos=@actuales+10
		WHERE	id_grupo=@g_id;
	ELSE
		UPDATE 	consumo
		SET		consumo_electrico=@suma
		WHERE	id_consumo=@registro;
	END IF;


END $$
DELIMITER ;

COMMIT;

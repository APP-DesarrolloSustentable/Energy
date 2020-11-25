/*
Este query consigue las preguntas y sus posibles respuestas para cada
electrodoméstico registrado en un grupo.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_preguntas $$
CREATE PROCEDURE consumo_preguntas(IN g_id INT)
BEGIN

	SET g_id = 17;

	SELECT	DISTINCT electrodomestico.id_electrodomestico,
			electrodomestico.nombre,
			pregunta.pregunta,
			pregunta.respuesta_1,
			pregunta.respuesta_2,
			pregunta.respuesta_3
	FROM	grupo_electrodomestico,
			electrodomestico,
            electrodomestico_pregunta,
			pregunta
	WHERE
			grupo_electrodomestico.id_grupo = g_id
			AND grupo_electrodomestico.id_electrodomestico =
			electrodomestico.id_electrodomestico
			AND electrodomestico.id_electrodomestico =
			electrodomestico_pregunta.id_electrodomestico
			AND electrodomestico_pregunta.id_pregunta = pregunta.id_pregunta;

END $$
DELIMITER ;

COMMIT;

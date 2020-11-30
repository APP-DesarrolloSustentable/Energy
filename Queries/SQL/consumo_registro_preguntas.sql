/*
Este query consigue las preguntas, sus posibles respuestas y el consumo
aproximado (de cada respuesta) para cada electrodoméstico registrado en un
grupo dado.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_registro_preguntas $$
CREATE PROCEDURE consumo_registro_preguntas(g_id INT)
BEGIN

	SELECT	DISTINCT electrodomestico.id_electrodomestico,
			electrodomestico.nombre,
			pregunta.pregunta,
			pregunta.respuesta_1,
			pregunta.valor_1,
			pregunta.respuesta_2,
			pregunta.valor_2,
			pregunta.respuesta_3
			pregunta.valor_3
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

/*
Este query te trae el consumo total de un año agrupado por meses, dado un
id_grupo y una fecha.

    +-----+---------+
    | Mes | Consumo |
    +-----+---------+
    |   2 |     280 |
    |   3 |    1270 |
    +-----+---------+
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_año_por_mes $$
CREATE PROCEDURE consumo_total_año_por_mes(g_id INT, dia DATE)
BEGIN

    SELECT      MONTH(fecha) AS Mes,
                SUM(consumo_electrico) AS Consumo
    FROM        consumo
    WHERE       YEAR(fecha)=YEAR(dia)
                AND id_grupo=g_id
    GROUP BY    MONTH(fecha);

END $$
DELIMITER ;

COMMIT;

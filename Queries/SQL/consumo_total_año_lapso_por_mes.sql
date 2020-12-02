/*
Este query te trae el consumo total de los últimos 12 meses, agrupado por meses,
dado un id_grupo y una fecha.

    +------+-----+---------+
    |  Año | Mes | Consumo |
    +------+-----+---------+
    | 2019 |   2 |     280 |
    | 2020 |   3 |    1270 |
    +------+-----+---------+
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_total_lapso_año_por_mes $$
CREATE PROCEDURE consumo_total_año_lapso_por_mes(g_id INT)
BEGIN

    SELECT      YEAR(fecha) AS Año,
                MONTH(fecha) AS Mes,
                SUM(consumo_electrico) AS Consumo
    FROM        consumo
    WHERE       (
                    YEAR(fecha)=YEAR(CURDATE())
                    OR
                    (
                        YEAR(fecha)=YEAR(DATE_ADD(CURDATE(), INTERVAL -1 YEAR))
                        AND MONTH(fecha)>MONTH(CURDATE())
                    )
                )
                AND id_grupo=g_id
    GROUP BY    MONTH(fecha)
    ORDER BY    YEAR(fecha), MONTH(fecha);

END $$
DELIMITER ;

COMMIT;

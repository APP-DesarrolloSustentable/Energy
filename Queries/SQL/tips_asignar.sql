/*
Este query asigna (3) tips aleatorios a un usuario si ha pasado más de una
semana desde la última vez que se asignaron tips.
Regresa 1 si se asignaron, 0 si no.
*/

START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS tips_asignar $$
CREATE PROCEDURE tips_asignar(u_id INT)
BEGIN

    SET @diff := (
        SELECT  DATEDIFF(CURDATE(), ultima)
        FROM    tip_usuario
        WHERE   id_usuario=u_id
    );

    IF (@diff >= 7) THEN
        CREATE TEMPORARY TABLE temp_tips
            SELECT      DISTINCT idtip
            FROM        tip, usuario
            WHERE       usuario.id_usuario=u_id
                        AND usuario.arquetipo=tip.arquetipo
            ORDER BY    RAND()
            LIMIT       3;

        IF (NULL=(
            SELECT  id_usuario
            FROM    tip_usuario
            WHERE   id_usuario=u_id
        )) THEN
            INSERT INTO tip_usuario(id_usuario)
            VALUES (u_id);
        END IF;

        UPDATE  tip_usuario
        SET     ultima=CURDATE(),
                id_tip_1=(
                    SELECT  idtip
                    FROM    temp_tips
                    LIMIT   1,1
                ),
                id_tip_2=(
                    SELECT  idtip
                    FROM    temp_tips
                    LIMIT   2,1
                )
        WHERE   id_usuario=u_id;

        SELECT 1;
    ELSE
        SELECT 0;
    END IF;

END $$
DELIMITER ;

COMMIT;

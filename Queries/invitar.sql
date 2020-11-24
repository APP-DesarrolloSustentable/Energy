START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS invitar $$
CREATE PROCEDURE invitar()
BEGIN

	SET @g_id = 17;
    SET @u_id = 18;

    SET @result = (
        SELECT id_usuario
        FROM grupo_usuario
        WHERE   id_grupo=@g_id
                AND id_usuario=@u_id
    );

    IF (@result IS NULL) THEN
        INSERT INTO grupo_usuario(id_grupo, id_usuario, rol)
        VALUES(@g_id, @u_id, 'basic');

        SELECT 1;
    ELSE
        SELECT 0;
    END IF;

END $$
DELIMITER ;

CALL invitar();

COMMIT;

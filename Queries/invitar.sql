START TRANSACTION;

DELIMITER $$
DROP PROCEDURE IF EXISTS invitar $$
<<<<<<< HEAD
CREATE PROCEDURE invitar(
    IN g_id INT,
    IN u_id INT
)
BEGIN

	SET @result = (
        SELECT id_usuario
        FROM grupo_usuario
        WHERE   id_grupo=g_id
                AND id_usuario=u_id
=======
CREATE PROCEDURE invitar()
BEGIN

	SET @g_id = 17;
    SET @u_id = 18;

    SET @result = (
        SELECT id_usuario
        FROM grupo_usuario
        WHERE   id_grupo=@g_id
                AND id_usuario=@u_id
>>>>>>> 17ca2e8bd47b0422b20e5f121c488f75a6bb9715
    );

    IF (@result IS NULL) THEN
        INSERT INTO grupo_usuario(id_grupo, id_usuario, rol)
<<<<<<< HEAD
        VALUES(g_id, u_id, 'basic');
=======
        VALUES(@g_id, @u_id, 'basic');
>>>>>>> 17ca2e8bd47b0422b20e5f121c488f75a6bb9715

        SELECT 1;
    ELSE
        SELECT 0;
    END IF;

END $$
DELIMITER ;

<<<<<<< HEAD
COMMIT;
=======
CALL invitar();

COMMIT;
>>>>>>> 17ca2e8bd47b0422b20e5f121c488f75a6bb9715

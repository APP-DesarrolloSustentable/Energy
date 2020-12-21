-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 21, 2020 at 09:01 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `energia`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_lista_mes` (`g_id` INT, `dia` DATE)  BEGIN

    SELECT  fecha, consumo_electrico
    FROM    consumo
    WHERE   MONTH(fecha)=MONTH(dia)
            AND YEAR(fecha)=YEAR(dia)
            AND id_grupo=g_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_lista_mes_actual` (`g_id` INT)  BEGIN

    CALL consumo_lista_mes(g_id, CURDATE());

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_lista_mes_anterior` (`g_id` INT)  BEGIN

    CALL consumo_lista_mes(g_id, DATE_ADD(CURDATE(), INTERVAL -1 MONTH));

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_registro_preguntas` (`g_id` INT)  BEGIN

	SELECT	DISTINCT electrodomestico.id_electrodomestico,
			electrodomestico.nombre,
			pregunta.pregunta,
			pregunta.respuesta_1,
			pregunta.valor_1,
			pregunta.respuesta_2,
			pregunta.valor_2,
			pregunta.respuesta_3,
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_registro_respuesta` (`g_id` INT, `total` INT)  BEGIN

    SET @registro = (
        SELECT	id_consumo
        FROM 	consumo
        WHERE	id_grupo=g_id
                AND fecha=CURDATE()
        );

        IF (@registro IS NULL) THEN
    		INSERT INTO consumo(consumo_electrico, fecha, id_grupo)
    		VALUES (total, CURDATE(), g_id);

    		SET @actuales = (SELECT puntos FROM grupo WHERE id_grupo=g_id);

    		UPDATE	grupo
    		SET		puntos=@actuales+10
    		WHERE	id_grupo=g_id;
    	ELSE
    		UPDATE 	consumo
    		SET		consumo_electrico=total
    		WHERE	id_consumo=@registro;
    	END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_año` (`g_id` INT, `dia` DATE)  BEGIN

    SELECT  SUM(consumo_electrico) AS Consumo_Año
    FROM    consumo
    WHERE   YEAR(fecha)=YEAR(dia)
            AND id_grupo=g_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_año_actual` (`g_id` INT)  BEGIN

    CALL consumo_total_año(g_id, CURDATE());

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_año_actual_por_mes` (`g_id` INT)  BEGIN

    CALL consumo_total_año_por_mes(g_id, CURDATE());

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_año_anterior` (`g_id` INT)  BEGIN

    CALL consumo_total_año(g_id, DATE_ADD(CURDATE(), INTERVAL -1 YEAR));

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_año_anterior_por_mes` (`g_id` INT)  BEGIN

    CALL consumo_total_año_por_mes(g_id, DATE_ADD(CURDATE(), INTERVAL -1 YEAR));

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_año_lapso_por_mes` (`g_id` INT)  BEGIN

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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_año_por_mes` (`g_id` INT, `dia` DATE)  BEGIN

    SELECT      MONTH(fecha) AS Mes,
                SUM(consumo_electrico) AS Consumo
    FROM        consumo
    WHERE       YEAR(fecha)=YEAR(dia)
                AND id_grupo=g_id
    GROUP BY    MONTH(fecha);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_mes` (`g_id` INT, `dia` DATE)  BEGIN

    SELECT  SUM(consumo_electrico) AS Consumo_Mes
    FROM    consumo
    WHERE   MONTH(fecha)=MONTH(dia)
            AND YEAR(fecha)=YEAR(dia)
            AND id_grupo=g_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_mes_actual` (`g_id` INT)  BEGIN

    CALL consumo_total_mes(g_id, CURDATE());

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consumo_total_mes_anterior` (`g_id` INT)  BEGIN

    CALL consumo_total_mes(g_id, DATE_ADD(CURDATE(), INTERVAL -1 MONTH));

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `grupo_electrodomestico_actualizar_cantidades` (`g_id` INT, `e_id` INT, `cant` INT)  BEGIN

    UPDATE  grupo_electrodomestico
    SET     cantidad=cant
    WHERE   id_grupo=g_id
            AND id_electrodomestico=e_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `invitar` (IN `g_id` INT, IN `u_id` INT)  BEGIN

	SET @result = (
        SELECT id_usuario
        FROM grupo_usuario
        WHERE   id_grupo=g_id
                AND id_usuario=u_id
    );

    IF (@result IS NULL) THEN
        INSERT INTO grupo_usuario(id_grupo, id_usuario, rol)
        VALUES(g_id, u_id, 'basic');

        SELECT 1;
    ELSE
        SELECT 0;
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tips_asignar` (`u_id` INT)  BEGIN

    SET @diff := (
        SELECT  DATEDIFF(CURDATE(), ultima)
        FROM    tip_usuario
        WHERE   id_usuario=u_id
    );

    IF ((@diff>=7) OR (@diff IS NULL)) THEN
        CREATE TEMPORARY TABLE temp_tips
            SELECT      DISTINCT idtip
            FROM        tip, usuario
            WHERE       usuario.id_usuario=u_id
                        AND usuario.arquetipo=tip.arquetipo
            ORDER BY    RAND()
            LIMIT       5;

        IF (@diff IS NULL) THEN
            INSERT INTO tip_usuario(id_usuario)
            VALUES (u_id);
        END IF;

        UPDATE  tip_usuario
        SET     ultima=CURDATE(),
                id_tip_1=(
                    SELECT  idtip
                    FROM    temp_tips
                    LIMIT   0,1
                ),
                id_tip_2=(
                    SELECT  idtip
                    FROM    temp_tips
                    LIMIT   1,1
                ),
                id_tip_3=(
                    SELECT  idtip
                    FROM    temp_tips
                    LIMIT   2,1
                ),
                id_tip_4=(
                    SELECT  idtip
                    FROM    temp_tips
                    LIMIT   3,1
                ),
                id_tip_5=(
                    SELECT  idtip
                    FROM    temp_tips
                    LIMIT   4,1
                )
        WHERE   id_usuario=u_id;

        SELECT 1;
    ELSE
        SELECT 0;
    END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `consumo`
--

CREATE TABLE `consumo` (
  `id_consumo` int(10) UNSIGNED NOT NULL,
  `consumo_electrico` int(10) UNSIGNED DEFAULT 0,
  `fecha` date NOT NULL,
  `id_grupo` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `consumo`
--

INSERT INTO `consumo` (`id_consumo`, `consumo_electrico`, `fecha`, `id_grupo`) VALUES
(1, 243, '2020-12-04', 1),
(2, 1450000, '2020-11-04', 1),
(3, 570200, '2020-10-12', 1),
(4, 1324000, '2020-09-08', 1),
(5, 1215000, '2020-11-23', 1),
(6, 131200, '2020-10-08', 1),
(7, 451200, '2020-09-13', 1),
(8, 192800, '2020-09-21', 1),
(9, 27, '2020-12-01', 1),
(10, 45, '2020-12-02', 1),
(11, 213, '2020-12-03', 1),
(12, 103, '2020-12-04', 3),
(13, 207, '2020-12-14', 1),
(14, 238, '2020-12-15', 1);

-- --------------------------------------------------------

--
-- Table structure for table `electrodomestico`
--

CREATE TABLE `electrodomestico` (
  `id_electrodomestico` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `consumo_por_hora` int(10) UNSIGNED NOT NULL,
  `url_imagen` text COLLATE latin1_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `electrodomestico`
--

INSERT INTO `electrodomestico` (`id_electrodomestico`, `nombre`, `consumo_por_hora`, `url_imagen`) VALUES
(1, 'Televisión de 14 Pulgadas', 0, ''),
(2, 'Televisión de 39 Pulgadas', 0, ''),
(3, 'Smartphone', 0, ''),
(4, 'Refrigerador (18-22 pies cúbicos', 0, ''),
(5, 'Computadora', 0, ''),
(6, 'Ventilador', 0, ''),
(7, 'Aire acondicionado dividido de 1', 0, ''),
(8, 'Estufa Eléctrica', 0, ''),
(9, 'Consola de Videojuegos', 0, ''),
(10, 'Impresora', 0, ''),
(11, 'Refrigeración central de 5 tonel', 0, ''),
(12, 'Calefacción', 0, ''),
(13, 'Congelador', 0, ''),
(14, 'Cafetera', 0, ''),
(15, 'Focos incandescentes', 0, ''),
(16, 'Plancha', 0, ''),
(17, 'Horno', 0, ''),
(18, 'Calentador de agua', 0, ''),
(19, 'Lavadora automática', 0, ''),
(20, 'Secadora de ropa', 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `electrodomestico_pregunta`
--

CREATE TABLE `electrodomestico_pregunta` (
  `id_pregunta_electrodomestico` int(10) NOT NULL,
  `id_pregunta` int(10) UNSIGNED NOT NULL,
  `id_electrodomestico` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `electrodomestico_pregunta`
--

INSERT INTO `electrodomestico_pregunta` (`id_pregunta_electrodomestico`, `id_pregunta`, `id_electrodomestico`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20);

-- --------------------------------------------------------

--
-- Table structure for table `factura`
--

CREATE TABLE `factura` (
  `id_factura` int(11) UNSIGNED NOT NULL,
  `id_grupo` int(11) UNSIGNED NOT NULL,
  `foto_factura` varchar(1000) COLLATE latin1_spanish_ci DEFAULT NULL,
  `fecha` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grupo`
--

CREATE TABLE `grupo` (
  `id_grupo` int(10) UNSIGNED NOT NULL,
  `puntos` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `nombre` varchar(100) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `grupo`
--

INSERT INTO `grupo` (`id_grupo`, `puntos`, `nombre`) VALUES
(1, 100, 'Familia'),
(2, 0, 'Chris'),
(3, 10, 'Familia'),
(6, 120, 'Casa Abuela'),
(7, 40, 'Oficina');

-- --------------------------------------------------------

--
-- Table structure for table `grupo_electrodomestico`
--

CREATE TABLE `grupo_electrodomestico` (
  `id_grupo_electrodomestico` int(10) UNSIGNED NOT NULL,
  `id_grupo` int(10) UNSIGNED NOT NULL,
  `id_electrodomestico` int(10) UNSIGNED NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `grupo_electrodomestico`
--

INSERT INTO `grupo_electrodomestico` (`id_grupo_electrodomestico`, `id_grupo`, `id_electrodomestico`, `cantidad`) VALUES
(8, 3, 3, 1),
(9, 3, 5, 1),
(10, 3, 6, 1),
(17, 6, 1, 1),
(18, 6, 4, 1),
(19, 6, 6, 1),
(20, 6, 7, 1),
(21, 7, 2, 1),
(22, 7, 3, 1),
(23, 7, 5, 1),
(24, 7, 7, 1),
(119, 1, 1, 1),
(120, 1, 3, 1),
(121, 1, 5, 1),
(122, 1, 7, 1),
(123, 1, 8, 1);

-- --------------------------------------------------------

--
-- Table structure for table `grupo_usuario`
--

CREATE TABLE `grupo_usuario` (
  `id_grupo` int(11) UNSIGNED NOT NULL,
  `id_usuario` int(11) UNSIGNED NOT NULL,
  `rol` enum('basic','admin') COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `grupo_usuario`
--

INSERT INTO `grupo_usuario` (`id_grupo`, `id_usuario`, `rol`) VALUES
(1, 1, 'admin'),
(2, 2, 'admin'),
(3, 3, 'admin'),
(6, 1, 'admin'),
(6, 4, 'basic'),
(6, 5, 'basic'),
(7, 1, 'admin'),
(7, 6, 'basic'),
(3, 4, NULL),
(1, 4, 'basic'),
(1, 7, 'basic'),
(1, 8, 'basic');

-- --------------------------------------------------------

--
-- Table structure for table `pregunta`
--

CREATE TABLE `pregunta` (
  `id_pregunta` int(10) UNSIGNED NOT NULL,
  `pregunta` varchar(128) COLLATE latin1_spanish_ci NOT NULL,
  `respuesta_1` varchar(128) COLLATE latin1_spanish_ci NOT NULL,
  `valor_1` int(10) UNSIGNED NOT NULL,
  `respuesta_2` varchar(128) COLLATE latin1_spanish_ci NOT NULL,
  `valor_2` int(10) UNSIGNED NOT NULL,
  `respuesta_3` varchar(128) COLLATE latin1_spanish_ci DEFAULT NULL,
  `valor_3` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `pregunta`
--

INSERT INTO `pregunta` (`id_pregunta`, `pregunta`, `respuesta_1`, `valor_1`, `respuesta_2`, `valor_2`, `respuesta_3`, `valor_3`) VALUES
(1, '¿Cuánto utilizaste la Televisión de 14 Pulgadas el día de hoy?', 'No la utilicé', 0, 'De 1 a 3 horas', 1020, 'Más de 3 horas', 3060),
(2, '¿Cuánto utilizaste la Televisión de 39 Pulgadas el día de hoy?', 'No la utilicé', 0, 'De 1 a 3 horas', 1020, 'Más de 3 horas', 3060),
(3, '¿Cuanto utilizaste la Televisión de 14 Pulgadas el dia de hoy?', 'No la utilicé', 0, 'De 1 a 3 horas', 1709, 'Mas de 3 horas', 5127),
(4, '¿Cuánto tiempo dejaste cargando tu Smartphone el día de hoy?', 'No lo cargué', 0, 'De 2 a 3 horas', 920, 'Toda la noche', 2760),
(5, '¿Cuántas veces abriste la puerta del Refrigerador el día de hoy?', 'No lo usé', 0, 'De 2 a 3 veces', 30, 'Más de 3 veces', 90),
(6, '¿Cuánto dejaste encendido el Ventilador?', 'No lo usé', 0, 'Menos de 3 horas', 130, 'Más de 3 horas', 390),
(7, '¿Cuánto dejaste encendido el airecondicionado?', 'No lo usé', 0, 'Menos de 3 horas', 1680, 'Más de 3 horas', 5040),
(8, '¿Cuántas veces se usó la impresora hoy?', 'Ninguna.', 0, 'Una vez.', 910, 'Más de una vez.', 2730),
(9, '¿Cuántas horas se jugaron con la consola?', 'No se usó.', 0, 'Menos de 2 horas.', 140, 'Más de 2 horas.', 420),
(10, '¿Cuánto tiempo se cocinó usando la estufa eléctirca?', 'No se utilizó.', 0, 'Menos de una hora.', 1000, 'Más de una hora.', 3000),
(11, '¿Cuánto utilizaste la mpresorael día de hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 645, 'Más de una hora.', 1935),
(12, '¿Cuánto utilizaste  el refrigerador central de 5 toneladasde hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 5250, 'Más de una hora.', 15750),
(13, '¿Cuánto utilizaste  la calefacción hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 870, 'Más de una hora.', 2610),
(14, '¿Cuánto utilizaste el congelador hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 1500, 'Más de una hora.', 4500),
(15, '¿Cuánto utilizaste la cafetera hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 400, 'Más de una hora.', 1200),
(16, '¿Cuánto utilizaste los focos incandescentes hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 60, 'Más de una hora.', 180),
(17, '¿Cuánto utilizaste la plancha hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 300, 'Más de una hora.', 900),
(18, '¿Cuánto utilizaste el horno hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 150, 'Más de una hora.', 450),
(19, '¿Cuánto utilizaste el calentador de agua hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 1680, 'Más de una hora.', 5040),
(20, '¿Cuánto utilizaste la lavadora automática de agua hoy?', 'No se utilizó.', 0, 'Menos de una hora.', 1020, 'Más de una hora.', 3060);

-- --------------------------------------------------------

--
-- Table structure for table `tip`
--

CREATE TABLE `tip` (
  `idtip` int(11) UNSIGNED NOT NULL,
  `texto` varchar(1000) COLLATE latin1_spanish_ci NOT NULL,
  `arquetipo` enum('Adulto','Niño') COLLATE latin1_spanish_ci NOT NULL,
  `url_imagen` text COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `tip`
--

INSERT INTO `tip` (`idtip`, `texto`, `arquetipo`, `url_imagen`) VALUES
(1, 'No dejes encendida ninguna conexión en las noches.', 'Niño', NULL),
(2, 'Apaga las luces de tu cuarto cuando no las uses.', 'Niño', NULL),
(3, 'Si algún foco hace falso contacto, quítalo, consume luz aún si no se está usando.', 'Niño', NULL),
(4, 'No dejes cargando tu celular en las noches, una vez se cargue al 100% desconéctalo.', 'Niño', NULL),
(5, 'Si ya no vas a usar tu computadora, apágala.', 'Niño', NULL),
(6, 'Cierra la puerta de tu refrigerador cuando no lo estés usando.', 'Niño', NULL),
(7, 'De preferencia usa luces de escritorio en vez de tener una habitación iluminada.', 'Niño', NULL),
(8, 'Apaga la televisión cuando la dejes de ver.', 'Niño', NULL),
(9, 'Revisa tu instalación eléctrica:\r\n\r\nRevisa que no haya fugas eléctricas, sobre todo si tu casa fue construida hace más de 10 años:\r\n* Apaga todos los focos y desconecta los aparatos que consumen energía.\r\n* Revisa tu medidor. El disco o el contador debería detenerse por completo.\r\n* Si el disco o el contador sigue avanzando, es probable que tengas una fuga eléctrica. En este caso, te recomendamos que llames a un técnico para que revise tu instalación.', 'Adulto', ''),
(10, 'Desconecta los aparatos eléctricos cuando no se utilicen:\r\n\r\nMuchos aparatos consumen energía aunque estén apagados como el cargador de celular o la computadora, así como las pantallas o las consolas de videojuegos.\r\n\r\nSegún la Procuraduría Federal del Consumidor (PROFECO), estos “vampiros eléctricos” representan hasta el 13% del consumo de luz de los hogares.', 'Adulto', NULL),
(11, 'Ubica tus aparatos de aire acondicionado en lugares frescos:\r\n\r\nLos aparatos eléctricos consumen menos energía cuando se ubican en lugares bien ventilados. Cambia regularmente los filtros, según lo indique el manual del usuario.', 'Adulto', NULL),
(12, 'Da mantenimiento preventivo y correctivo a los electrodomésticos:\r\n\r\nLos aparatos eléctricos consumen más energía si tienen fallas acumuladas, por lo que es recomendable que sean revisados periódicamente por técnicos especializados.', 'Adulto', NULL),
(13, 'Compra aparatos eléctricos certificados como ahorradores:\r\n\r\nAparatos como el aire acondicionado, el refrigerador, el horno de microondas, la lavadora, la plancha, la televisión y la computadora consumen mucha energía. Al comprarlos, revisa que estén certificados como ahorradores y evita que tu recibo de luz aumente innecesariamente. La CONUEE otorga un sello a los equipos con buen desempeño y ahorro de energía.', 'Adulto', NULL),
(14, 'Utiliza la vegetación a tu favor:\r\n\r\nLas enredaderas o plantas que cambian de follaje cada año dan sombra en verano y permiten el paso de la luz del sol en invierno.', 'Adulto', NULL),
(15, 'Aprovecha la iluminación natural:\r\n\r\nEn las zonas de clima templado en el país, las habitaciones con tragaluces, ventanas o domos no requieren mucha iluminación eléctrica. En las zonas de clima tropical, las ventanas también sirven como fuente de iluminación pero, a causa del calor, su apertura es más recomendable en las mañanas o al final del día.', 'Adulto', NULL),
(16, 'Aplica materiales o pinturas aislantes:\r\n\r\nLos aislantes en techos o paredes reducen el intercambio de calor con el exterior. En verano, mantienen el ambiente fresco generado por el aire acondicionado y en invierno retienen el calor en el interior.', 'Adulto', NULL),
(17, 'Pinta las paredes y techos de colores claros dentro y fuera de tu casa:\r\n\r\nLos colores claros en el exterior reflejan la luz del sol, ayudando a que la casa se caliente menos; en el interior permiten que se aproveche mejor la luz natural y artificial.', 'Adulto', NULL),
(18, 'Sustituye los focos incandescentes por focos ahorradores o LEDs:\r\n\r\nVerifica que tus focos sean de fabricantes reconocidos que ofrezcan altos niveles de iluminación y una larga vida útil. Para las áreas de uso común, como pasillos, escaleras o estacionamientos, te recomendamos que uses luminarias con sensores de movimiento.', 'Adulto', NULL),
(19, 'Aire acondicionado y calefacción:\r\n\r\nUtiliza la vegetación a tu favor; plantar árboles en puntos estratégicos ayuda a desviar las corrientes de aire frío en invierno y a generar sombras en el verano.\r\n\r\nMediante la instalación de toldos de lona o aleros inclinados, persianas de aluminio, vidrios polarizados, recubrimientos, mallas y películas plásticas, se evita que el sol llegue directamente al interior. Así se pueden obtener ahorros en el consumo de energía eléctrica por el uso de aire acondicionado.\r\n\r\nEl aislamiento adecuado de techos y paredes ayuda a mantener una temperatura agradable en la casa.\r\n\r\nSi utilizas unidades centrales de aire acondicionado, aísla también los ductos.\r\n\r\nEs relativamente sencillo sellar las ventanas y puertas de la casa con pasta de silicón, para que no entre el frío en los meses de invierno y no se escape en los meses calurosos.\r\n\r\nCuando compres o remplaces el equipo, verifica que sea el adecuado a tus necesidades.', 'Adulto', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tip_usuario`
--

CREATE TABLE `tip_usuario` (
  `id_usuario` int(11) UNSIGNED NOT NULL,
  `ultima` date NOT NULL,
  `id_tip_1` int(11) UNSIGNED NOT NULL,
  `id_tip_2` int(11) UNSIGNED NOT NULL,
  `id_tip_3` int(11) UNSIGNED NOT NULL,
  `id_tip_4` int(11) UNSIGNED NOT NULL,
  `id_tip_5` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) UNSIGNED NOT NULL,
  `nombre` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `apellido_paterno` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `apellido_materno` varchar(32) COLLATE latin1_spanish_ci DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `arquetipo` set('Adulto','Niño') COLLATE latin1_spanish_ci DEFAULT NULL,
  `correo` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `contraseña` varchar(64) COLLATE latin1_spanish_ci NOT NULL,
  `dirección` int(11) NOT NULL,
  `fecha_tip` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombre`, `apellido_paterno`, `apellido_materno`, `fecha_nacimiento`, `arquetipo`, `correo`, `contraseña`, `dirección`, `fecha_tip`) VALUES
(1, 'Rodrigo', 'Gómez', 'Maitret', '1996-06-24', 'Adulto', 'rodrigo.gomezm@udem.edu', '$2b$12$.nQkLb9Ck4oA6kbA/8Q.feIp/glP05kM7DhJJSYF3Q3O8v5qTEEm.', 0, NULL),
(2, 'Chris', 'Chris', 'Chris', '2020-02-20', 'Niño', 'chris@chris.com', '$2b$12$Hgi0XGajES/q0/f68QR6fuDxNE0aq/k1b7xFq8uZ.wmF3mzNqW3p2', 0, NULL),
(3, 'Roberto', 'Pérez', 'Martínez', '2020-02-20', 'Adulto', 'luis@luis.com', '$2b$12$jTpYnGLznSe9/rGpyJPGOOGFUIVDzP55VaJv.KYwW9SSSOZHx3twy', 0, NULL),
(4, 'José Manuel', 'Gómez', 'Maitret', '1996-06-24', 'Adulto', 'pepe@gmail.com', '$2b$12$GBJhFWwWuH27BZT4UBwR4ObCdlHsU/IhNSSi2iccHPnw0K7dvTcA6', 0, NULL),
(5, 'María Luisa', 'Gómez', 'Diego', '1950-01-01', 'Adulto', 'ml@gmail.com', '$2b$12$KTFo72eixIvexLHhfvJDJOdiq8cpXD0EM.MHciE..ylRiEZpa1qHe', 0, NULL),
(6, 'Christopher', 'Valdez', 'Cantú', '1990-01-01', 'Adulto', 'chris@gmail.com', '$2b$12$2c..6ri53rNsBi1eWPdrHuPUUs0/6.Fy3xK9xVLOkN4ALE0mLOJI6', 0, NULL),
(7, 'Lydia', 'Maitret', 'C.', '1950-02-01', 'Adulto', 'lydia@gmail.com', '$2b$12$rxiDPDhu8JY1YazoI5cBeu0Gwydnel.5IMFtGawR/c9AukCTAz45u', 0, NULL),
(8, 'José Luis', 'Gómez', 'Diego|', '1950-01-01', 'Adulto', 'jgd@gmail.com', '$2b$12$YqHF4bSFl405cfBD97ft1OqrTiIxgbB03Wg5tSESkKNGbxuu7bx2C', 0, NULL),
(9, 'Fernando', 'Morán', 'Cuspinera', '2010-01-01', 'Niño', 'fernando@gmail.com', '$2b$12$czR5tbTwwgjFP2ihwXl3r.yMsSp/vTJWP6FXku6EJdUcpdNs.YCoK', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `video`
--

CREATE TABLE `video` (
  `id_video` int(10) UNSIGNED NOT NULL,
  `url` text COLLATE latin1_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `video`
--

INSERT INTO `video` (`id_video`, `url`) VALUES
(1, 'https://youtu.be/d6pfSyKrbeg'),
(2, 'https://youtu.be/YCQsxqCfiz0'),
(3, 'https://youtu.be/dbTBMMcsr10'),
(4, 'https://youtu.be/nqDCSzPssX4'),
(5, 'https://youtu.be/COuC0e7LCj8'),
(6, 'https://youtu.be/bnEfEm1OH5Y'),
(7, 'https://youtu.be/rC2Ok1_cI4k');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `consumo`
--
ALTER TABLE `consumo`
  ADD PRIMARY KEY (`id_consumo`),
  ADD KEY `id_grupo` (`id_grupo`);

--
-- Indexes for table `electrodomestico`
--
ALTER TABLE `electrodomestico`
  ADD PRIMARY KEY (`id_electrodomestico`);

--
-- Indexes for table `electrodomestico_pregunta`
--
ALTER TABLE `electrodomestico_pregunta`
  ADD PRIMARY KEY (`id_pregunta_electrodomestico`),
  ADD KEY `id_electrodomestico` (`id_electrodomestico`),
  ADD KEY `id_pregunta` (`id_pregunta`) USING BTREE;

--
-- Indexes for table `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`id_factura`),
  ADD KEY `id_usuario` (`id_grupo`);

--
-- Indexes for table `grupo`
--
ALTER TABLE `grupo`
  ADD PRIMARY KEY (`id_grupo`);

--
-- Indexes for table `grupo_electrodomestico`
--
ALTER TABLE `grupo_electrodomestico`
  ADD PRIMARY KEY (`id_grupo_electrodomestico`),
  ADD KEY `id_grupo` (`id_grupo`,`id_electrodomestico`),
  ADD KEY `id_electrodomestico` (`id_electrodomestico`);

--
-- Indexes for table `grupo_usuario`
--
ALTER TABLE `grupo_usuario`
  ADD KEY `id_grupo` (`id_grupo`,`id_usuario`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indexes for table `pregunta`
--
ALTER TABLE `pregunta`
  ADD PRIMARY KEY (`id_pregunta`);

--
-- Indexes for table `tip`
--
ALTER TABLE `tip`
  ADD PRIMARY KEY (`idtip`),
  ADD KEY `arquetipo` (`arquetipo`);

--
-- Indexes for table `tip_usuario`
--
ALTER TABLE `tip_usuario`
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_tip_1` (`id_tip_1`),
  ADD KEY `id_tip_2` (`id_tip_2`),
  ADD KEY `id_tip_3` (`id_tip_3`),
  ADD KEY `id_tip_4` (`id_tip_4`,`id_tip_5`),
  ADD KEY `id_tip_5` (`id_tip_5`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `dirección` (`dirección`),
  ADD KEY `arquetipo` (`arquetipo`);

--
-- Indexes for table `video`
--
ALTER TABLE `video`
  ADD PRIMARY KEY (`id_video`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `consumo`
--
ALTER TABLE `consumo`
  MODIFY `id_consumo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `electrodomestico`
--
ALTER TABLE `electrodomestico`
  MODIFY `id_electrodomestico` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `electrodomestico_pregunta`
--
ALTER TABLE `electrodomestico_pregunta`
  MODIFY `id_pregunta_electrodomestico` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `factura`
--
ALTER TABLE `factura`
  MODIFY `id_factura` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grupo`
--
ALTER TABLE `grupo`
  MODIFY `id_grupo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `grupo_electrodomestico`
--
ALTER TABLE `grupo_electrodomestico`
  MODIFY `id_grupo_electrodomestico` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `pregunta`
--
ALTER TABLE `pregunta`
  MODIFY `id_pregunta` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tip`
--
ALTER TABLE `tip`
  MODIFY `idtip` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `video`
--
ALTER TABLE `video`
  MODIFY `id_video` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `consumo`
--
ALTER TABLE `consumo`
  ADD CONSTRAINT `consumo_ibfk_1` FOREIGN KEY (`id_grupo`) REFERENCES `grupo` (`id_grupo`) ON DELETE CASCADE;

--
-- Constraints for table `electrodomestico_pregunta`
--
ALTER TABLE `electrodomestico_pregunta`
  ADD CONSTRAINT `electrodomestico_pregunta_ibfk_1` FOREIGN KEY (`id_electrodomestico`) REFERENCES `electrodomestico` (`id_electrodomestico`),
  ADD CONSTRAINT `electrodomestico_pregunta_ibfk_2` FOREIGN KEY (`id_pregunta`) REFERENCES `pregunta` (`id_pregunta`);

--
-- Constraints for table `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`id_grupo`) REFERENCES `grupo` (`id_grupo`) ON DELETE CASCADE;

--
-- Constraints for table `grupo_electrodomestico`
--
ALTER TABLE `grupo_electrodomestico`
  ADD CONSTRAINT `grupo_electrodomestico_ibfk_1` FOREIGN KEY (`id_grupo`) REFERENCES `grupo` (`id_grupo`),
  ADD CONSTRAINT `grupo_electrodomestico_ibfk_2` FOREIGN KEY (`id_electrodomestico`) REFERENCES `electrodomestico` (`id_electrodomestico`);

--
-- Constraints for table `grupo_usuario`
--
ALTER TABLE `grupo_usuario`
  ADD CONSTRAINT `grupo_usuario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  ADD CONSTRAINT `grupo_usuario_ibfk_2` FOREIGN KEY (`id_grupo`) REFERENCES `grupo` (`id_grupo`) ON DELETE CASCADE;

--
-- Constraints for table `tip_usuario`
--
ALTER TABLE `tip_usuario`
  ADD CONSTRAINT `tip_usuario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

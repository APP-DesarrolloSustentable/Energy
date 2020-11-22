-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 22, 2020 at 08:54 PM
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

-- --------------------------------------------------------

--
-- Table structure for table `electrodomestico`
--

CREATE TABLE `electrodomestico` (
  `id_electrodomestico` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `consumo_por_hora` int(10) UNSIGNED NOT NULL,
  `url_imagen` text COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `electrodomestico`
--

INSERT INTO `electrodomestico` (`id_electrodomestico`, `nombre`, `consumo_por_hora`, `url_imagen`) VALUES
(1, 'Television 14 pulgadas', 50, ''),
(2, 'Television 39 pulgadas', 90, '');

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
(1, 1, 1);

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
(1, 0, 'Familia Valdez'),
(2, 0, 'Familia Gomez'),
(3, 0, '1'),
(4, 50, 'Familia Mágica'),
(5, 75, 'Familia Mágica'),
(6, 0, 'Familia SUPER'),
(7, 0, 'Familia SUPER'),
(8, 0, 'Familia SUPER'),
(10, 0, 'BBB'),
(11, 0, 'AAA'),
(12, 0, 'BBB'),
(13, 0, 'AAA'),
(15, 0, 'Familia SUPER'),
(16, 0, 'Familia SUPER'),
(17, 15, 'EFE'),
(18, 80, 'Magia');

-- --------------------------------------------------------

--
-- Table structure for table `grupo_electrodomestico`
--

CREATE TABLE `grupo_electrodomestico` (
  `id_grupo_electrodomestico` int(10) UNSIGNED NOT NULL,
  `id_grupo` int(10) UNSIGNED NOT NULL,
  `id_electrodomestico` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `grupo_electrodomestico`
--

INSERT INTO `grupo_electrodomestico` (`id_grupo_electrodomestico`, `id_grupo`, `id_electrodomestico`) VALUES
(2, 1, 1),
(3, 17, 1),
(1, 17, 2),
(5, 18, 1);

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
(2, 9, 'admin'),
(5, 8, 'admin'),
(6, 9, 'admin'),
(7, 9, 'admin'),
(3, 9, 'admin'),
(16, 9, 'admin'),
(17, 18, 'admin'),
(17, 8, 'admin'),
(18, 21, 'admin'),
(18, 8, 'basic');

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
(1, '¿Cuanto utilizaste la television el dia de hoy?', 'no la utilise', 0, 'de 1 a 3 horas', 2, 'mas de 3 horas', 3);

-- --------------------------------------------------------

--
-- Table structure for table `tip`
--

CREATE TABLE `tip` (
  `idtip` int(10) UNSIGNED NOT NULL,
  `texto` varchar(1000) COLLATE latin1_spanish_ci NOT NULL,
  `arquetipo` enum('Adulto','Niño') COLLATE latin1_spanish_ci NOT NULL,
  `url_imagen` text COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `tip`
--

INSERT INTO `tip` (`idtip`, `texto`, `arquetipo`, `url_imagen`) VALUES
(1, 'No dejes conectado ninguna conexion a la luz en las noches. ', 'Adulto', NULL),
(2, 'No dejes conectado ninguna conexion a la luz en las noches. ', 'Niño', NULL),
(3, 'Si algun foco hace falso contacto quitalo, consume luz aun si no se usa', 'Adulto', NULL),
(4, 'No dejes cargando tu celular en las noches, una vez se carga al 100% desconectalo', 'Adulto', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `uso`
--

CREATE TABLE `uso` (
  `id_uso` int(10) UNSIGNED NOT NULL,
  `id_grupo_electrodomestico` int(10) UNSIGNED NOT NULL,
  `cantidad` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `fecha` date NOT NULL DEFAULT current_timestamp()
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
(8, 'Christopher', 'Valdez', 'Cantu', '1997-11-11', 'Adulto', 'chris@gmail.com', '$2b$12$F.UvjVNsgsjHvPdk3azYS.jhohpNaDVnjC6Q7iC6L8S/ZDp3S8bE.', 0, NULL),
(9, 'Rodrigo', 'Gomez', 'Maitret', '1999-05-17', 'Adulto', 'rodrigo@udem.edu', '$2b$12$aV3YKKIeIvyAGGZtmvuvsuKfzuACUErEQhE3M86TD9rnq645MwP.G', 0, NULL),
(10, 'Karla', 'Lira', 'Rangel', '1999-02-18', 'Adulto', 'karla.lira@udem.edu', '$2b$12$x6a3R5spZ1INlvEk59LmJONmUIkSyBrPPak3VXiZYVLeyazN..a/.', 0, NULL),
(11, 'jorge', 'Ramirez', 'Sanchez', '2010-01-17', 'Niño', 'jorge.ramirez@gmail.com', '$2b$12$Imy3CF3w5LVcqqW8KPvnpulhWigIW76x.XGuTCvtr5z/Owung9cwK', 0, NULL),
(12, 'Andres', 'Ramirez', 'Perez', '2011-05-19', 'Niño', 'andres.ramirez@gmail.com', '$2b$12$zDKahf4C0FtpDV6uC4291OsUIrhJLjMSOCUZmiNKWrvKvOE0QGz7i', 0, NULL),
(13, 'Pepe', 'Ramoz', 'Ramirez', '2011-07-19', 'Niño', 'peperamos@gmail.com', '$2b$12$2WE3Rv4k6m7yUWQ83que1OnmGek97rJc8TNuTQzyYECCaybr4knfW', 0, NULL),
(14, 'Jose', 'Ramirez', 'Paramo', '1978-12-17', 'Adulto', 'jose.angel@gmail.com', '$2b$12$cWqw4r4uflfP4jw3zyX75OfO1ohDKvhf1sjp9Ybl2ar/v6JWOIZ.a', 0, NULL),
(15, 'Andrea Fernanda', 'Fernandes', 'Castro', '1997-08-12', 'Adulto', 'andrea.fernanda@udem.edu', '$2b$12$SKGvG0Rt2OambR.aQNGJNuMXFl65h1zS.1up.HI.8kYIXxft8utAi', 0, NULL),
(16, 'Juana Fernanda', 'Martinez', 'Ramirez', '2009-03-15', 'Niño', 'juana.martinez@hotmail.com', '$2b$12$rPPiRGQMCX7EWLaY86GwBe.n1EqO/teGmzMlAZwnxjYCu.X2WJiFe', 0, NULL),
(17, 'Jose Pablo', 'Hernan', 'Cortez', '1997-11-18', 'Adulto', 'jose.pablo@hotmail.com', '$2b$12$pRIBpZor8EM7AYVvr8d5OeNspe5dRZAdsLvPEx2kWrtWlM4ZiIOpe', 0, NULL),
(18, 'Lol', 'Lol', 'Lol', '2020-10-10', 'Niño', 'lel@hotmal.com', '$2b$12$Ga6xuNdLYI80o2dnPHuJwO4I5tKOW8.oguO/7N65V5lC95W1TBDoq', 0, NULL),
(19, 'Fu', 'Fu', 'Fu', '2020-10-10', 'Niño', 'Fidel@udem.edu', '$2b$12$SwzkGQPfF8pxK8ZGrJtEsuqrXq/tJPu51T7O32xB2CniMO5cH9q0.', 0, NULL),
(20, 'Juan', 'Jo', 'Jo', '2020-10-10', 'Niño', 'yo@yo.com', '$2b$12$l0EJgd0dAjgheuOS2tt9KOtalXlS/sytyvlqfqUWN1voa/tU7IRci', 0, NULL),
(21, 'Juju', 'Jaja', 'Jeje', '2020-05-05', 'Adulto', 'ye@ye.com', '$2b$12$3XJ6bUawj1tv1vJ1kRPdhe9BDSROIz7MhXhQdo0hiGsKeSA60VZhK', 0, NULL),
(22, 'Christopher', 'Valdez', 'Cantu', '1998-04-18', 'Adulto', 'christopherkntu@gmail.com', '$2b$12$RPFF7EItJ2b3G.bYbvXGeu3IkcwMpljO5LHaMe26ItOgkp1JQZB7K', 0, NULL),
(23, 'Christopher', 'Valdez ', 'Cantu', '1998-04-18', 'Adulto', 'christopher.valdez@udem.edu', '$2b$12$c0o28hi3rAueot.sE492H.c3zuHr8St8udlZOUR3gTFyUkqTKbuwS', 0, NULL),
(24, 'Christopher', 'Valdez', 'Cantu', '1997-12-17', 'Adulto', 'karla@gmail.com', '$2b$12$ykDbjsm1IcPQOAVLzvnU3ulOOpP83X4Axw.HRkjbL4rDJlGr6lH1a', 0, NULL),
(25, 'Chris', 'Valdez', 'Cantu', '1988-04-18', 'Adulto', 'test123@gmail.com', '$2b$12$Wh8DCY3/3.LBdYmjyvxb1uZ3sSUbdNTzWOhkAAhD9JMQ7qET/921S', 0, NULL),
(26, 'Christopher', 'Valdez', 'Cantu', '1998-04-17', 'Adulto', 'christopher.test@gmail.com', '$2b$12$g03nvO4VcCKNr./QOCT/cOpbp5wEX.z52w2hUvGWSwkZBwSCOTpNm', 0, NULL);

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
-- Indexes for table `uso`
--
ALTER TABLE `uso`
  ADD PRIMARY KEY (`id_uso`),
  ADD KEY `id_grupo_electrodomestico` (`id_grupo_electrodomestico`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `dirección` (`dirección`),
  ADD KEY `arquetipo` (`arquetipo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `consumo`
--
ALTER TABLE `consumo`
  MODIFY `id_consumo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `electrodomestico`
--
ALTER TABLE `electrodomestico`
  MODIFY `id_electrodomestico` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `electrodomestico_pregunta`
--
ALTER TABLE `electrodomestico_pregunta`
  MODIFY `id_pregunta_electrodomestico` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `factura`
--
ALTER TABLE `factura`
  MODIFY `id_factura` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grupo`
--
ALTER TABLE `grupo`
  MODIFY `id_grupo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `grupo_electrodomestico`
--
ALTER TABLE `grupo_electrodomestico`
  MODIFY `id_grupo_electrodomestico` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pregunta`
--
ALTER TABLE `pregunta`
  MODIFY `id_pregunta` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tip`
--
ALTER TABLE `tip`
  MODIFY `idtip` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `uso`
--
ALTER TABLE `uso`
  MODIFY `id_uso` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

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
-- Constraints for table `uso`
--
ALTER TABLE `uso`
  ADD CONSTRAINT `uso_ibfk_1` FOREIGN KEY (`id_grupo_electrodomestico`) REFERENCES `grupo_electrodomestico` (`id_grupo_electrodomestico`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

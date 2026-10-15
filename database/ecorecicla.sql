-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-10-2026 a las 20:57:38
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ecorecicla`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `beneficios_empresa`
--

CREATE TABLE `beneficios_empresa` (
  `id_beneficio` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `porcentaje_descuento` decimal(5,2) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_fin` datetime DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `beneficios_empresa`
--

INSERT INTO `beneficios_empresa` (`id_beneficio`, `id_empresa`, `nombre`, `descripcion`, `porcentaje_descuento`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
(1, 1, '10 copias gratis', 'Beneficio de prueba equivalente a 10 copias en la papelería aliada', NULL, '2026-08-27 03:32:32', NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `canjes`
--

CREATE TABLE `canjes` (
  `id_canje` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_recompensa` int(11) NOT NULL,
  `puntos_utilizados` decimal(12,2) NOT NULL,
  `codigo_ticket` varchar(20) DEFAULT NULL,
  `fecha_canje` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('PENDIENTE','GENERADO','ENTREGADO','CANCELADO','VENCIDO') NOT NULL DEFAULT 'PENDIENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `canjes`
--

INSERT INTO `canjes` (`id_canje`, `id_usuario`, `id_recompensa`, `puntos_utilizados`, `codigo_ticket`, `fecha_canje`, `estado`) VALUES
(1, 1, 1, 500.00, 'ECO-PKRWCSYH', '2026-08-28 09:30:40', 'GENERADO'),
(2, 1, 1, 500.00, 'ECO-HBGJZ683', '2026-08-28 09:36:50', 'GENERADO'),
(3, 1, 1, 500.00, 'ECO-EG0VHR4C', '2026-08-28 09:37:56', 'GENERADO'),
(4, 1, 1, 500.00, 'ECO-XFD3L5M1', '2026-08-28 09:40:19', 'GENERADO'),
(5, 1, 1, 500.00, 'ECO-4JF2AO2I', '2026-08-28 09:46:01', 'ENTREGADO'),
(6, 1, 1, 500.00, 'ECO-CX271PVM', '2026-08-31 12:28:33', 'GENERADO'),
(7, 1, 1, 500.00, 'ECO-W794P8M6', '2026-08-31 14:18:38', 'GENERADO'),
(8, 1, 1, 500.00, 'ECO-ABRZAW5X', '2026-08-31 18:00:41', 'ENTREGADO'),
(9, 1, 1, 500.00, 'ECO-4MUS7DR0', '2026-08-31 19:16:13', 'ENTREGADO'),
(10, 4, 1, 500.00, 'ECO-UAAF643U', '2026-08-31 19:20:56', 'GENERADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_recompensa`
--

CREATE TABLE `categorias_recompensa` (
  `id_categoria_recompensa` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias_recompensa`
--

INSERT INTO `categorias_recompensa` (`id_categoria_recompensa`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'Papelería', 'Beneficios relacionados con servicios y productos de papelería', 1),
(2, 'Alimentación', 'Productos o descuentos relacionados con alimentación', 1),
(3, 'Educación', 'Beneficios relacionados con actividades educativas', 1),
(4, 'Tecnología', 'Beneficios relacionados con tecnología', 1),
(5, 'Entretenimiento', 'Beneficios relacionados con entretenimiento', 1),
(6, 'Descuentos', 'Descuentos ofrecidos por empresas aliadas', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_reciclaje`
--

CREATE TABLE `detalle_reciclaje` (
  `id_detalle_reciclaje` int(11) NOT NULL,
  `id_reciclaje` int(11) NOT NULL,
  `id_tipo_material` int(11) NOT NULL,
  `cantidad` decimal(10,3) NOT NULL,
  `puntos` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `detalle_reciclaje`
--

INSERT INTO `detalle_reciclaje` (`id_detalle_reciclaje`, `id_reciclaje`, `id_tipo_material`, `cantidad`, `puntos`) VALUES
(1, 1, 1, 1.000, 100.00),
(2, 2, 4, 1.000, 50.00),
(3, 3, 1, 0.001, 0.10),
(4, 4, 1, 1.000, 100.00),
(5, 5, 1, 1.000, 100.00),
(6, 6, 1, 10.000, 1000.00),
(7, 7, 1, 5.000, 500.00),
(8, 8, 3, 8.000, 960.00),
(9, 9, 1, 1.000, 100.00),
(10, 10, 3, 10.000, 1200.00),
(11, 11, 3, 20.000, 2400.00),
(12, 12, 3, 10.000, 1200.00),
(13, 13, 1, 10.500, 1050.00),
(14, 14, 1, 1.000, 100.00),
(15, 15, 1, 10.000, 1000.00),
(16, 16, 1, 10.000, 1000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas_aliadas`
--

CREATE TABLE `empresas_aliadas` (
  `id_empresa` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `nit` varchar(30) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `empresas_aliadas`
--

INSERT INTO `empresas_aliadas` (`id_empresa`, `nombre`, `nit`, `descripcion`, `correo`, `telefono`, `direccion`, `logo`, `fecha_registro`, `estado`) VALUES
(1, 'Papelería San Mateo', NULL, 'Establecimiento aliado de prueba para validación y entrega de recompensas', 'papeleria@ejemplo.com', '0000000000', 'Fundación Universitaria San Mateo - Bogotá', NULL, '2026-08-27 03:32:11', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entregas_recompensa`
--

CREATE TABLE `entregas_recompensa` (
  `id_entrega` int(11) NOT NULL,
  `id_ticket` int(11) NOT NULL,
  `id_usuario_entrega` int(11) NOT NULL,
  `fecha_entrega` datetime NOT NULL DEFAULT current_timestamp(),
  `observacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_ticket`
--

CREATE TABLE `historial_ticket` (
  `id_historial` int(11) NOT NULL,
  `id_ticket` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `estado_anterior` varchar(30) DEFAULT NULL,
  `estado_nuevo` varchar(30) DEFAULT NULL,
  `fecha_cambio` datetime NOT NULL DEFAULT current_timestamp(),
  `observacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insignias`
--

CREATE TABLE `insignias` (
  `id_insignia` int(11) NOT NULL,
  `id_tipo_insignia` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `icono` varchar(255) DEFAULT NULL,
  `requisito_tipo` enum('RECICLAJES','PESO','PUNTOS','CANJES','MATERIAL','ESPECIAL') NOT NULL,
  `requisito_valor` decimal(12,2) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `insignias`
--

INSERT INTO `insignias` (`id_insignia`, `id_tipo_insignia`, `nombre`, `descripcion`, `icono`, `requisito_tipo`, `requisito_valor`, `estado`) VALUES
(1, 1, 'Primer Reciclaje', 'Realiza tu primer reciclaje en EcoRecicla', NULL, 'RECICLAJES', 1.00, 1),
(2, 1, 'Reciclador Constante', 'Completa 10 reciclajes', NULL, 'RECICLAJES', 10.00, 1),
(3, 1, 'Reciclador Experto', 'Completa 50 reciclajes', NULL, 'RECICLAJES', 50.00, 1),
(4, 2, 'Primeros Puntos', 'Acumula tus primeros 500 puntos', NULL, 'PUNTOS', 500.00, 1),
(5, 2, 'Eco 1.000', 'Acumula 1.000 puntos', NULL, 'PUNTOS', 1000.00, 1),
(6, 2, 'Eco 5.000', 'Acumula 5.000 puntos', NULL, 'PUNTOS', 5000.00, 1),
(7, 3, 'Recolector 5 KG', 'Recicla un total de 5 kilogramos', NULL, 'PESO', 5.00, 1),
(8, 3, 'Recolector 25 KG', 'Recicla un total de 25 kilogramos', NULL, 'PESO', 25.00, 1),
(9, 3, 'Recolector 100 KG', 'Recicla un total de 100 kilogramos', NULL, 'PESO', 100.00, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maquinas`
--

CREATE TABLE `maquinas` (
  `id_maquina` int(11) NOT NULL,
  `id_ubicacion` int(11) NOT NULL,
  `codigo_maquina` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_instalacion` date DEFAULT NULL,
  `ultima_conexion` datetime DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA','MANTENIMIENTO','FUERA_SERVICIO') NOT NULL DEFAULT 'ACTIVA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `maquinas`
--

INSERT INTO `maquinas` (`id_maquina`, `id_ubicacion`, `codigo_maquina`, `nombre`, `descripcion`, `fecha_instalacion`, `ultima_conexion`, `estado`) VALUES
(1, 1, 'ECO-SM-001', 'EcoRecicla San Mateo', 'Máquina piloto de recepción y registro de materiales reciclables', '2026-08-27', NULL, 'ACTIVA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maquina_material`
--

CREATE TABLE `maquina_material` (
  `id_maquina` int(11) NOT NULL,
  `id_tipo_material` int(11) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `maquina_material`
--

INSERT INTO `maquina_material` (`id_maquina`, `id_tipo_material`, `activo`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(1, 4, 1),
(1, 5, 1),
(1, 6, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_puntos`
--

CREATE TABLE `movimientos_puntos` (
  `id_movimiento` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_tipo_movimiento` int(11) NOT NULL,
  `puntos` decimal(12,2) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_movimiento` datetime NOT NULL DEFAULT current_timestamp(),
  `id_reciclaje` int(11) DEFAULT NULL,
  `id_canje` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `movimientos_puntos`
--

INSERT INTO `movimientos_puntos` (`id_movimiento`, `id_usuario`, `id_tipo_movimiento`, `puntos`, `descripcion`, `fecha_movimiento`, `id_reciclaje`, `id_canje`) VALUES
(1, 1, 1, 100.00, 'Reciclaje de Botellas PET', '2026-08-27 13:50:12', 1, NULL),
(2, 1, 1, 50.00, 'Reciclaje de Cartón', '2026-08-27 13:54:15', 2, NULL),
(3, 1, 1, 0.10, 'Reciclaje de Botellas PET', '2026-08-27 19:08:49', 3, NULL),
(4, 1, 1, 100.00, 'Reciclaje de Botellas PET', '2026-08-27 20:57:03', 4, NULL),
(5, 1, 1, 100.00, 'Reciclaje de Botellas PET', '2026-08-28 09:30:04', 5, NULL),
(6, 1, 1, 1000.00, 'Reciclaje de Botellas PET', '2026-08-28 09:30:23', 6, NULL),
(7, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-28 09:30:40', NULL, 1),
(8, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-28 09:36:50', NULL, 2),
(9, 1, 1, 500.00, 'Reciclaje de Botellas PET', '2026-08-28 09:37:49', 7, NULL),
(10, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-28 09:37:56', NULL, 3),
(11, 1, 1, 960.00, 'Reciclaje de Latas', '2026-08-28 09:39:50', 8, NULL),
(12, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-28 09:40:19', NULL, 4),
(13, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-28 09:46:01', NULL, 5),
(14, 1, 1, 100.00, 'Reciclaje de Botellas PET', '2026-08-31 12:27:59', 9, NULL),
(15, 1, 1, 1200.00, 'Reciclaje de Latas', '2026-08-31 12:28:24', 10, NULL),
(16, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-31 12:28:33', NULL, 6),
(17, 1, 1, 2400.00, 'Reciclaje de Latas', '2026-08-31 14:04:59', 11, NULL),
(18, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-31 14:18:38', NULL, 7),
(19, 1, 1, 1200.00, 'Reciclaje de Latas', '2026-08-31 18:00:24', 12, NULL),
(20, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-31 18:00:41', NULL, 8),
(21, 1, 1, 1050.00, 'Reciclaje de Botellas PET', '2026-08-31 19:01:15', 13, NULL),
(22, 1, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-31 19:16:13', NULL, 9),
(23, 4, 1, 100.00, 'Reciclaje de Botellas PET', '2026-08-31 19:20:23', 14, NULL),
(24, 4, 1, 1000.00, 'Reciclaje de Botellas PET', '2026-08-31 19:20:48', 15, NULL),
(25, 4, 3, -500.00, 'Canje de recompensa: 10 copias gratis', '2026-08-31 19:20:56', NULL, 10),
(26, 5, 1, 1000.00, 'Reciclaje de Botellas PET', '2026-09-02 11:31:23', 16, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id_permiso` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reciclajes`
--

CREATE TABLE `reciclajes` (
  `id_reciclaje` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_maquina` int(11) NOT NULL,
  `fecha_reciclaje` datetime NOT NULL DEFAULT current_timestamp(),
  `peso_total` decimal(10,3) NOT NULL DEFAULT 0.000,
  `puntos_obtenidos` decimal(10,2) NOT NULL DEFAULT 0.00,
  `codigo_reciclaje` varchar(50) NOT NULL,
  `estado` enum('REGISTRADO','VALIDADO','ANULADO') NOT NULL DEFAULT 'REGISTRADO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `reciclajes`
--

INSERT INTO `reciclajes` (`id_reciclaje`, `id_usuario`, `id_maquina`, `fecha_reciclaje`, `peso_total`, `puntos_obtenidos`, `codigo_reciclaje`, `estado`) VALUES
(1, 1, 1, '2026-08-27 13:50:12', 1.000, 100.00, 'REC-2AD25C1383', 'REGISTRADO'),
(2, 1, 1, '2026-08-27 13:54:15', 1.000, 50.00, 'REC-9C96D1C887', 'REGISTRADO'),
(3, 1, 1, '2026-08-27 19:08:49', 0.001, 0.10, 'REC-F80B5B28E6', 'REGISTRADO'),
(4, 1, 1, '2026-08-27 20:57:03', 1.000, 100.00, 'REC-6F5B46DCD2', 'REGISTRADO'),
(5, 1, 1, '2026-08-28 09:30:04', 1.000, 100.00, 'REC-F81654AFC8', 'REGISTRADO'),
(6, 1, 1, '2026-08-28 09:30:23', 10.000, 1000.00, 'REC-F750B2570B', 'REGISTRADO'),
(7, 1, 1, '2026-08-28 09:37:49', 5.000, 500.00, 'REC-E696EF3C3A', 'REGISTRADO'),
(8, 1, 1, '2026-08-28 09:39:50', 8.000, 960.00, 'REC-28001ACAAD', 'REGISTRADO'),
(9, 1, 1, '2026-08-31 12:27:59', 1.000, 100.00, 'REC-1B300A6642', 'REGISTRADO'),
(10, 1, 1, '2026-08-31 12:28:24', 10.000, 1200.00, 'REC-B22D1B9F89', 'REGISTRADO'),
(11, 1, 1, '2026-08-31 14:04:59', 20.000, 2400.00, 'REC-82AB8FC8F5', 'REGISTRADO'),
(12, 1, 1, '2026-08-31 18:00:24', 10.000, 1200.00, 'REC-8E627CE5AF', 'REGISTRADO'),
(13, 1, 1, '2026-08-31 19:01:15', 10.500, 1050.00, 'REC-90B21F2C74', 'REGISTRADO'),
(14, 4, 1, '2026-08-31 19:20:23', 1.000, 100.00, 'REC-BD92CE16D8', 'REGISTRADO'),
(15, 4, 1, '2026-08-31 19:20:48', 10.000, 1000.00, 'REC-8F48E5ED56', 'REGISTRADO'),
(16, 5, 1, '2026-09-02 11:31:23', 10.000, 1000.00, 'REC-6602FCA79F', 'REGISTRADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recompensas`
--

CREATE TABLE `recompensas` (
  `id_recompensa` int(11) NOT NULL,
  `id_categoria_recompensa` int(11) NOT NULL,
  `id_empresa` int(11) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `puntos_requeridos` decimal(12,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `imagen` varchar(255) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_fin` datetime DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA','AGOTADA','VENCIDA') NOT NULL DEFAULT 'ACTIVA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `recompensas`
--

INSERT INTO `recompensas` (`id_recompensa`, `id_categoria_recompensa`, `id_empresa`, `nombre`, `descripcion`, `puntos_requeridos`, `stock`, `imagen`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
(1, 1, 1, '10 copias gratis', 'Canje por 10 copias en la Papelería San Mateo', 500.00, 48, NULL, '2026-08-27 03:32:50', NULL, 'ACTIVA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recompensa_beneficio`
--

CREATE TABLE `recompensa_beneficio` (
  `id_recompensa` int(11) NOT NULL,
  `id_beneficio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `recompensa_beneficio`
--

INSERT INTO `recompensa_beneficio` (`id_recompensa`, `id_beneficio`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'USUARIO', 'Usuario que participa en el reciclaje y obtiene recompensas', 1),
(2, 'ADMINISTRADOR', 'Administrador general del sistema', 1),
(3, 'OPERADOR', 'Personal encargado de operar o supervisar máquinas', 1),
(4, 'ALIADO', 'Personal de una empresa o establecimiento aliado que valida recompensas', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
  `id_rol` int(11) NOT NULL,
  `id_permiso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `saldos_puntos`
--

CREATE TABLE `saldos_puntos` (
  `id_saldo` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `puntos_disponibles` decimal(12,2) NOT NULL DEFAULT 0.00,
  `puntos_acumulados` decimal(12,2) NOT NULL DEFAULT 0.00,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `saldos_puntos`
--

INSERT INTO `saldos_puntos` (`id_saldo`, `id_usuario`, `puntos_disponibles`, `puntos_acumulados`, `fecha_actualizacion`) VALUES
(1, 1, 4260.10, 8760.10, '2026-08-31 19:16:13'),
(2, 2, 0.00, 0.00, '2026-08-27 13:55:37'),
(3, 3, 0.00, 0.00, '2026-08-31 14:47:43'),
(4, 4, 600.00, 1100.00, '2026-08-31 19:20:56'),
(5, 5, 1000.00, 1000.00, '2026-09-02 11:31:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tickets_recompensa`
--

CREATE TABLE `tickets_recompensa` (
  `id_ticket` int(11) NOT NULL,
  `id_canje` int(11) NOT NULL,
  `codigo_ticket` varchar(100) NOT NULL,
  `fecha_generacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_vencimiento` datetime DEFAULT NULL,
  `estado` enum('ACTIVO','UTILIZADO','VENCIDO','CANCELADO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_documento`
--

CREATE TABLE `tipos_documento` (
  `id_tipo_documento` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `abreviatura` varchar(10) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_documento`
--

INSERT INTO `tipos_documento` (`id_tipo_documento`, `nombre`, `abreviatura`, `estado`) VALUES
(1, 'Cédula de ciudadanía', 'CC', 1),
(2, 'Tarjeta de identidad', 'TI', 1),
(3, 'Cédula de extranjería', 'CE', 1),
(4, 'Pasaporte', 'PAS', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_insignia`
--

CREATE TABLE `tipos_insignia` (
  `id_tipo_insignia` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `icono` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_insignia`
--

INSERT INTO `tipos_insignia` (`id_tipo_insignia`, `nombre`, `descripcion`, `icono`, `estado`) VALUES
(1, 'Reciclador', 'Insignias obtenidas por cantidad de reciclajes realizados', NULL, 1),
(2, 'Puntos', 'Insignias obtenidas por acumulación de puntos', NULL, 1),
(3, 'Peso', 'Insignias obtenidas por cantidad de material reciclado', NULL, 1),
(4, 'Especial', 'Insignias otorgadas por logros especiales', NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_material`
--

CREATE TABLE `tipos_material` (
  `id_tipo_material` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `unidad_medida` varchar(20) NOT NULL DEFAULT 'KG',
  `puntos_por_unidad` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_material`
--

INSERT INTO `tipos_material` (`id_tipo_material`, `nombre`, `descripcion`, `unidad_medida`, `puntos_por_unidad`, `estado`) VALUES
(1, 'Botellas PET', 'Botellas plásticas de tereftalato de polietileno', 'KG', 100.00, 1),
(2, 'Plástico', 'Otros materiales plásticos reciclables', 'KG', 80.00, 1),
(3, 'Latas', 'Latas de aluminio y otros metales reciclables', 'KG', 120.00, 1),
(4, 'Cartón', 'Cartón limpio y seco', 'KG', 50.00, 1),
(5, 'Papel', 'Papel reciclable limpio y seco', 'KG', 50.00, 1),
(6, 'Vidrio', 'Envases y elementos de vidrio reciclable', 'KG', 70.00, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_movimiento_puntos`
--

CREATE TABLE `tipos_movimiento_puntos` (
  `id_tipo_movimiento` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `naturaleza` enum('INGRESO','EGRESO') NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_movimiento_puntos`
--

INSERT INTO `tipos_movimiento_puntos` (`id_tipo_movimiento`, `nombre`, `descripcion`, `naturaleza`, `estado`) VALUES
(1, 'RECICLAJE', 'Puntos obtenidos mediante una actividad de reciclaje', 'INGRESO', 1),
(2, 'BONIFICACION', 'Puntos otorgados como bonificación', 'INGRESO', 1),
(3, 'RECOMPENSA', 'Puntos utilizados para adquirir una recompensa', 'EGRESO', 1),
(4, 'AJUSTE_POSITIVO', 'Corrección administrativa positiva de puntos', 'INGRESO', 1),
(5, 'AJUSTE_NEGATIVO', 'Corrección administrativa negativa de puntos', 'EGRESO', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicaciones`
--

CREATE TABLE `ubicaciones` (
  `id_ubicacion` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ubicaciones`
--

INSERT INTO `ubicaciones` (`id_ubicacion`, `nombre`, `descripcion`, `direccion`, `ciudad`, `latitud`, `longitud`, `estado`) VALUES
(1, 'Fundación Universitaria San Mateo', 'Ubicación piloto de la máquina EcoRecicla', 'Bogotá D.C.', 'Bogotá', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `id_tipo_documento` int(11) NOT NULL,
  `numero_documento` varchar(30) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `ultimo_acceso` datetime DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_rol`, `id_tipo_documento`, `numero_documento`, `nombres`, `apellidos`, `correo`, `telefono`, `password_hash`, `fecha_registro`, `ultimo_acceso`, `estado`) VALUES
(1, 1, 1, '1022935928', 'JEISSON', 'NIÑO', 'acevedojeisson217@gmail.com', '3180378583', 'scrypt:32768:8:1$K66WD9Za016g2e2d$61e6e3d19480fa6b34673345c189f7d0e0bdee4c1e65b77b14133844779a129dd7350b406e783cb5c4956c5caacfb2a8147960a9927eff5d99fac6c6e2069e42', '2026-08-27 08:18:41', '2026-08-31 19:14:45', 1),
(2, 1, 1, '123456789', 'DILAN', 'GOMEZ', 'gomez@gmail.com', '601 743-7919', 'scrypt:32768:8:1$7Q7d7Bff1htSsLMM$f9365b82ae6165723c4535649b1e8d0ebc7b68a23808d977d61ae0ed71a28a5c1d3c327a39d1f2b8bd03c61f6eaa77c21600e94c5332a7a8aea955ec77bc1704', '2026-08-27 13:55:37', '2026-08-27 13:55:49', 1),
(3, 1, 1, '1022936928', 'DILAN', 'SANCHES', 'dilangomez@gmail.com', '3132728762', 'scrypt:32768:8:1$XQbR4ufodvlYWpZS$b60aa1873b6ac1033384b2def52f8ba3261bc6c9c1e14ad2ed31bc2bea49f546cc759da0fbd657c9b53975ee91f8b1733106c869b8ed2ac3e8c9dbbf2ba5a037', '2026-08-31 14:47:43', '2026-08-31 18:50:23', 1),
(4, 1, 1, '1022935936', 'Angelica', 'Romero', 'angelicaromero07@gmail.com', '3125899634', 'scrypt:32768:8:1$NvqQAvGRfoWgAJL4$8089430995444d8fe14b7f08635765ba72125474c7ca7bed740b80cc4751f3f5c354ae6d144a6c85230ce74d22802b33f888be751d1f5daa7e1c36f94c09ed44', '2026-08-31 19:18:49', '2026-08-31 19:19:11', 1),
(5, 1, 1, '97447034', 'frank', 'acosta', 'scrcomputadores@gmail.com', '3058163648', 'scrypt:32768:8:1$iQ04W7JnrYQR0CS7$b99274ee22dad348aacbf876803df00b7f7e8e9ecac18dc4699ce687706299d32c4a973f9e160d4bb2167c2228fa8ad1e865135be3c8be71cbdae38eea57eee3', '2026-09-02 11:18:40', '2026-09-02 11:19:04', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_insignia`
--

CREATE TABLE `usuario_insignia` (
  `id_usuario` int(11) NOT NULL,
  `id_insignia` int(11) NOT NULL,
  `fecha_obtencion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `validaciones_ticket`
--

CREATE TABLE `validaciones_ticket` (
  `id_validacion` int(11) NOT NULL,
  `id_ticket` int(11) NOT NULL,
  `id_usuario_validador` int(11) NOT NULL,
  `fecha_validacion` datetime NOT NULL DEFAULT current_timestamp(),
  `resultado` enum('VALIDO','INVALIDO','YA_UTILIZADO','VENCIDO','CANCELADO') NOT NULL,
  `observacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `beneficios_empresa`
--
ALTER TABLE `beneficios_empresa`
  ADD PRIMARY KEY (`id_beneficio`),
  ADD KEY `fk_beneficios_empresa` (`id_empresa`);

--
-- Indices de la tabla `canjes`
--
ALTER TABLE `canjes`
  ADD PRIMARY KEY (`id_canje`),
  ADD UNIQUE KEY `uk_canjes_codigo_ticket` (`codigo_ticket`),
  ADD KEY `fk_canjes_usuario` (`id_usuario`),
  ADD KEY `fk_canjes_recompensa` (`id_recompensa`);

--
-- Indices de la tabla `categorias_recompensa`
--
ALTER TABLE `categorias_recompensa`
  ADD PRIMARY KEY (`id_categoria_recompensa`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `detalle_reciclaje`
--
ALTER TABLE `detalle_reciclaje`
  ADD PRIMARY KEY (`id_detalle_reciclaje`),
  ADD KEY `fk_detalle_reciclaje_reciclaje` (`id_reciclaje`),
  ADD KEY `fk_detalle_reciclaje_material` (`id_tipo_material`);

--
-- Indices de la tabla `empresas_aliadas`
--
ALTER TABLE `empresas_aliadas`
  ADD PRIMARY KEY (`id_empresa`),
  ADD UNIQUE KEY `nit` (`nit`);

--
-- Indices de la tabla `entregas_recompensa`
--
ALTER TABLE `entregas_recompensa`
  ADD PRIMARY KEY (`id_entrega`),
  ADD UNIQUE KEY `id_ticket` (`id_ticket`),
  ADD KEY `fk_entregas_usuario` (`id_usuario_entrega`);

--
-- Indices de la tabla `historial_ticket`
--
ALTER TABLE `historial_ticket`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `fk_historial_ticket` (`id_ticket`),
  ADD KEY `fk_historial_usuario` (`id_usuario`);

--
-- Indices de la tabla `insignias`
--
ALTER TABLE `insignias`
  ADD PRIMARY KEY (`id_insignia`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `fk_insignias_tipo` (`id_tipo_insignia`);

--
-- Indices de la tabla `maquinas`
--
ALTER TABLE `maquinas`
  ADD PRIMARY KEY (`id_maquina`),
  ADD UNIQUE KEY `codigo_maquina` (`codigo_maquina`),
  ADD KEY `fk_maquinas_ubicaciones` (`id_ubicacion`);

--
-- Indices de la tabla `maquina_material`
--
ALTER TABLE `maquina_material`
  ADD PRIMARY KEY (`id_maquina`,`id_tipo_material`),
  ADD KEY `fk_maquina_material_material` (`id_tipo_material`);

--
-- Indices de la tabla `movimientos_puntos`
--
ALTER TABLE `movimientos_puntos`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `fk_movimientos_usuario` (`id_usuario`),
  ADD KEY `fk_movimientos_tipo` (`id_tipo_movimiento`),
  ADD KEY `fk_movimientos_reciclaje` (`id_reciclaje`),
  ADD KEY `fk_movimientos_canje` (`id_canje`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id_permiso`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `reciclajes`
--
ALTER TABLE `reciclajes`
  ADD PRIMARY KEY (`id_reciclaje`),
  ADD UNIQUE KEY `codigo_reciclaje` (`codigo_reciclaje`),
  ADD KEY `fk_reciclajes_usuario` (`id_usuario`),
  ADD KEY `fk_reciclajes_maquina` (`id_maquina`);

--
-- Indices de la tabla `recompensas`
--
ALTER TABLE `recompensas`
  ADD PRIMARY KEY (`id_recompensa`),
  ADD KEY `fk_recompensas_categoria` (`id_categoria_recompensa`),
  ADD KEY `fk_recompensas_empresa` (`id_empresa`);

--
-- Indices de la tabla `recompensa_beneficio`
--
ALTER TABLE `recompensa_beneficio`
  ADD PRIMARY KEY (`id_recompensa`,`id_beneficio`),
  ADD KEY `fk_recompensa_beneficio_beneficio` (`id_beneficio`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD PRIMARY KEY (`id_rol`,`id_permiso`),
  ADD KEY `fk_rol_permiso_permiso` (`id_permiso`);

--
-- Indices de la tabla `saldos_puntos`
--
ALTER TABLE `saldos_puntos`
  ADD PRIMARY KEY (`id_saldo`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `tickets_recompensa`
--
ALTER TABLE `tickets_recompensa`
  ADD PRIMARY KEY (`id_ticket`),
  ADD UNIQUE KEY `id_canje` (`id_canje`),
  ADD UNIQUE KEY `codigo_ticket` (`codigo_ticket`);

--
-- Indices de la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  ADD PRIMARY KEY (`id_tipo_documento`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD UNIQUE KEY `abreviatura` (`abreviatura`);

--
-- Indices de la tabla `tipos_insignia`
--
ALTER TABLE `tipos_insignia`
  ADD PRIMARY KEY (`id_tipo_insignia`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `tipos_material`
--
ALTER TABLE `tipos_material`
  ADD PRIMARY KEY (`id_tipo_material`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `tipos_movimiento_puntos`
--
ALTER TABLE `tipos_movimiento_puntos`
  ADD PRIMARY KEY (`id_tipo_movimiento`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD PRIMARY KEY (`id_ubicacion`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `numero_documento` (`numero_documento`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `fk_usuarios_roles` (`id_rol`),
  ADD KEY `fk_usuarios_tipo_documento` (`id_tipo_documento`);

--
-- Indices de la tabla `usuario_insignia`
--
ALTER TABLE `usuario_insignia`
  ADD PRIMARY KEY (`id_usuario`,`id_insignia`),
  ADD KEY `fk_usuario_insignia_insignia` (`id_insignia`);

--
-- Indices de la tabla `validaciones_ticket`
--
ALTER TABLE `validaciones_ticket`
  ADD PRIMARY KEY (`id_validacion`),
  ADD KEY `fk_validaciones_ticket` (`id_ticket`),
  ADD KEY `fk_validaciones_usuario` (`id_usuario_validador`);

--
--  de las tablas volcadas
--

--
--  de la tabla `beneficios_empresa`
--
ALTER TABLE `beneficios_empresa`
  MODIFY `id_beneficio` int(11) NOT NULL , =2;

--
--  de la tabla `canjes`
--
ALTER TABLE `canjes`
  MODIFY `id_canje` int(11) NOT NULL , =11;

--
--  de la tabla `categorias_recompensa`
--
ALTER TABLE `categorias_recompensa`
  MODIFY `id_categoria_recompensa` int(11) NOT NULL , =7;

--
--  de la tabla `detalle_reciclaje`
--
ALTER TABLE `detalle_reciclaje`
  MODIFY `id_detalle_reciclaje` int(11) NOT NULL , =17;

--
--  de la tabla `empresas_aliadas`
--
ALTER TABLE `empresas_aliadas`
  MODIFY `id_empresa` int(11) NOT NULL , =2;

--
--  de la tabla `entregas_recompensa`
--
ALTER TABLE `entregas_recompensa`
  MODIFY `id_entrega` int(11) NOT NULL ;

--
--  de la tabla `historial_ticket`
--
ALTER TABLE `historial_ticket`
  MODIFY `id_historial` int(11) NOT NULL ;

--
--  de la tabla `insignias`
--
ALTER TABLE `insignias`
  MODIFY `id_insignia` int(11) NOT NULL , =10;

--
--  de la tabla `maquinas`
--
ALTER TABLE `maquinas`
  MODIFY `id_maquina` int(11) NOT NULL , =2;

--
--  de la tabla `movimientos_puntos`
--
ALTER TABLE `movimientos_puntos`
  MODIFY `id_movimiento` int(11) NOT NULL , =27;

--
--  de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id_permiso` int(11) NOT NULL ;

--
--  de la tabla `reciclajes`
--
ALTER TABLE `reciclajes`
  MODIFY `id_reciclaje` int(11) NOT NULL , =17;

--
--  de la tabla `recompensas`
--
ALTER TABLE `recompensas`
  MODIFY `id_recompensa` int(11) NOT NULL , =2;

--
--  de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL , =6;

--
--  de la tabla `saldos_puntos`
--
ALTER TABLE `saldos_puntos`
  MODIFY `id_saldo` int(11) NOT NULL , =6;

--
--  de la tabla `tickets_recompensa`
--
ALTER TABLE `tickets_recompensa`
  MODIFY `id_ticket` int(11) NOT NULL ;

--
--  de la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  MODIFY `id_tipo_documento` int(11) NOT NULL , =5;

--
--  de la tabla `tipos_insignia`
--
ALTER TABLE `tipos_insignia`
  MODIFY `id_tipo_insignia` int(11) NOT NULL , =5;

--
--  de la tabla `tipos_material`
--
ALTER TABLE `tipos_material`
  MODIFY `id_tipo_material` int(11) NOT NULL , =7;

--
--  de la tabla `tipos_movimiento_puntos`
--
ALTER TABLE `tipos_movimiento_puntos`
  MODIFY `id_tipo_movimiento` int(11) NOT NULL , =6;

--
--  de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `id_ubicacion` int(11) NOT NULL , =2;

--
--  de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL , =6;

--
--  de la tabla `validaciones_ticket`
--
ALTER TABLE `validaciones_ticket`
  MODIFY `id_validacion` int(11) NOT NULL ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `beneficios_empresa`
--
ALTER TABLE `beneficios_empresa`
  ADD CONSTRAINT `fk_beneficios_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresas_aliadas` (`id_empresa`) ON DELETE CASCADE;

--
-- Filtros para la tabla `canjes`
--
ALTER TABLE `canjes`
  ADD CONSTRAINT `fk_canjes_recompensa` FOREIGN KEY (`id_recompensa`) REFERENCES `recompensas` (`id_recompensa`),
  ADD CONSTRAINT `fk_canjes_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `detalle_reciclaje`
--
ALTER TABLE `detalle_reciclaje`
  ADD CONSTRAINT `fk_detalle_reciclaje_material` FOREIGN KEY (`id_tipo_material`) REFERENCES `tipos_material` (`id_tipo_material`),
  ADD CONSTRAINT `fk_detalle_reciclaje_reciclaje` FOREIGN KEY (`id_reciclaje`) REFERENCES `reciclajes` (`id_reciclaje`) ON DELETE CASCADE;

--
-- Filtros para la tabla `entregas_recompensa`
--
ALTER TABLE `entregas_recompensa`
  ADD CONSTRAINT `fk_entregas_ticket` FOREIGN KEY (`id_ticket`) REFERENCES `tickets_recompensa` (`id_ticket`),
  ADD CONSTRAINT `fk_entregas_usuario` FOREIGN KEY (`id_usuario_entrega`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `historial_ticket`
--
ALTER TABLE `historial_ticket`
  ADD CONSTRAINT `fk_historial_ticket` FOREIGN KEY (`id_ticket`) REFERENCES `tickets_recompensa` (`id_ticket`),
  ADD CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `insignias`
--
ALTER TABLE `insignias`
  ADD CONSTRAINT `fk_insignias_tipo` FOREIGN KEY (`id_tipo_insignia`) REFERENCES `tipos_insignia` (`id_tipo_insignia`);

--
-- Filtros para la tabla `maquinas`
--
ALTER TABLE `maquinas`
  ADD CONSTRAINT `fk_maquinas_ubicaciones` FOREIGN KEY (`id_ubicacion`) REFERENCES `ubicaciones` (`id_ubicacion`);

--
-- Filtros para la tabla `maquina_material`
--
ALTER TABLE `maquina_material`
  ADD CONSTRAINT `fk_maquina_material_maquina` FOREIGN KEY (`id_maquina`) REFERENCES `maquinas` (`id_maquina`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_maquina_material_material` FOREIGN KEY (`id_tipo_material`) REFERENCES `tipos_material` (`id_tipo_material`) ON DELETE CASCADE;

--
-- Filtros para la tabla `movimientos_puntos`
--
ALTER TABLE `movimientos_puntos`
  ADD CONSTRAINT `fk_movimientos_canje` FOREIGN KEY (`id_canje`) REFERENCES `canjes` (`id_canje`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_movimientos_reciclaje` FOREIGN KEY (`id_reciclaje`) REFERENCES `reciclajes` (`id_reciclaje`),
  ADD CONSTRAINT `fk_movimientos_tipo` FOREIGN KEY (`id_tipo_movimiento`) REFERENCES `tipos_movimiento_puntos` (`id_tipo_movimiento`),
  ADD CONSTRAINT `fk_movimientos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `reciclajes`
--
ALTER TABLE `reciclajes`
  ADD CONSTRAINT `fk_reciclajes_maquina` FOREIGN KEY (`id_maquina`) REFERENCES `maquinas` (`id_maquina`),
  ADD CONSTRAINT `fk_reciclajes_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `recompensas`
--
ALTER TABLE `recompensas`
  ADD CONSTRAINT `fk_recompensas_categoria` FOREIGN KEY (`id_categoria_recompensa`) REFERENCES `categorias_recompensa` (`id_categoria_recompensa`),
  ADD CONSTRAINT `fk_recompensas_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresas_aliadas` (`id_empresa`);

--
-- Filtros para la tabla `recompensa_beneficio`
--
ALTER TABLE `recompensa_beneficio`
  ADD CONSTRAINT `fk_recompensa_beneficio_beneficio` FOREIGN KEY (`id_beneficio`) REFERENCES `beneficios_empresa` (`id_beneficio`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_recompensa_beneficio_recompensa` FOREIGN KEY (`id_recompensa`) REFERENCES `recompensas` (`id_recompensa`) ON DELETE CASCADE;

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD CONSTRAINT `fk_rol_permiso_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rol_permiso_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE CASCADE;

--
-- Filtros para la tabla `saldos_puntos`
--
ALTER TABLE `saldos_puntos`
  ADD CONSTRAINT `fk_saldos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `tickets_recompensa`
--
ALTER TABLE `tickets_recompensa`
  ADD CONSTRAINT `fk_tickets_canje` FOREIGN KEY (`id_canje`) REFERENCES `canjes` (`id_canje`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_roles` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`),
  ADD CONSTRAINT `fk_usuarios_tipo_documento` FOREIGN KEY (`id_tipo_documento`) REFERENCES `tipos_documento` (`id_tipo_documento`);

--
-- Filtros para la tabla `usuario_insignia`
--
ALTER TABLE `usuario_insignia`
  ADD CONSTRAINT `fk_usuario_insignia_insignia` FOREIGN KEY (`id_insignia`) REFERENCES `insignias` (`id_insignia`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_usuario_insignia_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `validaciones_ticket`
--
ALTER TABLE `validaciones_ticket`
  ADD CONSTRAINT `fk_validaciones_ticket` FOREIGN KEY (`id_ticket`) REFERENCES `tickets_recompensa` (`id_ticket`),
  ADD CONSTRAINT `fk_validaciones_usuario` FOREIGN KEY (`id_usuario_validador`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

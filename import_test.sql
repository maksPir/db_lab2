-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Май 20 2024 г., 18:10
-- Версия сервера: 10.3.16-MariaDB
-- Версия PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `telescope`
--

CREATE DATABASE telescope
DELIMITER $$
--
-- Процедуры
--

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_Join2Tables` (IN `table_name1` VARCHAR(40), IN `table_name2` VARCHAR(40))  BEGIN
SET @table_name1 = table_name1;
SET @table_name2 = table_name2;
SET @sql_text = concat('SELECT * FROM ', @table_name1, ' cross join ', @table_name2);
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_pos` ()  NO SQL
BEGIN
 SELECT * FROM position;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `natural_objects`
--

CREATE TABLE `natural_objects` (
  `id_natural_object` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `galaxy` varchar(25) NOT NULL,
  `accuracy` varchar(10) NOT NULL,
  `luminous_flux` int(11) NOT NULL,
  `related_objects` varchar(100) NOT NULL,
  `note` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура таблицы `objects`
--

CREATE TABLE `objects` (
  `id_object` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `accuracy_determination` varchar(10) NOT NULL,
  `quantity` int(11) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `note` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура таблицы `position`
--

CREATE TABLE `position` (
  `id_position` int(11) NOT NULL,
  `earth_position` varchar(30) NOT NULL,
  `sun_position` varchar(30) NOT NULL,
  `moon_position` varchar(30) NOT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Дамп данных таблицы `position`
--

INSERT INTO `position` (`id_position`, `earth_position`, `sun_position`, `moon_position`, `date_update`) VALUES
(1, '33.33', '33.32', '32.33', NULL);

--
-- Триггеры `position`
--
DELIMITER $$
CREATE TRIGGER `on_update_add_column` BEFORE UPDATE ON `position` FOR EACH ROW SET NEW.date_update = NOW()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `relations`
--

CREATE TABLE `relations` (
  `id_relation` int(11) NOT NULL,
  `id_natural_object` int(11) NOT NULL,
  `id_object` int(11) NOT NULL,
  `id_position` int(11) NOT NULL,
  `id_sector` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура таблицы `sector`
--

CREATE TABLE `sector` (
  `id_sector` int(11) NOT NULL,
  `coordinates` varchar(20) NOT NULL,
  `luminous_intensity` int(11) NOT NULL,
  `foreign_objects` varchar(50) NOT NULL,
  `ojects_count` int(11) NOT NULL,
  `number_undefined_objects` int(11) NOT NULL,
  `number_specified_objects` int(11) NOT NULL,
  `notes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Дамп данных таблицы `sector`
--

INSERT INTO `sector` (`id_sector`, `coordinates`, `luminous_intensity`, `foreign_objects`, `ojects_count`, `number_undefined_objects`, `number_specified_objects`, `notes`) VALUES
(1, '1233212', 321, 'Earth', 4, 3, 1, 0);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `natural_objects`
--
ALTER TABLE `natural_objects`
  ADD PRIMARY KEY (`id_natural_object`);

--
-- Индексы таблицы `objects`
--
ALTER TABLE `objects`
  ADD PRIMARY KEY (`id_object`);

--
-- Индексы таблицы `position`
--
ALTER TABLE `position`
  ADD PRIMARY KEY (`id_position`);

--
-- Индексы таблицы `relations`
--
ALTER TABLE `relations`
  ADD PRIMARY KEY (`id_relation`),
  ADD KEY `id_natural_object` (`id_natural_object`),
  ADD KEY `id_object` (`id_object`,`id_position`,`id_sector`),
  ADD KEY `id_sector` (`id_sector`),
  ADD KEY `id_position` (`id_position`);

--
-- Индексы таблицы `sector`
--
ALTER TABLE `sector`
  ADD PRIMARY KEY (`id_sector`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `natural_objects`
--
ALTER TABLE `natural_objects`
  MODIFY `id_natural_object` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `objects`
--
ALTER TABLE `objects`
  MODIFY `id_object` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `position`
--
ALTER TABLE `position`
  MODIFY `id_position` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `relations`
--
ALTER TABLE `relations`
  MODIFY `id_relation` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `sector`
--
ALTER TABLE `sector`
  MODIFY `id_sector` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `relations`
--
ALTER TABLE `relations`
  ADD CONSTRAINT `relations_ibfk_1` FOREIGN KEY (`id_object`) REFERENCES `objects` (`id_object`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `relations_ibfk_2` FOREIGN KEY (`id_sector`) REFERENCES `sector` (`id_sector`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `relations_ibfk_3` FOREIGN KEY (`id_natural_object`) REFERENCES `natural_objects` (`id_natural_object`),
  ADD CONSTRAINT `relations_ibfk_4` FOREIGN KEY (`id_position`) REFERENCES `position` (`id_position`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

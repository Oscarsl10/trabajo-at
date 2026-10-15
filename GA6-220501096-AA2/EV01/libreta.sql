-- GA6-220501096-AA2-EV01 · Taller tabla "libreta"
CREATE DATABASE IF NOT EXISTS taller_sql CHARACTER SET utf8mb4;
USE taller_sql;
DROP TABLE IF EXISTS libreta;

-- 1. Crear la tabla
CREATE TABLE libreta (
  nombre    VARCHAR(20),
  domicilio VARCHAR(30),
  telefono  VARCHAR(11)
);

-- 2. Mostrar tablas
SHOW TABLES;

-- 3. Estructura de la tabla
DESCRIBE libreta;

-- 4. Insertar los dos primeros registros
INSERT INTO libreta (nombre, domicilio, telefono) VALUES ('Alberto Mores', 'Colon 123', '4234567');
INSERT INTO libreta (nombre, domicilio, telefono) VALUES ('Juan Torres', 'Avellaneda 135', '4458787');

-- 5. Mostrar todos los registros
SELECT * FROM libreta;

-- 6. Actualizar los datos recién insertados
UPDATE libreta SET telefono = '4234000' WHERE nombre = 'Alberto Mores';
UPDATE libreta SET domicilio = 'Avellaneda 200', telefono = '4458000' WHERE nombre = 'Juan Torres';
SELECT * FROM libreta;

-- 7. Insertar 5 registros más
INSERT INTO libreta (nombre, domicilio, telefono) VALUES
  ('Maria Lopez',   'Sarmiento 450',  '4321122'),
  ('Carlos Gomez',  'Belgrano 78',    '4335566'),
  ('Ana Fernandez', 'Rivadavia 910',  '4347788'),
  ('Luis Perez',    'San Martin 25',  '4359900'),
  ('Laura Diaz',    'Mitre 666',      '4361234');

-- 8. Contar registros
SELECT COUNT(*) AS total_registros FROM libreta;

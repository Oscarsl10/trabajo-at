-- ============================================================
-- GA6-220501096-AA2-EV03 · Script de base de datos del proyecto
-- Proyecto: Sistema de gestión de inventario y ventas (TiendaFácil)
-- Motor: MySQL 8.x
-- ============================================================
DROP DATABASE IF EXISTS tienda_db;
CREATE DATABASE tienda_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tienda_db;

CREATE TABLE roles (
  id_rol      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(30)  NOT NULL,
  descripcion VARCHAR(100) NULL,
  PRIMARY KEY (id_rol),
  UNIQUE KEY uq_roles_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE usuarios (
  id_usuario     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_rol         INT UNSIGNED NOT NULL,
  nombre         VARCHAR(60)  NOT NULL,
  correo         VARCHAR(100) NOT NULL,
  clave_hash     CHAR(60)     NOT NULL,
  activo         TINYINT(1)   NOT NULL DEFAULT 1,
  fecha_registro DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuarios_correo (correo),
  CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES roles (id_rol)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE categorias (
  id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(50)  NOT NULL,
  descripcion  VARCHAR(150) NULL,
  PRIMARY KEY (id_categoria),
  UNIQUE KEY uq_categorias_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE proveedores (
  id_proveedor INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(80)  NOT NULL,
  nit          VARCHAR(15)  NOT NULL,
  telefono     VARCHAR(15)  NULL,
  correo       VARCHAR(100) NULL,
  PRIMARY KEY (id_proveedor),
  UNIQUE KEY uq_proveedores_nit (nit)
) ENGINE=InnoDB;

CREATE TABLE productos (
  id_producto  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_categoria INT UNSIGNED NOT NULL,
  id_proveedor INT UNSIGNED NOT NULL,
  codigo       VARCHAR(20)  NOT NULL,
  nombre       VARCHAR(80)  NOT NULL,
  precio       DECIMAL(10,2) NOT NULL,
  stock        INT UNSIGNED NOT NULL DEFAULT 0,
  stock_minimo INT UNSIGNED NOT NULL DEFAULT 5,
  PRIMARY KEY (id_producto),
  UNIQUE KEY uq_productos_codigo (codigo),
  CONSTRAINT ck_productos_precio CHECK (precio > 0),
  CONSTRAINT fk_productos_categorias  FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_productos_proveedores FOREIGN KEY (id_proveedor) REFERENCES proveedores (id_proveedor)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE clientes (
  id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
  documento  VARCHAR(15)  NOT NULL,
  nombre     VARCHAR(80)  NOT NULL,
  telefono   VARCHAR(15)  NULL,
  correo     VARCHAR(100) NULL,
  PRIMARY KEY (id_cliente),
  UNIQUE KEY uq_clientes_documento (documento)
) ENGINE=InnoDB;

CREATE TABLE ventas (
  id_venta   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_cliente INT UNSIGNED NOT NULL,
  id_usuario INT UNSIGNED NOT NULL,
  fecha      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total      DECIMAL(12,2) NOT NULL DEFAULT 0,
  estado     ENUM('PENDIENTE','PAGADA','ANULADA') NOT NULL DEFAULT 'PENDIENTE',
  PRIMARY KEY (id_venta),
  CONSTRAINT ck_ventas_total CHECK (total >= 0),
  CONSTRAINT fk_ventas_clientes FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_ventas_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE detalle_venta (
  id_venta        INT UNSIGNED  NOT NULL,
  id_producto     INT UNSIGNED  NOT NULL,
  cantidad        INT UNSIGNED  NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_venta, id_producto),
  CONSTRAINT ck_detalle_cantidad CHECK (cantidad > 0),
  CONSTRAINT fk_detalle_ventas    FOREIGN KEY (id_venta)    REFERENCES ventas (id_venta)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_detalle_productos FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Datos de ejemplo
INSERT INTO roles (nombre, descripcion) VALUES ('Administrador','Acceso total'),('Vendedor','Registra ventas');
INSERT INTO usuarios (id_rol, nombre, correo, clave_hash) VALUES
  (1,'Administrador','admin@tiendafacil.com', REPEAT('a',60)),
  (2,'Vendedor Uno','vendedor@tiendafacil.com', REPEAT('b',60));
INSERT INTO categorias (nombre) VALUES ('Bebidas'),('Aseo'),('Snacks');
INSERT INTO proveedores (nombre, nit, telefono) VALUES ('Distribuidora Andina','900123456-1','3101234567');
INSERT INTO productos (id_categoria,id_proveedor,codigo,nombre,precio,stock) VALUES
  (1,1,'BEB-001','Agua 600 ml',1500,100),(2,1,'ASE-001','Jabón en barra',2800,50),(3,1,'SNK-001','Papas fritas',3200,40);
INSERT INTO clientes (documento,nombre,telefono) VALUES ('1075123456','Cliente de Mostrador','3009876543');
INSERT INTO ventas (id_cliente,id_usuario,total,estado) VALUES (1,2,6200,'PAGADA');
INSERT INTO detalle_venta VALUES (1,1,2,1500),(1,3,1,3200);

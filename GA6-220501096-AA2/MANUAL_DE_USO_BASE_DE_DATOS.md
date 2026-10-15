# Manual de uso – Base de datos (GA6-220501096-AA2)

Contenido de la carpeta `GA6-220501096-AA2`:

| Carpeta | Contenido |
|---|---|
| `EV01` | `libreta.sql` (taller) e `informe_EV01.pdf` (informe técnico) |
| `EV02` | `documento_EV02.pdf/.doc` (estructura de la BD) y `diagrama_entidad_relacion.svg` |
| `EV03` | `tienda_db.sql` (script del modelo físico del proyecto TiendaFácil) |

## 1. Requisitos
- MySQL Server 8.0 o superior (también sirve MySQL en Docker).
- Cliente: MySQL Workbench o la consola `mysql`.

## 2. Ejecutar el taller de la libreta (EV01)
Desde la consola:
```bash
mysql -u root -p < GA6-220501096-AA2/EV01/libreta.sql
```
En Workbench: *File → Open SQL Script…* → seleccionar `libreta.sql` → botón del rayo (Execute). Crea la base `taller_sql` y la tabla `libreta`, e inserta/actualiza los registros. Al final `SELECT COUNT(*)` devuelve 7.

## 3. Crear la base de datos del proyecto (EV03)
```bash
mysql -u root -p < GA6-220501096-AA2/EV03/tienda_db.sql
```
> Atención: el script ejecuta `DROP DATABASE IF EXISTS tienda_db`; si ya existe una base con ese nombre, se reemplaza.

Verificación:
```sql
USE tienda_db;
SHOW TABLES;   -- 8 tablas
SELECT p.nombre, c.nombre AS categoria, p.precio, p.stock
FROM productos p JOIN categorias c ON c.id_categoria = p.id_categoria;
```

## 4. Ver el diagrama entidad-relación en MySQL Workbench
1. Abrir *File → New Model*.
2. *File → Import → Reverse Engineer MySQL Create Script…* y elegir `tienda_db.sql`.
3. Marcar *Place imported objects on a diagram* → Execute. Se genera el diagrama EER.
4. Guardar con *File → Save Model* (`.mwb`).
El archivo `EV02/diagrama_entidad_relacion.svg` se abre en cualquier navegador.

## 5. Operaciones comunes
```sql
-- Registrar un producto
INSERT INTO productos (id_categoria,id_proveedor,codigo,nombre,precio,stock)
VALUES (1,1,'BEB-002','Jugo 1 L',4500,30);

-- Registrar una venta con dos productos
INSERT INTO ventas (id_cliente,id_usuario,total,estado) VALUES (1,2,7500,'PAGADA');
INSERT INTO detalle_venta VALUES (LAST_INSERT_ID(),1,2,1500),(LAST_INSERT_ID(),2,1,4500);

-- Productos con stock bajo
SELECT codigo, nombre, stock FROM productos WHERE stock <= stock_minimo;
```

## 6. Restricciones a tener en cuenta
- `precio` debe ser > 0 y `cantidad` > 0 (CHECK).
- `correo`, `nit`, `documento` y `codigo` son únicos.
- No se puede borrar un cliente, producto, rol, etc. que tenga registros relacionados (`RESTRICT`); al borrar una venta se borran sus líneas de `detalle_venta` (`CASCADE`).
- Los datos de ejemplo usan claves ficticias; en producción almacene un hash real (p. ej. bcrypt de 60 caracteres).

## 7. Solución de problemas
| Error | Causa / solución |
|---|---|
| `ERROR 1451` | Hay registros hijos que dependen de la fila que intenta borrar. |
| `ERROR 3819` | Se violó un CHECK (precio o cantidad ≤ 0). |
| `ERROR 1062` | Valor duplicado en una columna UNIQUE. |
| `Access denied` | Verifique usuario y contraseña de MySQL. |

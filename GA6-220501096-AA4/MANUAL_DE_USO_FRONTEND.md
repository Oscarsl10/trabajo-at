# Manual de uso – Front-end (GA6-220501096-AA4)

| Carpeta | Contenido |
|---|---|
| `EV01/tutorial` | Página con el tutorial «Git para principiantes» (`index.html`, `estilos.css`, `img/`) |
| `EV03/frontend` | Aplicación web TiendaFácil (`index.html`, `css/estilos.css`, `js/app.js`) |

## 1. Requisitos
Solo un navegador moderno (Chrome, Edge, Firefox). No requiere instalación ni servidor.

## 2. Tutorial (EV01)
1. Abra `GA6-220501096-AA4/EV01/tutorial/index.html` con doble clic.
2. En la lista ordenada «Contenido» pulse un tema para ir directamente a su sección (título, imagen y descripción).
3. El diseño se adapta a pantallas de celular y escritorio.

## 3. Aplicación TiendaFácil (EV03)
Abra `GA6-220501096-AA4/EV03/frontend/index.html`. La barra superior tiene tres pestañas.

### 3.1 Inventario
- **Agregar producto:** complete código, nombre, precio (> 0) y stock (≥ 0) y pulse *Guardar producto*.
- **Editar:** pulse *Editar* en la fila; el formulario se llena, modifique y pulse *Actualizar producto* (o *Cancelar*).
- **Eliminar:** pulse *Eliminar* y confirme.
- **Buscar:** escriba en el cuadro de búsqueda para filtrar por código o nombre.
- Los productos con stock ≤ 5 muestran el stock en rojo (alerta de reposición).
- Si un dato es inválido o el código está repetido, aparece un mensaje y el campo se resalta en rojo.

### 3.2 Nueva venta
1. Elija el producto y la cantidad, y pulse *Agregar*. No se permite superar el stock disponible.
2. Use *Quitar* para sacar una línea. El total se actualiza automáticamente.
3. Pulse *Confirmar venta*: se descuenta el stock y la venta queda registrada.

### 3.3 Historial
Lista las ventas realizadas (número, fecha, detalle y total), de la más reciente a la más antigua.

## 4. Almacenamiento de datos
La aplicación guarda la información en el `localStorage` del navegador (no hay servidor). Los datos persisten al cerrar la página, pero son propios de cada navegador. Para reiniciar los datos de ejemplo, abra las herramientas de desarrollo (F12) → *Application* → *Local Storage* y elimine las claves `tf_productos` y `tf_ventas`.

## 5. Accesibilidad y usabilidad
Enlace «Saltar al contenido», etiquetas en todos los campos, avisos con `aria-live`, foco visible, mensajes de error claros y diseño responsivo.

## 6. Conexión con la base de datos
El modelo de datos de la pantalla (productos, ventas y detalle) corresponde a las tablas `productos`, `ventas` y `detalle_venta` de `GA6-220501096-AA2/EV03/tienda_db.sql`. Una versión con servidor reemplazaría el `localStorage` por llamadas a una API que lea/escriba esas tablas.

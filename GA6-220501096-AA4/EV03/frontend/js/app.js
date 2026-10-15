(function () {
  'use strict';
  var $ = function (id) { return document.getElementById(id); };
  var money = new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 });

  function load(key, fallback) {
    try { return JSON.parse(localStorage.getItem(key)) || fallback; } catch (e) { return fallback; }
  }
  function save(key, val) { try { localStorage.setItem(key, JSON.stringify(val)); } catch (e) {} }

  var productos = load('tf_productos', [
    { id: 1, codigo: 'BEB-001', nombre: 'Agua 600 ml', precio: 1500, stock: 100 },
    { id: 2, codigo: 'ASE-001', nombre: 'Jabón en barra', precio: 2800, stock: 50 },
    { id: 3, codigo: 'SNK-001', nombre: 'Papas fritas', precio: 3200, stock: 4 }
  ]);
  var ventas = load('tf_ventas', []);
  var carrito = [];

  function aviso(msg) {
    var a = $('aviso'); a.textContent = msg; a.classList.add('visible');
    setTimeout(function () { a.classList.remove('visible'); }, 2200);
  }
  function el(tag, text, cls) {
    var e = document.createElement(tag);
    if (text !== undefined) e.textContent = text;
    if (cls) e.className = cls;
    return e;
  }
  function btn(text, cls, fn) {
    var b = el('button', text, cls); b.type = 'button'; b.addEventListener('click', fn); return b;
  }

  // ---- Navegación
  document.querySelectorAll('.tab').forEach(function (t) {
    t.addEventListener('click', function () {
      document.querySelectorAll('.tab').forEach(function (x) { x.classList.toggle('activa', x === t); });
      document.querySelectorAll('.vista').forEach(function (v) { v.hidden = v.id !== t.dataset.vista; });
      render();
    });
  });

  // ---- Inventario
  function renderInventario() {
    var q = $('buscar').value.trim().toLowerCase();
    var tb = $('tabla-productos'); tb.innerHTML = '';
    productos.filter(function (p) {
      return !q || p.codigo.toLowerCase().indexOf(q) >= 0 || p.nombre.toLowerCase().indexOf(q) >= 0;
    }).forEach(function (p) {
      var tr = el('tr', undefined, p.stock <= 5 ? 'bajo' : '');
      tr.appendChild(el('td', p.codigo)); tr.appendChild(el('td', p.nombre));
      tr.appendChild(el('td', money.format(p.precio))); tr.appendChild(el('td', String(p.stock)));
      var td = el('td');
      td.appendChild(btn('Editar', '', function () { editar(p.id); }));
      td.appendChild(document.createTextNode(' '));
      td.appendChild(btn('Eliminar', 'peligro', function () {
        if (confirm('¿Eliminar "' + p.nombre + '"?')) {
          productos = productos.filter(function (x) { return x.id !== p.id; });
          save('tf_productos', productos); render(); aviso('Producto eliminado');
        }
      }));
      tr.appendChild(td); tb.appendChild(tr);
    });
  }
  function editar(id) {
    var p = productos.find(function (x) { return x.id === id; });
    $('p-id').value = p.id; $('p-codigo').value = p.codigo; $('p-nombre').value = p.nombre;
    $('p-precio').value = p.precio; $('p-stock').value = p.stock;
    $('btn-guardar').textContent = 'Actualizar producto'; $('btn-cancelar').hidden = false;
    $('p-codigo').focus();
  }
  function limpiarForm() {
    $('form-producto').reset(); $('p-id').value = '';
    $('btn-guardar').textContent = 'Guardar producto'; $('btn-cancelar').hidden = true; $('p-error').textContent = '';
    document.querySelectorAll('.invalido').forEach(function (i) { i.classList.remove('invalido'); });
  }
  $('btn-cancelar').addEventListener('click', limpiarForm);
  $('buscar').addEventListener('input', renderInventario);
  $('form-producto').addEventListener('submit', function (e) {
    e.preventDefault();
    ['p-codigo', 'p-nombre', 'p-precio', 'p-stock'].forEach(function (c) { $(c).classList.remove('invalido'); });
    var err = '';
    var codigo = $('p-codigo').value.trim(), nombre = $('p-nombre').value.trim();
    var precio = Number($('p-precio').value), stock = Number($('p-stock').value);
    if (!codigo) { err = 'El código es obligatorio.'; $('p-codigo').classList.add('invalido'); }
    else if (!nombre) { err = 'El nombre es obligatorio.'; $('p-nombre').classList.add('invalido'); }
    else if (!(precio > 0)) { err = 'El precio debe ser mayor que 0.'; $('p-precio').classList.add('invalido'); }
    else if ($('p-stock').value === '' || !Number.isInteger(stock) || stock < 0) { err = 'El stock debe ser un entero ≥ 0.'; $('p-stock').classList.add('invalido'); }
    var id = Number($('p-id').value);
    if (!err && productos.some(function (p) { return p.codigo.toLowerCase() === codigo.toLowerCase() && p.id !== id; })) {
      err = 'Ya existe un producto con ese código.'; $('p-codigo').classList.add('invalido');
    }
    $('p-error').textContent = err;
    if (err) return;
    if (id) {
      var p = productos.find(function (x) { return x.id === id; });
      p.codigo = codigo; p.nombre = nombre; p.precio = precio; p.stock = stock;
    } else {
      productos.push({ id: Date.now(), codigo: codigo, nombre: nombre, precio: precio, stock: stock });
    }
    save('tf_productos', productos); limpiarForm(); render(); aviso('Producto guardado');
  });

  // ---- Ventas
  function renderVentas() {
    var sel = $('v-producto'); sel.innerHTML = '';
    productos.forEach(function (p) {
      var o = el('option', p.nombre + ' (' + p.stock + ' disp.)'); o.value = p.id; sel.appendChild(o);
    });
    var tb = $('tabla-carrito'); tb.innerHTML = ''; var total = 0;
    carrito.forEach(function (l, i) {
      var sub = l.precio * l.cantidad; total += sub;
      var tr = el('tr');
      tr.appendChild(el('td', l.nombre)); tr.appendChild(el('td', String(l.cantidad))); tr.appendChild(el('td', money.format(sub)));
      var td = el('td'); td.appendChild(btn('Quitar', 'peligro', function () { carrito.splice(i, 1); renderVentas(); }));
      tr.appendChild(td); tb.appendChild(tr);
    });
    $('total').textContent = money.format(total);
  }
  $('btn-agregar').addEventListener('click', function () {
    var p = productos.find(function (x) { return x.id === Number($('v-producto').value); });
    var cant = Number($('v-cantidad').value);
    $('v-error').textContent = '';
    if (!p) { $('v-error').textContent = 'No hay productos disponibles.'; return; }
    if (!Number.isInteger(cant) || cant < 1) { $('v-error').textContent = 'La cantidad debe ser un entero ≥ 1.'; return; }
    var ya = carrito.filter(function (l) { return l.id === p.id; }).reduce(function (s, l) { return s + l.cantidad; }, 0);
    if (ya + cant > p.stock) { $('v-error').textContent = 'Stock insuficiente: quedan ' + (p.stock - ya) + ' unidades.'; return; }
    var linea = carrito.find(function (l) { return l.id === p.id; });
    if (linea) linea.cantidad += cant; else carrito.push({ id: p.id, nombre: p.nombre, precio: p.precio, cantidad: cant });
    renderVentas();
  });
  $('btn-vender').addEventListener('click', function () {
    if (!carrito.length) { $('v-error').textContent = 'Agregue al menos un producto.'; return; }
    var total = 0;
    carrito.forEach(function (l) {
      total += l.precio * l.cantidad;
      productos.find(function (p) { return p.id === l.id; }).stock -= l.cantidad;
    });
    ventas.push({ n: ventas.length + 1, fecha: new Date().toLocaleString('es-CO'), lineas: carrito.slice(), total: total });
    save('tf_productos', productos); save('tf_ventas', ventas);
    carrito = []; $('v-error').textContent = ''; render(); aviso('Venta registrada');
  });

  // ---- Historial
  function renderHistorial() {
    var tb = $('tabla-historial'); tb.innerHTML = '';
    if (!ventas.length) {
      var r = el('tr'); var c = el('td', 'Aún no hay ventas.'); c.colSpan = 4; r.appendChild(c); tb.appendChild(r); return;
    }
    ventas.slice().reverse().forEach(function (v) {
      var tr = el('tr');
      tr.appendChild(el('td', String(v.n))); tr.appendChild(el('td', v.fecha));
      tr.appendChild(el('td', v.lineas.map(function (l) { return l.cantidad + '× ' + l.nombre; }).join(', ')));
      tr.appendChild(el('td', money.format(v.total))); tb.appendChild(tr);
    });
  }

  function render() { renderInventario(); renderVentas(); renderHistorial(); }
  render();
})();

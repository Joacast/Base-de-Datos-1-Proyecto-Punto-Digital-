# Base de Datos 1 - Proyecto Punto Digital

**Integrantes:**
* Rodriguez Agustina Ailén — DNI: 44294409
* Sarli Ochat, Melina — DNI: 44683566
* Castañeda Joaquina Aymara — DNI: 46842335
* Ramirez Camila Julieta — DNI: 46843127
* Quintana Javier Armando — DNI: 44683558

## PRESENTACION Y CONTEXTO
**Punto Digital** es un sistema de gestión de base de datos diseñado para una tienda especializada en la comercialización de productos electrónicos y tecnología.

El proyecto surge a partir de la necesidad de administrar de manera centralizada e íntegra las operaciones comerciales del negocio, garantizando la consistencia de los datos, evitando redundancias y manteniendo un historial de las transacciones realizadas.

El modelo de negocio comprende:
* **Comercialización de productos tecnológicos:** venta de celulares, computadoras, accesorios, periféricos y dispositivos electrónicos de diversas marcas y categorías.
* **Gestión de abastecimiento y relaciones comerciales:** administración de proveedores, catálogo categorizado, registro de clientes y control de compras con múltiples métodos de pago.

El sistema permite registrar y relacionar la información correspondiente a **productos, categorías, marcas, stock, proveedores, clientes, métodos de pago y transacciones con su respectivo detalle histórico**, proporcionando una estructura robusta para la toma de decisiones y la operativa diaria.

---

## PROBLEMÁTICA
Uno de los principales problemas identificados en el comercio es la dificultad para mantener un control preciso, unificado y actualizado del stock disponible, así como la pérdida de trazabilidad en los precios de venta a lo largo del tiempo.

Las fallas operativas más comunes incluyen:
* **Inconsistencia en el inventario:** falta de actualización inmediata tras una operación comercial y riesgo de valores negativos en existencias.
* **Pérdida del valor histórico de venta:** sobreescritura de montos facturados cuando un producto cambia su precio de lista actual, alterando balances contables pasados.
* **Redundancia y dispersión de datos de contacto:** duplicación de estructuras para personas (clientes y proveedores) y desorden en el almacenamiento de múltiples vías de comunicación (teléfonos).
* **Falta de integridad en métodos de cobro y categorización:** inconsistencias causadas por carga en texto libre de marcas, categorías y formas de pago.

---

## REGLAS DEL NEGOCIO

El funcionamiento de Punto Digital se rige bajo un conjunto formal de reglas de negocio orientadas a preservar la consistencia operativa y relacional:

* **Gestión y control de stock :** Cada producto debe mantener registrado su stock disponible. Se actualiza automáticamente ante cada operación comercial y bajo ninguna circunstancia puede admitir valores negativos.
* **Registro de clientes :** Todo cliente debe estar registrado con sus datos identificatorios. Puede efectuar una o múltiples compras, pero cada transacción debe asociarse a un único cliente.
* **Categorización jerárquica :** Cada producto pertenece estrictamente a una única categoría, mientras que una categoría puede agrupar múltiples productos.
* **Historial e inmutabilidad de precios :** El precio unitario registrado en el detalle de una transacción debe conservarse de forma independiente a las variaciones del precio actual de lista del producto, impidiendo modificaciones retroactivas.
* **Normalización de métodos de pago :** Toda operación de cobro debe registrarse mediante un método de pago tipificado y habilitado (Efectivo, Débito, Crédito, Transferencia), pudiendo reutilizarse en múltiples transacciones.
* **Integridad de transacciones y detalle :** Cada compra/venta posee un identificador único, fecha, cliente asociado y monto total. Debe contener de manera obligatoria al menos un producto desglosado en su respectiva línea de detalle.
* **Relación con proveedores :** Un proveedor puede suministrar múltiples productos y un producto puede ser provisto por uno o varios proveedores (cardinalidad N:M).

La definición y justificación técnica completa se encuentra en:
`docs/etapa-01/reglas-negocio.md`

---

## DOCUMETACIÓN

La documentación del proyecto se encuentra organizada dentro del repositorio en el directorio `docs/`, dividida de acuerdo con las fases de desarrollo:

### Etapa 01 — Requerimientos y dominio del negocio
Comprende el análisis inicial de la tienda, la delimitación del alcance, el relevamiento de la problemática y las reglas de negocio base.

| Documento | Descripción |
| :--- | :--- |
| `descripcion-caso.md` | Descripción del caso comercial, modelo de negocio y problemática. |
| `alcance.md` | Delimitación del alcance del sistema, entidades contempladas y objetivos. |
| `reglas-negocio.md` | Especificación de reglas de negocio (RN.01 a RN.07). |
| `decisiones-diseno.md` | Justificación técnica de atributos atómicos, herencia de personas e inmutabilidad. |

### Etapa 02 — Modelado conceptual y lógico
Comprende la representación gráfica conceptual mediante DER y su correspondiente mapeo al modelo relacional normalizado.

| Documento | Descripción |
| :--- | :--- |
| `der/` | Diagrama Entidad-Relación (DER) conceptual con jerarquía de especialización PERSONA. |
| `modelo-relacional.md` | Esquema relacional detallado con definición de tablas, PK compuestas y FKs. |
| `normalizacion.md` | Aplicación y justificación del proceso de normalización (1FN, 2FN y 3FN), eliminación de redundancias y dependencias funcionales. |
| `decisiones-diseno.md` | Registro de normalización (1FN, 2FN, 3FN), claves surrogadas y resolución de jerarquías. |

### Etapa 03 — Implementación física
Esta etapa comprende la definición de la estructura física de la base de datos, el establecimiento de restricciones de integridad y la validación de los datos mediante pruebas de consistencia.

| Documento | Descripción |
| :--- | :--- |
| `implementacion.md` | Especificación de la creación de tablas, tipos de datos y mapeo físico en el motor de base de datos. |
| `pruebas-validacion.md` | Casos de prueba y verificación de consistencia tras la carga de registros. |
| `restricciones-integridad.md` | Definición de claves primarias, foráneas, restricciones de no nulidad, unicidad y reglas de validación (CHECK). |

---

### Etapa 04 — Consultas avanzadas y reportes
Esta etapa corresponde a la explotación de los datos mediante consultas SQL complejas, generación de comprobantes y reportes comerciales con funciones de agregación.

| Documento | Descripción |
| :--- | :--- |
| `consulta-avanzada.md` | Desarrollo y explicación de consultas complejas con múltiples JOINs y filtros analíticos. |
| `factura_comprobante.md` | Consulta estructurada para la emisión del detalle completo de comprobantes y facturas comerciales. |
| `reporte-agregado.md` | Métricas de negocio y reportes estadísticos utilizando funciones de agregación y agrupamiento (`GROUP BY`). |

---

### Scripts SQL — Directorio `/sql`
Contiene la totalidad de los scripts organizados por propósito operativo y listos para su ejecución secuencial en el gestor de base de datos.

| Directorio | Descripción |
| :--- | :--- |
| `sql/ddl/` | Scripts de Definición de Datos (Data Definition Language) para la creación de tablas, claves, índices y restricciones. |
| `sql/dml/` | Scripts de Manipulación de Datos (Data Manipulation Language) para el poblado masivo y consistente de datos de prueba. |
| `sql/consultas/` | Scripts con las consultas analíticas, reportes periódicos y generación de comprobantes de venta. |

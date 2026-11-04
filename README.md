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
- **Integridad de compras y ventas:** Cada registro de venta relaciona un cliente con un producto e incluye fecha, cantidad, precio unitario, monto total y método de pago. Cada registro de compra relaciona un proveedor con un producto e incluye fecha, cantidad, monto total y método de pago. Las claves foráneas y las restricciones de integridad controlan la validez de estas relaciones y de los valores registrados.
* **Relación con proveedores :** Un proveedor puede suministrar múltiples productos y un producto puede ser provisto por uno o varios proveedores (cardinalidad N:M).

La definición y justificación técnica completa se encuentra en:
``etapa-01/reglas-negocio.md`

---

## DOCUMENTACIÓN

La documentación del proyecto se encuentra organizada en las carpetas `etapa-01/`, `etapa-02/`, `etapa-03/`, `etapa-04/` y `etapa-05/`, ubicadas en la raíz del repositorio y divididas según las fases de desarrollo.

### Etapa 01 — Requerimientos y dominio del negocio
Comprende el análisis inicial de la tienda, la delimitación del alcance, el relevamiento de la problemática y las reglas de negocio base.

| Documento | Descripción |
| :--- | :--- |
| `descripcion-caso.md` | Descripción del caso comercial, modelo de negocio y problemática. |
| `alcance.md` | Delimitación del alcance del sistema, entidades contempladas y objetivos. |
| `reglas-negocio.md` | Especificación de reglas de negocio (RN.01 a RN.07). |
| `decisiones-diseno.md` | Justificación técnica de atributos atómicos, herencia de personas e inmutabilidad. |

### Etapa 02 — Modelado conceptual y lógico

Comprende la representación del caso de estudio mediante un Diagrama Entidad-Relación (DER), el modelo relacional y la documentación de las decisiones de diseño y del proceso de normalización.

| Documento | Descripción |
| :--- | :--- |
| `der/DER.png` | Diagrama Entidad-Relación del caso de estudio, con sus entidades, atributos y relaciones. |
| `modelo-relacional.png` | Representación gráfica del modelo relacional con Persona, Cliente y Proveedor; pendiente de ajustar sus campos al DDL actual. |
| `normalizacion.md` | Desarrollo del proceso de normalización: primera, segunda y tercera forma normal. |
| `decisiones-diseno.md` | Decisiones sobre Persona, sus relaciones con Cliente y Proveedor, claves y normalización. |

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

### Etapa 05 — Temas técnicos

Esta etapa comprende el desarrollo de temas técnicos de SQL Server aplicados al sistema Punto Digital: procedimientos y funciones almacenadas, manejo de transacciones, triggers de auditoría, seguridad y optimización de consultas. Incluye la descripción y los fundamentos de aplicación de cada tema, los scripts SQL correspondientes y la documentación de su demostración.

| Documento | Descripción |
| :--- | :--- |
| `procedimientos-funciones.md` | Descripción de procedimientos y funciones almacenadas y sus fundamentos de aplicación al sistema de ventas. |
| `manejo-transiciones.md` | Descripción del manejo de transacciones para mantener la consistencia de las operaciones. |
| `triggers-auditoria.md` | Fundamentos de utilización de triggers para registrar cambios y facilitar la auditoría de los datos. |
| `seguridad.md` | Administración de usuarios, roles y permisos para controlar el acceso a la información y las operaciones autorizadas. |
| `indices-optimizacion.md` | Fundamentos de utilización de índices para mejorar el rendimiento de las consultas. |

La documentación de esta etapa se encuentra en el directorio [`etapa-05/`](etapa-05/).

---

### Scripts SQL — Directorio `/sql`

Contiene los scripts organizados según su propósito. Para ejecutarlos, se deben respetar las dependencias y las instrucciones indicadas en cada archivo, seleccionando la base de datos correspondiente.

| Directorio | Descripción |
| :--- | :--- |
| `sql/ddl/` | Scripts de Definición de Datos (Data Definition Language) para la creación de tablas, claves y restricciones. |
| `sql/dml/` | Scripts de Manipulación de Datos (Data Manipulation Language) para la carga de datos de prueba. |
| `sql/consultas/` | Scripts con consultas analíticas, reportes y generación de comprobantes de venta. |
| `sql/tecnico/` | Scripts de los temas técnicos de la Etapa 05: procedimientos, funciones, transacciones, triggers, seguridad e índices para la optimización de consultas. |

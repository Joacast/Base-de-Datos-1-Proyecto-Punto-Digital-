# Restricciones de Integridad - Módulo Ventas y Productos
**Proyecto:** Punto Digital  
**Equipo:** 14  
**Etapa:** III – Implementación Física (SQL Server)  

---

## 1. Integridad de Entidad (Claves Primarias)

Identificadores únicos no nulos generados mediante clave subrogada autoincremental:

| Tabla | Restricción | Columna | Definición SQL | Propósito |
| :--- | :--- | :--- | :--- | :--- |
| `producto` | `pk_producto` | `producto_id` | `PRIMARY KEY (producto_id)` | Identificador unívoco del producto. Generado con `IDENTITY(1,1)`. |
| `registro_venta` | `pk_registro_venta` | `registro_venta_id` | `PRIMARY KEY (registro_venta_id)` | Identificador unívoco de la transacción. Generado con `IDENTITY(1,1)`. |

---

## 2. Integridad Referencial (Claves Foráneas)

Vínculos relacionales entre la transacción de venta y las entidades principales:

| Tabla Origen | Restricción | Columna FK | Tabla Referenciada | ON UPDATE | ON DELETE | Justificación |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `registro_venta` | `fk_venta_cliente` | `cliente_id` | `cliente(cliente_id)` | `CASCADE` | `NO ACTION` | Bloquea el borrado de clientes con ventas asociadas para preservar el historial fiscal. |
| `registro_venta` | `fk_venta_producto` | `producto_id` | `producto(producto_id)` | `CASCADE` | `NO ACTION` | Impide eliminar productos del catálogo que figuren en comprobantes emitidos. |

---

## 3. Integridad de Dominio y Restricciones de Negocio

### A. Restricciones de Verificación (`CHECK`)

| Tabla | Restricción | Expresión Lógica | Regla de Negocio / Propósito |
| :--- | :--- | :--- | :--- |
| `producto` | `ck_producto_stock` | `CHECK (stock >= 0)` | Garantiza que las existencias no tomen valores negativos (RN.01). |
| `producto` | `ck_producto_precio` | `CHECK (precio_venta > 0)` | Evita artículos con precio cero o importes negativos en catálogo. |
| `registro_venta` | `ck_venta_cantidad` | `CHECK (cantidad > 0)` | Exige que la transacción incluya al menos una unidad. |
| `registro_venta` | `ck_venta_precio` | `CHECK (precio_unitario > 0)` | Valida el precio unitario congelado al facturar (RN.04). |
| `registro_venta` | `ck_venta_monto` | `CHECK (monto_total > 0)` | Valida que el importe total facturado sea mayor a cero. |

### B. Valores por Defecto (`DEFAULT`)

| Tabla | Columna | Valor Predeterminado | Comportamiento |
| :--- | :--- | :--- | :--- |
| `producto` | `stock` | `DEFAULT 0` | Inicializa existencias en cero ante omisión de stock inicial. |
| `registro_venta` | `fecha_compra` | `DEFAULT CURRENT_TIMESTAMP` | Asigna automáticamente la fecha y hora del sistema al registrar la operación. |

### C. Campos Obligatorios (`NOT NULL`)

* **`producto`:** `nombre`, `marca`, `categoria`, `color`, `stock`, `precio_venta` no admiten nulos por ser atributos indispensables para la identificación y venta del artículo.
* **`registro_venta`:** `cliente_id`, `producto_id`, `fecha_compra`, `cantidad`, `precio_unitario`, `monto_total` son de registro mandatorio para garantizar la validez legal del comprobante.
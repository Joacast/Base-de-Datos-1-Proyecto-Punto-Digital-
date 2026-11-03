# Etapa V – Implementación técnica: Triggers de Auditoría

## 1. Descripción y fundamentos

### 1.1. ¿Qué es un trigger?

Un *trigger* o disparador es un objeto de la base de datos que ejecuta automáticamente un conjunto de instrucciones cuando ocurre un evento determinado sobre una tabla o vista.

En SQL Server, los triggers pueden ejecutarse ante operaciones como:

- `INSERT`: inserción de registros.
- `UPDATE`: modificación de registros.
- `DELETE`: eliminación de registros.

A diferencia de un procedimiento almacenado, que debe ser invocado explícitamente, un trigger se ejecuta automáticamente cuando sucede el evento para el cual fue definido.

### 1.2. ¿Qué es una auditoría?

La auditoría consiste en registrar información sobre determinadas operaciones realizadas en la base de datos para poder revisar posteriormente qué datos fueron modificados, cuándo ocurrió el cambio y quién lo realizó.

Una tabla de auditoría puede almacenar:

- El identificador del registro modificado.
- Los valores anteriores.
- Los valores nuevos.
- La fecha y hora del cambio.
- El usuario que realizó la operación.

### 1.3. Aplicación en el proyecto Punto Digital

En el sistema Punto Digital, la tabla `producto` almacena información del catálogo, incluyendo el stock disponible y el precio de venta.

Estos datos son importantes para el funcionamiento del negocio. Una modificación incorrecta del stock podría generar diferencias entre las existencias reales y las registradas en el sistema. De igual manera, un cambio de precio no autorizado podría afectar las ventas.

Por este motivo, se implementa un trigger de auditoría que registra automáticamente los cambios de stock y precio realizados sobre la tabla `producto`.

La solución contempla:

1. Una tabla `auditoria_producto` que almacena el historial de cambios.
2. Un trigger `tr_auditar_producto` que se ejecuta después de una operación `UPDATE`.
3. El registro de los valores anteriores y nuevos de stock y precio.
4. La identificación del usuario de SQL que realizó la modificación.

### 1.4. Funcionamiento en SQL Server

Cuando se ejecuta un `UPDATE`, SQL Server proporciona dos tablas lógicas especiales al trigger:

| Tabla lógica | Contenido |
|---|---|
| `deleted` | Valores anteriores a la modificación. |
| `inserted` | Valores nuevos después de la modificación. |

El trigger relaciona ambas tablas mediante `producto_id`, que identifica al producto modificado.

Se utiliza `AFTER UPDATE` porque la auditoría debe registrar el cambio una vez que la modificación se realizó correctamente. Si la operación que activa el trigger se revierte, también se revierten las inserciones de auditoría realizadas por ese trigger.


## 3. Script de demostración y prueba

Para comprobar el funcionamiento del trigger, se modifica el stock y el precio de un producto existente. Luego se consulta la tabla de auditoría para verificar que se guardaron los valores anteriores y nuevos.

**Importante:** reemplazar `1` por el `producto_id` de un producto existente en la base de datos.

```sql
USE punto_digital;
GO

/* ============================================================
   1. CONSULTAR EL PRODUCTO ANTES DE MODIFICARLO
   ============================================================ */

SELECT
    producto_id,
    nombre,
    stock,
    precio_venta
FROM dbo.producto
WHERE producto_id = 1;
GO


/* ============================================================
   2. MODIFICAR STOCK Y PRECIO
   El trigger se ejecuta automáticamente.
   ============================================================ */

UPDATE dbo.producto
SET
    stock = stock + 5,
    precio_venta = precio_venta + 100
WHERE producto_id = 1;
GO


/* ============================================================
   3. CONSULTAR LOS CAMBIOS REGISTRADOS EN LA AUDITORÍA
   ============================================================ */

SELECT
    auditoria_id,
    producto_id,
    stock_anterior,
    stock_nuevo,
    precio_anterior,
    precio_nuevo,
    fecha_cambio,
    usuario_sql
FROM dbo.auditoria_producto
WHERE producto_id = 1
ORDER BY auditoria_id DESC;
GO
```

### 3.1. Resultado esperado

Después de ejecutar el `UPDATE`, la tabla `auditoria_producto` debe contener un nuevo registro con:

- El identificador del producto modificado.
- El stock anterior y el stock nuevo.
- El precio anterior y el precio nuevo.
- La fecha y hora de la modificación.
- El usuario de SQL que realizó la operación.

Por ejemplo, si el producto tenía stock `10` y precio `1500.00`, después de la modificación tendrá stock `15` y precio `1600.00`. La auditoría registrará ambos pares de valores.

---

## 4. Conclusión

La implementación de triggers de auditoría en Punto Digital permite mantener un historial de modificaciones relevantes en los productos sin depender de que los usuarios registren manualmente los cambios.

Esta solución mejora la trazabilidad, facilita la detección de modificaciones inesperadas y aporta mayor control y confiabilidad a la base de datos.

El trigger complementa las restricciones y validaciones existentes: estas ayudan a evitar datos inválidos, mientras que la auditoría permite revisar qué modificaciones efectivamente se realizaron.

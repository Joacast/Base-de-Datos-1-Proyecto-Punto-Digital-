# PROCESO DE NORMALIZACIÓN

## 1FN: Eliminación de grupos repetitivos y garantía de atomicidad

### PASO 1
Antes de normalizar, podríamos tener registrada una venta de esta forma:

**VENTA NO NORMALIZADA**

| id_venta | cliente | productos | cantidades |
| :--- | :--- | :--- | :--- |
| 001 | Juan | Samsung A55, funda, cargador | 1, 2, 1 |

Acá notamos un error, en `productos` hay: *Samsung A55, funda, cargador*. Es decir, tres valores en una misma celda.  
Y en `cantidades`: *1, 2, 1*. También tenemos varios valores en una misma celda.  
Esto no es correcto en 1FN.

---

### PASO 2
El problema es que los atributos `productos` y `cantidades` contienen grupos repetitivos / múltiples valores.  
Por ejemplo: `productos` = Samsung A55, Funda, Cargador. No tenemos un único valor. Según la teoría, cada atributo debe contener valores atómicos y no debe haber grupos repetitivos.

---

### PASO 3
Para solucionar esto, hacemos que cada fila represente un producto dentro de una venta.

| id_venta | cliente | producto | cantidad |
| :--- | :--- | :--- | :--- |
| 001 | Juan | Samsung A55 | 1 |
| 001 | Juan | Funda | 2 |
| 001 | Juan | Cargador | 1 |

Ahora cada celda tiene un solo valor.  
Pero tenemos otro inconveniente: `cliente` se está repitiendo en cada fila.  
Por eso, la información de la venta debe separarse de la información de sus productos.

---

### PASO 4 

**VENTA**
| id_venta | cliente | fecha | metodo_pago | monto_total |
| :--- | :--- | :--- | :--- | :--- |
| 001 | Juan | 14/09/2026 | Tarjeta | $600.000 |

**DETALLE_VENTA**
| id_venta | producto | cantidad |
| :--- | :--- | :--- |
| 001 | Samsung A55 | 1 |
| 001 | Funda | 2 |
| 001 | Cargador | 1 |

Así cada fila de **DETALLE_VENTA** representa un producto concreto dentro de una venta.

---

### PASO 5 
Una compra del local al proveedor podría inicialmente tener:

| id_compra | proveedor | productos | cantidades |
| :--- | :--- | :--- | :--- |
| 050 | Proveedor X | Samsung A55, Funda, Cargador | 10, 20, 5 |

Nuevamente tenemos múltiples valores dentro de una celda.  
Lo transformamos en:

**COMPRA**
| id_compra | proveedor | fecha | metodo_pago | monto_total |
| :--- | :--- | :--- | :--- | :--- |
| 050 | Proveedor X | 14/09/2026 | Transferencia | $5.500.000 |

**DETALLE_COMPRA**
| id_compra | producto | cantidad |
| :--- | :--- | :--- |
| 050 | Samsung A55 | 10 |
| 050 | Funda | 20 |
| 050 | Cargador | 5 |

Ahora los valores son atómicos.

---

### PASO 6 
Finalmente obtenemos las siguientes entidades:

* CLIENTE
* PROVEEDOR
* PRODUCTO
* COMPRA
* DETALLE_COMPRA
* VENTA
* DETALLE_VENTA

Y cada atributo contiene un único valor, sin listas ni grupos repetitivos.

> **Conclusión:** El modelo se encuentra en **Primera Forma Normal (1FN)**, ya que todos sus atributos presentan valores atómicos y se eliminaron los grupos repetitivos, separando las operaciones de compra y venta de sus respectivos detalles.


## 2FN: Eliminación de dependencias funcionales

### 1. Análisis de las tablas obtenidas en la 1FN
Revisando el resultado de la 1FN, identificamos la clave primaria (PK) de cada tabla:
•	CLIENTE -> PK: id_cliente (clave simple)
•	PROVEEDOR -> PK: id_proveedor (clave simple)
•	PRODUCTO -> PK: id_producto (clave simple)
•	VENTA -> PK: id_venta (clave simple)
•	COMPRA -> PK: id_compra (clave simple)
•	DETALLE_VENTA -> PK compuesta: (id_venta, id_producto)
•	DETALLE_COMPRA -> PK compuesta: (id_compra, id_producto)
Las tablas con claves simples (cliente, proveedor, producto, venta, compra) cumplen automáticamente con la 2FN, ya que al tener un único atributo como clave no pueden existir dependencias parciales.

### 2. Detección y resolución de dependencias parciales
Analizamos las dos tablas intermedias que poseen claves compuestas:
### A. Tabla DETALLE_VENTA
•	Clave primaria (PK): (id_venta, id_producto)
•	Atributos: id_venta, id_producto, cantidad
•	Evaluación de dependencias:
o	cantidad: depende directamente de la combinación de la venta y del producto específico que se está vendiendo. No depende solo del producto ni solo de la venta.
Por lo tanto, la clave compuesta (id_venta, id_producto) determina completamente a cantidad. No existen dependencias parciales en esta tabla.

### B. Tabla DETALLE_COMPRA
•	Clave primaria (PK): (id_compra, id_producto)
•	Atributos: id_compra, id_producto, cantidad
•	Evaluación de dependencias:
o	cantidad: depende de forma completa de qué compra se realizó y qué producto específico se incluyó en esa compra.
Por lo tanto, la clave compuesta (id_compra, id_producto) determina completamente a cantidad. No existen dependencias parciales en esta tabla.

### 3. Estado final en 2FN
Dado que en las tablas con claves compuestas (DETALLE_VENTA y DETALLE_COMPRA) el atributo cantidad depende de la totalidad de la clave primaria y no de una parte de ella, el modelo no requiere la creación de nuevas tablas para alcanzar la 2FN.
Las tablas quedan definidas de la siguiente manera:
•	CLIENTE (id_cliente, dni, numero_telefono, provincia, localidad, calle)
•	PROVEEDOR (id_proveedor, cuit, provincia, localidad, calle)
•	PRODUCTO (id_producto, nombre, marca, categoria, color, precio_venta, stock)
•	VENTA (id_venta, fecha, metodo_pago, monto_total, id_cliente)
•	COMPRA (id_compra, fecha, metodo_pago, monto_total, id_proveedor)
•	DETALLE_VENTA (id_venta, id_producto, cantidad)
•	DETALLE_COMPRA (id_compra, id_producto, cantidad)

## Conclusión de la 2FN:
Se confirma que el modelo se encuentra formalmente en segunda forma normal (2FN), ya que todos los atributos no clave dependen funcionalmente de manera completa de sus respectivas claves primarias, no existiendo dependencias funcionales parciales.


# Tercera Forma Normal (3FN)
## Etapa II – Modelado Conceptual y Lógico
---

### 1. Definición
Una relación se encuentra en **Tercera Forma Normal (3FN)** cuando ya cumple con la Segunda Forma Normal (2FN) y no presenta dependencias funcionales transitivas. 

Una dependencia transitiva aparece cuando un atributo no clave depende de otro atributo no clave, y este último a su vez depende de la clave primaria.

$$\text{Clave primaria} \longrightarrow \text{Atributo no clave A} \longrightarrow \text{Atributo no clave B}$$

El objetivo de la 3FN es eliminar este tipo de dependencias para reducir la redundancia y evitar anomalías de actualización, inserción y borrado. Para lograrlo, los atributos que dependen de otro atributo no clave se separan en una nueva relación (tabla), manteniendo la vinculación mediante una clave foránea (FK).

---

### 2. Aplicación de 3FN al modelo
A partir del modelo relacional propuesto, se revisan las dependencias funcionales de cada relación. Los atributos no clave deben depender de manera directa y no transitiva de la clave primaria de su tabla:

| Relación | Dependencia funcional principal | Evaluación en 3FN |
| :--- | :--- | :--- |
| **Producto** | `id_Producto` $\rightarrow$ `marca, categoría, color, stock` | **Cumple 3FN:** Los atributos dependen directamente de `id_Producto` y no se observa ninguna dependencia transitiva. |
| **Cliente** | `id_Cliente` $\rightarrow$ `DNI_Cliente, numero_Telefono, calle, localidad, provincia` | **Cumple 3FN:** Los datos propios del cliente dependen directamente de su identificador (`id_Cliente`). |
| **Proveedor** | `id_Proveedor` $\rightarrow$ `CUIT, calle, localidad, provincia` | **Cumple 3FN:** Los datos propios del proveedor dependen directamente de su identificador (`id_Proveedor`). |
| **Registro_Venta** | `id_Registro_Venta` $\rightarrow$ `id_Cliente, id_Producto, fecha_Compra, cantidad` | **Cumple 3FN:** Los datos de cada venta dependen directamente de la clave del registro. |
| **Registro_Compra** | `id_Registro_Compra` $\rightarrow$ `id_Proveedor, id_Producto, fecha, método_Pago, monto_Total` | **Cumple 3FN:** Los datos de cada compra al proveedor dependen de la clave del registro. |

---

### 3. Esquema resultante en 3FN

* **PRODUCTO** (`id_Producto` **PK**, marca, categoría, color, stock)
* **CLIENTE** (`id_Cliente` **PK**, DNI_Cliente **U**, numero_Telefono, calle, localidad, provincia)
* **PROVEEDOR** (`id_Proveedor` **PK**, CUIT **U**, calle, localidad, provincia)
* **REGISTRO_VENTA** (`id_Registro_Venta` **PK**, `id_Cliente` **FK**, `id_Producto` **FK**, fecha_Compra, cantidad)
* **REGISTRO_COMPRA** (`id_Registro_Compra` **PK**, `id_Proveedor` **FK**, `id_Producto` **FK**, fecha, método_Pago, monto_Total)

---

### 4. Justificación
En el esquema final no se identifican dependencias transitivas entre atributos no clave. Cada atributo descriptivo depende directamente de la clave primaria de su relación. De esta forma, el modelo alcanza la **Tercera Forma Normal (3FN)**, disminuyendo la redundancia y favoreciendo la consistencia e integridad de los datos.

---------------------------------------------------------
-- PROYECTO PUNTO DIGITAL - ETAPA III: IMPLEMENTACIÓN FÍSICA
-- Script DDL: Creación de Tablas Base
---------------------------------------------------------
-- TABLA: CLIENTE
CREATE TABLE cliente (
    cliente_id INT IDENTITY(1,1),
    dni_cliente VARCHAR(15) NOT NULL,
    numero_telefono VARCHAR(20) NULL,
    calle VARCHAR(100) NOT NULL,
    localidad VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (cliente_id),
    CONSTRAINT uq_cliente_dni UNIQUE (dni_cliente)
);

-- TABLA: PROVEEDOR
CREATE TABLE proveedor (
    proveedor_id INT IDENTITY(1,1),
    cuit VARCHAR(20) NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    calle VARCHAR(100) NOT NULL,
    localidad VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    CONSTRAINT pk_proveedor PRIMARY KEY (proveedor_id),
    CONSTRAINT uq_proveedor_cuit UNIQUE (cuit)
);

-- TABLA: PRODUCTO
CREATE TABLE producto (
    producto_id INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    color VARCHAR(30) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    precio_venta DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (producto_id),
    CONSTRAINT ck_producto_stock CHECK (stock >= 0),
    CONSTRAINT ck_producto_precio CHECK (precio_venta > 0)
);

-- TABLA: REGISTRO_VENTA
CREATE TABLE registro_venta (
    registro_venta_id INT IDENTITY(1,1),
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL, -- Historial de precio congelado
    monto_total DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_registro_venta PRIMARY KEY (registro_venta_id),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id)
        REFERENCES cliente (cliente_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT fk_venta_producto FOREIGN KEY (producto_id)
        REFERENCES producto (producto_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT ck_venta_cantidad CHECK (cantidad > 0),
    CONSTRAINT ck_venta_precio CHECK (precio_unitario > 0),
    CONSTRAINT ck_venta_monto CHECK (monto_total > 0)
);

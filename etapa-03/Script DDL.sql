
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

-- TABLA: REGISTRO_COMPRA
CREATE TABLE registro_compra (
    registro_compra_id INT IDENTITY(1,1),
    proveedor_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cantidad INT NOT NULL,
    metodo_pago VARCHAR(30) NOT NULL,
    monto_total DECIMAL(12, 2) NOT NULL,
    CONSTRAINT pk_registro_compra PRIMARY KEY (registro_compra_id),
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (proveedor_id)
        REFERENCES proveedor (proveedor_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT fk_compra_producto FOREIGN KEY (producto_id)
        REFERENCES producto (producto_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT ck_compra_cantidad CHECK (cantidad > 0),
    CONSTRAINT ck_compra_monto CHECK (monto_total > 0),
    CONSTRAINT ck_compra_metodo CHECK (metodo_pago IN ('Efectivo', 'Tarjeta_Debito', 'Tarjeta_Credito', 'Transferencia'))
);

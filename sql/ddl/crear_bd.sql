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

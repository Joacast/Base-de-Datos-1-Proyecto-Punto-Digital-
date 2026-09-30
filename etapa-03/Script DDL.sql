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

-- ============================================================================
-- ETAPA III: IMPLEMENTACIÓN FÍSICA
-- SCRIPT DML: POBLADO DE DATOS (10 REGISTROS POR TABLA)
-- BASE DE DATOS: PUNTO DIGITAL (EQUIPO 14)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. TABLA: cliente (10 registros)
-- ----------------------------------------------------------------------------
INSERT INTO cliente (dni_cliente, numero_telefono, calle, localidad, provincia) VALUES
('40112233', '3794111222', 'San Juan 450', 'Corrientes', 'Corrientes'),
('41223344', '3794222333', 'Córdoba 780', 'Corrientes', 'Corrientes'),
('42334455', '3794333444', 'Mendoza 1120', 'Corrientes', 'Corrientes'),
('43445566', '3794444555', 'Salta 630', 'Resistencia', 'Chaco'),
('44556677', '3794555666', 'Bolívar 910', 'Corrientes', 'Corrientes'),
('45667788', '3794666777', 'Belgrano 1340', 'Resistencia', 'Chaco'),
('46778899', '3794777888', 'San Martín 520', 'Corrientes', 'Corrientes'),
('47889900', '3794888999', '25 de Mayo 1680', 'Corrientes', 'Corrientes'),
('48990011', '3794999000', 'Plácido Martínez 820', 'Paso de la Patria', 'Corrientes'),
('49001122', '3794000111', 'Vera 1050', 'Goya', 'Corrientes');

-- ----------------------------------------------------------------------------
-- 2. TABLA: proveedor (10 registros)
-- ----------------------------------------------------------------------------
INSERT INTO proveedor (cuit, razon_social, calle, localidad, provincia) VALUES
('30-71234567-8', 'Distribuidora Tech Corrientes SRL', 'Av. 3 de Abril 1240', 'Corrientes', 'Corrientes'),
('30-71890123-4', 'NEA Mayorista Electrónica', 'Carlos Pellegrini 850', 'Corrientes', 'Corrientes'),
('30-71998877-6', 'Accesorios del Litoral SA', 'Junín 1580', 'Corrientes', 'Corrientes'),
('30-71445566-2', 'Importaciones Norte SA', 'San Lorenzo 1020', 'Resistencia', 'Chaco'),
('30-71556677-3', 'MegaTech Argentina', '9 de Julio 950', 'Corrientes', 'Corrientes'),
('30-71667788-5', 'Global Cables y Conectividad', 'Catamarca 430', 'Resistencia', 'Chaco'),
('30-71778899-7', 'Audio Pro Mayorista', 'Santa Fe 780', 'Corrientes', 'Corrientes'),
('30-71889900-9', 'Vidrios y Protectores NEA', 'Rivadavia 1120', 'Corrientes', 'Corrientes'),
('30-71990011-1', 'Central Gadgets SA', 'España 640', 'Resistencia', 'Chaco'),
('30-71001122-0', 'Electro Corrientes Mayorista', 'Yrigoyen 1430', 'Corrientes', 'Corrientes');

-- ----------------------------------------------------------------------------
-- 3. TABLA: producto (10 registros - Exclusivo Samsung y Apple)
-- ----------------------------------------------------------------------------
INSERT INTO producto (nombre, marca, categoria, color, stock, precio_venta) VALUES
('Galaxy A15 128GB', 'Samsung', 'Smartphones', 'Negro', 15, 280000.00),
('Galaxy S24 256GB', 'Samsung', 'Smartphones', 'Gris Titanio', 8, 1150000.00),
('iPhone 13 128GB', 'Apple', 'Smartphones', 'Azul Medianoche', 10, 890000.00),
('iPhone 15 128GB', 'Apple', 'Smartphones', 'Negro', 6, 1250000.00),
('Funda Clear Case MagSafe iPhone 15', 'Apple', 'Fundas', 'Transparente', 25, 45000.00),
('Funda Silicona Galaxy S24', 'Samsung', 'Fundas', 'Gris', 30, 22000.00),
('Cargador Rápido 25W USB-C', 'Samsung', 'Cargadores', 'Blanco', 25, 28000.00),
('Adaptador de Corriente 20W USB-C', 'Apple', 'Cargadores', 'Blanco', 20, 39000.00),
('Auriculares AirPods 3ra Gen', 'Apple', 'Audio', 'Blanco', 12, 210000.00),
('Auriculares Galaxy Buds FE', 'Samsung', 'Audio', 'Grafito', 14, 115000.00);


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


-- ----------------------------------------------------------------------------
-- 4. TABLA: registro_venta (10 registros actualizados con precios Samsung/Apple)
-- ----------------------------------------------------------------------------
INSERT INTO registro_venta (cliente_id, producto_id, fecha_compra, cantidad, precio_unitario, monto_total) VALUES
(1, 1, '2026-08-01 10:15:00', 1, 280000.00, 280000.00), -- Galaxy A15
(2, 5, '2026-08-02 11:30:00', 1, 45000.00, 45000.00),   -- Funda MagSafe
(3, 2, '2026-08-05 16:00:00', 1, 1150000.00, 1150000.00), -- Galaxy S24
(4, 9, '2026-08-08 17:45:00', 1, 210000.00, 210000.00), -- AirPods 3
(5, 3, '2026-08-10 09:20:00', 1, 890000.00, 890000.00), -- iPhone 13
(6, 7, '2026-08-12 18:10:00', 1, 28000.00, 28000.00),   -- Cargador Samsung
(7, 8, '2026-08-15 12:00:00', 1, 39000.00, 39000.00),   -- Cargador Apple
(8, 6, '2026-08-18 15:30:00', 2, 22000.00, 44000.00),   -- 2 Fundas S24
(9, 10, '2026-08-20 19:15:00', 1, 115000.00, 115000.00), -- Galaxy Buds FE
(10, 4, '2026-08-22 10:50:00', 1, 1250000.00, 1250000.00); -- iPhone 15

-- ----------------------------------------------------------------------------
-- 5. TABLA: registro_compra (10 registros)
-- (Valores de metodo_pago compatibles con el CHECK: 'Efectivo', 'Tarjeta_Debito', 'Tarjeta_Credito', 'Transferencia')
-- ----------------------------------------------------------------------------
INSERT INTO registro_compra (proveedor_id, producto_id, fecha, cantidad, metodo_pago, monto_total) VALUES
(1, 1, '2026-07-10 08:30:00', 10, 'Transferencia', 2100000.00),
(1, 2, '2026-07-11 09:15:00', 5, 'Transferencia', 4600000.00),
(2, 3, '2026-07-12 10:00:00', 8, 'Transferencia', 2080000.00),
(3, 4, '2026-07-15 11:20:00', 50, 'Transferencia', 250000.00),
(8, 5, '2026-07-16 14:00:00', 60, 'Efectivo', 132000.00),
(4, 6, '2026-07-18 15:30:00', 30, 'Transferencia', 540000.00),
(6, 7, '2026-07-20 16:45:00', 40, 'Transferencia', 300000.00),
(7, 8, '2026-07-22 09:00:00', 20, 'Transferencia', 640000.00),
(9, 9, '2026-07-25 11:15:00', 25, 'Efectivo', 225000.00),
(10, 10, '2026-07-28 17:00:00', 15, 'Transferencia', 525000.00);


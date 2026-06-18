/*
==============================================
STR Eventos
Datos iniciales de la base de datos
nombre de la base de datos: "evora"

==============================================
*/
-- ===========================================
-- INSTRUCCIONES 
-- ===========================================
-- 1. Ejecutar este script DESPUÉS de hacer git pull del repositorio
--
-- 2. En phpMyAdmin:
--    - Seleccionar la base de datos "evora"
--    - Ir a la pestaña SQL
--    - Pegar todo este archivo o ejecutar:
--      SOURCE database/inserts.sql;
--
-- 3. Este script:
--    - Limpia todas las tablas necesarias 
--    - Inserta datos de prueba consistentes
--    - Garantiza una misma base de datos

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- LIMPIEZA
-- =====================================================

TRUNCATE TABLE user_event;
TRUNCATE TABLE purchases;
TRUNCATE TABLE incidents;
TRUNCATE TABLE waste;
TRUNCATE TABLE redeemed_reward;
TRUNCATE TABLE tickets;
TRUNCATE TABLE products;
TRUNCATE TABLE reward;
TRUNCATE TABLE events;
TRUNCATE TABLE users;

-- =====================================================
-- USERS
-- =====================================================

INSERT INTO users (id, address, age, city, email, name, password, phone, points, postal_code, role) VALUES
(1,'mostoles',20,'Mostoles','pedro@gmail.com','pedro','1234','637891928',0,'28916','asistente'),
(2,'Calle Mayor 1',35,'Madrid','admin@gmail.com','Admin','1234','600000001',500,'28001','administrador'),
(3,'Gran Via 10',32,'Madrid','admin2@gmail.com','Admin2','1234','600000002',250,'28013','administrador'),
(4,'Calle Toledo 20',26,'Madrid','staff@gmail.com','Staff','1234','600000003',50,'28005','staff'),
(5,'Calle Madrid 15',29,'Getafe','staff2@gmail.com','Staff2','1234','600000004',40,'28901','staff'),
(6,'Calle Serrano 40',30,'Madrid','organizador@gmail.com','Organizador','1234','600000005',100,'28006','organizador'),
(7,'Av. Europa 8',34,'Alcorcon','organizador2@gmail.com','Organizador2','1234','600000006',120,'28922','organizador'),
(8,'Calle Luna 5',22,'Madrid','ana@gmail.com','Ana','1234','600000007',75,'28004','asistente'),
(9,'Calle Rio 12',24,'Mostoles','luis@gmail.com','Luis','1234','600000008',40,'28935','asistente'),
(10,'Calle Sol 8',21,'Fuenlabrada','maria@gmail.com','Maria','1234','600000009',120,'28944','asistente'),
(11,'Calle Norte 3',27,'Leganes','carlos@gmail.com','Carlos','1234','600000010',60,'28911','asistente'),
(12,'Calle Sur 11',23,'Madrid','laura@gmail.com','Laura','1234','600000011',90,'28020','asistente'),
(13,'Calle Centro 7',25,'Getafe','javier@gmail.com','Javier','1234','600000012',30,'28902','asistente'),
(14,'Calle A',24,'Madrid','sergio@gmail.com','Sergio','1234','611111111',80,'28001','asistente'),
(15,'Calle B',21,'Madrid','david@gmail.com','David','1234','611111112',40,'28002','asistente'),
(16,'Calle C',23,'Madrid','lucia@gmail.com','Lucia','1234','611111113',95,'28003','asistente'),
(17,'Calle D',22,'Madrid','paula@gmail.com','Paula','1234','611111114',110,'28004','asistente'),
(18,'Calle E',27,'Getafe','alberto@gmail.com','Alberto','1234','611111115',50,'28901','asistente'),
(19,'Calle F',26,'Mostoles','raul@gmail.com','Raul','1234','611111116',30,'28935','asistente'),
(20,'Calle G',24,'Leganes','elena@gmail.com','Elena','1234','611111117',70,'28911','asistente'),
(21,'Calle H',20,'Madrid','sara@gmail.com','Sara','1234','611111118',120,'28005','asistente'),
(22,'Calle I',25,'Madrid','miguel@gmail.com','Miguel','1234','611111119',150,'28006','asistente'),
(23,'Calle J',23,'Madrid','andrea@gmail.com','Andrea','1234','611111120',60,'28007','asistente'),
(24,'Calle K',22,'Alcorcon','victor@gmail.com','Victor','1234','611111121',80,'28922','asistente'),
(25,'Calle L',24,'Madrid','irene@gmail.com','Irene','1234','611111122',90,'28008','asistente'),
(26,'Calle M',21,'Madrid','jorge@gmail.com','Jorge','1234','611111123',20,'28009','asistente'),
(27,'Calle N',25,'Fuenlabrada','patricia@gmail.com','Patricia','1234','611111124',55,'28944','asistente'),
(28,'Calle O',28,'Madrid','fernando@gmail.com','Fernando','1234','611111125',75,'28010','asistente');

-- =====================================================
-- EVENTS
-- =====================================================

INSERT INTO events (id, active, available, capacity, category, description, event_date, image_url, location, name, ticket_price, organizer_id) VALUES
(1,b'1',15000,15000,'MUSICA','Concierto Dua Lipa','2026-07-20','', 'WiZink Center Madrid','Dua Lipa Live Madrid',65,6),
(2,b'1',12000,12000,'MUSICA','Aitana Tour','2026-08-15','', 'Palau Sant Jordi','Aitana Tour',55,6),
(3,b'1',5000,5000,'VIDEOJUEGOS','Gaming Fest','2026-09-10','', 'IFEMA Madrid','Madrid Gaming Fest',20,7),
(4,b'1',3000,3000,'TECNOLOGIA','Tech Summit','2026-10-05','', 'IFEMA Madrid','Tech Future Summit',35,7),
(5,b'1',4000,4000,'SOSTENIBILIDAD','Festival Verde','2026-09-25','', 'Parque Juan Carlos I','Festival Verde',15,7);

-- =====================================================
-- TICKETS
-- =====================================================

INSERT INTO tickets (id, available, name, price, event_id) VALUES
(1,12000,'Entrada General',65,1),
(2,3000,'Entrada VIP',120,1),
(3,10000,'Entrada General',55,2),
(4,2000,'Entrada VIP',100,2),
(5,4500,'Entrada General',20,3),
(6,3000,'Entrada General',35,4),
(7,4000,'Entrada General',15,5);

-- =====================================================
-- PRODUCTS
-- =====================================================

INSERT INTO products (id, category, description, name, price, stock, event_id) VALUES
(1,'BEBIDA','Coca Cola','Coca Cola',2.5,1000,1),
(2,'BEBIDA','Agua Mineral','Agua Mineral',1.5,2000,1),
(3,'COMIDA','Hamburguesa','Hamburguesa',8,500,1),
(4,'MERCH','Camiseta Dua Lipa','Camiseta Dua Lipa',25,200,1),
(5,'BEBIDA','Monster Energy','Monster Energy',3,600,3),
(6,'COMIDA','Pizza','Pizza',4.5,300,3),
(7,'MERCH','Sudadera Gaming Fest','Sudadera Gaming Fest',35,100,3);

-- =====================================================
-- REWARD
-- =====================================================

INSERT INTO reward (id, active, description, name, points_required) VALUES
(1,b'1','Agua gratis','Botella de agua gratis',20),
(2,b'1','Refresco gratis','Coca Cola gratis',35),
(3,b'1','Descuento','Descuento 5 euros',50),
(4,b'1','Entrada gratis','Entrada gratuita',200),
(5,b'1','Merch','Camiseta oficial',300);

-- =====================================================
-- REDEEMED_REWARD
-- =====================================================

INSERT INTO redeemed_reward (id, qr_code, redeemed_at, used, used_at, reward_id, user_id) VALUES
(1,'RW001','2026-06-18 12:33:43',1,'2026-06-18 12:33:43',1,8),
(2,'RW002','2026-06-18 12:33:43',1,'2026-06-18 12:33:43',2,10),
(3,'RW003','2026-06-18 12:33:43',0,NULL,3,14),
(4,'RW004','2026-06-18 12:33:43',1,'2026-06-18 12:33:43',1,15),
(5,'RW005','2026-06-18 12:33:43',0,NULL,4,21);

-- =====================================================
-- USER_EVENT
-- =====================================================

INSERT INTO user_event (user_id, event_id) VALUES
(1,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),
(14,1),(15,1),(16,1),(17,1),
(18,2),(19,2),(20,2),(21,2),
(22,3),(23,3),(24,3),(25,3),
(26,4),(27,4),
(28,5),
(14,3),(15,3),(16,4),(17,5),
(18,1),(19,4),(20,5);

-- =====================================================
-- PURCHASES
-- =====================================================

INSERT INTO purchases (id, product_name, price, date, used, qr_code, user_id, event_id, ticket_id) VALUES
(1,'Entrada General',65,NOW(),0,'QR001',8,1,1),
(2,'Entrada General',65,NOW(),0,'QR002',9,1,1),
(3,'Entrada VIP',120,NOW(),0,'QR003',10,1,2),
(4,'Entrada General',55,NOW(),0,'QR004',18,2,3),
(5,'Entrada VIP',100,NOW(),0,'QR005',19,2,4),
(6,'Entrada General',20,NOW(),0,'QR006',22,3,5),
(7,'Entrada General',20,NOW(),0,'QR007',23,3,5),
(8,'Entrada General',35,NOW(),0,'QR008',26,4,6),
(9,'Entrada General',15,NOW(),0,'QR009',28,5,7),
(10,'Coca Cola',2.5,NOW(),1,'QR010',8,1,NULL),
(11,'Hamburguesa',8,NOW(),1,'QR011',9,1,NULL),
(12,'Monster Energy',3,NOW(),1,'QR012',22,3,NULL);

-- =====================================================
-- INCIDENTS
-- =====================================================

INSERT INTO incidents (id, date, description, points_penalty, status, title, type, event_id, staff_id, user_id) VALUES
(1,'2026-06-18 12:35:55','Residuo incorrecto',10,'RESUELTA','Basura fuera de zona','RESIDUO',1,4,8),
(2,'2026-06-18 12:35:55','Acceso zona privada',20,'PENDIENTE','Acceso restringido','SEGURIDAD',3,5,22),
(3,'2026-06-18 12:35:55','Conducta no permitida',15,'RESUELTA','Conducta inapropiada','COMPORTAMIENTO',2,4,18);

-- =====================================================
-- WASTE
-- =====================================================

INSERT INTO waste (id, date, location, qr_code, recycled, type, event_id, user_id) VALUES
(1,'2026-06-18 12:34:05','WiZink Center','WS001',1,'PLASTICO',1,8),
(2,'2026-06-18 12:34:05','WiZink Center','WS002',1,'PLASTICO',1,9),
(3,'2026-06-18 12:34:05','IFEMA Madrid','WS003',1,'PAPEL',3,22),
(4,'2026-06-18 12:34:05','IFEMA Madrid','WS004',1,'VIDRIO',3,23),
(5,'2026-06-18 12:34:05','Parque Juan Carlos I','WS005',0,'PLASTICO',5,28);

SET FOREIGN_KEY_CHECKS = 1;
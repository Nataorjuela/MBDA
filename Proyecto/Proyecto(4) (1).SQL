
DROP TABLE PERSONA;
DROP TABLE CLIENTE;
DROP TABLE EMPLEADO;
DROP TABLE MASCOTA;
DROP TABLE TOMA;
DROP TABLE SERVICIO;
DROP TABLE GUARDERIA;
DROP TABLE BAÑO;
DROP TABLE VENTAPRODUCTO;
DROP TABLE FACTURA;
DROP TABLE ESDE;
DROP TABLE PROVEEDOR;
DROP TABLE PRODUCTO;
DROP TABLE PROVEEN;

/*TABLAS-ATRIBUTOS*/

CREATE TABLE PERSONA(NumDoc NUMBER(15)NOT NULL,NOMBRE VARCHAR2(50) NOT NULL,CELULAR NUMBER(15)NOT NULL,DIRECCION VARCHAR2(50)NOT NULL,CORREO VARCHAR2(50),FECHANACIMIENTO TIMESTAMP NOT NULL, EDAD NUMBER NOT NULL);
CREATE TABLE CLIENTE(IDCLIENTE NUMBER(15)NOT NULL,IDMASCOTA VARCHAR(6) NOT NULL,BONODESCUENTO NUMBER,BONOBAÑO NUMBER);
CREATE TABLE EMPLEADO(IDEMPLEADO NUMBER(15)NOT NULL, CARGO VARCHAR2(1)NOT NULL);
CREATE TABLE MASCOTA(IDMASCOTA VARCHAR(6) NOT NULL,NOMBRE VARCHAR2(20),RAZA VARCHAR2(50)NOT NULL, SEXO VARCHAR2(1)NOT NULL,PESO NUMBER(4,2)NOT NULL,EDAD NUMBER(2)NOT NULL,ALERGIAS VARCHAR(2));
CREATE TABLE TOMA(IDMASCOTA VARCHAR(6) NOT NULL, IDSERVICIO VARCHAR(1) NOT NULL);
CREATE TABLE SERVICIO(IDSERVICIO VARCHAR(3) NOT NULL,IDEMPLEADO NUMBER(15)NOT NULL,IDMASCOTA VARCHAR2(6)NOT NULL,IDFACTURA NUMBER(8)NOT NULL);
CREATE TABLE GUARDERIA(IDGUARDERIA VARCHAR(1) NOT NULL,IDMASCOTA NUMBER(8) NOT NULL,TIEMPOPASEO NUMBER(2)NOT NULL,FECHAINGRESO TIMESTAMP NOT NULL,FECHASALIDA TIMESTAMP NOT NULL,DESCRIPCION VARCHAR2(100));
CREATE TABLE BAÑO(IDBAÑO VARCHAR(1) NOT NULL,IDMASCOTA NUMBER(8) NOT NULL,FECHA TIMESTAMP NOT NULL,ANESTECIA VARCHAR2(2)NOT NULL,DESCRIPCION VARCHAR2(100));
CREATE TABLE VENTAPRODUCTO(IDVENTA VARCHAR(1) NOT NULL,NOMBREPR VARCHAR2(20)NOT NULL, IDPRODUCTO NUMBER(8) NOT NULL,CANTIDAD NUMBER NOT NULL,FECHA TIMESTAMP NOT NULL,PRECIO NUMBER NOT NULL);
CREATE TABLE FACTURA(IDFACTURA NUMBER(8)NOT NULL,COSTODERIVADO NUMBER(8,2)NOT NULL, BONODESCUENTO NUMBER,BONOBAÑO NUMBER,fecha TIMESTAMP NOT NULL);
CREATE TABLE ESDE (IDFACTURA NUMBER(8), IDCLIENTE NUMBER(8));
CREATE TABLE PROVEEDOR(IDPROVEEDOR NUMBER(10) NOT NULL,IDPRODUCTO VARCHAR(6) NOT NULL, NOMBRE VARCHAR2(20));
CREATE TABLE PRODUCTO(IDPRODUCTO VARCHAR(6) NOT NULL,PRECIO NUMBER NOT NULL,NOMBRE VARCHAR2(20)NOT NULL,CANTIDAD NUMBER NOT NULL);
CREATE TABLE PROVEEN(IDPROVEEDOR NUMBER(10) NOT NULL,IDPRODUCTO VARCHAR(6) NOT NULL);

/*Primarias*/
ALTER TABLE Persona ADD CONSTRAINT PK_Persona
PRIMARY KEY (NumDoc);
ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente
PRIMARY KEY (idCliente);
ALTER TABLE Cliente ADD CONSTRAINT PK_Bonodescuento
PRIMARY KEY (Bonodescuento);
ALTER TABLE Cliente ADD CONSTRAINT PK_Bonobaño
PRIMARY KEY (Bonobaño);
ALTER TABLE Empleado ADD CONSTRAINT PK_Empleado
PRIMARY KEY (idEmpleado);
ALTER TABLE Mascota ADD CONSTRAINT PK_Mascota
PRIMARY KEY (idMascota);
ALTER TABLE TOMA ADD CONSTRAINT PK_Toma 
PRIMARY KEY (idFactura,idCliente);
ALTER TABLE Servicio ADD CONSTRAINT PK_Servicio
PRIMARY KEY (idServicio);
ALTER TABLE Guarderia ADD CONSTRAINT PK_Guarderia
PRIMARY KEY (idGuarderia);
ALTER TABLE Baño ADD CONSTRAINT PK_Guarderia
PRIMARY KEY (idBaño);
ALTER TABLE VentaProducto ADD CONSTRAINT PK_VentaProducto
PRIMARY KEY (idVenta);
ALTER TABLE Factura ADD CONSTRAINT PK_Factura
PRIMARY KEY (idFactura);
ALTER TABLE EsDE ADD CONSTRAINT PK_EsDe 
PRIMARY KEY (idFactura,idCliente);
ALTER TABLE Proveedor ADD CONSTRAINT PK_Proveedor
PRIMARY KEY (idProveedor);
ALTER TABLE Producto ADD CONSTRAINT PK_Producto
PRIMARY KEY (idproducto);
ALTER TABLE Proveen ADD CONSTRAINT PK_Proveen
PRIMARY KEY (idProveedor,idproducto);

/*Foraneas*/

ALTER TABLE Empleado ADD CONSTRAINT FK_Empleado FOREIGN KEY (idEmpleado) REFERENCES Persona (NumDoc);
ALTER TABLE Cliente ADD CONSTRAINT FK_Cliente FOREIGN KEY (idCliente) REFERENCES Persona (NumDoc);
ALTER TABLE Cliente ADD CONSTRAINT FK_Clientemascota FOREIGN KEY (idmascota) REFERENCES Mascota(idmascota);
ALTER TABLE Servicio ADD CONSTRAINT FK_servicioempleado FOREIGN KEY (idempleado) REFERENCES Empleado(idempleado);
ALTER TABLE Servicio ADD CONSTRAINT FK_serviciomascota FOREIGN KEY (idmascota) REFERENCES Mascota(idmascota);
ALTER TABLE Servicio ADD CONSTRAINT FK_serviciofactura FOREIGN KEY (idfactura) REFERENCES Factura(idfactura);
ALTER TABLE Guarderia ADD CONSTRAINT FK_Guarderia FOREIGN KEY (idGuarderia) REFERENCES Servicio (idServicio);
ALTER TABLE Guarderia ADD CONSTRAINT FK_guarderiamascota FOREIGN KEY(idmascota) REFERENCES mascota(idmascota);
ALTER TABLE VentaProducto ADD CONSTRAINT FK_VentaProducto FOREIGN KEY (idventa) REFERENCES Servicio (idServicio);
ALTER TABLE VentaProducto ADD CONSTRAINT FK_VentaProductoProducto FOREIGN KEY (idproducto) REFERENCES Producto (idproducto);
ALTER TABLE Baño ADD CONSTRAINT FK_baño FOREIGN KEY (idbaño) REFERENCES Servicio(idservicio);
ALTER TABLE Baño ADD CONSTRAINT FK_bañomascota FOREIGN KEY  (idmascota) REFERENCES Mascota(idmascota);
ALTER TABLE proveen ADD CONSTRAINT FK_proveenproveedor FOREIGN KEY (idproveedor) REFERENCES Proveedor (idproveedor);
ALTER TABLE proveen ADD CONSTRAINT FK_proveen FOREIGN KEY (idproducto) REFERENCES Producto (idproducto);
ALTER TABLE proveedor ADD CONSTRAINT FK_proveedor FOREIGN KEY (idproducto) REFERENCES Producto (idproducto);
ALTER TABLE Factura ADD CONSTRAINT FK_facturaBonoDescuento FOREIGN KEY(BonoDescuento) REFERENCES Cliente(BonoDescuento);
ALTER TABLE Factura ADD CONSTRAINT FK_facturaBonoBaño FOREIGN KEY(BonoBaño) REFERENCES Cliente(BonoBaño);
ALTER TABLE Toma ADD CONSTRAINT FK_TomaServicio FOREIGN KEY(idservicio) REFERENCES Servicio(idservicio);
ALTER TABLE Toma ADD CONSTRAINT FK_TomaMascota FOREIGN KEY (idmascota) REFERENCES Mascota(idmascota);
ALTER TABLE EsDe ADD CONSTRAINT FK_EsDefactura FOREIGN KEY (idFactura) REFERENCES Factura(idfactura);
ALTER TABLE EsDe ADD CONSTRAINT FK_EsDeclienre FOREIGN KEY (idcliente) REFERENCES Cliente(idcliente);

-- Unique Keys 

ALTER TABLE Persona ADD CONSTRAINT UK_Celular UNIQUE(celular);
ALTER TABLE Persona ADD CONSTRAINT UK_CORREO UNIQUE(correo);
ALTER TABLE Persona ADD CONSTRAINT UK_DIRECCION UNIQUE(direccion);

/* Tuplas*/

--verificar que la persona sea mayor de edad

ALTER TABLE Persona ADD CONSTRAINT CK_Verifedad CHECK (edad >=18 and NumDoc >1000000 );

--verficar que la fecha de salida sea despues que la fecha de ingreso 

ALTER TABLE Guaderia ADD CONSTRAINT CK_Verifecha CHECK (fechasalida > fechaingreso);

--verificar que el id de la mascota inicie por PET Y este seguido por un numero

ALTER TABLE Mascota ADD CONSTRAINT CK_verifid CHECK (idmascota like '%pet_%');

--Verificar que la edad y el peso de la mascota sea mayor a 0

ALTER TABLE Mascota ADD CONSTRAINT CKverifpeso_edad CHECK(peso>0 and edad>0);

--verificar que el id de la persona inicia por G o B o V y este seguido por un numero

ALTER TABLE Mascota ADD CONSTRAINT CK_verifidservicio CHECK (idservicio like '%G_%'or  idservicio like '%B_%' or idservicio Like '%V_%');

/* Tuplas Ok*/

INSERT INTO PERSONA VALUES(1010247478,'Natalia Orjuela',32168710084,'CARRERA 7 #9-86','NATA@HOTMAIL.COM',TO_DATE('1999/09/08','YYYY/MM/DD'),20);
INSERT INTO Guarderia VALUES('G01','PET1',60,TO_DATE('2019/09/26','YYYY/MM/DD'),TO_DATE('2019/09/28','YYYY/MM/DD'),NULL);
INSERT INTO Mascota VALUES('PET1','TEDDY','schnauzer','M',6,3,NULL);

/*Tuplas NoOK*/

--SE VERIFICA QUE LA EDAD DEBE SER MAYOR A 18
INSERT INTO PERSONA VALUES(1234,'TEOFILO PEREZ',350765893,'CARRERA 7 #8-74','TEO@HOTMAIL.COM',TO_DATE('2002/08/26','YYYY/MM/DD'),17);
--SE VERIFICA QUE LA FECHA DE INGRESO SEA ANTES QUE LA FECHA DE SALIDA
INSERT INTO GUARDERIA VALUES('G01','PET1',60,TO_DATE('2019/09/26','YYYY/MM/DD'),TO_DATE('2019/09/20','YYYY/MM/DD'),NULL);
--SE VERIFICA QUE EL ID DE MASTOCA DEBE COMENZAR CON PET Y LLEVAR UN NUMERO
INSERT INTO MASCOTA VALUES ('MASC2','KENAI','ALASKAN MALAMUTE','M',6,4,NULL);

/*ACCIONES*/

ALTER TABLE Empleado DROP CONSTRAINT FK_Empleado;
ALTER TABLE Cliente DROP CONSTRAINT FK_Cliente;
ALTER TABLE Cliente DROP CONSTRAINT FK_Clientemascota;
ALTER TABLE Servicio DROP CONSTRAINT FK_servicioempleado;
ALTER TABLE Servicio DROP CONSTRAINT FK_serviciomascota;
ALTER TABLE Servicio DROP CONSTRAINT FK_serviciofactura;
ALTER TABLE Guarderia DROP CONSTRAINT FK_Guarderia;
ALTER TABLE Guarderia DROP CONSTRAINT FK_guarderiamascota;
ALTER TABLE VentaProducto DROP CONSTRAINT FK_VentaProducto;
ALTER TABLE VentaProducto DROP CONSTRAINT FK_VentaProductoProducto;
ALTER TABLE Baño DROP CONSTRAINT FK_baño;
ALTER TABLE Baño DROP CONSTRAINT FK_bañomascota;
ALTER TABLE proveen DROP CONSTRAINT FK_proveenproveedor;
ALTER TABLE proveen DROP CONSTRAINT FK_proveen;
ALTER TABLE proveedor DROP CONSTRAINT FK_proveedor;
ALTER TABLE Factura DROP CONSTRAINT FK_facturabonodescuento;
ALTER TABLE Factura DROP CONSTRAINT FK_facturabonobaño;
ALTER TABLE Toma DROP CONSTRAINT FK_TomaServicio;
ALTER TABLE Toma DROP CONSTRAINT FK_TomaMascota;
ALTER TABLE EsDe DROP CONSTRAINT FK_EsDeFactura;
ALTER TABLE EsDe DROP CONSTRAINT FK_EsDeCliente;


ALTER TABLE Empleado ADD CONSTRAINT FK_Empleado FOREIGN KEY (idEmpleado) REFERENCES Persona (NumDoc) ON DELETE CASCADE;
ALTER TABLE Cliente ADD CONSTRAINT FK_Cliente FOREIGN KEY (idCliente) REFERENCES Persona (NumDoc)ON DELETE CASCADE;
ALTER TABLE Cliente ADD CONSTRAINT FK_Clientemascota FOREIGN KEY(idmascota) references Mascota(idmascota)ON DELETE CASCADE;
ALTER TABLE Servicio ADD CONSTRAINT FK_servicioempleado FOREIGN KEY(idempleado) references Empleado(idempleado)ON DELETE CASCADE;
ALTER TABLE Servicio ADD CONSTRAINT FK_serviciomascota  FOREIGN KEY(idmascota) references Mascota(idmascota)ON DELETE CASCADE;
ALTER TABLE Servicio ADD CONSTRAINT FK_serviciofactura FOREIGN KEY(idfactura) references Factura(idfactura)ON DELETE CASCADE;
ALTER TABLE Guarderia ADD CONSTRAINT FK_Guarderia FOREIGN KEY (idGuarderia) REFERENCES Servicio (idServicio)ON DELETE CASCADE;
ALTER TABLE VentaProducto ADD CONSTRAINT FK_VentaProducto FOREIGN KEY (idventa) REFERENCES Servicio (idServicio)ON DELETE CASCADE;
ALTER TABLE VentaProducto ADD CONSTRAINT FK_VentaProductoProducto FOREIGN KEY (idproducto) REFERENCES Producto (idproducto)ON DELETE CASCADE;
ALTER TABLE Guarderia ADD CONSTRAINT FK_guarderimascota foreign key(idmascota) references Mascota(idmascota)ON DELETE CASCADE;
ALTER TABLE Baño ADD CONSTRAINT FK_baño foreign key(idbaño) references Servicio(idservicio)ON DELETE CASCADE;
ALTER TABLE Bano ADD CONSTRAINT FK_bañomascota foreign key(idmascota) references Mascota(idmascota)ON DELETE CASCADE;
ALTER TABLE proveen ADD CONSTRAINT FK_proveenproveedor FOREIGN KEY (idproveedor) REFERENCES Proveedor (idproveedor)ON DELETE CASCADE;
ALTER TABLE proveen ADD CONSTRAINT FK_proveen FOREIGN KEY (idproducto) REFERENCES Producto (idproducto)ON DELETE CASCADE;
ALTER TABLE proveedor ADD CONSTRAINT FK_proveedor FOREIGN KEY (idproducto) REFERENCES Producto (idproducto)ON DELETE CASCADE;
ALTER TABLE Factura ADD CONSTRAINT FK_bonodescuento FOREIGN KEY(bonodescuento) references Cliente(bonodescuento)ON DELETE CASCADE;
ALTER TABLE Factura ADD CONSTRAINT FK_bonobaño FOREIGN KEY(bonobaño) references Cliente(bonobaño)ON DELETE CASCADE;
ALTER TABLE Toma ADD CONSTRAINT FK_TomaServicio FOREIGN KEY(idservicio) REFERENCES Servicio(idservicio)ON DELETE CASCADE;
ALTER TABLE Toma ADD CONSTRAINT FK_TomaMascota FOREIGN KEY(idmascota) REFERENCES Mascota(idmascota) ON DELETE CASCADE;
ALTER TABLE EsDe ADD CONSTRAINT FK_EsDeFactura FOREIGN KEY(idfactura) REFERENCES Factura(idfactura)ON DELETE CASCADE;
ALTER TABLE EsDe ADD CONSTRAINT FK_EsDeCliente FOREIGN KEY(idcliente) REFERENCES Cliente(idcliente )ON DELETE CASCADE;

ALTER TABLE Persona DROP CONSTRAINT CK_Verifedad ;
ALTER TABLE Guaderia DROP CONSTRAINT CK_Verifecha ;
ALTER TABLE Mascota DROP CONSTRAINT CK_verifid;
ALTER TABLE Mascota DROP CONSTRAINT CK_verifpeso_edad;
ALTER TABLE Servicio DROP CONSTRAINT CK_verifidservicio;

--ACCIONESOK

 DELETE FROM Persona WHERE NumDoc=1010247478;
 DELETE FROM Factura WHERE idfactura=2569;
 DELETE FROM Mascota WHERE Nombre='teddy';
 DELETE FROM Empleado WHERE idempleado=35968452;
 DELETE FROM Servicio WHERE idservicio='G';
 DELETE FROM Producto WHERE nombre='PLACA';
 DELETE FROM Baño WHERE idbaño=2589;
 DELETE FROM Cliente WHERE nombre='NATALIA ORJUELA';


/*POBLAROK*/

insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('9849824239', 'Inness', '8936784579', '114 Judy Plaza', 'imacairt0@google.pl', '9/13/2019', 32);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('7878023395', 'Juline', '6766751416', '15424 Iowa Pass', 'jchafney1@wikia.com', '12/24/2018', 54);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('2965626921', 'Kalli', '2382920601', '3567 Veith Pass', 'kbubbear2@phoca.cz', '4/28/2019', 40);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('4563278432', 'Dani', '7361499961', '395 Miller Drive', 'dslayton3@qq.com', '1/19/2019', 58);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('9429547852', 'Cazzie', '9068529118', '1 Prairieview Park', 'cgale4@list-manage.com', '12/5/2018', 29);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('5429145238', 'Alanson', '9433643655', '495 Center Place', 'awhitcher5@blog.com', '12/9/2018', 36);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('0548513627', 'Haleigh', '5462199100', '1 Carey Park', 'hkeavy6@issuu.com', '2/28/2019', 34);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('9768475056', 'Phillis', '5967455250', '25784 John Wall Junction', 'plittrell7@whitehouse.gov', '1/1/2019', 59);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('6371466631', 'Margeaux', '3801558609', '4 Shopko Lane', 'moneal8@chron.com', '3/30/2019', 18);
insert into PERSONA (NumDoc, Nombre, Celular, Direccion, Correo, FechaNacimiento, Edad) values ('0851199712', 'Devondra', '2546937136', '26795 Ruskin Plaza', 'dwalsham9@cocolog-nifty.com', '9/16/2019', 19);

insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (7878023395, 'PET1', 191166, 171865);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (942954785, 'PET2', 160268, 182596);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (9768475056, 'PET3', 107839, 17551);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (6371466631, 'PET4', 92887, 21952);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (1202832767, 'PET5', 114957, 166411);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (1247899074, 'PET6', 141496, 148041);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (7458400585, 'PET7', 192368, 197749);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (1084903855, 'PET8', 13176, 124376);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (0485730385, 'PET9', 132226, 143982);
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (8849303785, 'PET10', 110863, 55215);

insert into EMPLEADO (IDEMPLEADO, CARGO) values (1158039765, 'E');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (4321379876, 'E');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (4016449879, 'E');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (3408857896, 'A');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (9849824239, 'E');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (2965626921, 'V');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (5429145238, 'P');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (9768475056, 'A');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (0851199712, 'E');
insert into EMPLEADO (IDEMPLEADO, CARGO) values (1180918897, 'V');

insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET9', 'Quinton', 'DALMATA', 'F', 19, 13, 'NO');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET7', 'Mark', 'SCHNAUZER', 'F', 37, 13, 'NO');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET2', 'Boycey', 'DALMATA', 'M', 17, 8, 'SI');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET8', 'Merwyn', 'PITBULL', 'F', 49, 3, 'SI');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET9', 'Ronny', 'DALMATA', 'F', 14, 13, 'NO');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET4', 'Saw', 'SCHNAUZER', 'F', 33, 10, 'SI');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET7', 'Gearard', 'SCHNAUZER', 'F', 28, 12, 'SI');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET8', 'Stan', 'PITBULL', 'M', 21, 7, 'NO');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET4', 'Hilliard', 'SCHNAUZER', 'M', 24, 11, 'NO');
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET6', 'Kelby', 'PITBULL', 'M', 26, 13, 'SI');


insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET6', 'G01');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET1', 'B01');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET8', 'G02');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET4', 'B02');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET5', 'B03');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET2', 'G03');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET10', 'G04');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET9', 'B04');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET3', 'V01');
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET7', 'G05');

insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('B', 45, 'PET1', 123456);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('V', 2, 'PET2', 234567);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('G', 82, 'PET3', 345678);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('B', 69, 'PET4', 456789);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('V', 12, 'PET5', 567890);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('V', 73, 'PET6', 678901);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('G', 3, 'PET7', 7890123);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('G', 4, 'PET8', 8901234);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('V', 89, 'PET9',9011234);
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('B', 59, 'PET10',1012345);

insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET11', 38, '2/24/2019', '7/10/2019', 'NULL');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET2', 113, '10/7/2019', '1/21/2019', 'NULL');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET13', 83, '5/6/2019', '4/4/2019', 'NULL');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET14', 37, '6/2/2019', '6/5/2019', 'CEPILLAR');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET15', 81, '1/21/2019', '5/8/2019', 'LAVAR DIENTES');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET6', 102, '5/16/2019', '6/26/2019', 'CEPILLAR');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET7', 57, '7/16/2019', '10/1/2019', 'CEPILLAR');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET8', 30, '4/7/2019', '6/17/2019', 'ALERGIA AL CHOCOLATE');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET19', 120, '6/5/2019', '6/30/2019', 'LAVAR DIENTES');
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET10', 90, '10/12/2019', '5/18/2019', 'NULL');

insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET1', '1/25/2019', 'SI', 'BAÑAR DIENTES');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET22', '3/19/2019', 'NO', 'APLICAR ANTIPULGAS');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET23', '5/1/2019', 'SI', 'BAÑAR DIENTES');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET4', '12/1/2019', 'SI', 'NULL');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET5', '4/17/2019', 'NO', 'APLICAR PERFUME');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET26', '6/3/2019', 'NO', 'APLICAR ANTIPULGAS');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET27', '3/7/2019', 'SI', 'APLICAR ANTIPULGAS');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET28', '9/22/2019', 'NO', 'NULL');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET29', '12/15/2018', 'NO', 'APLICAR PERFUME');
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET21', '8/21/2019', 'NO', 'APLICAR ANTIPULGAS');

insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V01', 'COMIDA', 599, 10, '8/20/2019', 34092);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V02', 'CORREA', 403, 8, '8/1/2019', 218660);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V03', 'BUSO', 545, 15, '4/11/2019', 228426);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V04', 'COMIDA', 468, 8, '1/8/2019', 224101);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V05', 'BUSO', 284, 16, '10/27/2019', 194325);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V06', 'PLATO', 895, 6, '7/1/2019', 215119);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V07', 'BUSO', 884, 11, '9/16/2019', 27965);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V08', 'CAMA', 326, 10, '3/5/2019', 277336);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V09', 'PLATO', 958, 1, '2/14/2019', 202920);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V10', 'PLATO', 962, 19, '7/26/2019', 297115);

insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (17383, 161841, 12099, 136247, '7/16/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (28297, 163863, 75669, 71913, '4/13/2019');
insert into FACTURA(IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (37503, 242871, 122068, 72260, '4/30/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (4974, 214530, 11883, 185602, '9/13/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (58543, 294660, 184420, 196281, '1/12/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (686865, 157841, 158976, 132607, '3/25/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (78743, 34668, 106101, 194030, '8/17/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (89763, 255276, 21734, 40792, '2/20/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (90624, 148086, 124839, 21383, '5/15/2019');
insert into FACTURA (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (10374, 23084, 19432, 76667, '12/13/2018');

insert into ESDE (IDFACTURA, IDCLIENTE) values (17383, 7878023395);
insert into ESDE (IDFACTURA, IDCLIENTE) values (28297, 942954785);
insert into ESDE (IDFACTURA, IDCLIENTE) values (37503, 9768475056);
insert into ESDE (IDFACTURA, IDCLIENTE) values (4974, 6371466631);
insert into ESDE (IDFACTURA, IDCLIENTE) values (58543, 1202832767);
insert into ESDE (IDFACTURA, IDCLIENTE) values (686865, 1247899074);
insert into ESDE (IDFACTURA, IDCLIENTE) values (78743, 7458400585);
insert into ESDE (IDFACTURA, IDCLIENTE) values (89763, 1084903855);
insert into ESDE (IDFACTURA, IDCLIENTE) values (90624, 0485730385);
insert into ESDE (IDFACTURA, IDCLIENTE) values (10374, 8849303785);

insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (12345, 'CHUNKY');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (28395, 'DOG CHOW');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (34948, 'MUNDO MASCOTA');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (45930, 'KANU');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (50362, 'MONELLO');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (63468, 'PROPLAN');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (75929, 'HILLS');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (89036, 'I AM MASCOTA');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (95639, 'TOTAL MAX');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (10408, 'ROYAL CANIN');

insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR3', 25165, 'PLATO', 4);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR1', 96841, 'COMIDA CHUNKY', 5);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR2', 103357, 'COLLAR', 4);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR4', 112886, 'BUSO', 10);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR7', 95843, 'COMIDA MONELLO', 4);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR2', 69000, 'COLLAR', 1);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR6', 174246, 'COMIDA DOG CHOW', 3);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR8', 101416, 'COMIDA PROPLAN', 10);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR4', 182535, 'BUSO', 7);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR5', 21734, 'HUESO', 10);

insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (12345,'PR1');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (28395,'PR6');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (34948,'PR3');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (45930,'PR5');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (50362,'PR7');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (63468,'PR8');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (34948,'PR2');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (89036,'PR4');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (34948,'PR2');
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (89036,'PR4');

/*PoblarNoOK*/

--Se verifica que el Numero de Documento no sea una cadena
INSERT INTO PERSONA VALUES(HJSD125,'TEOFILO PEREZ',32087965,'CARRERA 7 #8-74','TEO@HOTMAIL.COM',TO_DATE('1995/08/26','YYYY/MM/DD'),18);
--Se verifica que la persona sea mayor de 18 años
INSERT INTO PERSONA VALUES(3928565120,'DANIEL GOMEZ',320863782,'CALLE 150 #65-25','DANIPOVEDA45@HOTMAIL.COM',TO_DATE('1995/08/26','YYYY/MM/DD'),15);

--Se verifica que el id de la mascota debe iniciar con PET y seguido de un numero
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values (7878023395, '12345', 191166, 171865);
--Se verifica que el id del cliente debe ser el numero del documento
insert into CLIENTE (IDCLIENTE, IDMASCOTA, BONODESCUENTO, BONOBAÑO) values ('natdkie', 'PET2', 160268, 0);

--Se verifica que el cargo cumpla con las iniciales P,V,E,A
insert into EMPLEADO (IDEMPLEADO, CARGO) values (1158039765, 'D');
--Se verifica que el id del empleado sea el numero de documento
insert into EMPLEADO (IDEMPLEADO, CARGO) values ('empleado11', 'E');

--Se verifica que el id de la mascota tenga un numero 
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET', 'Quinton', 'DALMATA', 'F', 6, 8, 'NO');
--Se verifica que el peso de la mascota sea mayor a 0
insert into MASCOTA (IDMASCOTA, NOMBRE, RAZA, SEXO, PESO, EDAD, ALERGIAS) values ('PET7', 'Mark', 'SCHNAUZER', 'F', 0, 5, 'NO');

--Se verifica que el id de la mascota sea una cadena con inicio PET y seguido por un numero
insert into TOMA (IDMASCOTA, IDSERVICIO) values (1345, 'G07');
--Se verifica que el id del servicio cumpla con una cadena con inicio G, B,V seguido por un numero.
insert into TOMA (IDMASCOTA, IDSERVICIO) values ('PET1', 'B');

--Se verifica que el id de la factura sean numeros
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('B01', 45, 'PET1', 'factura1');
--Se verifica que el id del empleado sea un numero
insert into SERVICIO (IDSERVICIO, IDEMPLEADO, IDMASCOTA, IDFACTURA) values ('V', 'Emp1', 'PET2', 234567);

--Se verifica que el id guarderia lleve un numero
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G', 'PET11', 38, '2/24/2019', '7/10/2019', 'NULL');
--Se verifica que la descripcion debe ser un texto
insert into GUARDERIA (IDGUARDERIA, IDMASCOTA, TIEMPOPASEO, FECHAINGRESO, FECHASALIDA, DESCRIPCION) values ('G04', 'PET2', 113, '10/7/2019', '1/21/2019', 1832);

--Se verifica que el id bano lleve un numero
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B', 'PET1', '1/25/2019', 'SI', 'BAÑAR DIENTES');
--Se verifica que la anestecia sea un booleano SI o No
insert into BAÑO (IDBAÑO, IDMASCOTA, FECHA, ANESTECIA, DESCIPCION) values ('B04', 'PET22', '3/19/2019', 12, 'APLICAR ANTIPULGAS');


insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V', 'COMIDA', 599, 10, '8/20/2019', 34092);
insert into VENTAPRODUCTO (IDVENTA, NOMBREPR, IDPRODUCTO, CANTIDAD, FECHA, PRECIO) values ('V', 'CORREA', 403, 8, '8/1/2019', 218660);

insert into VENTAPRODUCTO (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (1, 161841, 12099, 136247, '7/16/2019');
insert into VENTAPRODUCTO (IDFACTURA, COSTODERIVADO, BONODESCUENTO, BONOBAÑO, FECHA) values (2, 163863, 75669, 71913, '4/13/2019');


insert into ESDE (IDFACTURA, IDCLIENTE) values (1, 7878023395);
insert into ESDE (IDFACTURA, IDCLIENTE) values (2, 942954785);


insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (12345, 'CHUNKY');
insert into PROVEEDOR (IDPROVEEDOR, NOMBRE) values (28395, 'DOG CHOW');


insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR3', 25165, 'PLATO', 4);
insert into PRODUCTO (IDPRODUCTO, PRECIO, NOMBRE, CANTIDAD) values ('PR1', 96841, 'COMIDA CHUNKY', 5);

--Se verifica que el id del proveedor sea un numero
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values ('abcd','PR6');
--Se verifica que el id del producto lleve un numero
insert into PROVEEN(IDPROVEEDOR,IDPRODUCTO) values (28395,'P');

/*XPoblar*/

DELETE FROM PROVEEN;
DELETE FROM PRODUCTO;
DELETE FROM PROVEEDOR;
DELETE FROM ESDE;
DELETE FROM VENTAPRODUCTO;
DELETE FROM BAÑO;
DELETE FROM GUARDERIA;
DELETE FROM SERVICIO;
DELETE FROM TOMA;
DELETE FROM MASCOTA;
DELETE FROM EMPLEADO;
DELETE FROM CLIENTE;
DELETE FROM FACTURA;
DELETE FROM PERSONA;


/* Triggers */

-- Automatiza el id de las mascotas

CREATE OR REPLACE TRIGGER id_mascota
BEFORE INSERT ON Mascota
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idmascota) into actual from Mascota;
        :new.idmascota := actual + 1;
END id_mascota;
/

-- Automatiza el id de las facturas

CREATE OR REPLACE TRIGGER id_facturas
BEFORE INSERT ON Factura
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idfactura) into actual from Factura;
        :new.idfactura := actual + 1;
END id_facturas;
/
--Autimatiza el id del cliente
CREATE OR REPLACE TRIGGER id_cliente
BEFORE INSERT ON Cliente
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idcliente) into actual from Cliente;
        :new.idcliente := actual + 1;
END id_cliente;
/
--Automatiza el id del empleado 
CREATE OR REPLACE TRIGGER id_empleado
BEFORE INSERT ON empleado
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idempleado) into actual from empleado;
        :new.idempleado := actual + 1;
END id_empleado;
/
--Automatiza el id del servicio
CREATE OR REPLACE TRIGGER id_servicio
BEFORE INSERT ON servicio
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idservicio) into actual from servicio;
        :new.idservicio := actual + 1;
END id_servicio;
/
--Automatiza el id de venta
CREATE OR REPLACE TRIGGER id_ventaproducto
BEFORE INSERT ON ventaproducto
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idventa) into actual from ventaproducto;
        :new.idventa := actual + 1;
END id_ventaproducto;
/
--Automatiza el id de proveedor
CREATE OR REPLACE TRIGGER id_proveedor
BEFORE INSERT ON proveedor
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idproveedor) into actual from proveedor;
        :new.idproveedor := actual + 1;
END id_proveedor;
/
--Automatiza el id de producto
CREATE OR REPLACE TRIGGER id_producto
BEFORE INSERT ON producto
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idproducto) into actual from proveen;
        :new.idproducto:= actual + 1;
END id_producto;
/
--Automatiza el id de baño
CREATE OR REPLACE TRIGGER id_baño
BEFORE INSERT ON baño
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idbaño) into actual from baño;
        :new.idbaño := actual + 1;
END id_baño;
/
--Automatiza el id de guarderia
CREATE OR REPLACE TRIGGER id_guarderia
BEFORE INSERT ON guarderia
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idguarderia) into actual from guarderia;
        :new.idguarderia := actual + 1;
END id_guarderia;
/

-- Restringe cambio del id de las mascotas

CREATE OR REPLACE TRIGGER id_mascota_Restriccion
BEFORE UPDATE ON Mascota
for each row
    BEGIN
        :new.idmascota := :old.idmascota;
END id_mascota_Restriccion;
/

-- Restringe cambio del id de las facturas

CREATE OR REPLACE TRIGGER id_facturas_Restriccion
BEFORE UPDATE ON Factura
for each row
    BEGIN
        :new.idfactura := :old.idfactura;
END id_facturas_Restriccion;
/

-- Automatiza la fecha de ingreso de las mascotas que toman el servicio de guarderia

CREATE OR REPLACE TRIGGER fecha_guarderia
BEFORE INSERT ON Guarderia
for each row
    BEGIN
        :new.fechaingreso := SYSDATE;
END fecha_guarderia;
/
/* Actualizacion */
--No se permite actualizar la cedula

CREATE OR REPLACE TRIGGER No_upd_cedula
BEFORE UPDATE ON persona
for each row
    BEGIN
        :NEW.NumDoc:=OLD.NumDoc;

END No_upd_cedula;
/

--verifica cambio de celular

CREATE OR REPLACE TRIGGER UPD_CELULAR
BEFORE UPDATE ON persona
for each row
    BEGIN
	IF :OLD.celular = :NEW.celular THEN
		RAISE_APPLICATION_ERROR(-20002,'EL CELULAR DEBE SER DIFERENTE AL ANTIGUO');
	END IF;

END UPD_CELULAR;
/

--verifica cambio de direccion

CREATE OR REPLACE TRIGGER UPD_Direccion
BEFORE UPDATE ON persona
for each row
    BEGIN
	IF :OLD.direccion = :NEW.direccion THEN
		RAISE_APPLICATION_ERROR(-20002,'LA DIRECCION DEBE SER DIFERENTE A LA ANTIGUA');
	END IF;

END UPD_Direccion;
/


-- Disparadores Ok 

--Se verifica que el id de la mascota se genere automaticamente
INSERT INTO MASCOTA VALUES('PET01','TEDDY','PUG','M',8,2,'SI');
INSERT INTO MASCOTA VALUES('PET05','CHESTER','BORDER COLLIE','M',11,2,'NO');

--Se verifica que el id de la factura no se pueda cambiar
UPDATE INTO FACTURA SET idfactura = 90624 WHERE COSTODERIVADO=161841;
UPDATE INTO FACTURA SET idfactura=00000 WHERE COSTODERIVADO=242871;

--Se verifica  que el id de la mascota no se puede modificar
UPDATE Mascota SET idmascota = 21321 WHERE nombre = 'TEDDY';
UPDATE Mascota SET idmascota = 523423 WHERE nombre = 'CHESTER';

--se VERIFICA QUE EL ID DEL SERVICIO SE GENERA AUTOMATICAMENTE
INSERT INTO SERVICIO VALUES('G07');
INSERT INTO SERVICIO VALUES('B9');
--SE VERIFICA QUE EL ID DE LA VENTAPRODUCTO SE GENERA AUTOMATICAMENTE
INSERT INTO VENTAPRODUCTO VALUES(9877,'PELOTA','PR12',1,TO_DATE('2019/09/03','YYYY/MM/DD HH24:MI'),8000);
--SE VERIFICA QUE EL ID DE LA GUARDERIA SE GENERA AUTOMATICAMENTE
INSERT INTO GUARDERIA VALUES ('G05','PET07',60,TO_DATE('2019/05/13 11:40','YYYY/MM/DD HH24:MI'),TO_DATE('2019/05/14 13:00','YYYY/MM/DD HH24:MI'),NULL);


--Vistas

--Queremos las ventas diarias 
 
 CREATE OR REPLACE VIEW VENTASDIARIAS AS
    SELECT costoderivado AS Venta
    FROM Factura
    WHERE fecha = TO_DATE(SYSDATE,'DD-MM-YYYY'); 
    
--Queremos mirar la informacion de la mascota 

CREATE OR REPLACE VIEW INFOMASCOTAS AS
    SELECT nombre,raza,sexo,peso,edad,alergias
    FROM Mascota, Cliente
    WHERE Mascota.idMascota=Cliente.idMascota;
    
--XVISTAS

DROP VIEW VENTASDIARIAS;
DROP VIEW INFOMASCOTAS;

--INDICES

CREATE INDEX INDEX_MASCOTAS ON Mascotas(nombre);
CREATE INDEX INDEX_GUARDERIA_FECHA_INICIO ON Guarderia(fechaingreso);
CREATE INDEX INDEX_GUARDERIA_FECHA_FIN ON Guarderia(fechasalida);
CREATE INDEX INDEX_PERSONAS_NOMBRES ON Clientes(nombre);


--CRUDE

CREATE OR REPLACE PACKAGE PC_PERSONA IS 
    PROCEDURE AD_EMPLEADOS(xNumDoc IN number(15),xnombre IN varchar(50),XCelular IN number(10),XDireccion IN varchar(50),XCorreo IN varchar(50),Xfechanacimiento IN Date,Xedad IN number(2),XIDEmpleado IN number,XCargo IN varchar(1));
    PROCEDURE MOD_EMPLEADOS(XIDEmpleado INnumber,XCargo:varchar(1));
    PROCEDURE EL_EMPLEADOSX(IDEmpleadoIN number)(15);
    FUNCTION CO_EMPLEADOS(xIDEmpleado IN number(15)) RETURN SYS_REFCURSOR;
END PC_PERSONA;
/

CREATE OR REPLACE PACKAGE PC_FACTURA IS 
    PROCEDURE AD_FACTURA (XidFactura IN number,XidCliente IN number,XCostoDerivado IN number,XBonoDescuento IN number,XBonoBaño IN number,xfecha IN Date);
    PROCEDURE MOD_FACTURA (XIdFactura : number);
    FUNCTION CO_FACTURA (XidFactura IN number) RETURN SYS_RECURSOR;
END PC_FACTURA;
/

CREATE OR REPLACE PACKAGE PC_SERVICIOS IS 
    PROCEDURE AD_GUARDERIA (XIdGuarderia IN number,XFechaIngreso IN DATE,XFechaSalida IN DATE ,XTiempoPaseo:number);
    PROCEDURE AD_BANO (XidBaño IN number,XidMascota IN number,XAnestecia IN varchar,XDescripcion IN varchar,Xfecha IN DATE);
    PROCEDURE AD_VENTA (XidProducto IN number,XNombrepr IN varchar,Xprecio IN number,XBono IN number);
    PROCEDURE AD_SERVICIO (XidServicio IN number);
    PROCEDURE MOD_GUARDERIA(XIdGuarderia IN number,XFechaIngreso IN DATE,XFechaSalida IN DATE,XTiempoPaseo IN number);
    PROCEDURE MOD_BANO (XidBaño  IN  number,XidMascota IN number,XAnestecia IN varchar(2),XDescripcion IN varchar(100),Xfecha IN DATE);
    PROCEDURE MOD_VENTAPRODUCTO (XidProducto  IN number,XNombrepr IN varchar(50),Xprecio IN number);
    FUNCTION CO_GUARDERIA (Xidguarderia IN number) RETURN SYS_RECURSOR;
    FUNCTION CO_BANO (XidBaño IN number) RETURN SYS_RECURSOR;
    FUNCTION CO_VENTA (XidVentaProducto IN number) RETURN SYS_RECURSOR;
    FUNCTION CO_SERVICIO (Xidservicio IN number) RETURN SYS_RECURSOR;
END PC_SERVICIOS;
/
CREATE OR REPLACE PACKAGE PC_PROVEEDOR IS 
    PROCEDURE AD_PROVEEDOR (XidprooveedorIN varchar,Xnombre IN varchar);
    PROCEDURE AD_PRODUCTO (XidProducto IN number,XPrecio IN number,Xnombre IN varchar,XCantidad IN number);
    PROCEDURE MOD_PROVEEDOR(Xidprooveedor IN varchar,Xnombre IN varchar);
    PROCEDURE MOD_PRODUCTO (xidoriducto IN  number,xPrecio IN number,Xnombre IN varchar,XCantidad IN number);
    PROCEDURE EL_PROVEEDOR (Xidproveedor IN varchar);
    PROCEDURE EL_PRODUCTO (Xidproducto IN number);
    FUNCTION CO_PROVEEDOR (Xidproveedor IN varchar) RETURN SYS_RECURSOR;
    FUNCTION CO_PRODUCTO (Xidproducto IN number) RETURN SYS_RECURSOR;
END PC_PROVEEDOR;
/


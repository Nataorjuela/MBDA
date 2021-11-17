BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (   'FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;
/

/*XTABLAS*/

DROP TABLE empleados;
DROP TABLE clientes;
DROP TABLE mascotas ;
DROP TABLE celulares;
DROP TABLE facturas;
DROP TABLE lineaFactura;
DROP TABLE bienes;
DROP TABLE productos;
/*TABLAS*/

CREATE TABLE empleados(cedula number(10)not null,cargo char(1) not null,nombre varchar2(50) not null,edad number(2) not null ,correo varchar2(50));

CREATE TABLE clientes(cedula number(10)not null,nombre varchar2(50) not null,edad number(2) not null,fechaInscripcion timestamp not null,fechaRetiro timestamp,correo varchar2(50),direccion varchar2(50) not null);

CREATE TABLE mascotas (idMascota varchar(8)not null,cedula number(10) not null,nombreMascota varchar2(50)not null,edad number(2)not null,raza varchar2(50)not null,sexo char(1)not null);

CREATE TABLE celularesC(cedula number(10) not null,celular number(10)not null);

CREATE TABLE celularesE(cedula number(10) not null,celular number(10)not null);

CREATE TABLE facturas(idFactura number(5) not null,cedula number(10) not null,fecha timestamp not null);

CREATE TABLE lineaFactura(idFactura number(5) not null,idBien number(5) not null,precio number not null,cantidad number not null,descripcion varchar2(50),fecha timestamp not null);

CREATE TABLE bienes(idBien number(5) not null,nombreBien varchar(10)not null,idMascota varchar(8) not null);

CREATE TABLE productos(idBien number(5) not null,nombreProducto varchar2(50) not null,cantidad number not null,tipoProducto char(1) not null,precioCompra number not null,descripcion varchar2(90));

/*ATRIBUTOS*/

--Verficar que el cargo sea P o V
ALTER TABLE empleados ADD CONSTRAINT CK_EMPLEADOS_CARGO CHECK(cargo='P' or cargo='V');

--Verificar que el empleado sea mayor de edad
ALTER TABLE empleados ADD CONSTRAINT CK_EMPLEADOS_CEDULA CHECK(cedula>1000000);

----verificar que el correo tenga un @
ALTER TABLE empleados ADD CONSTRAINT CK_EMPLEADOS_CORREO CHECK(correo LIKE '%@%'OR correo='null');

--Verificar que el cliente sea mayor de edad
ALTER TABLE clientes ADD CONSTRAINT CK_CLIENTES_CEDULA CHECK(cedula>1000000);

----verificar que el correo tenga un @
ALTER TABLE clientes  ADD CONSTRAINT CK_CLIENTES_CORREO CHECK(correo LIKE '%@%');

--Verficiar en el caso de que un cliente se retire que su fecha de retiro sea despúes de la fecha de inscripcion
ALTER TABLE clientes ADD CONSTRAINT CK_CLIENTES_FECHA CHECK (fechaInscripcion<fechaRetiro or fechaRetiro='null');

--Verificar que el dueño d ela mascota sea mayor de edad
ALTER TABLE mascotas ADD CONSTRAINT CK_MASCOTAS_CEDULA CHECK(cedula>1000000);

--Verificar que el sexo de la mascota sea M o H
ALTER TABLE mascotas ADD CONSTRAINT CK_MASCOTAS_SEXO CHECK(sexo='M' or sexo='H');

--Verificar que el numero de celular sea mayor a 999999999
ALTER TABLE celularesC ADD CONSTRAINT CK_CELULARES_CELULARC CHECK(celular>999999999);

--Verficar que la persona sera mayor de edad, confimarndo que su numero de ceula es mayor a 1000000
ALTER TABLE celularesC ADD CONSTRAINT CK_CELULARES_CEDULAC CHECK(cedula>100000000);

--Verificar que el numero de celular sea mayor a 999999999
ALTER TABLE celularesE ADD CONSTRAINT CK_CELULARES_CELULARE CHECK(celular>999999999);
--Verficar que la persona sera mayor de edad, confimarndo que su numero de ceula es mayor a 1000000
ALTER TABLE celularesE ADD CONSTRAINT CK_CELULARES_CEDULAE CHECK(cedula>100000000);

--Verificar que el id de la factura sea mayor a 9999
ALTER TABLE lineaFactura ADD CONSTRAINT CK_LINEAFACTURA_IDFACTURA CHECK(idFactura>9999);

--Verificar que el id de la factura sea mayor a 9999
ALTER TABLE lineaFactura ADD CONSTRAINT CK_LINEAFACTURA_PRECIO CHECK(precio>0);

--Verificar que la cantidad sea mayor a 0
ALTER TABLE lineaFactura ADD CONSTRAINT CK_LINEAFACTURAS_CANTIDAD CHECK(cantidad>0);

--Verificar que el id de la factura sea mayor a 9999
ALTER TABLE facturas ADD CONSTRAINT CK_FACTURAS_IDFACTURA CHECK(idFactura>9999);

--Verificar que la persona registrada en la factura sea mayor de edad
ALTER TABLE facturas ADD CONSTRAINT CK_FACTURAS_CEDULA CHECK(cedula>10000000);

--Verificar que el nombre del bien es una compra o es peluqueria
ALTER TABLE bienes ADD CONSTRAINT CK_BIENES_NOMBRE CHECK(nombreBien='compra' or nombreBien='peluqueria');

--Verificar que el id del bien sea mayor a 9999
ALTER TABLE bienes ADD CONSTRAINT CK_BIENES_IDBIEN CHECK(idBien>9999);

--Verificar que el precio d ela compra sea mayor a 0
ALTER TABLE productos ADD CONSTRAINT CK_PRODUCTOS_PRECIOCOMPRA CHECK(precioCompra>0);

--Verificar que el id del bien sea mayor a 9999
ALTER TABLE productos ADD CONSTRAINT CK_PRODUCTOS_IDBien CHECK(idBien>9999);

--Verficiar que el tipo del producto sea  A,H,P,J,C
ALTER TABLE productos ADD CONSTRAINT CK_PRODUCTOS_TIPOPRODUCTO CHECK(tipoProducto='A' or tipoProducto='H'  or tipoProducto='P' or tipoProducto='J' or tipoProducto='C');


/*PRIMARIAS*/

ALTER TABLE empleados ADD PRIMARY KEY (cedula);
ALTER TABLE clientes ADD PRIMARY KEY (cedula);
ALTER TABLE mascotas ADD PRIMARY KEY (idMascota);
ALTER TABLE celularesC ADD PRIMARY KEY(celular);
ALTER TABLE celularesE ADD PRIMARY KEY(celular);
ALTER TABLE LineaFactura ADD PRIMARY KEY (idFactura,idBien);
ALTER TABLE Facturas ADD PRIMARY KEY(idFactura);
ALTER TABLE Bienes ADD PRIMARY KEY (idBien);
ALTER TABLE productos ADD PRIMARY KEY (idBien,nombreProducto);

/*UNICAS*/

ALTER TABLE empleados ADD UNIQUE (correo);
ALTER TABLE clientes ADD UNIQUE (correo);
ALTER TABLE clientes ADD UNIQUE (direccion);

/*FORANEAS*/

ALTER TABLE mascotas ADD CONSTRAINT FK_MASCOTAS_CEDULA FOREIGN KEY (cedula) REFERENCES clientes(cedula);
ALTER TABLE celularesC ADD CONSTRAINT FK_CELULARES_CEDULAC FOREIGN KEY(cedula)REFERENCES clientes(cedula); 
ALTER TABLE celularesE ADD CONSTRAINT FK_CELULARES_CEDULAE FOREIGN KEY(cedula) REFERENCES empleados(cedula);
ALTER TABLE lineaFactura ADD CONSTRAINT FK_LINEASFACTURA_IDFACTURA FOREIGN KEY (idFactura) REFERENCES facturas(idFactura);
ALTER TABLE lineaFactura ADD CONSTRAINT FK_LINEASFACTURA_IDBIEN FOREIGN KEY (idBien) REFERENCES bienes(idBien);
ALTER TABLE facturas ADD CONSTRAINT FK_FACTURAS_CEDULA FOREIGN KEY (cedula) REFERENCES clientes(cedula);
ALTER TABLE productos ADD CONSTRAINT FK_PRODUCTOS_IDBIEN FOREIGN KEY (idBien) REFERENCES bienes(idBien);
ALTER TABLE bienes ADD CONSTRAINT FK_BIENES_IDMASCOTA FOREIGN KEY (idMascota) REFERENCES mascotas(idMascota);

/*POBLAR OK*/

insert into empleados (cedula, cargo, nombre,edad, correo) values (2491770576, 'V','Diego Orjuela',18,'Diego@hotmail.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (9308659915, 'V', 'Diana Rocha',19, 'Diana@gmail.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (3190645099, 'P', 'Raimundo Orjuela',20, 'Raimundo@hotmail.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (0495866918, 'V', 'Claudia Hernandez' , 21,'Claudia@yahoo.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (1513420173, 'P', 'Rocio Paramo',22, 'kbubbear2@phoca.cz');
insert into empleados (cedula, cargo, nombre,edad, correo) values (9857359797, 'P', 'Luis Rocha',23, 'hkeavy6@issuu.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (3698040675, 'V', 'Lucia Quintero',24, 'lucia@hotmail.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (7408710636, 'V', 'Camila Villate',25, 'mariacas17@gmail.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (3291216475, 'P', 'Patricia Gomez', 26,'moneal8@chron.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (7179872852, 'P', 'Oscar rey',27, 'plittrell7@whitehouse.gov');
insert into empleados (cedula, cargo, nombre,edad, correo) values (6999473369, 'V','Dilan Castillo',28,'dila.r@gmail.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (9050331051, 'P', 'Mariana Romero', 29,'dwalsham9@cocolog-nifty.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (3764450028, 'P', 'Nataly Quintero',30, 'nata@yahoo.es');
insert into empleados (cedula, cargo, nombre,edad, correo) values (1313293827, 'V', 'Laura Perez', 31,'lau@hotmail.com');
insert into empleados (cedula, cargo, nombre,edad, correo) values (7900167071, 'V', 'Sofia Franco',32, 'sofif@hotmail.com');
insert into empleados (cedula, cargo, nombre, edad, correo) values (8438608863, 'P', 'Juan Mendez',33, 'jm@mail.com');

insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (2491770576,'Diego Orjuela',18,'24/2/2020',null,'Diego@hotmail.com','calle 55 a sur No 68 d 21');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (1010247478,'Tomas Santamaria',19,'10/10/2020','12/11/2020','tomas@gmail.com','cr 68 d No 76- 42');
insert into clientes (cedula, nombre, edad,  fechaInscripcion, fechaRetiro, correo, direccion) values (2522805709,'Maria Sierra', 20,'15/08/2020',null,'awhitcher5@blog.com','114 Judy Plaza');
insert into clientes (cedula, nombre, edad,  fechaInscripcion, fechaRetiro, correo, direccion) values (1833497778,'Valentina Aguirre', 21,'04/05/2020',null,'vaguirre@gmail.com','15424 Iowa Pass');
insert into clientes (cedula, nombre, edad,  fechaInscripcion, fechaRetiro, correo, direccion) values (6796457783, 'Sofia Vargas',22, '08/09/2020',null,'sofiav@hotmail.com','3567 Veith Pass');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (5790200407, 'Mariana Ramirez',23, '12/11/2020','24/12/2020','mr9@cocolog-nifty.com','396 Miller Drive');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (4704349235, 'Tania Lopez',24, '25/11/2020',null,'tania@outlook.es','1 Prairieview Park');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (2272832783, 'Yulian Torres',25, '06/07/2010',null,'yt@cght.com', '495 Center Place');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (0495866918, 'Claudia Hernandez',21, '10/02/2019',null,'Claudia@yahoo.com','1 Carey Park');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (5212626405, 'Camilo Medina',22,  '08/05/2019',null,'cm@yahoo.cvom','25784 John Wall Junction');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (0186510635, 'Lorena Martinez',30,'12/07/2019',null,'lmar@gmail.com','4 Shopko Lane');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (6248777938, 'Juan Hernandez', 31,'09/03/2015',null,'juanh@yahoo.es','26795 Ruskin Plaza');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (0594237596, 'Fabian Cardozo',32, '15/09/2020', null, 'fabi@gmail.com','calle 27 sur No 45-20');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (4610189578, 'Luis Barrera',33,  '07/01/2019', null, 'luis@outlook.es','cr 08 No 19-43');
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo, direccion) values (3321411534, 'Sebastian Montes',34, '06/02/2019', null, 'montes@gmail.com','diagonal 22 No.15-34');


insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97083', 2491770576, 'Korry', 2, 'affenpinscher', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97084', 1010247478, 'Cary', 4, 'airedale terrier', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97085', 2522805709, 'Lurlene', 12, 'affenpinscher', 'H');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97086', 1833497778, 'Rosaleen', 9, 'akita americano', 'H');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97087', 6796457783, 'Delmer', 3, 'beagle', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97088', 5790200407, 'Markos', 6, 'boston terrier', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97089', 4704349235, 'Constancy', 3, 'akita americano', 'H');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97090', 2272832783, 'Tammy', 3, 'airedale terrier', 'H');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97091', 0495866918, 'Garrick', 4, 'akita americano', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97092', 5212626405, 'Brent', 6, 'affenpinscher', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97093', 0186510635,'Roqui', 8,'Husky Siberiano','M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97094', 6248777938,'Teddy', 2,'Chow Chow','M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97095', 0594237596,'Kenai', 8,'Alaskan Malamute','M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97096', 4610189578,'Yuyuba', 9,'Chow Chow','H');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET97097', 3321411534, 'Luna', 2,'Labrador Retriever','H');


insert into celularesE(cedula, celular) values (2491770576, 3506598573);
insert into celularesE(cedula, celular) values (9308659915, 3186342807);
insert into celularesE(cedula, celular) values (3190645099, 3206598736);
insert into celularesE(cedula, celular) values (0495866918, 3132678896);
insert into celularesE(cedula, celular) values (1513420173, 3107000996);
insert into celularesE(cedula, celular) values (9857359797, 3152019782);
insert into celularesE(cedula, celular) values (3698040675, 3503416894);
insert into celularesE(cedula, celular) values (7408710636, 3144278339);
insert into celularesE(cedula, celular) values (3291216475, 3203156985);
insert into celularesE(cedula, celular) values (7179872852, 3156987642);
insert into celularesE(cedula, celular) values (6999473369, 3136265584);
insert into celularesE(cedula, celular) values (9050331051, 3194556278);
insert into celularesE(cedula, celular) values (3764450028, 3052478893);
insert into celularesE(cedula, celular) values (1313293827, 3175362104);
insert into celularesE(cedula, celular) values (7900167071, 3215869974);
insert into celularesE(cedula, celular) values (8438608863, 3206548397);

insert into celularesC(cedula, celular) values (1010247478, 3124658955);
insert into celularesC(cedula, celular) values (2522805709, 3144426537);
insert into celularesC(cedula, celular) values (1833497778, 3212707055);
insert into celularesC(cedula, celular) values (6796457783, 3058152756);
insert into celularesC(cedula, celular) values (5790200407, 3229058274);
insert into celularesC(cedula, celular) values (4704349235, 3138894347);
insert into celularesC(cedula, celular) values (2272832783, 3125301721);
insert into celularesC(cedula, celular) values (0495866918, 3053125171);
insert into celularesC(cedula, celular) values (5212626405, 3053719255);
insert into celularesC(cedula, celular) values (0186510635, 3013561437);
insert into celularesC(cedula, celular) values (6248777938, 3168710083);
insert into celularesC(cedula, celular) values (0594237596, 3105726007);
insert into celularesC(cedula, celular) values (4610189578, 3007565807);
insert into celularesC(cedula, celular) values (3321411534, 3142153611);

insert into facturas(idFactura, cedula, fecha) values (10223, 2491770576, '24/02/2020');
insert into facturas(idFactura, cedula, fecha) values (10224, 1010247478, '10/10/2020');
insert into facturas(idFactura, cedula, fecha) values (10225, 2522805709, '15/08/2020');
insert into facturas(idFactura, cedula, fecha) values (10226, 1833497778, '04/05/2020');
insert into facturas(idFactura, cedula, fecha) values (10227, 6796457783, '08/09/2020');
insert into facturas(idFactura, cedula, fecha) values (10228, 5790200407, '12/11/2020');
insert into facturas(idFactura, cedula, fecha) values (10229, 4704349235, '25/11/2020');
insert into facturas(idFactura, cedula, fecha) values (10230, 2272832783, '06/07/2010');
insert into facturas(idFactura, cedula, fecha) values (10231, 0495866918, '10/02/2019');
insert into facturas(idFactura, cedula, fecha) values (10232, 5212626405, '08/05/2019');
insert into facturas(idFactura, cedula, fecha) values (10233, 0186510635, '12/07/2019');
insert into facturas(idFactura, cedula, fecha) values (10234, 6248777938, '09/03/2015');
insert into facturas(idFactura, cedula, fecha) values (10235, 0594237596, '15/09/2020');
insert into facturas(idFactura, cedula, fecha) values (10236, 4610189578, '07/01/2019');
insert into facturas(idFactura, cedula, fecha) values (10237, 3321411534, '06/02/2019');
insert into facturas(idFactura, cedula, fecha) values (10238, 2491770576, '24/03/2020');
insert into facturas(idFactura, cedula, fecha) values (10239, 1010247478, '10/11/2020');
insert into facturas(idFactura, cedula, fecha) values (10240, 2491770576, '24/04/2020');

insert into Bienes (idBien, nombreBien, idMascota) values (65041, 'peluqueria','PET97083');
insert into Bienes (idBien, nombreBien, idMascota) values (65042, 'compra', 'PET97084');
insert into Bienes (idBien, nombreBien, idMascota) values (65043,'compra' ,'PET97085');
insert into Bienes (idBien, nombreBien, idMascota) values (65044, 'compra','PET97086');
insert into Bienes (idBien, nombreBien, idMascota) values (65045,'compra', 'PET97087');
insert into Bienes (idBien, nombreBien, idMascota) values (65046,'compra', 'PET97088');
insert into Bienes (idBien, nombreBien, idMascota) values (65047, 'peluqueria','PET97089');
insert into Bienes (idBien, nombreBien, idMascota) values (65048, 'compra','PET97090');
insert into Bienes (idBien, nombreBien, idMascota) values (65049,'compra', 'PET97091');
insert into Bienes (idBien, nombreBien,idMascota) values (65050,'compra', 'PET97092');
insert into Bienes (idBien, nombreBien, idMascota) values (65051, 'compra','PET97093');
insert into Bienes (idBien, nombreBien, idMascota) values (65052, 'compra','PET97094');
insert into Bienes (idBien, nombreBien, idMascota) values (65053,'peluqueria','PET97095');
insert into Bienes (idBien, nombreBien, idMascota) values (65054,'compra', 'PET97096');
insert into Bienes (idBien, nombreBien, idMascota) values (65055, 'peluqueria','PET97097');
insert into Bienes (idBien, nombreBien, idMascota) values (65056,'peluqueria','PET97097');

insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10223, 65041, 25000, 1, 'dejar bajito el corte', '24/02/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10224, 65042, 10000, 1, 'null', '10/10/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10225, 65043, 14000, 1, 'null', '15/08/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10226, 65044, 18000, 2, 'Talla mediana', '04/05/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10227, 65045, 50000, 1, 'Small', '08/09/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10228, 65046, 25000, 1, 'pelota grande', '12/11/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10229, 65047, 2000, 2, 'peluqueria', '25/11/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10230, 65048, 20000, 1, 'Mediano',  '06/07/2010');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10231, 65049, 22000, 1, 'buso talla m', '10/02/2019');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10232, 65050, 12000, 1, 'can amor',  '08/05/2019');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10233, 65051, 100000, 1, 'Bulto 25 kg','12/07/2019');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10234, 65052, 35000, 1, 'Medium', '09/03/2015');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10235, 65053, 25000, 1, 'peluqueria', '15/09/2020');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10236, 65054, 1000, 1, 'pollo', '07/01/2019');
insert into lineaFactura (idFactura, idBien, precio, cantidad, descripcion, fecha) values (10237, 65055, 20000, 1, 'peluqueria', '06/02/2019');

insert into productos (idBien,  nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65042,  'crema dental para perros', 7, 'H', 240768, 'COLGATE');
insert into productos (idBien,nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65043,  'cuerda de bola royalcare', 10, 'J', 14492, 'JUGUETE RESISTENTE PARA CACHORRO DE PERRO');
insert into productos (idBien,nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65044, 'BUSO PERRO', 8, 'A', 401974, 'MARCA SQUEAKER SQUEEZE');
insert into productos (idBien,nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65045,  'cama perro adulto', 16, 'A', 196776, 'DIÁMETRO 7.1CM (AMARILLO + AZUL)');
insert into productos (idBien,  nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65046,  'pelota de goma', 2, 'J', 360839, 'PARA MORDELONES AGRESIVOS. JUGUETES INDESTRUCTIBLES PARA PERROS GRANDES');
insert into productos (idBien, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65048,  'cuerda llanta', 14, 'J', 285342, 'null');
insert into productos (idBien, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65049,  'saco gorro', 15, 'A', 476578, 'Saco con mangas y gorro');
insert into productos (idBien,  nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65050,  'perfume canAmor', 3, 'H', 185449, 'ANTIPULGAS');
insert into productos (idBien,  nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65051,  'bulto Dog Chow Raza pequeña', 1, 'C', 100000, 'Bulto por 25 kg');
insert into productos (idBien,  nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65052,  'cama perro cachorro', 18, 'A', 174998, 'SMALL');
insert into productos (idBien,  nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65054,  'cabano', 5, 'A', 243692, ' BACON/POLLO');

/*POBLAR NO OK*/

--Longitud de la cedula
insert into empleados (cedula, cargo, nombre,edad,  correo) values (24917705, 'V','Diego Orjuela',50,'Diego@hotmail.com');
--cedula null
insert into empleados (cedula, cargo, nombre,edad, correo) values (null, 'V', 'Diana Rocha', 20,'Diana@gmail.com');
--cargo P
insert into empleados (cedula, cargo, nombre,edad, correo) values (319064509, 'P', 'Raimundo Orjuela', 18,'Raimundo@hotmail.com');
--nombre null
insert into empleados (cedula, cargo, nombre,edad, correo) values (0495866915, 'V', 'null' , 19,'Claudia@yahoo.com');
--cargo null
insert into empleados (cedula, cargo, nombre,edad, correo) values (1513420173, null,20, 'Rocio Paramo', null);
--correo sin @
insert into empleados (cedula, cargo, nombre,edad, correo) values (369804065, 'V',21, 'Lucia Quintero', 'luciahotmail.com');
--longitud cedula
insert into clientes (cedula, nombre, edad,  fechaInscripcion, fechaRetiro, correo) values (2491770,'Diego Orjuela',18,'2/24/2020',null,'Diego@hotmail.com');
--fecha retiro < fecha inscripcion
insert into clientes (cedula, nombre, edad,  fechaInscripcion, fechaRetiro, correo) values (101024747,'Tomas Santamaria',19, '10/10/2020','12/09/2020','tomas@gmail.com');
--fecha de inscripcion null
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo) values (252280570,'Maria Sierra',20,null,null,null);
--nombre null
insert into clientes (cedula, nombre, edad,  fechaInscripcion, fechaRetiro, correo) values (1833497778,null, 21,'04/05/2020',null,'vaguirre@gmail.com');
--cedula null
insert into clientes (cedula, nombre, edad,  fechaInscripcion, fechaRetiro, correo) values ('null', 'Sofia Vargas',22, '08/09/2020',null,'sofiav@hotmail.com');
--numeros en lugar de un correo
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo) values (4704349235, 'Tania Lopez',23, '25/11/2020',null,1235);
--correo sin @
insert into clientes (cedula, nombre, edad, fechaInscripcion, fechaRetiro, correo) values (2272832783, 'Yulian Torres', 24,'06/07/2010','06/08/2010','tyhotmail.com');

insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values (9708, 2491770576, 'Korry', 2, 'affenpinscher', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET76666', 10102474, 'Cary', 4, 'airedale terrier', 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET44396', 2522805709, null, 12, 'affenpinscher', 'H');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET68189', 1833497778, 'Rosaleen', null, 'akita americano', 'H');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET16237', 6796457783, 'Delmer', 3, null, 'M');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET15934', 5790200407, 'Markos', 6, 'boston terrier', null);
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET71333', 4704349235, 'Constancy', 3, 'akita americano', 'P');
insert into mascotas (idMascota, cedula, nombreMascota, edad, raza, sexo) values ('PET03763', 2272832786, 'Tammy', 0, 'airedale terrier', 'H');

insert into celulares(cedula, celular) values (249177, 3506598573);
insert into celulares(cedula, celular) values (9308659915, 31863428);
insert into celulares(cedula, celular) values (null, 3206598736);
insert into celulares(cedula, celular) values (0495866918, null);

insert into facturas(idFactura, cedula, fecha) values (1022, 2491770576, '2/24/2020');
insert into facturas(idFactura, cedula, fecha) values (10224, 101024747, '10/10/2020');
insert into facturas(idFactura, cedula, fecha) values (10225, 2522805709, '00/00/00');
insert into facturas(idFactura, cedula, fecha) values (null, 1833497778, '04/05/2020');
insert into facturas(idFactura, cedula, fecha) values (10227, null, '08/09/2020');
insert into facturas(idFactura, cedula, fecha) values (10228, 5790200407, null);

insert into Bienes (idBien, idFactura) values (6504, 10223);
insert into Bienes (idBien, idFactura) values (65042, 1022);
insert into Bienes (idBien, idFactura) values (null, 10225);
insert into Bienes (idBien, idFactura) values (65044, null);

insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (1022, 65041, 8000, 2, null);
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10224, 6504, 10000, 1, null);
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10225, 65043, 0, 1, null);
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10226, 65044, 10000, 0, 'Talla mediana');
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10227, 65045, 50000, 1, null);
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (null, 65046, 25000, 1, 'baño');
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10229, null, 2000, 2, 'hueso');
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10230, 65048,null, 1, 'cabano');
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10231, 65049, 22000, null, 'buso talla m');
insert into LineaFactura (idFactura, idBien, precio, cantidad, descripcion) values (10232, 65050, 9000, 1, 12256);

insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (6504, 18889, 'perfume canAmor', 3, 'H', 19000, 'PERFUME ANTICASPA');
insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65042, 2631, 'crema dental para perros', 7, 'H', 240768, 'HUESO PARA MASTICA DE JUGUETE');
insert into productos (idBien,idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65043, 82955, null, 10, 'J', 14492, 'JUGUETE RESISTENTE PARA CACHORRO DE PERRO');
insert into productos (idBien,idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65044, 00047, 'BUSO PERRO', null, 'A', 401974, 'MARCA SQUEAKER SQUEEZE');
insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65045, 53787, 'cama perro adulto', 16, null, 196776, 'DIÁMETRO 7.1CM (AMARILLO + AZUL)');
insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65046, 83121, 'pelota de goma', 2, 'J', null, 'PARA MORDELONES AGRESIVOS. JUGUETES INDESTRUCTIBLES PARA PERROS GRANDES');
insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65047, 36614, 'perfume canAmor', 7, 'H', 480293, 1123365);
insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65048, 92634, 'cuerda de bola royalcare', 14, 'J', 285342, null);
insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (null, 09733, 'saco gorro', 15, 'A', 476578, 'Saco con mangas y gorro');
insert into productos (idBien, idProducto, nombreProducto, cantidad, tipoProducto, precioCompra, descripcion) values (65050, null, 'perfume canAmor', 3, 'H', 185449, 'JUGUETE');

                                                                              /*CONSULTAS*/----------------------------------------

--CONSULTAR LA MASCOTA QUE MÁS HA TOMADO EL BIEN DE PELUQUERIA
SELECT bienes.idmascota, count(*) as MascotaP
FROM bienes
WHERE nombreBien='peluqueria' 
GROUP BY idMascota, bienes.idmascota 
ORDER BY idmascota DESC;


--CONSULTAR LA CANTIDAD DE CLIENTES DE LOS DOS ULTIMOS MESES

SELECT count(clientes.cedula)as cantcientes,fechainscripcion
FROM clientes
WHERE fechaInscripcion BETWEEN '15/09/2020/' and '15/11/2020' 
group by fechainscripcion 
order by fechainscripcion Asc;

--CONSULTAR LA CANTIDAD DE PRODUCTOS EN INVENTARIO

SELECT cantidad,idBien,nombreProducto
FROM productos
ORDER BY cantidad ASC;

--CONSULTAR LAS MAYORES VENTAS

SELECT sum(precio),idFactura
FROM LineaFactura
group by precio,idFactura
ORDER BY precio DESC;

--CONSULTAR EL CLIENTE MÁS ANTIGUO

SELECT (fechaInscripcion)as antiguedad,nombre,cedula
FROM clientes
ORDER BY antiguedad ASC;

/*TUPLAS*/

--verificar que la persona sea mayor de edad

ALTER TABLE Clientes ADD CONSTRAINT CK_Clientedad CHECK (edad >=18 and cedula >1000000 );
ALTER TABLE Empleados ADD CONSTRAINT CK_Empleadoedad CHECK (edad >=18 and cedula >1000000 );

--verificar que la fecha de sretirosea despues que la fecha de inscripcion 

ALTER TABLE Clientes ADD CONSTRAINT CK_Verifecha CHECK (fecharetiro > fechainscripcion);

--verificar que el id de la mascota inicie por PET Y este seguido por un numero

ALTER TABLE mascotas ADD CONSTRAINT CK_verifid CHECK (idmascota like '%PET_%');

/* TUPLAS Ok*/

INSERT INTO clientes VALUES(1010247479,'TEOFILO PEREZ',18,TO_DATE('2020/08/26','YYYY/MM/DD'),TO_DATE('2020/09/28','YYYY/MM/DD'),'TEO@HOTMAIL.COM','Cr 56 d No 76');
INSERT INTO mascotas VALUES ('PET10105',1010247479,'KENAI',3,'ALASKAN MALAMUTE','M');

/*TUPLAS NoOK*/

--SE VERIFICA QUE LA EDAD DEBE SER MAYOR A 18

INSERT INTO CLIENTES VALUES(2004569,'TEOFILO PEREZ',17,'26/08/2020','26/09/2020','TEO@HOTMAIL.COM','cr 78 n 9');

--SE VERIFICA QUE LA FECHA DE INSCRIPCION SEA ANTES QUE LA FECHA DE RETIRO
INSERT INTO CLIENTES VALUES(2004569,'TEOFILO PEREZ',28,'2020/08/26','12/06/2020','TEO@HOTMAIL.COM','cr 56 n 9');

--SE VERIFICA QUE EL ID DE MASTOCA DEBE COMENZAR CON PET Y LLEVAR UN NUMERO
INSERT INTO MASCOTAS VALUES ('MASC2',101024758,'KENAI',3,'ALASKAN MALAMUTE','M');

/*ACCIONES*/


ALTER TABLE mascotas DROP CONSTRAINT FK_MASCOTAS_CEDULA;
ALTER TABLE celularesE DROP CONSTRAINT FK_CELULARES_CEDULAE;
ALTER TABLE celularesC DROP CONSTRAINT FK_CELULARES_CEDULAC;
ALTER TABLE lineaFactura DROP CONSTRAINT FK_LINEASFACTURA_IDFACTURA;
ALTER TABLE facturas DROP CONSTRAINT FK_FACTURAS_CEDULA;
ALTER TABLE productos DROP CONSTRAINT FK_PRODUCTOS_IDBIEN;
ALTER TABLE bienes DROP CONSTRAINT FK_BIENES_IDMASCOTA;

ALTER TABLE mascotas ADD CONSTRAINT FK_MASCOTAS_CEDULA FOREIGN KEY (cedula) REFERENCES clientes(cedula)ON DELETE CASCADE;
ALTER TABLE celularesC ADD CONSTRAINT FK_CELULARES_CEDULAE FOREIGN KEY(cedula)REFERENCES clientes(cedula)ON DELETE CASCADE;
ALTER TABLE celularesE ADD CONSTRAINT FK_CELULARES_CEDULAC FOREIGN KEY(cedula)REFERENCES empleados(cedula)ON DELETE CASCADE;
ALTER TABLE lineaFactura ADD CONSTRAINT FK_LINEASFACTURA_IDFACTURA FOREIGN KEY (idFactura) REFERENCES facturas(idFactura)ON DELETE CASCADE;
ALTER TABLE facturas ADD CONSTRAINT FK_FACTURAS_CEDULA FOREIGN KEY (cedula) REFERENCES Clientes(cedula)ON DELETE CASCADE;
ALTER TABLE productos ADD CONSTRAINT FK_PRODUCTOS_IDBIEN FOREIGN KEY (idBien) REFERENCES Bienes(idBien)ON DELETE CASCADE;


ALTER TABLE empleados DROP CONSTRAINT CK_EMPLEADOS_CARGO ;
ALTER TABLE empleados DROP CONSTRAINT CK_EMPLEADOS_CEDULA ;
ALTER TABLE empleados DROP CONSTRAINT CK_EMPLEADOS_CORREO ;
ALTER TABLE clientes DROP CONSTRAINT CK_CLIENTES_CEDULA;
ALTER TABLE clientes DROP CONSTRAINT CK_CLIENTES_CORREO;
ALTER TABLE clientes DROP CONSTRAINT CK_CLIENTES_FECHA ;
ALTER TABLE mascotas DROP CONSTRAINT CK_MASCOTAS_CEDULA ;
ALTER TABLE mascotas DROP CONSTRAINT CK_MASCOTAS_SEXO ;
ALTER TABLE celularesC DROP CONSTRAINT CK_CELULARES_CELULARC ;
ALTER TABLE celularesC DROP CONSTRAINT CK_CELULARES_CEDULAC ;
ALTER TABLE celularesE DROP CONSTRAINT CK_CELULARES_CELULARE ;
ALTER TABLE celularesE DROP CONSTRAINT CK_CELULARES_CEDULAE ;
ALTER TABLE lineaFactura DROP CONSTRAINT CK_LINEAFACTURA_IDFACTURA;
ALTER TABLE lineaFactura DROP CONSTRAINT CK_LINEAFACTURA_PRECIO;
ALTER TABLE lineaFactura DROP CONSTRAINT CK_LINEAFACTURAS_CANTIDAD;
ALTER TABLE facturas DROP CONSTRAINT CK_FACTURAS_IDFACTURA ;
ALTER TABLE facturas DROP CONSTRAINT CK_FACTURAS_CEDULA;
ALTER TABLE bienes DROP CONSTRAINT CK_BIENES_NOMBRE;
ALTER TABLE bienes DROP CONSTRAINT CK_BIENES_IDBIEN;
ALTER TABLE productos DROP CONSTRAINT CK_PRODUCTOS_PRECIOCOMPRA;
ALTER TABLE productos DROP CONSTRAINT CK_PRODUCTOS_IDBien;
ALTER TABLE productos DROP CONSTRAINT CK_PRODUCTOS_TIPOPRODUCTO;

/*XPOBLAR*/

DELETE FROM empleados;
DELETE FROM clientes;
DELETE FROM mascotas;
DELETE FROM celularesC;
DELETE FROM celularesE;
DELETE FROM facturas;
DELETE FROM lineaFactura;
DELETE FROM bienes;
DELETE FROM productos;

--ACCIONESOK

 DELETE FROM Clientes WHERE cedula=1010247478;
 DELETE FROM Facturas WHERE idfactura=10223;
 DELETE FROM Mascotas WHERE NombreMascota='teddy';
 DELETE FROM Empleados WHERE cedula=39557102;
 DELETE FROM Productos WHERE idBien=65042;
 DELETE FROM Clientes WHERE nombre='Tomas Santamaria';

/*DISPARADORES*/

/* Actualizacion */

--No se permite actualizar la cedula en el cliente

CREATE OR REPLACE TRIGGER No_upd_cedulac
BEFORE UPDATE ON clientes
for each row
    BEGIN
        :NEW.cedula:=:OLD.cedula;

END No_upd_cedulac;
/
--No se permite actualizar la cedula en el empleado

CREATE OR REPLACE TRIGGER No_upda_cedulae
BEFORE UPDATE ON empleados
for each row
    BEGIN
        :NEW.cedula:=:OLD.cedula;

END No_upda_cedulae;
/
--verifica cambio de celular en los clientes

CREATE OR REPLACE TRIGGER UPD_CELULARC
BEFORE UPDATE ON celularesc
for each row
    BEGIN
	IF :OLD.celular = :NEW.celular THEN
		RAISE_APPLICATION_ERROR(-20002,'EL CELULAR DEBE SER DIFERENTE AL ANTIGUO');
	END IF;

END UPD_CELULARC;
/
--verificar el cambio de celular en los empleados
CREATE OR REPLACE TRIGGER UPD_CELULARE
BEFORE UPDATE ON celularese
for each row
    BEGIN
	IF :OLD.celular = :NEW.celular THEN
		RAISE_APPLICATION_ERROR(-20002,'EL CELULAR DEBE SER DIFERENTE AL ANTIGUO');
	END IF;

END UPD_CELULARE;
/
--verifica cambio de correo cliente

CREATE OR REPLACE TRIGGER Upd_CorreoC
BEFORE UPDATE ON clientes
for each row
    BEGIN
	IF :OLD.correo = :NEW.correo THEN
		RAISE_APPLICATION_ERROR(-20002,'EL CORREO DEBE SER DIFERENTE AL ANTIGUO');
	END IF;

END Upd_CorreoC;
/
--verifica cambio de correo empleado
CREATE OR REPLACE TRIGGER Upd_CorreoE
BEFORE UPDATE ON empleados
for each row
    BEGIN
	IF :OLD.correo = :NEW.correo THEN
		RAISE_APPLICATION_ERROR(-20002,'EL CORREO DEBE SER DIFERENTE AL ANTIGUO');
	END IF;

END Upd_CorreoE;
/
--Restringe el cambio del nombre de un empleado

CREATE OR REPLACE TRIGGER No_mod_nombreEmpleado
BEFORE UPDATE ON Empleados
for each row
	BEGIN
		IF(:old.nombre<>:new.nombre)
			THEN
				RAISE_APPLICATION_ERROR(-20205,'No se permite cambiar el nombre');
		END IF;
END No_mod_nombreEmpleado;
/
-- Automatiza el id de las mascotas

CREATE OR REPLACE TRIGGER id_mascota
BEFORE INSERT ON mascotas
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idmascota) into actual from mascotas;
        :new.idmascota := actual + 1;
END id_mascota;
/

-- Automatiza el id de las facturas

CREATE OR REPLACE TRIGGER id_facturas
BEFORE INSERT ON facturas
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idfactura) into actual from facturas;
        :new.idfactura := actual + 1;
END id_facturas;
/

--Automatiza el id del Bien
CREATE OR REPLACE TRIGGER id_bien
BEFORE INSERT ON Bienes
for each row
    DECLARE 
        actual NUMBER;
    BEGIN
        select count(idBien) into actual from bienes;
        :new.idBien := actual + 1;
END id_bien;
/
-- Automatiza la fecha de inscripcion de los clientes

CREATE OR REPLACE TRIGGER fechainscripcion
BEFORE INSERT ON Clientes
for each row
    BEGIN
        :new.fechainscripcion := SYSDATE;
END fechainscripcion;
/


-- Restringe cambio del id de las mascotas

CREATE OR REPLACE TRIGGER id_mascota_Restriccion
BEFORE UPDATE ON Mascotas
for each row
    BEGIN
        :new.idmascota := :old.idmascota;
END id_mascota_Restriccion;
/

-- Restringe cambio del id de las facturas

CREATE OR REPLACE TRIGGER id_facturas_Restriccion
BEFORE UPDATE ON Facturas
for each row
    BEGIN
        :new.idfactura := :old.idfactura;
END id_facturas_Restriccion;
/

-- Restringe cambio del bien

CREATE OR REPLACE TRIGGER No_mod_Bien
BEFORE UPDATE ON Bienes
for each row
    BEGIN
        IF(:old.idBien<>:new.idBien) OR (:old.nombreBien<>:new.nombreBien)OR (:old.idMascota<>:new.idMascota)
		THEN
			RAISE_APPLICATION_ERROR(-20204,'ACTUALIZACION NO PERMITIDA');

	END IF;
END No_mod_Bien;
/
/*Eliminacion*/

--No se permite eliminar un bien
CREATE OR REPLACE TRIGGER No_elim_bien
BEFORE DELETE ON Bienes
for each row
	BEGIN
		RAISE_APPLICATION_ERROR(-20203,'NO SE PERMITE ELIMINAR UN BIEN');
END No_elim_bien;
/

--Restringe el cambio en el nombre y el tipo del producto

CREATE OR REPLACE TRIGGER No_ModNombreyTipoProducto
BEFORE UPDATE ON Productos
for each row
	BEGIN
		if(:old.nombreProducto<>:new.nombreProducto) OR (:old.tipoProducto<>:new.tipoProducto)
			THEN
				RAISE_APPLICATION_ERROR(-20202,'ACTUALIZACION NO PERMITIDA');
                        END IF;
END No_ModNombreyTipoProducto;
/

--RESTRINGE INSERTAR UNA MASCOTA EN BIEN DE PELUQUERIA SI HAY MÁS DE 7 EL MISMO DIA

CREATE OR REPLACE TRIGGER No_Ad_Masc
BEFORE INSERT ON Bienes
for each row
    DECLARE fecha timestamp;
            cantP number(1);
	BEGIN
		select Count(nombreBien) AS CantP INTO cantP FROM bienes WHERE (nombreBien='peluqueria' and fecha=SYSDATE());
		IF(CantP>7)
			THEN 
				RAISE_APPLICATION_ERROR(-20204,'ADICION NO PERMITIDA, CUPO DE PELUQUERIA LLENO');
			END IF;
END No_Ad_Masc;
/

--/*DISPARADORES OK*/
--
----/* Actualizacion */
-- Se verifica el cambio del correo
UPDATE Clientes SET correo= 'nataorjuela62@hotmail.com' where cedula = 049586691;
UPDATE Clientes SET correo= 'laura@godps.vom' where cedula = 2491770576 ;
UPDATE Clientes SET correo= 'nuevocorreo@hotm.com' where cedula = 2522805709;
UPDATE Clientes SET correo= 'phre@hotmail.com' where cedula = 1833497778;
UPDATE Clientes SET correo= 'fhgjiok2@hotmail.com' where cedula = 3321411534;
--
----Se verifica que el id de las mascotas se genere automaticamente
INSERT INTO MASCOTAS (cedula,nombreMascota,edad,raza,sexo) VALUES(1012589663,'TEDDY',8,'pug','M');
INSERT INTO MASCOTAS (cedula,nombreMascota,edad,raza,sexo)VALUES(11313602,'CHESTER',2,'BORDER COLLIE','M');

----Se verifica que el id de la factura no se pueda cambiar
UPDATE INTO facturas SET idfactura = 90624 WHERE cedula=1010247478;
UPDATE INTO facturas SET idfactura=00000 WHERE cedula=39557102;
--
----Se verifica  que el id de la mascota no se puede modificar
UPDATE Mascotas SET idmascota = 21321 WHERE nombreMascota = 'TEDDY';
UPDATE Mascotas SET idmascota = 523423 WHERE nombreMascota = 'CHESTER';

--se VERIFICA QUE EL ID DEL BIEN SE GENERA AUTOMATICAMENTE
INSERT INTO BIENES (nombreBien,idMascota) VALUES('baño','PET97096');
INSERT INTO BIENES (nombreBien,idMascota) VALUES('compra','PET97095');

--SE VERIFICA CANT DE MASCOTAS EN PELUQUERIA NO DEBE SER MAYOR A 7
insert into Bienes ( nombreBien, idMascota) values ('peluqueria', 'PET97051');
insert into Bienes ( nombreBien,idMascota) values ('peluqueria', 'PET97052');
insert into Bienes ( nombreBien, idMascota) values ( 'peluqueria','PET97053');
insert into Bienes (nombreBien, idMascota) values ( 'peluqueria','PET97054');
insert into Bienes (nombreBien, idMascota) values ('peluqueria','PET97055');
insert into Bienes ( nombreBien, idMascota) values ('peluqueria', 'PET97056');
insert into Bienes ( nombreBien, idMascota) values ( 'peluqueria','PET97057');

/*VISTAS*/

--Queremos las ventas diarias 
 
 CREATE OR REPLACE VIEW VENTASDIARIAS AS
    SELECT fecha,precio,lineafactura.idBien,nombreBien,nombre AS Venta
    FROM lineaFactura,clientes,bienes
    WHERE fecha = TO_DATE(SYSDATE,'DD-MM-YYYY')
    order by fecha; 

--Queremos la cantidad de clientes

CREATE OR REPLACE VIEW CANTCLENTES AS
    SELECT fechaInscripcion, count(cedula) as cantCliente
    FROM clientes 
    group by fechaInscripcion;

--Queremos las mayores Ventas
CREATE OR REPLACE VIEW MayoresVentas AS
   SELECT sum(precio)as total,idFactura,idBien
    FROM LineaFactura
    group by precio,idFactura, idBien
    ORDER BY precio DESC;
    
--Queremos la cantidad de productos
CREATE OR REPLACE VIEW CantidadProductos AS
    SELECT cantidad,idBien,nombreProducto
    FROM productos
    ORDER BY cantidad ASC;
    
--XVISTAS

DROP VIEW VENTASDIARIAS;
DROP VIEW CANTCLENTES;
DROP VIEW MayoresVentas;
DROP VIEW CantidadProductos;

--INDICES

CREATE INDEX INDEX_CLIENTE ON clientes(fechaInscripcion);
CREATE INDEX INDEX_PELUQUERIA ON bienes(nombreBien);

--XINDICES
DROP INDEX INDEX_CLIENTE;
DROP INDEX INDEX_PELUQUERIA;

/*COMPONENTES*/
               /*CRUDE*/
------------------------                                       /*PC_PERSONA*/    -----------------------------------
                                       
CREATE OR REPLACE PACKAGE PC_PERSONA IS
    PROCEDURE AD_EMPLEADOS(xcedula IN number(10),xcargo IN char(1),xnombre IN varchar(50),XCorreo IN varchar(50));
        PROCEDURE MOD_EMPLEADOS(xcedula IN number(10),xnombre IN varchar(50), XCargo IN char(1),XCorreo IN varchar(50));
        PROCEDURE EL_EMPLEADOS(XNumDoc IN number(15));
     PROCEDURE AD_CLIENTES(xcedula IN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50));
        PROCEDURE MOD_CLIENTES (xcedula IN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50));
        PROCEDURE EL_CLIENTES(Xcedula IN number(10));
    PROCEDURE AD_CELULARES (xcedula IN NUMBER(10), xcelular IN NUMBER(10));
        PROCEDURE MOD_CELULARES(xcedula IN NUMBER(10),xcelular IN NUMBER(10));
        PROCEDURE EL_CELULARES (xcelular IN number(10));
    PROCEDURE AD_MASCOTAS(xidmascota IN varchar(8),xcedula IN NUMBER(10),xnombreMascota IN varchar(50),Xedad IN number(2),xraza IN varchar(50),xsexo IN char(1));
        PROCEDURE MOD_MASCOTAS(xidmascota IN varchar(8),xcedula IN NUMBER(10),xnombreMascota IN varchar(50),Xedad IN number(2),xraza IN varchar(50),xsexo IN char(1));
        PROCEDURE EL_MASCOTAS(XidMascota IN varchar(8));
    FUNCTION CO_EMPLEADOS RETURN SYS_REFCURSOR;
	FUNCTION CO_CLIENTE  RETURN SYS_REFCURSOR ; 
    FUNCTION CO_CELULARES RETURN SYS_REFCURSOR;
    FUNCTION CO_MASCOTAS RETURN SYS_REFCURSOR;
    FUNCTION CO_CANTCLIENTES RETURN SYS_REFCURSOR;
	 
END PC_PERSONA;            
/

                               --------------               /*PCFACTURA*/    ------------------
CREATE OR REPLACE PACKAGE PC_FACTURA IS
	PROCEDURE AD_FACTURA( XIdfactura IN number(5),xcedula in number(10),XFecha IN DATE);
        PROCEDURE MOD_FACTURAS(Xidfactura IN number(5),xcedula in number(10),XFecha IN DATE);
         PROCEDURE EL_FACTURAS(Xidfactura IN number(5));
    FUNCTION CO_FACTURA RETURN SYS_REFCURSOR;
	FUNCTION CO_VentasDiarias RETURN SYS_REFCURSOR;
END PC_FACTURA;
/

                        /*PC BIEN*/
                        
CREATE OR REPLACE PACKAGE PC_BIEN IS
    PROCEDURE AD_BIEN( XIdbien IN number(5),xnombreBien in varchar(50));
    PROCEDURE AD_PRODUCTO(Xidbien IN number(5),xnombreProducto in varchar(50), xcantidad in number(3),xtipoproducto in char(1),xprecioCompra in number(4),xdescripcion in varchar(50));
        PROCEDURE EL_PRODUCTO(XidBien in number(5), xnombreProducto in varchar(50));
        PROCEDURE MOD_PRODUCTO (XidBien in number(5), XnombreProducto in varchar(50));
    FUNCTION CO_BIEN RETURN SYS_REFCURSOR;
	FUNCTION CO_CantProductos RETURN SYS_REFCURSOR;
    FUNCTION CO_Producto RETURN SYS_REFCURSOR;
    
END PC_BIEN;
/

      /*CRUDI------------------------------------------------------------*/
                                  ---------     /*PC_PERSONA*/-----------
                                       
CREATE OR REPLACE PACKAGE BODY PC_PERSONA IS

	PROCEDURE AD_EMPLEADOS (Xcedula IN number(10),Xcargo IN char(1),Xnombre IN varchar(50),XCorreo IN varchar(50)) IS
        BEGIN
            INSERT INTO empleados(cedula, cargo, nombre,edad,correo) 
            VALUES (xcedula,xcargo,xnombre,XCorreo);
            COMMIT;
                EXCEPTION
                WHEN OTHERS THEN
                ROLLBACK;
                raise_application_error(-20001,'Error al insertar en empleado');
    END;
    PROCEDURE MOD_EMPLEADOS(xcedula IN number(10),xnombre IN varchar(50), XCargo IN varchar(1),XCorreo IN varchar(50))IS
	  BEGIN
		UPDATE empelados SET correo=xcorreo,cargo=xcargo WHERE cedula = Xcedula;
		COMMIT;
            EXCEPTION 
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20002,'Error al modificar en empleados');
	END;
    PROCEDURE EL_EMPLEADOS(Xcedula IN number(10)) IS
	 BEGIN 
		DELETE FROM empleados  WHERE(cedula=Xcedula);
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20003,'Error al eliminar en empleados');
	END;
    PROCEDURE AD_CLIENTES(xcedula IN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50)) IS
	  BEGIN
		INSERT INTO clientes (cedula ,nombre , edad,fechainscipcion, fecharetiro,,correo,direccion) VALUES (xcedula ,xnombre , xedad,xfechainscipcion, xfecharetiro,xcorreo,xdireccion);
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al insertar en clientes');
	END;
    PROCEDURE MOD_CLIENTES (xcedulaIN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50)) IS
	BEGIN
		UPDATE clientes SET  direccion=xdireccion,correo=xcorreo,edad=xedad,cargo=xcargo WHERE cedula = xcedula;
		COMMIT;
		EXCEPTION 
		WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20002,'Error al modificar en clientes');
	END;
    PROCEDURE EL_CLIENTES(Xcedula IN number(10)) IS
	BEGIN 
		DELETE FROM clientes  WHERE(cedula=xcedula);
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20003,'Error al eliminar en clientes');
	END;
    PROCEDURE AD_CELULARES (xcedula IN NUMBER(10), xcelular IN NUMBER(10)) IS
      BEGIN
        INSERT INTO celulares(cedla,celulares)
        VALUES(xcedula,xcelular);
        COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
            ROLLBACK;
            raise_application_error(-20004,'error al insertar en celulares');
    END;
    PROCEDURE MOD_CELULARES(xcedula IN NUMBER(10),xcelular IN NUMBER(10)) IS
    BEGIN
		UPDATE celulares SET  celular=xcelular WHERE cedula = xcedula;
		COMMIT;
            EXCEPTION 
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20002,'Error al modificar en celulares');
	END;
    PROCEDURE EL_CELULARES(xcedula in number(10),xcelular in number(10)) IS
    BEGIN
        DELETE FROM celulares WHERE (cedula=xcedula);
        COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20003,'Error al eliminar en celulares');
	END;
    PROCEDURE AD_MASCOTAS(xidmascota IN varchar(8),xcedula IN NUMBER(10),xnombreMascota IN varchar(50),Xedad IN number(2),xraza IN varchar(50),xsexo IN char(1)) IS
	  BEGIN
		INSERT INTO clientes (idmascota ,cedula ,nombreMascota,edad ,raza,sexo) VALUES (Xidmascota ,Xcedula ,XnombreMascota,Xedad ,Xraza,Xsexo);
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al insertar en mascotas');
	END;
  
    PROCEDURE MOD_MASCOTAS(xidmascota IN varchar(8),xcedula IN NUMBER(10),xnombreMascota IN varchar(50),Xedad IN number(2),xraza IN varchar(50),xsexo IN char(1)) IS
	  BEGIN
		UPDATE clientes SET nombreMascota=xnombremascota,edad=xedad ,raza=xraza,sexo=xsexo WHERE idMascota=Xidmascota;
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al modificar en mascotas');
	END;
    PROCEDURE EL_MASCOTAS(XidMascota IN varchar(8)) IS
      BEGIN 
		DELETE FROM mascotas WHERE(idMascota=xidMascota);
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20003,'Error al eliminar en mascotas');
    END;

  FUNCTION CO_EMPLEADOS(Xcedula IN number(15)) RETURN SYS_REFCURSOR IS co_emp SYS_REFCURSOR;
	 BEGIN 
		OPEN co_emp FOR
			SELECT *
            FROM empleados 
            ORDER BY cedula;;
		RETURN co_emp;
	END; 
  FUNCTION CO_CLIENTE (Xcedula IN number(10)) RETURN SYS_REFCURSOR IS CO_CLIEN SYS_REFCURSOR;
	BEGIN 
		OPEN CO_CLIEN FOR
			SELECT 
                *
            FROM clientes 
            ORDER BY cedula;
		RETURN CO_CLIEN;
    END;
    FUNCTION CO_MASCOTAS (Xidmascota IN varchar(8)) RETURN SYS_REFCURSOR IS CO_MASC SYS_REFCURSOR;
        BEGIN 
            OPEN CO_MASC FOR
                 SELECT *
            FROM MASCOTAS 
            ORDER BY xidMascota;;
		RETURN CO_MASC;
	END;
  FUNCTION CONSULTARCANTCLIENTES(xcedula IN number(10),xnombre in varchar(50),xfechainscripcion,xcancliente number(3))RETURN SYS_REFCURSOR IS CO_CANTCLI SYS_REFCURSOR;
    BEGIN 
        OPEN CO_CANTCLI FOR
            SELECT *
            FROM clientes
            ORDER BY fechainscripcion;
        RETURN CO_CANTCLI;
	END;
    
END PC_PERSONA;            
/

                                              /*PCFACTURA*/--------------------
CREATE OR REPLACE PACKAGE BODY PC_factura IS
	PROCEDURE AD_FACTURA( XIdfactura IN number(5),xcedula in number(10),XFecha IN DATE) IS
	BEGIN
		INSERT INTO FACTURAS (Idfactura ,cedula,Fecha) 
        VALUES (XIdfactura ,xcedula,XFecha);
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al insertar en facturas');
	END;
    PROCEDURE MOD_FACTURAS(Xidfactura IN number(5),xcedula in number(10),XFecha IN DATE) IS
	BEGIN
		UPDATE FACTURAS SET Fecha = Xfecha WHERE idfactura = Xidfactura;
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al modificar en factura');
	END;
    FUNCTION CO_FACTURA(XidFactura IN number) RETURN SYS_REFCURSOR IS CO_FAC SYS_REFCURSOR;
	BEGIN 
		OPEN CO_FAC FOR
			SELECT *
            FROM FACTURAS 
            ORDER BY idfactura;
		RETURN CO_FAC;
	END;
    PROCEDURE EL_FACTURAS(Xidfactura IN number(5)) IS
	BEGIN
		DELETE FROM facturas WHERE idfactura = Xidfactura;
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al eliminar en facturas');
	END;                                              
    FUNCTION CO_VentasDiarias(Xfecha IN date, Xprecio in number,Xidbien IN number,xidBien in number(5),xnombreBien in varchar(50),xnombreCliente in varchar(50)) RETURN SYS_REFCURSOR IS VENTASDIARIAS SYS_REFCURSOR;
	BEGIN 
		OPEN VENTASDIARIAS FOR
			SELECT *
            FROM lineaFactura
            GROUP BY idBien 
            ORDER BY precio DESC;
		RETURN VETASDIARIAS ;
	END;          

                        /*PC BIEN*/
CREATE OR REPLACE PACKAGE BODY PC_BIEN IS
    PROCEDURE AD_BIEN(XIdbien IN number(5),xnombreBien in varchar(50),xidmascota in varchar(8)) IS
    BEGIN
        INSERT INTO bienes (Idbien,nombreBien,idmascota)
        VALUES (XIdbien IN number(5),xnombreBien in varchar(50),xidmascota in varchar(8));
         COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20016, 'No se puede insertar el bien');
    END;
    
    PROCEDURE AD_PRODUCTO(Xidbien IN number(5),xnombreProducto in varchar(50), xcantidad in number(3),xtipoproducto in char(1),xprecioCompra in number(4),xdescripcion in varchar(50))IS
     BEGIN
        INSERT INTO productos (Idbien,nombrePrducto,cantidad,tipoProducto,precioCompra,descripcion))
        VALUES (Xidbien IN number(5),xnombreProducto in varchar(50), xcantidad in number(3),xtipoproducto in char(1),xprecioCompra in number(4),xdescripcion in varchar(50));
         COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20016, 'No se puede insertar el producto');
    END;
        PROCEDURE EL_PRODUCTO(XidBien in number(5), xnombreProducto in varchar(50));
        BEGIN
		DELETE FROM productos WHERE idbien = Xidbien and nombreProducto=xnombreProducto;
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al eliminar en prodcutos');
	END;                                              
        PROCEDURE MOD_PRODUCTO (XidBien in number(5), XnombreProducto in varchar(50)) IS
        BEGIN
		UPDATE productos SET nombreProducto=xnombreProducto WHERE idBien=xidBien;
		COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
			ROLLBACK;
			raise_application_error(-20001,'Error al modificar en productos');
	END;
    FUNCTION CO_BIEN RETURN SYS_REFCURSOR IS CO_B SYS_REFCURSOR;
    BEGIN 
		OPEN CO_B FOR
			SELECT *
            FROM bienes
            ORDER BY idbien;
		RETURN CO_B ;
	END;  
	FUNCTION CO_CantProductos RETURN SYS_REFCURSOR IS CO_CANTP SYS_REFCURSOR;
    BEGIN 
		OPEN CO_CANTP FOR
			SELECT *
            FROM productos
            ORDER BY idbien;
		RETURN CO_CANTP ;
	END; 
    FUNCTION CO_Producto RETURN SYS_REFCURSOR IS CO_PROD SYS_REFCURSOR;
    BEGIN 
		OPEN CO_CANTP FOR
			SELECT *
            FROM productos
            ORDER BY cantidad;
		RETURN CO_CANTP ;
	END; 
END PC_FACTURA;
/   
/*XCRUD*/
DROP PACKAGE PC_PERSONA;
DROP PACKAGE PC_FACTURA;
DROP PACKAGE PC_BIEN;

/*CRUD OK*/
begin
    PC_PERSONA.AD_EMPLEADOS(11313602,'V','Natalia Orjuela',21,'natalia.orjuela@mail.com');
end;
                                                      --/*ACTORESE*/
                                       --PA_GERENTE
CREATE OR REPLACE PACKAGE  PA_GERENTE IS
    PROCEDURE AD_EMPLEADOS(xcedula IN number(10),xcargo IN char(1),xnombre IN varchar(50),XCorreo IN varchar(50));
        PROCEDURE MOD_EMPLEADOS(xcedula IN number(15),xnombre IN varchar(50), XCargo IN varchar(1),XCorreo IN varchar(50));
        PROCEDURE EL_EMPLEADOS(XNumDoc IN number(15));
     PROCEDURE AD_CLIENTES(xcedula IN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50));
        PROCEDURE MOD_CLIENTES (xcedula IN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50));
        PROCEDURE EL_CLIENTES(Xcedula IN number(10));
    PROCEDURE AD_CELULARES (xcedula IN NUMBER(10), xcelular IN NUMBER(10));
        PROCEDURE MOD_CELULARES(xcedula IN NUMBER(10),xcelular IN NUMBER(10));
        PROCEDURE EL_CELULARES (xcelular IN number(10));
    PROCEDURE AD_MASCOTAS(xidmascota IN varchar(8),xcedula IN NUMBER(10),xnombreMascota IN varchar(50),Xedad IN number(2),xraza IN varchar(50),xsexo IN char(1));
        PROCEDURE MOD_MASCOTAS(xidmascota IN varchar(8),xcedula IN NUMBER(10),xnombreMascota IN varchar(50),Xedad IN number(2),xraza IN varchar(50),xsexo IN char(1));
        PROCEDURE EL_MASCOTAS(XidMascota IN varchar(8));
    FUNCTION CO_EMPLEADOS RETURN SYS_REFCURSOR;
	FUNCTION CO_CLIENTE  RETURN SYS_REFCURSOR ; 
    FUNCTION CO_CELULARES RETURN SYS_REFCURSOR;
    FUNCTION CO_MASCOTAS RETURN SYS_REFCURSOR;
    FUNCTION CO_CANTCLIENTES RETURN SYS_REFCURSOR;
	PROCEDURE AD_FACTURA( XIdfactura IN number(5),xcedula in number(10),XFecha IN DATE);
        PROCEDURE MOD_FACTURAS(Xidfactura IN number(5),xcedula in number(10),XFecha IN DATE);
         PROCEDURE EL_FACTURAS(Xidfactura IN number(5));
    FUNCTION CO_FACTURA RETURN SYS_REFCURSOR;
	FUNCTION CO_VentasDiarias RETURN SYS_REFCURSOR;
    PROCEDURE AD_BIEN( XIdbien IN number(5),xnombreBien in varchar(50));
    PROCEDURE AD_PRODUCTO(Xidbien IN number(5),xnombreProducto in varchar(50), xcantidad in number(3),xtipoproducto in char(1),xprecioCompra in number(4),xdescripcion in varchar(50));
        PROCEDURE EL_PRODUCTO(XidBien in number(5), xnombreProducto in varchar(50));
        PROCEDURE MOD_PRODUCTO (XidBien in number(5), XnombreProducto in varchar(50));
    FUNCTION CO_BIEN RETURN SYS_REFCURSOR;
	FUNCTION CO_CantProductos RETURN SYS_REFCURSOR;
    FUNCTION CO_Producto RETURN SYS_REFCURSOR; 
END PA_GERENTE;            
/                                                      
	                        --PA_VENDEDOR
CREATE OR REPLACE PACKAGE  PA_VENDEDOR IS
    PROCEDURE AD_CLIENTES(xcedula IN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50));
        PROCEDURE MOD_CLIENTES (xcedula IN number(10),xnombre IN varchar(50),Xedad IN number(2),Xfechainscripcion IN Date,Xfecharetiro IN Date,XCorreo IN varchar(50),XDireccion IN varchar(50));    
    FUNCTION CO_CLIENTE  RETURN SYS_REFCURSOR ; 
    PROCEDURE AD_PRODUCTO(Xidbien IN number(5),xnombreProducto in varchar(50), xcantidad in number(3),xtipoproducto in char(1),xprecioCompra in number(4),xdescripcion in varchar(50));
     FUNCTION CO_Producto RETURN SYS_REFCURSOR; 
    PROCEDURE AD_FACTURA( XIdfactura IN number(5),xcedula in number(10),XFecha IN DATE);
    FUNCTION CO_FACTURA RETURN SYS_REFCURSOR;
    FUNCTION CO_CantProductos RETURN SYS_REFCURSOR;
END PA_VENDEDOR;
/
                                                      /*ACTORESI*/
--PA_GERENTE
CREATE OR REPLACE PACKAGE BODY PA_GERENTE IS
    PROCEDURE AD_EMPLEADOS(xcedula IN number(10),xcargo IN char(1),xnombre IN varchar(50),XCorreo IN varchar(50))IS
    BEGIN
        PC_PERSONAS.AD_EMPLEADOS(xcedula ,xcargo ,xnombre,XCorreo);
        PC_PERSONAS.AD_CLIENTES(xcedula,xnombre,Xedad ,Xfechainscripcion,Xfecharetiro ,XCorreo,XDireccion);
        PC_PERSONAS.AD_CELULARES(xcedula , xcelular);
        PROCEDURE AD_MASCOTAS(xidmascota,xcedula,xnombreMascota,Xedad,xraza,xsexo);
    END;
    
                                                       /*SEGURIDAD*/
create role gerente;
create role Vendedor;
/*Grantizar ejecucion*/
GRANT EXECUTE ON PA_GERENTE TO gerente;
GRANT EXECUTE ON PA_VENDEDOR TO vendedor;
                                                       /*XSEGURIDAD*/
                                                       
/*Remover Ejecucion*/
REVOKE EXECUTE ON PA_GERENTE FROM gerente;
REVOKE EXECUTE ON PA_VENDEDOR FROM vendedor;
/*Remover Roles*/
DROP ROLE gerente;
DROP ROLE vendedor;

/*Borrar Paquetes*/
DROP PACKAGE PA_VENDEDOR;
DROP PACKAGE PA_GERENTE;

                                         /*PRUEBAS*/
/*

Como Gerente de Rey kanino soy el responsable de registrar los empleados o los clientes nuevos que lleguen
El día de hoy 30 de noviembre del 2020 ingreso una persona,y tomo el servicio de peluqueria , se le tomaron sus datos 
los cuales fueron su numero de cedula 39557102, su nombre el cual es Maria Villate, su edad la cual es 18 años y su correo el cual es mariav@gmail.com
*/
begin
    PA_GERENTE.AD_CLIENTES(39557102,'Maria Villate',18,'30/11/2020',null,'mariav@gmail.com');
end;
/
                                         
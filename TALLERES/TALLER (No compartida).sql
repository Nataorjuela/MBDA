DROP TABLE Clientes;
DROP TABLE Bienes;
DROP TABLE Servicios;
DROP TABLE Productos;
DROP TABLE Facturas;
DROP TABLE LineasFacturas;
DROP TABLE Utilizados;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='Bienes';


/*RESTRICCIONES DECLARATIVAS*/

/*MANTENER CLIENTE*/
--1.TipoId puede tener uno de los siguientes valores CC (Cedula de ciudadania) , CE (Cedula de extranjer�a) o NT(Nit)
--2.Un cliente debe tener m�nimo un tel�fono
--3.El nombre debe tener m�nimo 10 caracteres
--4. El correo debe tener m�ximo un @ y un .
--5. Un cliente no se puede auto-recomendar
CREATE TABLE Clientes(tId varchar(2) NOT NULL,nId number(15)NOT NULL,nombre varchar(20)NOT NULL,correo varchar(10),telefonos varchar(10) NOT NULL,recomienda number(15));
ALTER TABLE Clientes ADD CONSTRAINT TipoId CHECK(tId='CC' OR tId='CE'OR tId='NT');
ALTER TABLE Clientes ADD CONSTRAINT nombre CHECK(nombre>9);
ALTER TABLE Clientes ADD CONSTRAINT correo CHECK(correo LIKE '%@%' AND correo LIKE '%.%');
ALTER TABLE Clientes ADD CONSTRAINT recomendar CHECK(nId!=recomienda); 

/*MANTENER BIEN*/
--1. Moneda es positivo y tiene 8 d�gitos enteros y dos reales.El valor real s�lo puede ser 00 o 50.
--2. La herencia debe ser exclusiva (ver DC)
--3. La herencia debe ser completa (ver DC)
--4. El precio de venta de los productos debe ser 10% mayor al de compra
--5. El precio de venta de los servicios debe ser 20% mayor a su costo
ALTER TABLE Bienes ADD CONSTRAINT Moneda CHECK(precioVenta>0 AND (precioVenta=(to_char(precioVenta,'fm99999999.00')) OR (precioVenta=to_char(precioVenta,'fm99999999.50'))));
CREATE TABLE Servicios(codigoBien varchar(5)NOT NULL,manoDeObra numeric(10,2)NOT NULL, costo numeric(10,2)NOT NULL)INHERITS(Bienes);
CREATE TABLE Productos(codigoBien varchar(5)NOT NULL,existencias number NOT NULL,precioCompra numeric(10,2)NOT NULL )INHERITS (Productos);
CREATE TABLE Facturas(numero number(6)NOT NULL,fecha date NOT NULL,total numeric(10,2)NOT NULL );
CREATE TABLE LineasFacturas(cantidad number NOT NULL,precioVenta numeric(10,2)NOT NULL)INHERITS(Facturas);
ALTER TABLE  Productos ADD CONSTRAINT precioVenta CHECK(precioCompra<precioVenta-precioVenta*0.1);
ALTER TABLE Servicios ADD CONSTRAINT CHK_precioVenta CHECK(precioVenta-precioVenta*0.2>costo);


/*REGISTRAR FACTURA*/
--1.El n�mero de la factura debe ser consecutivo iniciando en 1
--2.El n�mero de la factura se asigna cuando se realiza???????
--3.Las facturas deben tener m�nimo una l�nea de factura (ver DC)
--4.Los precios de venta de los bienes nunca deben disminuir
--5.Los precios de venta no pueden ser mayores al precio actual del venta del bien
ALTER TABLE Facturas ADD CONSTRAINT Consecutivo CHECK(numero=ROW_NUMBER(numero) AND numero LIKE '1%');


--/*CONSTRUCCI�N B�SICA*/
CREATE TABLE Bienes(codigo varchar(5)NOT NULL,nombre varchar(10)NOT NULL,precioVenta numeric(10,2)NOT NULL);
CREATE TABLE Servicios(codigoBien varchar(5)NOT NULL,manoDeObra numeric(10,2)NOT NULL,costo numeric(10,2)NOT NULL);
CREATE TABLE Productos(codigoBien varchar(5)NOT NULL,existencias number NOT NULL,precioCompra numeric(10,2)NOT NULL);
CREATE TABLE Utilizados(codigoBien varchar(5)NOT NULL,unidades number NOT NULL);


ALTER TABLE Bienes ADD PRIMARY KEY (codigo);

ALTER TABLE Servicios ADD PRIMARY KEY (codigoBien);
ALTER TABLE Servicios ADD CONSTRAINT FK_Servicios FOREIGN KEY (codigoBien) REFERENCES Bienes(codigo);

ALTER TABLE Productos ADD PRIMARY KEY (codigoBien);
ALTER TABLE Productos ADD CONSTRAINT FK_productos FOREIGN KEY (codigoBien) REFERENCES Bienes(codigo);

ALTER TABLE Utilizados ADD PRIMARY KEY (codigoBien);
ALTER TABLE Productos ADD CONSTRAINT FK_Utilizados FOREIGN KEY (codigoBien) REFERENCES Servicios(codigoBien); 
ALTER TABLE Productos ADD CONSTRAINT FK_Utiliza FOREIGN KEY (codigoBien) REFERENCES Productos(codigoBien);
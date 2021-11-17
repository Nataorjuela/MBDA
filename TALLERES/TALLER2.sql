DROP TABLE Clientes;
DROP TABLE Bienes;
DROP TABLE Servicios;
DROP TABLE Productos;
DROP TABLE Facturas;
DROP TABLE LineasFacturas;
DROP TABLE Utilizados;
DROP TABLE Opiniones;

--/*CONSTRUCCI�N B�SICA*/
CREATE TABLE Bienes(codigo varchar(5)NOT NULL,nombre varchar(10)NOT NULL,precioVenta numeric(10,2)NOT NULL);
CREATE TABLE Servicios(codigoBien varchar(5)NOT NULL,nombre varchar(10)NOT NULL,precioVenta numeric(10,2)NOT NULL,manoDeObra numeric(10,2)NOT NULL,costo numeric(10,2)NOT NULL);
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
CREATE TABLE LineasFacturas(numeroFact number(6)NOT NULL,cantidad number NOT NULL,precioVenta numeric(10,2)NOT NULL,tId varchar(2) NOT NULL,nId number(15)NOT NULL,codigoBien varchar(5)NOT NULL)INHERITS(Facturas);
ALTER TABLE  Productos ADD CONSTRAINT precioVenta CHECK(precioCompra<precioVenta-precioVenta*0.1);
ALTER TABLE Servicios ADD CONSTRAINT CHK_precioVenta CHECK(precioVenta-precioVenta*0.2>costo);


/*REGISTRAR FACTURA*/
--1.El n�mero de la factura debe ser consecutivo iniciando en 1
--2.El n�mero de la factura se asigna cuando se realiza
--3.Las facturas deben tener m�nimo una l�nea de factura (ver DC)
--4.Los precios de venta de los bienes nunca deben disminuir
--5.Los precios de venta no pueden ser mayores al precio actual de la venta del bien
ALTER TABLE Facturas ADD CONSTRAINT Consecutivo CHECK(numero=ROW_NUMBER(numero) AND numero LIKE '1%');

CREATE OR REPLACE TRIGGER Consecutivo
BEFORE INSERT ON Facturas
FOR EACH ROW
    DECLARE
    Consecutivo NUMBER(6);
    BEGIN 
        SELECT COUNT(numero) INTO Consecutivo FROM Facturas;
        :NEW.numero:=Consecutivo+1;
    END;

ALTER TABLE LineasFacturas ADD CONSTRAINT  CantLinea CHECK(COUNT(numeroFact)>=1);

CREATE OR REPLACE TRIGGER precioVenta
BEFORE UPDATE ON LineasFacturas
FOR EACH ROW WHEN (precioVenta!= NULL)
BEGIN
    IF :OLD.precioVenta<NEW.precioVenta THEN
        :NEW.precioVenta:=OLD.precioVenta;
    ELSE
        :NEW.precioVenta:=New.precioVenta;
    END IF;
END;

CREATE OR REPLACE TRIGGER precioActual
BEFORE UPDATE ON LineasFacturas
FOR EACH ROW WHEN(precioVenta!=Null)
BEGIN
    IF :OLD.PrecioVenta>NEW.precioVenta THEN
        :NEW.precioVenta:=OLD.precioVenta;
    ELSE
        :NEW.precioVenta:=NEW.precioVenta;
    END IF;
END;

/*RESTRICCIONES PROCEDIMENTALES*/
--MANTENER BIEN
--1.Los bienes se deben poder eliminar si no tienen facturas asociadas o si no son parte de un servicio.
--Actualmente, �qu� condiciones se deben cumplir para poder eliminar un bien? 
--RTA/ SE DEBE CUMPLIR LA CONDICION DE QUE EL BIEN NO TENGA UNA FACTURA.
CREATE OR REPLACE TRIGGER eliminarBien
BEFORE DELETE ON Bienes
BEGIN
    SELECT Bienes.codigo,numeroFact INTO eliminar FROM Bienes
    FULL OUTER JOIN LineasFacturas
    ON Bienes.codigo=LineasFacturas.codigoBien;
    IF LineasFacturas.numeroFact=NULL THEN
        DELETE Bienes.codigo;
    END IF;
END;
--3.En un servicio el costo total de los productos no debe superar el valor de la mano de obra.
--�Qu� acciones hacen que se modifique el costo de productos? �Qu� acciones hacen que se modifique el precio de la mano de obra? 
CREATE OR REPLACE TRIGGER CostoTotal
BEFORE INSERT ON Servicios 
BEGIN
    IF :NEW.costo <= NEW.manoDeObra THEN
        :NEW.costo:=:NEW.costo;
    ELSE
        :NEW.costo:=NEW.manoDeObra;
    END IF;
END;
/*MANTENER CLIENTE*/
--1. Los clientes se deben poder eliminar, si no tienen facturas asociadas.
--Actualmente, �qu� condiciones se deben cumplir para poder eliminar un cliente? 
--RTA/El cliente debe tener un numero de factura nulo.
CREATE OR REPLACE TRIGGER eliminarCliente
BEFORE DELETE ON Clientes
BEGIN
    SELECT Clientes.nId,numero INTO eliminar FROM Clientes
    FULL OUTER JOIN Facturas
    ON Clientes.nId=Facturas.nid;
    IF Facturas.numeroFact=NULL THEN
        DELETE Clientes.nId;
    END IF;
END;
--3. No est� permitido modificar los datos de identificaci�n de los clientes.
CREATE OR REPLACE TRIGGER nid_Cliente
BEFORE UPDATE ON Clientes
FOR EACH ROW
    BEGIN
        :NEW.nId := old.nId;
END;
        
CREATE OR REPLACE TRIGGER tid_Cliente
BEFORE UPDATE ON Clientes
FOR EACH ROW
    BEGIN
        :NEW.tId := old.tId;
END;
/*REGISTRAR FACTURA*/
--1. �Cu�les son los datos m�nimos para crear el encabezado de una factura? �C�mo se definen los otros?
--Implemente la automatizaci�n.
--RTA En el encabezado de la factura se pide el nombre del establecimiento,la direcci�n,el NIT.
--RTA/ La fecha,los items con su precio, un subtotal y un total.
CREATE OR REPLACE TRIGGER fecha
BEFORE INSERT ON Facturas
FOR EACH ROW
    BEGIN
        :NEW.fecha:=SYSDATE;
END;
--3. Ni las facturas, ni sus detalles, se deben poder eliminar ni modificar. Es un registrar. Lance una
--excepci�n de aplicaci�n indicando que no es posible hacerlo.
CREATE OR REPLACE TRIGGER Facturas_ID_restriccion
BEFORE UPDATE ON Facturas
FOR EACH ROW
    BEGIN
        IF OLD.numero = :NEW.numero THEN
            RAISE_APPLICATION_ERROR(-2002,'NO SE PUEDE MODIFICAR EL NUMERO DE LA FACTURA');
        END IF;
END;

CREATE OR REPLACE TRIGGER Facturas_FECHA_restriccion
BEFORE UPDATE ON Facturas
FOR EACH ROW
    BEGIN
        IF OLD.fecha = :NEW.fecha THEN
            RAISE_APPLICATION_ERROR(-2002,'NO SE PUEDE MODIFICAR LA FECHA DE LA FACTURA');
        END IF;
END;

CREATE OR REPLACE TRIGGER Facturas_TOTAL_restriccion
BEFORE UPDATE ON Facturas
FOR EACH ROW
    BEGIN
        IF OLD.total = :NEW.total THEN
            RAISE_APPLICATION_ERROR(-2002,'NO SE PUEDE MODIFICAR EL TOTAL DE LA FACTURA');
        END IF;
END;

CREATE OR REPLACE TRIGGER Facturas_ID_restriccion
BEFORE DELETE ON Facturas
FOR EACH ROW
    BEGIN
        IF OLD.numero = :NEW.numero THEN
            RAISE_APPLICATION_ERROR(-2002,'NO SE PUEDE ELIMINAR EL NUMERO DE LA FACTURA');
        END IF;
END;

CREATE OR REPLACE TRIGGER Facturas_FECHA_restriccion
BEFORE DELETE ON Facturas
FOR EACH ROW
    BEGIN
        IF OLD.fecha = :NEW.fecha THEN
            RAISE_APPLICATION_ERROR(-2002,'NO SE PUEDE ELIMINAR LA FECHA DE LA FACTURA');
        END IF;
END;

CREATE OR REPLACE TRIGGER Facturas_TOTAL_restriccion
BEFORE DELETE ON Facturas
FOR EACH ROW
    BEGIN
        IF OLD.total = :NEW.total THEN
            RAISE_APPLICATION_ERROR(-2002,'NO SE PUEDE ELIMINAR EL TOTAL DE LA FACTURA');
        END IF;
END;


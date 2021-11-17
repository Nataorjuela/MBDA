

/*CICLO1:TABLAS*/

--CRUD GRIS
CREATE TABLE Localidades(nombre varchar(15)NOT NULL,prioridad number(1)NOT NULL,numerofam number(5)NOT NULL,departamento varchar(15)NOT NULL);
--CRUD VERDE
CREATE TABLE Familias(numero number(5)NOT NULL);
--CRUD NARANJA
CREATE TABLE Personas(codigo number(7)NOT NULL,numerofam number(5) NOT NULL,nombre varchar2(50)NOT NULL,genero char(1)NOT NULL,talla char(2) NOT NULL,nacimiento date NOT NULL);
CREATE TABLE Adultos(cedula number(12)NOT NULL,codigo number(7) NOT NULL,correo varchar2(40) NOT NULL,telefono varchar(12) NOT NULL);
--CRUD AZUL
CREATE TABLE Asignaciones(numerofam number(5) NOT NULL,numero number(9) NOT NULL,fecha date NOT NULL,aceptado varchar(5)NOT NULL);
CREATE TABLE Detalles(numeroAsig number(9) NOT NULL,orden number(4) NOT NULL ,codigoBien varchar(5) NOT NULL);
--CRUD ROSA
CREATE TABLE Bienes(codigo varchar(5) NOT NULL,nombre varchar2(30)NOT NULL,tipo char(1) NOT NULL,medida char(2)NOT NULL,unitario number(5) NOT NULL,retirado varchar(5)NOT NULL);
CREATE TABLE Vestuarios(cantidad number(4) NOT NULL,talla char(3)NOT NULL,numeroAsig number(9) NOT NULL,orden number(4) NOT NULL);
CREATE TABLE Perecederos(cantidad number(4) NOT NULL,vencimiento date NOT NULL,numeroAsig number(9) NOT NULL,orden number(4) NOT NULL);
CREATE TABLE Genericos(cantidad number(4) NOT NULL,numeroAsig number(9) NOT NULL,orden number(4) NOT NULL);
--CRUD MORADO
CREATE TABLE Opiniones(cedula  number(12)NOT NULL,numero NUMBER(5)NOT NULL,codigoBien varchar(5) NOT NULL,fecha date NOT NULL,opinion char(1) NOT NULL,justificacion varchar(20)NOT NULL);
CREATE TABLE OpinionesGrupales(numeroOp NUMBER(5)NOT NULL,razon varchar2(100),estrellas char(1)NOT NULL);

/*CICLO1:XTABLAS*/

DROP TABLE Localidades;
DROP TABLE Familias;
DROP TABLE Personas;
DROP TABLE Adultos;
DROP TABLE Asignaciones;
DROP TABLE Detalles;
DROP TABLE Bienes;
DROP TABLE Vestuarios;
DROP TABLE Perecederos;
DROP TABLE Genericos;
DROP TABLE Opiniones;
DROP TABLE OpinionesGrupales;
DROP TABLE Carrera;
DROP TABLE Ciclista;
DROP TABLE Empresa;
DROP TABLE Miembro;
DROP TABLE Persona;
DROP TABLE PropiedadDe;
DROP TABLE Punto;
DROP TABLE Registro;
DROP TABLE Segmento;
DROP TABLE Versión;




CREATE TABLE Carrera(codigo varchar2(20) not null, nombre varchar2(30) not null, pais varchar2(15) not null, categoria number(1)not null,periodicidad VARCHAR2(8) not null);
CREATE TABLE Punto (orden number(2) not null, nombre varchar2(10)not null,tipo varchar2(1) not null,distancia number(8,2) not null, tiempoLimite number(9) not null);
CREATE TABLE PropiedadDe(porcentaje Decimal(5,2) not null);
CREATE TABLE Miembro(id number(5) not null, dt varchar2 (2) not null, idn number(15) not null, pais varchar2(15) not null,correo varchar2(30));
CREATE TABLE Persona(nombres varchar2(50) not null);
CREATE TABLE Empresa(razonsocial varchar2(30) not null);
CREATE TABLE Ciclista( nacimiento date not null, categoria number(1)not null);
CREATE TABLE Segmento (nombre varchar2(10) not null, tipo varchar2 (1) not null);
CREATE TABLE Versión(nombre varchar2(5) not null, fecha date not null);
CREATE TABLE Registro(numero number(5) not null, fecha timestamp not null, tiempo number(9) not null, posicion number(5) not null, revision varchar(50)not null,dificultad varchar (1) not null, fotos varchar2(50) not null,comentario varchar2(20));


--A. ConsulteMla información que actualmente está en esa tabla
SELECT * FROM mbda.BENEFICIARIOS;
--B. Inclúyanse como adultos. (Los dos como adultos de una nueva familia)
INSERT INTO mbda.BENEFICIARIOS
VALUES(4,1,2155289,'Natalia Orjuela','F','1999/09/08',1010247478,'natalia.orjuela@mail.escuelaing.edu.co',3506698573);
--C. Traten de modificarse o borrarse. ¿qué pasa?
--No se tienen privilegios de borrado y de actualizacion de datos sobre la base
--D. Escriban la instrucción necesaria para otorgar los permisos que actualmente tiene la tabla BENEFICIARIOS. ¿quién la escribió?
--"Esta instruccion la deberia ejecutar el administrador de la base de datos o la persona que tenga la autorizacion  para dar permisos"
GRANT INSERT,SELECT ON mbda.BENEFICIARIOS TO bd2155289
--E. Escriban las instrucciones necesarias para importar los datos de esa tabla a su base de datos.

    
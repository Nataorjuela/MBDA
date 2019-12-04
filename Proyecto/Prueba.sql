 -- PRUEBA

-- Se abre una nueva peluqueria canina, por lo que el propietario decide contratar 3 empleados

EXECUTE PA_PERSONA.AD_EMPLEADOS ('9849821239', 'Inness', '8936784579', '114 Judy Plaza', 'imacairt0@google.pl', '9/13/2019', 32);
EXECUTE PA_PERSONA.AD_EMPLEADOS ('7512423395', 'Juline', '6766751416', '15424 Iowa Pass', 'jchafney1@wikia.com', '12/24/2018', 54);
EXECUTE PA_PERSONA.AD_EMPLEADOS ('29664534691', 'Kalli', '2382920601', '3567 Veith Pass', 'kbubbear2@phoca.cz', '4/28/2019', 40);


-- En su primer dia iniciaron recibiendo sus clientes, llegaron dos personas para tomar diferentes servicios en la clinica
-- por lo que se les pidio primero hacer su registro, con lo cual un empleado les iba a colaborar

EXECUTE PA_CLIENTE.AD_CLIENTE(7878023395, 'PET1', 191166, 171865);
EXECUTE PA_CLIENTE.AD_CLIENTE(942954785, 'PET2', 160268, 182596);

--luego se les pidio hacer el registro de sus mascotas a cada uno de los nuevos clientes

EXECUTE PA_CLIENTE.AD_MASCOTAS('PET6', 'Kelby', 'PITBULL', 'M', 26, 13, 'SI');
EXECUTE PA_CLIENTE.AD_MASCOTAS('PET7', 'Gearard', 'SCHNAUZER', 'F', 28, 12, 'SI');


-- Nuestros nuevos clientes despues de tomar el servicio generan un reporte con quejas sobre el veterinario Kalli, 
--por lo que se toman medidas y debe dejar la veterinaria

execute PA_PERSONA.EL_EMPLEADOS('29664534691');
UPDATE VDIR_PRODUCTO 
   SET DESCRIPCION = 'Medicina integral es una alternativa de aseguramiento en salud voluntario que permite acceso directo a todas las especialidades de la salud a través de una amplia red de prestadores, con coberturas y asistencias para cualquier evento en salud. Conoce nuestro completo portafolio de servicios con tarifas que se ajustan a cada una de tus necesidades y beneficios adicionales que aportan en el bienestar de nuestros usuarios.' 
 WHERE COD_PRODUCTO = 1;
UPDATE VDIR_PRODUCTO 
   SET DESCRIPCION = 'Con nuestros programas odontológicos cuentas con coberturas en diferentes espacialidades de la salud oral como rehabilitación, ortodoncia, odontopediatría, tratamientos excluidos del Plan Obligatorio y coberturas estéticas. También cuenta con asistencias y acompañamiento para inquietudes odontológicas, todo para darte motivos para sonreir.'
 WHERE COD_PRODUCTO = 2;
UPDATE VDIR_PRODUCTO 
   SET DESCRIPCION = 'Coomeva emergencia medica: Es un servicio diseñado para aquellas personas que quieren tener a sus empleados, visitantes y/o grupo familiar protegidos frente a un accidente o situación vital de salud, bien sea en su trabajo, en su casa o en cualquier lugar donde se encuentre (según área de cobertura)' 
 WHERE COD_PRODUCTO = 3;

COMMIT;



UPDATE VDIR_PROGRAMA 
   SET DESCRIPCION = 'Es un servicio de Atención Médica a Domicilio, Urgencias y Emergencias, orientación médica telefónica y traslado de pacientes. En la comodidad de ser atendido en el lugar donde se encuentre, las 24 horas al día, los 365 días del año, excelente atención con personal (Médico y Paramédico) altamente calificado. Adicionales, orientación medica telefónica, tele salud nutrición y psicología, urgencias odontológicas domiciliarias.' 
 WHERE COD_PROGRAMA = 1;
 
 UPDATE VDIR_PROGRAMA 
   SET DESCRIPCION = 'Es un programa de atención odontológica, con el respaldo de una red de especialistas altamente calificada, amplias coberturas integrales y con fines estéticos como ortodoncia correctiva y preventiva, ortopedia maxilar, blanqueamiento cosmético, tratamiento para cáncer oral, cobertura de accidentes y anestesia general en estos casos, y otros procedimientos excluidos del plan obligatorio de salud.' 
 WHERE COD_PROGRAMA = 2;
 
 UPDATE VDIR_PROGRAMA 
   SET DESCRIPCION = 'Es un programa de aseguramiento voluntario que cuenta con beneficios como, consulta por fuera de la red, atención médica a domicilio con Coomeva Emergencia Médica 2 veces al año, enfermera acompañante, renta diaria por hospitalización, ambulancia aérea, trastornos congénitos y genéticos, prótesis y ortesis, urgencias en el exterior  50 mil USD, menores periodos de carencia y entre otros.' 
 WHERE COD_PROGRAMA = 3;
 
 UPDATE VDIR_PROGRAMA 
   SET DESCRIPCION = 'Programa dirigido a población joven menores de 35 años, con amplias coberturas ambulatorias (consulta, terapias, ayudas diagnosticas), maternidad, medicina alternativa, procedimientos quirúrgicos y hospitalario con topes de cobertura y bolsa de hospitalización reinstalable por diagnóstico. Directorio abierto más de 10.000 prestadores entre especialistas e instituciones de salud a nivel nacional.' 
 WHERE COD_PROGRAMA = 4;
 
 UPDATE VDIR_PROGRAMA 
   SET DESCRIPCION = 'Es un programa de aseguramiento voluntario que cubre hasta 7 especialidades básicas, endoscopia digestiva alta, 100% en urgencias y hospitalización en red especial, maternidad,  y suministros; así como otras coberturas especiales.' 
 WHERE COD_PROGRAMA = 5;
 
 UPDATE VDIR_PROGRAMA 
   SET DESCRIPCION = 'Dirigido exclusivamente para los asociados a la Cooperativa Coomeva con edad de ingreso hasta los 65 años, con amplias coberturas ambulatorias, procedimientos quirúrgicos y hospitalario con topes de cobertura amplios y bolsa de hospitalización reinstalable por diagnóstico, directorio abierto con más de 10.000 prestadores entre especialistas e instituciones de salud a nivel nacional.' 
 WHERE COD_PROGRAMA = 6;
 COMMIT;
UPDATE VDIR_PRODUCTO SET DES_PRODUCTO = 'Medicina Integral' WHERE COD_PRODUCTO = 1;
UPDATE VDIR_PRODUCTO 
   SET DES_PRODUCTO = 'Salud Oral',
       DESCRIPCION = 'Es un programa de atención odontológica. Único en su género y pionero en Colombia. Se fundamenta en un diagnóstico completo y oportuno con tratamientos asequibles y de alta calidad, procedimientos de prevención y controles periódicos, seguro contra accidentes odontológicos y cobertura de nuevos eventos.'
 WHERE COD_PRODUCTO = 2;
UPDATE VDIR_PRODUCTO SET DES_PRODUCTO = 'Coomeva Emergencia médica' WHERE COD_PRODUCTO = 3;

COMMIT;

ALTER TABLE VDIR_PROGRAMA ADD DESCRIPCION VARCHAR2(4000);
COMMENT ON COLUMN VDIR_PROGRAMA.DESCRIPCION IS 'Descripción del programa indicando el fin y coberturas';

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
   SET DESCRIPCION = 'Dirigido exclusivamente para los asociados a la Cooperativa Coomeva con edad de ingreso hasta los 65 años, con amplias coberturas ambulatorias, procedimientos quirúrgicos y hospitalario con topes de cobertura amplios y bolsa de hospitalización reinstalable por diagnóstico, directorio abierto con más de 10.000 prestadores entre especialistas e instituciones de salud a nivel nacional.' 
 WHERE COD_PROGRAMA = 6;
 COMMIT;
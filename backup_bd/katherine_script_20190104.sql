ALTER TABLE VDIR_FILE MODIFY OBSERVACION VARCHAR2(4000);
ALTER TABLE VDIR_FILE MODIFY RUTA VARCHAR2(4000);
ALTER TABLE VDIR_FILE ADD URL VARCHAR2(4000);

--------------------------------------------------------
-- Archivo creado  - viernes-enero-04-2019   
--------------------------------------------------------
REM INSERTING into VDIR_TIPO_FILE
SET DEFINE OFF;
Insert into VDIR_TIPO_FILE (COD_TIPO_FILE,DES_TIPO_FILE,COD_ESTADO) values ('1','Cobertura inicial','1');
Insert into VDIR_TIPO_FILE (COD_TIPO_FILE,DES_TIPO_FILE,COD_ESTADO) values ('2','Cobertura_final','1');
Insert into VDIR_TIPO_FILE (COD_TIPO_FILE,DES_TIPO_FILE,COD_ESTADO) values ('3','Contrato programa','1');
Insert into VDIR_TIPO_FILE (COD_TIPO_FILE,DES_TIPO_FILE,COD_ESTADO) values ('4','InclusiÃ³n','1');
COMMIT;

--------------------------------------------------------
-- Archivo creado  - viernes-enero-04-2019   
--------------------------------------------------------
REM INSERTING into VDIR_FILE
SET DEFINE OFF;
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('1','Contrato Oro Plus',null,'uploadPdf/Contrato/MPFT642_CONTRATO_ORO_PLUS.pdf','3',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhCvP7SHTBGJ5iNhNIrwaq--2nL4mZumX02lCh1hiS5N97eNix81P3xsLradMuVt1xY*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('2','Contrato Asociado',null,'uploadPdf/Contrato/MPFT674_CONTRATO_ASOCIADO.pdf','3',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhAO1K419T6PT9VmkdYbCL9jBZcg0HEZsr_qBUnZy01a1T1yWisGzOUfZx6Hq02ROJY*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('3','Contrato Tradicional Especial',null,'uploadPdf/Contrato/MPFT648_CONTRATO_TRADICIONAL_ESPECIAL.pdf','3',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhC-ettmJBPt37hUufG_XdpCQYoY84d7hVnxAkyfRwNBVaxz5PG9r7BhxnKdqCmaqVs*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('4','Contrato Plata Joven',null,'uploadPdf/Contrato/MPFT645_CONTRATO_PLATA_JOVEN.pdf','3',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhDUE1fIvxnLta6URLbkaPunNvPb2YJDGX3uFehZw4Z1ectsvx8xjUpA0AUk9zOpJa4*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('5','Contrato Cem',null,'uploadPdf/Contrato/MPFT675_CONTRATO_CEM.pdf','3',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhBvVyiJqtQND7w2GLhYEHPsuPVYz_j9-m8dMRMH29phYqgKQrRXY3ZGYPa-zs3I_co*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('6','Contrato Dental Elite',null,'uploadPdf/Contrato/MPFT647_CONTRATO_DENTAL_ELITE.pdf','3',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhA0WvIAnsdHIUEmKeqiXjSCBX9yMWG2ZVzhl29X0fjwyeo_VeZo8gNNyBvqX6Z8mdE*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('7','Inclusión Solicitud de Ingreso',null,'uploadPdf/Inclusion/MPFT003_SOLICITUD_INGRESO.pdf','4',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhAxuW3nEWwQzMLmcOJXYH_pnflQUvzW-u60k3J09x7miEbn6oRMtfYUGhXfFGY0qJ0*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('8','Inclusión tratamiento de datos personales',null,'uploadPdf/Inclusion/MPDC311_TRATAMIENTO_DATOS_PERSONALES.pdf','4',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhC0sDi4Rqr917w9ACqXUSuYtvknn9LVSa7RrnbkEG09vseCJckqmduoRP1gScekrNE*');
Insert into VDIR_FILE (COD_FILE,DES_FILE,OBSERVACION,RUTA,COD_TIPO_FILE,FECHA_CREACION,URL) values ('9','Inclusión Cuota Mes',null,'uploadPdf/Inclusion/MPFT083_CUOTA_MES.pdf','4',to_date('02/01/19','DD/MM/RR'),'https://secure.na2.echosign.com/public/esignWidget?wid=CBFCIBAA3AAABLblqZhBK83pp4OTvz2SIJczuIuGaiktmvdQB60gtKrvH0aC46v4ll9vz6J-TDNaw6FAa1NY*');
COMMIT;

--------------------------------------------------------
-- Archivo creado  - viernes-enero-04-2019   
--------------------------------------------------------
REM INSERTING into VDIR_PROGRAMA_FILE
SET DEFINE OFF;
Insert into VDIR_PROGRAMA_FILE (COD_PROGRAMA_FILE,COD_FILE,COD_PROGRAMA) values ('1','1','3');
Insert into VDIR_PROGRAMA_FILE (COD_PROGRAMA_FILE,COD_FILE,COD_PROGRAMA) values ('2','2','6');
Insert into VDIR_PROGRAMA_FILE (COD_PROGRAMA_FILE,COD_FILE,COD_PROGRAMA) values ('3','3','5');
Insert into VDIR_PROGRAMA_FILE (COD_PROGRAMA_FILE,COD_FILE,COD_PROGRAMA) values ('4','4','4');
Insert into VDIR_PROGRAMA_FILE (COD_PROGRAMA_FILE,COD_FILE,COD_PROGRAMA) values ('5','5','1');
Insert into VDIR_PROGRAMA_FILE (COD_PROGRAMA_FILE,COD_FILE,COD_PROGRAMA) values ('6','6','2');
COMMIT;

SET DEFINE OFF;
Insert into VDIR_PERSONA (COD_PERSONA,COD_TIPO_IDENTIFICACION,NUMERO_IDENTIFICACION,NOMBRE_1,NOMBRE_2,APELLIDO_1,APELLIDO_2,FECHA_NACIMIENTO,TELEFONO,EMAIL,DIRECCION,COD_SEXO,COD_MUNICIPIO,FECHA_CREACION,COD_ESTADO,CELULAR,COD_EPS,COD_ESTADO_CIVIL,IND_TIENE_MASCOTA,DIR_TIPO_VIA,DIR_NUM_VIA,DIR_NUM_PLACA,DIR_COMPLEMENTO) values ('42','1','1113649251','Gustavo',null,'Portilla','Sarria',to_date('09/09/90','DD/MM/RR'),'4407416','gustavo.portilla@coomeva.com.co','Calle 45 # 98B - 50 Valle del lili','1','1',to_date('04/01/19','DD/MM/RR'),'3','33207830990','108','4','1','17','45','98B - 50','Valle del lili');
Insert into VDIR_PERSONA (COD_PERSONA,COD_TIPO_IDENTIFICACION,NUMERO_IDENTIFICACION,NOMBRE_1,NOMBRE_2,APELLIDO_1,APELLIDO_2,FECHA_NACIMIENTO,TELEFONO,EMAIL,DIRECCION,COD_SEXO,COD_MUNICIPIO,FECHA_CREACION,COD_ESTADO,CELULAR,COD_EPS,COD_ESTADO_CIVIL,IND_TIENE_MASCOTA,DIR_TIPO_VIA,DIR_NUM_VIA,DIR_NUM_PLACA,DIR_COMPLEMENTO) values ('43','1','16725908','Wilson',null,'Latorre','Hoyos',to_date('30/07/66','DD/MM/RR'),null,'wilaho44@hotmail.com','Calle 70 # 1A 12 - 05 San Luis','1','1',to_date('04/01/19','DD/MM/RR'),'3','3152456092','108','4','1','17','70','1A 12 - 05','San Luis');
Insert into VDIR_PERSONA (COD_PERSONA,COD_TIPO_IDENTIFICACION,NUMERO_IDENTIFICACION,NOMBRE_1,NOMBRE_2,APELLIDO_1,APELLIDO_2,FECHA_NACIMIENTO,TELEFONO,EMAIL,DIRECCION,COD_SEXO,COD_MUNICIPIO,FECHA_CREACION,COD_ESTADO,CELULAR,COD_EPS,COD_ESTADO_CIVIL,IND_TIENE_MASCOTA,DIR_TIPO_VIA,DIR_NUM_VIA,DIR_NUM_PLACA,DIR_COMPLEMENTO) values ('44','1','66847517','Alejandra',null,'Ceballos','Marines',to_date('22/09/74','DD/MM/RR'),null,'alejaceballosmarines@gmail.com','Calle 70 # 98B - 50 Valle del lili','2','1',to_date('04/01/19','DD/MM/RR'),'3','3177093156','108','4','1','17','70','98B - 50','Valle del lili');
Insert into VDIR_PERSONA (COD_PERSONA,COD_TIPO_IDENTIFICACION,NUMERO_IDENTIFICACION,NOMBRE_1,NOMBRE_2,APELLIDO_1,APELLIDO_2,FECHA_NACIMIENTO,TELEFONO,EMAIL,DIRECCION,COD_SEXO,COD_MUNICIPIO,FECHA_CREACION,COD_ESTADO,CELULAR,COD_EPS,COD_ESTADO_CIVIL,IND_TIENE_MASCOTA,DIR_TIPO_VIA,DIR_NUM_VIA,DIR_NUM_PLACA,DIR_COMPLEMENTO) values ('41','1','1151939922','Jeniffer','Katherine','Latorre','Mejía',to_date('15/04/91','DD/MM/RR'),'4332461','katherine.latorre@kalettre.com','Calle 70 # 1A 12 - 05 San Luis','2','1',to_date('04/01/19','DD/MM/RR'),'3','3122914900','108','4','1','17','70','1A 12 - 05','San Luis');
Insert into VDIR_PERSONA (COD_PERSONA,COD_TIPO_IDENTIFICACION,NUMERO_IDENTIFICACION,NOMBRE_1,NOMBRE_2,APELLIDO_1,APELLIDO_2,FECHA_NACIMIENTO,TELEFONO,EMAIL,DIRECCION,COD_SEXO,COD_MUNICIPIO,FECHA_CREACION,COD_ESTADO,CELULAR,COD_EPS,COD_ESTADO_CIVIL,IND_TIENE_MASCOTA,DIR_TIPO_VIA,DIR_NUM_VIA,DIR_NUM_PLACA,DIR_COMPLEMENTO) values ('50','1','123445','William','Walter','Perez','Palacios',to_date('02/02/10','DD/MM/RR'),'4332461','hidalgoever@live.com','Bulevar 23 # 45 54','1','1',to_date('04/01/19','DD/MM/RR'),'3','5424','89','1','1','11','23','45','54');

--------------------------------------------------------
-- Archivo creado  - viernes-enero-04-2019   
--------------------------------------------------------
REM INSERTING into VDIR_CONTRATANTE_BENEFICIARIO
SET DEFINE OFF;
Insert into VDIR_CONTRATANTE_BENEFICIARIO (COD_CONTRATANTE_BENEFICIARIO,COD_CONTRATANTE,COD_BENEFICIARIO,COD_PARENTESCO,COD_AFILIACION,COD_TIPO_SOLICITUD) values ('3','12','42','1','1',null);
Insert into VDIR_CONTRATANTE_BENEFICIARIO (COD_CONTRATANTE_BENEFICIARIO,COD_CONTRATANTE,COD_BENEFICIARIO,COD_PARENTESCO,COD_AFILIACION,COD_TIPO_SOLICITUD) values ('4','12','43','1','1',null);
Insert into VDIR_CONTRATANTE_BENEFICIARIO (COD_CONTRATANTE_BENEFICIARIO,COD_CONTRATANTE,COD_BENEFICIARIO,COD_PARENTESCO,COD_AFILIACION,COD_TIPO_SOLICITUD) values ('5','12','44','1','1',null);
Insert into VDIR_CONTRATANTE_BENEFICIARIO (COD_CONTRATANTE_BENEFICIARIO,COD_CONTRATANTE,COD_BENEFICIARIO,COD_PARENTESCO,COD_AFILIACION,COD_TIPO_SOLICITUD) values ('1','12','12','1','1',null);
Insert into VDIR_CONTRATANTE_BENEFICIARIO (COD_CONTRATANTE_BENEFICIARIO,COD_CONTRATANTE,COD_BENEFICIARIO,COD_PARENTESCO,COD_AFILIACION,COD_TIPO_SOLICITUD) values ('2','12','41','1','1',null);
Insert into VDIR_CONTRATANTE_BENEFICIARIO (COD_CONTRATANTE_BENEFICIARIO,COD_CONTRATANTE,COD_BENEFICIARIO,COD_PARENTESCO,COD_AFILIACION,COD_TIPO_SOLICITUD) values ('6','12','50','1','1',null);
COMMIT;
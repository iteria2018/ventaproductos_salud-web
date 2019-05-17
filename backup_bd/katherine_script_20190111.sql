ALTER TABLE VDIR_FILE ADD IDWIDGET VARCHAR2(4000);
COMMENT ON COLUMN VDIR_FILE.IDWIDGET IS 'Cadena con el Id Widget en Adobe Sign';
COMMENT ON COLUMN VDIR_FILE.URL IS 'Ruta para inscrustar el Widget proveniente de Adobe Sign (Ruta remota)';
COMMENT ON COLUMN VDIR_FILE.COD_FILE IS 'Código consecutivo del archivo';
COMMENT ON COLUMN VDIR_FILE.DES_FILE IS 'Nombre para mostrar en pantalla del archivo';
COMMENT ON COLUMN VDIR_FILE.OBSERVACION IS 'Observación del archivo';
COMMENT ON COLUMN VDIR_FILE.COD_TIPO_FILE IS 'Código del tipo de archivo que los agrupa';
COMMENT ON COLUMN VDIR_FILE.RUTA IS 'Ruta local en donde se encuentra el archivo';
COMMENT ON COLUMN VDIR_FILE.FECHA_CREACION IS 'Fecha de creación del registro en el Sistema';

COMMENT ON COLUMN VDIR_PERSONA_CONTRATO.COD_PERSONA_CONTRATO IS 'Código consecutivo del contrante asociado a un contrato';
COMMENT ON COLUMN VDIR_PERSONA_CONTRATO.COD_PERSONA IS 'Código del contrante';
COMMENT ON COLUMN VDIR_PERSONA_CONTRATO.COD_PROGRAMA IS 'Código del programa';
COMMENT ON COLUMN VDIR_PERSONA_CONTRATO.COD_AFILIACION IS 'Código de la afiliación';
COMMENT ON COLUMN VDIR_PERSONA_CONTRATO.NUMERO_CONTRATO_ADOBE IS 'Número de contrato proveniente de adobe';
COMMENT ON COLUMN VDIR_PERSONA_CONTRATO.FECHA_CREACION IS 'Fecha de creación del registro en el Sistema';

--------------------------------------------------------
-- Archivo creado  - jueves-enero-10-2019   
--------------------------------------------------------
REM INSERTING into VDIR_PARAMETRO
SET DEFINE OFF;
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('11','Url Adobe Sign para las API Rest','https://api.na2.echosign.com','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('6','Id del Cliente para el API Rest','CBJCHBCAABAAXY5dLaq4vX4uRT1n2ahSsZd29owZxD5C','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('7','Id secreto del Cliente para el API Rest','sKvgZDbalpNsjbXbDYNq6XumexUxrRBj','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('8','Token para resfrescar API Rest','3AAABLblqZhBnXHKnWNg-D8ba5tNN1yyEUZEfmurE4UTFgkWhLRpYRPyFmTw3esrbAIfgk-BNGM0*','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('9','Url Origen Firmas Widget','https://secure.na2.echosign.com','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('10','Url local para crear archivos temporales','/venta_directa/asset/public/temporales/','1');
COMMIT;

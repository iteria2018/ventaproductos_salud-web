Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('15','Extensiones permitidas Input File Cotización','.jpg, .png, .gif, .bmp, .tif, .pdf','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('16','Tamaño permitido Input File Cotización','2MB','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('17','Ruta archivos de beneficiario','/venta_directa/asset/public/fileBeneficiarios/','1');


Insert into VDIR_TIPO_FILE (COD_TIPO_FILE,DES_TIPO_FILE,COD_ESTADO) values ('6','Cédula beneficiario','1');
Insert into VDIR_TIPO_FILE (COD_TIPO_FILE,DES_TIPO_FILE,COD_ESTADO) values ('7','Afiliación beneficiario','1');


CREATE SEQUENCE  "VDIRMP"."VDIR_SEQ_FILEBENEFICIARIO"  MINVALUE 1 MAXVALUE 9999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
COMMIT;
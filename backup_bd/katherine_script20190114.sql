Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('12','Mensaje inicio servicio','Señor usuario gracias por afiliarse a Coomeva Medicina Prepagada, a partir del día 16 del presente mes podrá iniciar servicio con nosotros','1');
Insert into VDIR_PARAMETRO (COD_PARAMETRO,DES_PARAMETRO,VALOR_PARAMETRO,COD_ESTADO) values ('13','Mensaje inicio servicio','Señor usuario, gracias por afiliarse a Coomeva Medicina Prepagada, a partir del 1 del siguiente mes podrá iniciar servicio con nosotros','1');
COMMIT;

CREATE SEQUENCE  "VDIRMP"."VDIR_SEQ_PERSONACONTRATO"  MINVALUE 1 MAXVALUE 9999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
CREATE SEQUENCE  "VDIRMP"."VDIR_SEQ_CONTRATO"  MINVALUE 1 MAXVALUE 9999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;

  CREATE TABLE "VDIRMP"."VDIR_CONDICION_TARIFA" 
   (	"COD_CONDICION_TARIFA" NUMBER(6,0) NOT NULL ENABLE, 
	"DES_CONDICION_TARIFA" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
	"COD_ESTADO" NUMBER(2,0) NOT NULL ENABLE, 
	 PRIMARY KEY ("COD_CONDICION_TARIFA"), 
	 FOREIGN KEY ("COD_ESTADO")
	  REFERENCES "VDIRMP"."VDIR_ESTADO" ("COD_ESTADO"));
  /  
  
  CREATE TABLE "VDIRMP"."VDIR_NUM_USUARIOS_TARIFA" 
   (	"COD_NUM_USUARIOS_TARIFA" NUMBER(6,0) NOT NULL ENABLE, 
	"DES_NUM_USUARIOS_TARIFA" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
	"COD_ESTADO" NUMBER(2,0) NOT NULL ENABLE, 
	 PRIMARY KEY ("COD_NUM_USUARIOS_TARIFA"), 
	 FOREIGN KEY ("COD_ESTADO")
	  REFERENCES "VDIRMP"."VDIR_ESTADO" ("COD_ESTADO")); 
 / 
  
  DROP TABLE "VDIRMP"."VDIR_TARIFA";
  CREATE TABLE "VDIRMP"."VDIR_TARIFA" 
   (	"COD_TARIFA" NUMBER(14,0) NOT NULL ENABLE, 
	"COD_PLAN_PROGRAMA" NUMBER(14,0) NOT NULL ENABLE, 
	"COD_PLAN" NUMBER(6,0) NOT NULL ENABLE, 
	"COD_ESTADO" NUMBER(2,0) NOT NULL ENABLE, 
	"COD_TIPO_TARIFA" NUMBER NOT NULL ENABLE, 
	"VALOR_TARIFA" NUMBER(12,0), 
	"FECHA_VIGE_INICIAL" DATE, 
	"FECHA_VIGE_FIN" DATE, 
	"COD_CONDICION_TARIFA" NUMBER(6,0), 
	"COD_NUM_USUARIOS_TARIFA" NUMBER(6,0), 
	"COD_SEXO" NUMBER(2,0), 
	"EDAD_INICIAL" NUMBER(2,0), 
	"EDAD_FINAL" NUMBER(2,0), 
	 CONSTRAINT "VDIR_TARIFA_PK" PRIMARY KEY ("COD_TARIFA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "TARIFA_PLAN_FK" FOREIGN KEY ("COD_PLAN")
	  REFERENCES "VDIRMP"."VDIR_PLAN" ("COD_PLAN") ENABLE, 
	 CONSTRAINT "TARIFA_PROGRAMA_FK" FOREIGN KEY ("COD_PLAN_PROGRAMA")
	  REFERENCES "VDIRMP"."VDIR_PROGRAMA" ("COD_PROGRAMA") ENABLE, 
	 CONSTRAINT "FK_TIPO_TARIFA" FOREIGN KEY ("COD_TIPO_TARIFA")
	  REFERENCES "VDIRMP"."VDIR_TIPO_TARIFA" ("COD_TIPO_TARIFA") ENABLE, 
	 CONSTRAINT "FK_PLAN_PROGRAMA" FOREIGN KEY ("COD_PLAN_PROGRAMA")
	  REFERENCES "VDIRMP"."VDIR_PLAN_PROGRAMA" ("COD_PLAN_PROGRAMA") ENABLE, 
	 CONSTRAINT "FK_COD_CONDI_TARIFA" FOREIGN KEY ("COD_CONDICION_TARIFA")
	  REFERENCES "VDIRMP"."VDIR_CONDICION_TARIFA" ("COD_CONDICION_TARIFA") ENABLE, 
	 CONSTRAINT "FK_COD_NUM_USU_TARI" FOREIGN KEY ("COD_NUM_USUARIOS_TARIFA")
	  REFERENCES "VDIRMP"."VDIR_NUM_USUARIOS_TARIFA" ("COD_NUM_USUARIOS_TARIFA") ENABLE, 
	 CONSTRAINT "FK_SEXO" FOREIGN KEY ("COD_SEXO")
	  REFERENCES "VDIRMP"."VDIR_SEXO" ("COD_SEXO") ENABLE, 
	 CONSTRAINT "FK_ESTADO_003" FOREIGN KEY ("COD_ESTADO")
	  REFERENCES "VDIRMP"."VDIR_ESTADO" ("COD_ESTADO") ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" ;
 

  CREATE INDEX "VDIRMP"."VDIR_TARIFA_INDEX1" ON "VDIRMP"."VDIR_TARIFA" ("COD_PLAN_PROGRAMA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" ;
 

  CREATE INDEX "VDIRMP"."VDIR_TARIFA_INDEX2" ON "VDIRMP"."VDIR_TARIFA" ("COD_PLAN") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" ;
 

  CREATE INDEX "VDIRMP"."VDIR_TARIFA_INDEX3" ON "VDIRMP"."VDIR_TARIFA" ("COD_ESTADO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" ;
 

  CREATE INDEX "VDIRMP"."VDIR_TARIFA_INDEX4" ON "VDIRMP"."VDIR_TARIFA" ("COD_CONDICION_TARIFA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" ;
 

  CREATE INDEX "VDIRMP"."VDIR_TARIFA_INDEX5" ON "VDIRMP"."VDIR_TARIFA" ("COD_TIPO_TARIFA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" ;
 

  CREATE INDEX "VDIRMP"."VDIR_TARIFA_INDEX6" ON "VDIRMP"."VDIR_TARIFA" ("COD_NUM_USUARIOS_TARIFA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" ;
 
  
      
  CREATE INDEX VDIR_CONDICION_TARIFA_INDEX1 ON VDIR_CONDICION_TARIFA (COD_ESTADO);
  CREATE INDEX VDIR_NUM_USUARIOS_TARIFA_INDE ON VDIR_NUM_USUARIOS_TARIFA (COD_ESTADO);
    
  INSERT INTO "VDIRMP"."VDIR_CONDICION_TARIFA" (COD_CONDICION_TARIFA, DES_CONDICION_TARIFA, COD_ESTADO) VALUES ('1', 'Número de usuarios', '1');
  INSERT INTO "VDIRMP"."VDIR_CONDICION_TARIFA" (COD_CONDICION_TARIFA, DES_CONDICION_TARIFA, COD_ESTADO) VALUES ('2', 'Quinquenio', '1');
    
    INSERT INTO "VDIRMP"."VDIR_NUM_USUARIOS_TARIFA" (COD_NUM_USUARIOS_TARIFA, DES_NUM_USUARIOS_TARIFA, COD_ESTADO) VALUES ('1', '1', '1');
    INSERT INTO "VDIRMP"."VDIR_NUM_USUARIOS_TARIFA" (COD_NUM_USUARIOS_TARIFA, DES_NUM_USUARIOS_TARIFA, COD_ESTADO) VALUES ('2', '2', '1');
    INSERT INTO "VDIRMP"."VDIR_NUM_USUARIOS_TARIFA" (COD_NUM_USUARIOS_TARIFA, DES_NUM_USUARIOS_TARIFA, COD_ESTADO) VALUES ('3', '3', '1');
    INSERT INTO "VDIRMP"."VDIR_NUM_USUARIOS_TARIFA" (COD_NUM_USUARIOS_TARIFA, DES_NUM_USUARIOS_TARIFA, COD_ESTADO) VALUES ('4 ', '4 o mas', '1');
       

  

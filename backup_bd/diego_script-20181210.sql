ALTER TABLE VDIR_PRODUCTO ADD (DESCRIPCION VARCHAR2(4000));
ALTER TABLE VDIR_PAIS ADD (ABR_PAIS VARCHAR2(4));
ALTER TABLE VDIR_TIPO_VIA ADD (ABR_TIPO_VIA VARCHAR2(4));
ALTER TABLE VDIR_EPS ADD (SIGLA_EPS VARCHAR2(100));
ALTER TABLE VDIR_ESTADO_CIVIL ADD (ABR_ESTADO_CIVIL VARCHAR2(2));
ALTER TABLE VDIR_PARENTESCO ADD (ABR_PARENTESCO VARCHAR2(2) );
ALTER TABLE VDIR_TARIFA RENAME COLUMN CDO_PLAN TO COD_PLAN;
--------------------------------------
-- TABLE VDIR_PLAN_PROGRAMA
--------------------------------------
ALTER TABLE VDIR_PLAN_PROGRAMA ADD (COD_PROGRAMA_HOMOLOGA VARCHAR2(100) );

--------------------------------------
-- TABLE VDIR_BENEFICIARIO_PROGRAMA
--------------------------------------
ALTER TABLE VDIR_BENEFICIARIO_PROGRAMA ADD (COD_TIPO_SOLICITUD NUMBER );

--------------------------------------
-- TABLE VDIR_CONTRATANTE_BENEFICIARIO
--------------------------------------
ALTER TABLE VDIR_CONTRATANTE_BENEFICIARIO ADD (COD_ESTADO NUMBER NOT NULL);

ALTER TABLE VDIR_CONTRATANTE_BENEFICIARIO ADD CONSTRAINT VDIR_CONTRATANTE_BENEFICI_FK1 FOREIGN KEY (COD_ESTADO) REFERENCES VDIR_ESTADO (COD_ESTADO) ENABLE;

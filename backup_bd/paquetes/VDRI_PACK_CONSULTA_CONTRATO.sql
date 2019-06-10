create or replace PACKAGE VDIR_PACK_CONSULTA_CONTRATO AS
/* ---------------------------------------------------------------------
 Copyright  TecnologÃ­a InformÃ¡tica Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_CONTRATO
 Caso de Uso :
 DescripciÃ³n : Procesos para la consulta los archivos de contratos
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 20-02-2018
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor ModificaciÃ³n
 ----------------------------------------------------------------- */

	-- ---------------------------------------------------------------------
	-- Declaracion de estructuras dinamicas
	-- ---------------------------------------------------------------------
	TYPE type_cursor IS REF CURSOR;

	-- ---------------------------------------------------------------------
    -- fnGetDatosContrato
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosContrato
    (
      	inu_codPersona  IN VDIR_PERSONA.COD_PERSONA%TYPE,
		inu_codPrograma IN VDIR_PROGRAMA.COD_PROGRAMA%TYPE,
        inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN VARCHAR2;

	-- ---------------------------------------------------------------------
    -- fnGetValidaContrato
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaContrato
    (
        inu_codAfiliacion IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE,
		inu_codPrograma   IN VDIR_PERSONA_CONTRATO.COD_PROGRAMA%TYPE
    )
	RETURN NUMBER;


END VDIR_PACK_CONSULTA_CONTRATO;
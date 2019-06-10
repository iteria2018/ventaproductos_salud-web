create or replace PACKAGE VDIR_PACK_REGISTRO_LINEAS AS
/* ---------------------------------------------------------------------
 Copyright  TecnologÃ­a InformÃ¡tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_LINEAS
 Caso de Uso :
 DescripciÃ³n : Procesos para el registro del los programas asociados al
               plan - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 25-01-2018
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
	-- prGuardarPlanPrograma
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarPlanPrograma
	(
		inu_codPlan           IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE,
		inu_codPrograma       IN VDIR_PLAN_PROGRAMA.COD_PROGRAMA%TYPE,
		inu_codEstado         IN VDIR_PLAN_PROGRAMA.COD_ESTADO%TYPE,
		ivc_coberturaInicial  IN VDIR_PLAN_PROGRAMA.COBERTURA_INICIAL%TYPE,
		ivc_coberturaFinal    IN VDIR_PLAN_PROGRAMA.COBERTURA_FINAL%TYPE,
        ivc_codProgramaHologa IN VDIR_PLAN_PROGRAMA.COD_PROGRAMA_HOMOLOGA%TYPE
    );

	-- ---------------------------------------------------------------------
	-- prActualizarPlanPrograma
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarPlanPrograma
	(
	    inu_codPlanPrograma   IN VDIR_PLAN_PROGRAMA.COD_PLAN_PROGRAMA%TYPE,
		inu_codPlan           IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE,
		inu_codPrograma       IN VDIR_PLAN_PROGRAMA.COD_PROGRAMA%TYPE,
		inu_codEstado         IN VDIR_PLAN_PROGRAMA.COD_ESTADO%TYPE,
		ivc_coberturaInicial  IN VDIR_PLAN_PROGRAMA.COBERTURA_INICIAL%TYPE,
		ivc_coberturaFinal    IN VDIR_PLAN_PROGRAMA.COBERTURA_FINAL%TYPE,
        ivc_codProgramaHologa IN VDIR_PLAN_PROGRAMA.COD_PROGRAMA_HOMOLOGA%TYPE
    );

END VDIR_PACK_REGISTRO_LINEAS;
CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_TARIFAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_TARIFAS
 Caso de Uso : 
 Descripci�n : Procesos para el registro del las tarifas - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 28-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 
	-- ---------------------------------------------------------------------
	-- Declaracion de estructuras dinamicas
	-- ---------------------------------------------------------------------
	TYPE type_cursor IS REF CURSOR;
 
	-- ---------------------------------------------------------------------
	-- prGuardarTarifa
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarTarifa
	(
		inu_codPlanPrograma  IN VDIR_TARIFA.COD_PLAN_PROGRAMA%TYPE,
        inu_codPlan          IN VDIR_TARIFA.COD_PLAN%TYPE,
		inu_codEstado        IN VDIR_TARIFA.COD_ESTADO%TYPE,
		inu_codTipoTarifa    IN VDIR_TARIFA.COD_TIPO_TARIFA%TYPE,
		inu_valorTarifa      IN VDIR_TARIFA.VALOR%TYPE,
		idt_fecVigenciaIni   IN VDIR_TARIFA.FECHA_VIGE_INICIAL%TYPE,
		idt_fecVigenciaFin   IN VDIR_TARIFA.FECHA_VIGE_FIN%TYPE,
		inu_codCondicion     IN VDIR_TARIFA.COD_CONDICION_TARIFA%TYPE,
		inu_codNumUsuarios   IN VDIR_TARIFA.COD_NUM_USUARIOS_TARIFA%TYPE,
		inu_codSexo          IN VDIR_TARIFA.COD_SEXO%TYPE,
		inu_edadInicial      IN VDIR_TARIFA.EDAD_INICIAL%TYPE,
		inu_edadFinal        IN VDIR_TARIFA.EDAD_FINAL%TYPE,
		ivc_codTarifaMP      IN VDIR_TARIFA.COD_TARIFA_MP%TYPE
    );
	
	-- ---------------------------------------------------------------------
	-- prActualizarTarifa
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarTarifa
	(
	    inu_codTarifa        IN VDIR_TARIFA.COD_TARIFA%TYPE,
	    inu_codPlanPrograma  IN VDIR_TARIFA.COD_PLAN_PROGRAMA%TYPE,
        inu_codPlan          IN VDIR_TARIFA.COD_PLAN%TYPE,
		inu_codEstado        IN VDIR_TARIFA.COD_ESTADO%TYPE,
		inu_codTipoTarifa    IN VDIR_TARIFA.COD_TIPO_TARIFA%TYPE,
		inu_valorTarifa      IN VDIR_TARIFA.VALOR%TYPE,
		idt_fecVigenciaIni   IN VDIR_TARIFA.FECHA_VIGE_INICIAL%TYPE,
		idt_fecVigenciaFin   IN VDIR_TARIFA.FECHA_VIGE_FIN%TYPE,
		inu_codCondicion     IN VDIR_TARIFA.COD_CONDICION_TARIFA%TYPE,
		inu_codNumUsuarios   IN VDIR_TARIFA.COD_NUM_USUARIOS_TARIFA%TYPE,
		inu_codSexo          IN VDIR_TARIFA.COD_SEXO%TYPE,
		inu_edadInicial      IN VDIR_TARIFA.EDAD_INICIAL%TYPE,
		inu_edadFinal        IN VDIR_TARIFA.EDAD_FINAL%TYPE
    );
  
END VDIR_PACK_REGISTRO_TARIFAS;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_REGISTRO_TARIFAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_TARIFAS
 Caso de Uso : 
 Descripci�n : Procesos para el registro del las tarifas - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 28-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 
	-- ---------------------------------------------------------------------
	-- prGuardarTarifa
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarTarifa
	(
		inu_codPlanPrograma  IN VDIR_TARIFA.COD_PLAN_PROGRAMA%TYPE,
        inu_codPlan          IN VDIR_TARIFA.COD_PLAN%TYPE,
		inu_codEstado        IN VDIR_TARIFA.COD_ESTADO%TYPE,
		inu_codTipoTarifa    IN VDIR_TARIFA.COD_TIPO_TARIFA%TYPE,
		inu_valorTarifa      IN VDIR_TARIFA.VALOR%TYPE,
		idt_fecVigenciaIni   IN VDIR_TARIFA.FECHA_VIGE_INICIAL%TYPE,
		idt_fecVigenciaFin   IN VDIR_TARIFA.FECHA_VIGE_FIN%TYPE,
		inu_codCondicion     IN VDIR_TARIFA.COD_CONDICION_TARIFA%TYPE,
		inu_codNumUsuarios   IN VDIR_TARIFA.COD_NUM_USUARIOS_TARIFA%TYPE,
		inu_codSexo          IN VDIR_TARIFA.COD_SEXO%TYPE,
		inu_edadInicial      IN VDIR_TARIFA.EDAD_INICIAL%TYPE,
		inu_edadFinal        IN VDIR_TARIFA.EDAD_FINAL%TYPE,
		ivc_codTarifaMP      IN VDIR_TARIFA.COD_TARIFA_MP%TYPE
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Procedimiento que guarda la tarifa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	    inu_codPlanPrograma  C�digo del plan asociado al programa
        inu_codPlan          C�digo del plan
		inu_codEstado        C�digo del estado
		inu_codTipoTarifa    C�digo del tipo de tarifa
		inu_valorTarifa      Valor de la tarifa
		idt_fecVigenciaIni   Fecha inicio de vigencia
		idt_fecVigenciaFin   Fecha fin de vigencia
		inu_codCondicion     C�digo de la condici�n
		inu_codNumUsuarios   C�digo del n�mero de usuarios
		inu_codSexo          C�digo del genero
		inu_edadInicial      Edad m�nima
		inu_edadFinal        Edad m�xima
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    lnu_codTarifa VDIR_TARIFA.COD_TARIFA%TYPE;
	
	BEGIN
		
	    -- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_TARIFA.NEXTVAL INTO lnu_codTarifa FROM DUAL;   
		
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se ingresa la tarifa
			-- --------------------------------------------------------------------- 
			INSERT INTO VDIR_TARIFA
			(
				COD_TARIFA,
				COD_PLAN_PROGRAMA, 
				COD_PLAN,
				COD_ESTADO, 
				COD_TIPO_TARIFA, 
				VALOR,
				FECHA_VIGE_INICIAL,
				FECHA_VIGE_FIN,
				COD_CONDICION_TARIFA,
				COD_NUM_USUARIOS_TARIFA,
				COD_SEXO,
				EDAD_INICIAL,
				EDAD_FINAL,
				COD_TARIFA_MP
			) 
			VALUES 
			(
			    lnu_codTarifa,
				inu_codPlanPrograma, 
				inu_codPlan,
				inu_codEstado, 
				inu_codTipoTarifa, 
				inu_valorTarifa,
				idt_fecVigenciaIni,
				idt_fecVigenciaFin,
				inu_codCondicion,
				inu_codNumUsuarios,
				inu_codSexo,
				inu_edadInicial,
				inu_edadFinal,
				ivc_codTarifaMP
			);
			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al guardar la tarifa: '||SQLERRM); 
		
		END;
		
	END prGuardarTarifa;
	
	-- ---------------------------------------------------------------------
	-- prActualizarTarifa
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarTarifa
	(
	    inu_codTarifa        IN VDIR_TARIFA.COD_TARIFA%TYPE,
	    inu_codPlanPrograma  IN VDIR_TARIFA.COD_PLAN_PROGRAMA%TYPE,
        inu_codPlan          IN VDIR_TARIFA.COD_PLAN%TYPE,
		inu_codEstado        IN VDIR_TARIFA.COD_ESTADO%TYPE,
		inu_codTipoTarifa    IN VDIR_TARIFA.COD_TIPO_TARIFA%TYPE,
		inu_valorTarifa      IN VDIR_TARIFA.VALOR%TYPE,
		idt_fecVigenciaIni   IN VDIR_TARIFA.FECHA_VIGE_INICIAL%TYPE,
		idt_fecVigenciaFin   IN VDIR_TARIFA.FECHA_VIGE_FIN%TYPE,
		inu_codCondicion     IN VDIR_TARIFA.COD_CONDICION_TARIFA%TYPE,
		inu_codNumUsuarios   IN VDIR_TARIFA.COD_NUM_USUARIOS_TARIFA%TYPE,
		inu_codSexo          IN VDIR_TARIFA.COD_SEXO%TYPE,
		inu_edadInicial      IN VDIR_TARIFA.EDAD_INICIAL%TYPE,
		inu_edadFinal        IN VDIR_TARIFA.EDAD_FINAL%TYPE
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Procedimiento que actualiza la tarifa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	    inu_codTarifa        C�digo de la tarifa
	    inu_codPlanPrograma  C�digo del plan asociado al programa
        inu_codPlan          C�digo del plan
		inu_codEstado        C�digo del estado
		inu_codTipoTarifa    C�digo del tipo de tarifa
		inu_valorTarifa      Valor de la tarifa
		idt_fecVigenciaIni   Fecha inicio de vigencia
		idt_fecVigenciaFin   Fecha fin de vigencia
		inu_codCondicion     C�digo de la condici�n
		inu_codNumUsuarios   C�digo del n�mero de usuarios
		inu_codSexo          C�digo del genero
		inu_edadInicial      Edad m�nima
		inu_edadFinal        Edad m�xima
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	
	BEGIN
			    	
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se actualiza la tarifa
			-- --------------------------------------------------------------------- 
			UPDATE VDIR_TARIFA
			   SET COD_PLAN_PROGRAMA        = inu_codPlanPrograma, 
				   COD_PLAN                 = inu_codPlan,
				   COD_ESTADO               = inu_codEstado, 
				   COD_TIPO_TARIFA          = inu_codTipoTarifa, 
				   VALOR                    = inu_valorTarifa,
				   FECHA_VIGE_INICIAL       = idt_fecVigenciaIni,
				   FECHA_VIGE_FIN           = idt_fecVigenciaFin,
				   COD_CONDICION_TARIFA     = inu_codCondicion,
				   COD_NUM_USUARIOS_TARIFA  = inu_codNumUsuarios,
				   COD_SEXO                 = inu_codSexo,
				   EDAD_INICIAL             = inu_edadInicial,
				   EDAD_FINAL               = inu_edadFinal
		     WHERE COD_TARIFA               = inu_codTarifa;
	
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al actualizar la tarifa: '||SQLERRM); 
		
		END;
		
	END prActualizarTarifa;
 
END VDIR_PACK_REGISTRO_TARIFAS;
/
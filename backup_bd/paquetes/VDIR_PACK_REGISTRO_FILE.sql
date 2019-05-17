CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_FILE AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_FILE
 Caso de Uso : 
 Descripci�n : Procesos para el registro los archivos adjuntos - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 23-01-2018  
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
	-- prGuardarFile
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarFile
	(
		ivc_desFile        IN VDIR_FILE.DES_FILE%TYPE, 
		ivc_observacion    IN VDIR_FILE.OBSERVACION%TYPE,
		ivc_ruta           IN VDIR_FILE.RUTA%TYPE,
		inu_codTipoFile    IN VDIR_FILE.COD_TIPO_FILE%TYPE,
		onu_codFile       OUT VDIR_FILE.COD_FILE%TYPE
    );
	
	-- ---------------------------------------------------------------------
	-- prGuardarFileBeneficiario
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarFileBeneficiario
	(
		inu_codAfiliacion    IN VDIR_FILE_BENEFICIARIO.COD_AFILIACION%TYPE, 
		inu_codFile          IN VDIR_FILE_BENEFICIARIO.COD_FILE%TYPE,
		inu_codBeneficiaro   IN VDIR_FILE_BENEFICIARIO.COD_BENEFICIARIO%TYPE
	);
  
END VDIR_PACK_REGISTRO_FILE;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_REGISTRO_FILE AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_FILE
 Caso de Uso : 
 Descripci�n : Procesos para el registro los archivos adjuntos - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 23-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 
 
	-- ---------------------------------------------------------------------
	-- prGuardarFile
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarFile
	(
		ivc_desFile        IN VDIR_FILE.DES_FILE%TYPE, 
		ivc_observacion    IN VDIR_FILE.OBSERVACION%TYPE,
		ivc_ruta           IN VDIR_FILE.RUTA%TYPE,
		inu_codTipoFile    IN VDIR_FILE.COD_TIPO_FILE%TYPE,
		onu_codFile       OUT VDIR_FILE.COD_FILE%TYPE
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_FILE
	 Caso de Uso : 
	 Descripci�n : Procedimiento que guarda el archivo en la tabla de 
	               parametrizaci�n
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 23-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   ivc_desFile        Descripci�n del archivo
	   ivc_observacion    Observaci�n del archivo
	   ivc_ruta           Ruta en la que queda el archivo
	   inu_codTipoFile    C�digo del tipo de archivo
	   onu_codFile        Variable consecutivo del archivo
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    lnu_codFile VDIR_FILE.COD_FILE%TYPE;
	
	BEGIN
		
	    -- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_FILE.NEXTVAL INTO lnu_codFile FROM DUAL;  
    	onu_codFile := lnu_codFile;
		
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se almacena la ruta del archivo en la base de datos
			-- --------------------------------------------------------------------- 
			INSERT INTO VDIR_FILE
			(
				COD_FILE, 
				DES_FILE, 
				OBSERVACION, 
				RUTA,
				COD_TIPO_FILE
			) 
			VALUES 
			(
				lnu_codFile,
				ivc_desFile,
				ivc_observacion,
				ivc_ruta,
				inu_codTipoFile
			);
			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al guardar el archivo: '||SQLERRM); 
		
		END;
		 
	END prGuardarFile;
	
	-- ---------------------------------------------------------------------
	-- prGuardarFileBeneficiario
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarFileBeneficiario
	(
		inu_codAfiliacion    IN VDIR_FILE_BENEFICIARIO.COD_AFILIACION%TYPE, 
		inu_codFile          IN VDIR_FILE_BENEFICIARIO.COD_FILE%TYPE,
		inu_codBeneficiaro   IN VDIR_FILE_BENEFICIARIO.COD_BENEFICIARIO%TYPE
	)
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_FILE
	 Caso de Uso : 
	 Descripci�n : Procedimiento que asocia un archivo y un beneficiario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 23-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codAfiliacion    C�digo de la afiliaci�n 
	   inu_codFile          C�digo del archivo adjunto
	   inu_codBeneficiaro   C�digo del beneficiario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    lnu_codFileBeneficiario VDIR_FILE_BENEFICIARIO.COD_FILE_BENEFICIARIO%TYPE;
	
	BEGIN
		
	    -- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_FILEBENEFICIARIO.NEXTVAL INTO lnu_codFileBeneficiario FROM DUAL;  
    			
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se asocia el archivo adjunto al beneficiario
			-- --------------------------------------------------------------------- 
			INSERT INTO VDIR_FILE_BENEFICIARIO
			(
				COD_FILE_BENEFICIARIO, 
				COD_AFILIACION, 
				COD_FILE, 
				COD_BENEFICIARIO
			) 
			VALUES 
			(
				lnu_codFileBeneficiario,
				inu_codAfiliacion,
				inu_codFile,
				inu_codBeneficiaro
			);
			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al guardar el archivo asociado al beneficiario: '||SQLERRM); 
		
		END;
		 
	END prGuardarFileBeneficiario;
 
END VDIR_PACK_REGISTRO_FILE;
/
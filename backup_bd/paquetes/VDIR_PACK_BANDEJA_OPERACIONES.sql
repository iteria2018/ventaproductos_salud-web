/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE VDIR_PACK_BANDEJA_OPERACIONES AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_BANDEJA_OPERACIONES
 Caso de Uso : 
 Descripci�n : Procesos para realizar la gesti�n de la bandeja de 
               operaciones
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 14-02-2018  
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
	-- prGuardarBitacora
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarBitacora
	(
		inu_codAfiliacion    IN VDIR_BITACORA_SOLICITUD.COD_AFILIACION%TYPE, 
		inu_codUsuario       IN VDIR_BITACORA_SOLICITUD.COD_USUARIO%TYPE, 
		ivc_desValorAnterior IN VDIR_BITACORA_SOLICITUD.DES_VALOR_ANTERIOR%TYPE, 
		ivc_desValorNuevo    IN VDIR_BITACORA_SOLICITUD.DES_VALOR_NUEVO%TYPE, 
		ivc_observacion      IN VDIR_BITACORA_SOLICITUD.OBSERVACION%TYPE
	);
	
	-- ---------------------------------------------------------------------
	-- prActualizaAfiliacion
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizaAfiliacion
	(
		inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,
		inu_codEstado     IN VDIR_AFILIACION.COD_ESTADO%TYPE,
		idt_fechaGestion  IN VDIR_AFILIACION.FECHA_GESTION%TYPE DEFAULT NULL,
		inu_codUsuario    IN VDIR_AFILIACION.COD_USUARIO_GESTION%TYPE DEFAULT NULL
    );
	
	-- ---------------------------------------------------------------------
	-- prGuardarColaSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarColaSolicitud
	(
		inu_codUsuario       IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion    IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    );
				
	-- ---------------------------------------------------------------------
	-- prEliminaColaSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prEliminaColaSolicitud
	(
		inu_codUsuario        IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion     IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    );
	
	-- ---------------------------------------------------------------------
	-- prActualizaColaSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizaColaSolicitud
	(
		inu_codUsuario        IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion     IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    );
  
    -- ---------------------------------------------------------------------
	-- prGestionSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prGestionSolicitud
	(
		inu_codUsuario     IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion  IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE,
		inu_tipoGestion    IN NUMBER
    );
	
END VDIR_PACK_BANDEJA_OPERACIONES;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VDIR_PACK_BANDEJA_OPERACIONES AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_BANDEJA_OPERACIONES
 Caso de Uso : 
 Descripci�n : Procesos para realizar la gesti�n de la bandeja de 
               operaciones
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 14-02-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 
    
	-- ---------------------------------------------------------------------
	-- prGuardarBitacora
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarBitacora
	(
		inu_codAfiliacion    IN VDIR_BITACORA_SOLICITUD.COD_AFILIACION%TYPE, 
		inu_codUsuario       IN VDIR_BITACORA_SOLICITUD.COD_USUARIO%TYPE, 
		ivc_desValorAnterior IN VDIR_BITACORA_SOLICITUD.DES_VALOR_ANTERIOR%TYPE, 
		ivc_desValorNuevo    IN VDIR_BITACORA_SOLICITUD.DES_VALOR_NUEVO%TYPE, 
		ivc_observacion      IN VDIR_BITACORA_SOLICITUD.OBSERVACION%TYPE
	)
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripci�n : Procedimiento que guarda las gestiones realizadas para 
	               la solicitud
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codAfiliacion    C�digo de la afiliaci�n
	   inu_codUsuario       C�digo del usuario 
	   ivc_desValorAnterior Descripci�n del valor anterior
	   ivc_desValorNuevo    Descripci�n del valor nuevo 
	   ivc_observacion      Observaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    lnu_codBitacoraSolicitud VDIR_BITACORA_SOLICITUD.COD_BITACORA_SOLICITUD%TYPE;
	
	BEGIN
				
	    -- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_BITACORASOLICITUD.NEXTVAL INTO lnu_codBitacoraSolicitud FROM DUAL; 
		
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se el registro en la base de datos
			-- --------------------------------------------------------------------- 
		    INSERT INTO VDIR_BITACORA_SOLICITUD
            (
				COD_BITACORA_SOLICITUD, 
				COD_AFILIACION, 
				COD_USUARIO, 
				DES_VALOR_ANTERIOR,
				DES_VALOR_NUEVO,
				OBSERVACION, 
				FECHA_BITACORA
			)
            VALUES
            (
				lnu_codBitacoraSolicitud, 
				inu_codAfiliacion, 
				inu_codUsuario, 
				ivc_desValorAnterior,
				ivc_desValorNuevo,
				ivc_observacion, 
				SYSDATE
			);

			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al guardar el registro en la bitacora: '||SQLERRM); 
		
		END;
		 
	END prGuardarBitacora;
	
	-- ---------------------------------------------------------------------
	-- prActualizaAfiliacion
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizaAfiliacion
	(
		inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,
		inu_codEstado     IN VDIR_AFILIACION.COD_ESTADO%TYPE,
		idt_fechaGestion  IN VDIR_AFILIACION.FECHA_GESTION%TYPE DEFAULT NULL,
		inu_codUsuario    IN VDIR_AFILIACION.COD_USUARIO_GESTION%TYPE DEFAULT NULL
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripci�n : Procedimiento que actualiza el estado de la solicitud
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codAfiliacion C�digo de la afiliac�n
	   inu_codEstado     C�digo del estado de la solicitud
	   idt_fechaGestion  Fecha de gesti�n de la solicitud
	   inu_codUsuario    C�digo del usuario que realiza la gesti�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 	
	BEGIN
			       			
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se actualiza el estado de la solicitud
			-- --------------------------------------------------------------------- 
			UPDATE VDIR_AFILIACION
			   SET cod_estado          = inu_codEstado,
			       fecha_gestion       = idt_fechaGestion,
				   cod_usuario_gestion = inu_codUsuario
		     WHERE cod_afiliacion      = inu_codAfiliacion;
			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al actualizar la afiliaci�n: '||SQLERRM); 
		
		END;
		 
	END prActualizaAfiliacion;
 
	-- ---------------------------------------------------------------------
	-- prGuardarColaSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarColaSolicitud
	(
		inu_codUsuario    IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripci�n : Procedimiento que guarda en la cola de la bandeja de 
	               operaciones
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codUsuario     C�digo del usuario 
	   inu_codAfiliacion  C�digo de la afiliaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    lnu_codColaSolicitud VDIR_COLA_SOLICITUD.COD_COLA_SOLICITUD%TYPE;
		lnu_error NUMBER(1) := 0;
	
	BEGIN
		
	    -- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_COLASOLICITUD.NEXTVAL INTO lnu_codColaSolicitud FROM DUAL;  
		
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se ingresa la solicitud en la cola
			-- --------------------------------------------------------------------- 
			INSERT INTO VDIR_COLA_SOLICITUD
			(
				COD_COLA_SOLICITUD, 
				COD_USUARIO, 
				COD_AFILIACION
			)
			VALUES
			(
				lnu_codColaSolicitud, 
				inu_codUsuario, 
				inu_codAfiliacion
			);
			
			-- ---------------------------------------------------------------------
			-- Se actualiza el estado de la afiliaci�n a "en gesti�n"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, 5);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al guardar la solicitud en la cola: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurri� ningun error
		-- --------------------------------------------------------------------- 
		IF lnu_error = 0 THEN
		
		    -- ---------------------------------------------------------------------
			-- Se guarda en la tabla de bitacora
			-- --------------------------------------------------------------------- 
		    VDIR_PACK_BANDEJA_OPERACIONES.prGuardarBitacora
			(
				inu_codAfiliacion, 
				inu_codUsuario, 
				NULL, 
				NULL, 
				'Se toma la solicitud para realizarle gesti�n'
			);
			
		END IF;
		 
	END prGuardarColaSolicitud;	
		
	-- ---------------------------------------------------------------------
	-- prEliminaColaSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prEliminaColaSolicitud
	(
		inu_codUsuario        IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion     IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripci�n : Procedimiento que elimina la solicitud de la cola
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codUsuario           C�digo del usuario 
	   inu_codAfiliacion        C�digo de la afiliaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	   	lnu_error NUMBER(1)  := 0;
	
	BEGIN
		
	  	BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se elimina la solicitud de la cola
			-- --------------------------------------------------------------------- 
			DELETE FROM VDIR_COLA_SOLICITUD WHERE COD_AFILIACION = inu_codAfiliacion;
			
			-- ---------------------------------------------------------------------
			-- Se actualiza el estado de la afiliaci�n a "Validado"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, 6,SYSDATE,inu_codUsuario);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al eliminar la solicitud en la cola: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurri� ningun error
		-- --------------------------------------------------------------------- 
		IF lnu_error = 0 THEN
		
		    -- ---------------------------------------------------------------------
			-- Se guarda en la tabla de bitacora
			-- --------------------------------------------------------------------- 
		    VDIR_PACK_BANDEJA_OPERACIONES.prGuardarBitacora
			(
				inu_codAfiliacion, 
				inu_codUsuario, 
				NULL, 
				NULL, 
				'Se realiza la validaci�n de la solicitud'
			);
			
		END IF;
		 
	END prEliminaColaSolicitud;
	
	-- ---------------------------------------------------------------------
	-- prActualizaColaSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizaColaSolicitud
	(
		inu_codUsuario        IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion     IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripci�n : Procedimiento que actualiza la solicitud en la cola
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:	  
	   inu_codUsuario           C�digo del usuario 
	   inu_codAfiliacion        C�digo de la afiliaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	   	lnu_error NUMBER(1) := 0;
	
	BEGIN
		
	  	BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se actualiza el usuario en la cola
			-- --------------------------------------------------------------------- 
			UPDATE VDIR_COLA_SOLICITUD
			   SET COD_USUARIO     = inu_codUsuario
			 WHERE COD_AFILIACION  = inu_codAfiliacion;
			
			-- ---------------------------------------------------------------------
			-- Se actualiza el estado de la afiliaci�n a "en gesti�n"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, 5);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al actualizar la solicitud en la cola: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurri� ningun error
		-- --------------------------------------------------------------------- 
		IF lnu_error = 0 THEN
		
		    -- ---------------------------------------------------------------------
			-- Se guarda en la tabla de bitacora
			-- --------------------------------------------------------------------- 
		    VDIR_PACK_BANDEJA_OPERACIONES.prGuardarBitacora
			(
				inu_codAfiliacion, 
				inu_codUsuario, 
				NULL, 
				NULL, 
				'Se reasigna la solicitud'
			);
			
		END IF;
		 
	END prActualizaColaSolicitud;
	
	-- ---------------------------------------------------------------------
	-- prGestionSolicitud
	-- ---------------------------------------------------------------------
	PROCEDURE prGestionSolicitud
	(
		inu_codUsuario     IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE,
		inu_codAfiliacion  IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE,
		inu_tipoGestion    IN NUMBER
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripci�n : Procedimiento que deja pendiente la solicitud para el 
	               usuario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codUsuario       C�digo del usuario 
	   inu_codAfiliacion    C�digo de la afiliaci�n
	   inu_tipoGestion      Tipo de gesti�n 1 = Si se deja pendiente 
	                        / 2 = Se retoma la solicitud
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	   	lnu_error       NUMBER(1) := 0;
		lnu_codEstado   VDIR_AFILIACION.COD_ESTADO%TYPE;
		lvc_descripcion VARCHAR2(4000);
	
	BEGIN
		
	  	BEGIN
		
		    IF inu_tipoGestion = 1 THEN
			
			    lnu_codEstado   := 4;
			    lvc_descripcion := 'Se cambia a estado pendiente la solicitud'; 
			
			ELSE 
			
			    lnu_codEstado   := 5;
			    lvc_descripcion := 'Se retoma la solicitud para realizarle gesti�n'; 
			
			END IF;
		  	-- ---------------------------------------------------------------------
			-- Se actualiza el estado de la afiliaci�n a "pendiente"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, lnu_codEstado);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri� un error al dejar pendiente la solicitud: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurri� ningun error
		-- --------------------------------------------------------------------- 
		IF lnu_error = 0 THEN
		
		    -- ---------------------------------------------------------------------
			-- Se guarda en la tabla de bitacora
			-- --------------------------------------------------------------------- 
		    VDIR_PACK_BANDEJA_OPERACIONES.prGuardarBitacora
			(
				inu_codAfiliacion, 
				inu_codUsuario, 
				NULL, 
				NULL, 
				lvc_descripcion
			);
			
		END IF;
		 
	END prGestionSolicitud;
	
END VDIR_PACK_BANDEJA_OPERACIONES;
/


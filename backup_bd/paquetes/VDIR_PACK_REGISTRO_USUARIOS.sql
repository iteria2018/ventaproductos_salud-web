CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_USUARIOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_USUARIOS
 Caso de Uso : 
 Descripci�n : Procesos para el registro del los usuarios - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 30-01-2018  
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
	-- prGuardarUsuario
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarUsuario
	(
		inu_codTipoId         IN VDIR_PERSONA.COD_TIPO_IDENTIFICACION%TYPE,
        inu_nroId             IN VDIR_PERSONA.NUMERO_IDENTIFICACION%TYPE,
		ivc_primerNombre      IN VDIR_PERSONA.NOMBRE_1%TYPE,
		ivc_segundoNombre     IN VDIR_PERSONA.NOMBRE_2%TYPE,
		ivc_primerApellido    IN VDIR_PERSONA.APELLIDO_1%TYPE,
		ivc_segundoApellido   IN VDIR_PERSONA.APELLIDO_2%TYPE,
		ivc_correoElectronico IN VDIR_PERSONA.EMAIL%TYPE,
		ivc_telefono          IN VDIR_PERSONA.TELEFONO%TYPE,
		ivc_login             IN VDIR_USUARIO.LOGIN%TYPE,
		ivc_clave             IN VDIR_USUARIO.CLAVE%TYPE,
		inu_codPerfil         IN VDIR_ROL_USUARIO.COD_ROL%TYPE,
		inu_codEstado         IN VDIR_USUARIO.COD_ESTADO%TYPE
    );
	
	-- ---------------------------------------------------------------------
	-- prActualizarUsuario
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarUsuario
	(
	    inu_codUsuario   IN VDIR_USUARIO.COD_USUARIO%TYPE,
        inu_codPerfil    IN VDIR_ROL_USUARIO.COD_ROL%TYPE,
		inu_codEstado    IN VDIR_USUARIO.COD_ESTADO%TYPE
    );
	
	-- ---------------------------------------------------------------------
	-- prActualizarClave
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarClave
	(
	    inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE,
        ivc_clave      IN VDIR_USUARIO.CLAVE%TYPE
    );
  
END VDIR_PACK_REGISTRO_USUARIOS;
/

create or replace PACKAGE BODY VDIR_PACK_REGISTRO_USUARIOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_USUARIOS
 Caso de Uso : 
 Descripci�n : Procesos para el registro del los usuarios - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 30-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */

	-- ---------------------------------------------------------------------
	-- prGuardarUsuario
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarUsuario
	(
		inu_codTipoId         IN VDIR_PERSONA.COD_TIPO_IDENTIFICACION%TYPE,
        inu_nroId             IN VDIR_PERSONA.NUMERO_IDENTIFICACION%TYPE,
		ivc_primerNombre      IN VDIR_PERSONA.NOMBRE_1%TYPE,
		ivc_segundoNombre     IN VDIR_PERSONA.NOMBRE_2%TYPE,
		ivc_primerApellido    IN VDIR_PERSONA.APELLIDO_1%TYPE,
		ivc_segundoApellido   IN VDIR_PERSONA.APELLIDO_2%TYPE,
		ivc_correoElectronico IN VDIR_PERSONA.EMAIL%TYPE,
		ivc_telefono          IN VDIR_PERSONA.TELEFONO%TYPE,
		ivc_login             IN VDIR_USUARIO.LOGIN%TYPE,
		ivc_clave             IN VDIR_USUARIO.CLAVE%TYPE,
		inu_codPerfil         IN VDIR_ROL_USUARIO.COD_ROL%TYPE,
		inu_codEstado         IN VDIR_USUARIO.COD_ESTADO%TYPE
    )
	IS

	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_USUARIOS
	 Caso de Uso : 
	 Descripci�n : Procedimiento que guarda el ingreso
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	    inu_codTipoId         C�digo del tipo de identificaci�n
        inu_nroId             N�mero del tipo de identificaci�n
		ivc_primerNombre      Primer nombre del usuario
		ivc_segundoNombre     Segundo nombre del usuario
		ivc_primerApellido    Primer apellido del usuario
		ivc_segundoApellido   Segundo apellido del usuario
		ivc_correoElectronico Correo electr�nico del usuario
		ivc_telefono          Tel�fono del usuario
		ivc_login             Login del usuario
		ivc_clave             Clave del usuario
		inu_codPerfil         C�digo del perfil
		inu_codEstado         C�digo del estado
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */

	    lnu_codPersona    VDIR_PERSONA.COD_PERSONA%TYPE;
		lnu_codUsuario    VDIR_USUARIO.COD_USUARIO%TYPE;
		lnu_codRolUsuario VDIR_ROL_USUARIO.COD_ROL_USUARIO%TYPE;
		lnu_error         NUMBER(1) := 0;

	BEGIN

	    -- ---------------------------------------------------------------------
		-- Se valida si la persona existe
		-- ---------------------------------------------------------------------
		lnu_codPersona := VDIR_PACK_CONSULTA_USUARIOS.fnGetExistePersona(inu_codTipoId,inu_nroId);

		-- ---------------------------------------------------------------------
		-- Si la persona no existe
		-- ---------------------------------------------------------------------
		IF lnu_codPersona IS NULL THEN

		    -- ---------------------------------------------------------------------
			-- Se avanza la secuencia
			-- --------------------------------------------------------------------- 
		    SELECT VDIR_SEQ_PERSONA.NEXTVAL INTO lnu_codPersona FROM DUAL;   

			BEGIN

				-- ---------------------------------------------------------------------
				-- Se ingresa la persona
				-- --------------------------------------------------------------------- 
				INSERT INTO VDIR_PERSONA
				(
					COD_PERSONA,
					COD_TIPO_IDENTIFICACION,
                    NUMERO_IDENTIFICACION,
		            NOMBRE_1,
		            NOMBRE_2,
		            APELLIDO_1,
		            APELLIDO_2,
		            EMAIL,
		            TELEFONO,
					CELULAR,
					COD_ESTADO
				) 
				VALUES 
				(
					lnu_codPersona,
					inu_codTipoId,
					inu_nroId,
					ivc_primerNombre,
					ivc_segundoNombre,
					ivc_primerApellido,
					ivc_segundoApellido,
					ivc_correoElectronico,
					ivc_telefono,
					ivc_telefono,
					1
				);

			EXCEPTION WHEN OTHERS THEN

			    lnu_error := 1;
				RAISE_APPLICATION_ERROR(-20001,'Ocurri&oacute; un error al guardar la persona: '||SQLERRM); 

			END; 

			-- ---------------------------------------------------------------------
			-- Si no ocurri� ningun error
			-- --------------------------------------------------------------------- 
			IF lnu_error = 0 THEN

			    -- ---------------------------------------------------------------------
				-- Se valida si el login del usuario existe
				-- ---------------------------------------------------------------------
				lnu_codUsuario := VDIR_PACK_CONSULTA_USUARIOS.fnGetExisteLogin(ivc_login);

				-- ---------------------------------------------------------------------
				-- Si el usuario no existe
				-- ---------------------------------------------------------------------
				IF lnu_codUsuario IS NULL THEN

				    -- ---------------------------------------------------------------------
					-- Se avanza la secuencia
					-- --------------------------------------------------------------------- 
					SELECT VDIR_SEQ_USUARIO.NEXTVAL INTO lnu_codUsuario FROM DUAL;   

					BEGIN

						-- ---------------------------------------------------------------------
						-- Se ingresa el usuario
						-- --------------------------------------------------------------------- 
						INSERT INTO VDIR_USUARIO
						(
							COD_USUARIO,
							LOGIN,
							CLAVE,
							COD_PERSONA,
							COD_ESTADO
						) 
						VALUES 
						(
							lnu_codUsuario,
							ivc_login,
							ivc_clave,
							lnu_codPersona,
							inu_codEstado
						);

					EXCEPTION WHEN OTHERS THEN

						lnu_error := 1;
						RAISE_APPLICATION_ERROR(-20001,'Ocurri&oacute; un error al guardar el usuario: '||SQLERRM); 

					END; 

					-- ---------------------------------------------------------------------
					-- Si no ocurri� ningun error
					-- --------------------------------------------------------------------- 
					IF lnu_error = 0 THEN

					    -- ---------------------------------------------------------------------
						-- Se valida si el perfil existe
						-- ---------------------------------------------------------------------
						lnu_codRolUsuario := VDIR_PACK_CONSULTA_USUARIOS.fnGetExistePerfil(lnu_codUsuario,inu_codPerfil);  

						-- ---------------------------------------------------------------------
						-- Si el perfil no existe
						-- ---------------------------------------------------------------------
						IF lnu_codRolUsuario IS NULL THEN

						    -- ---------------------------------------------------------------------
							-- Se avanza la secuencia
							-- --------------------------------------------------------------------- 
							SELECT VDIR_SEQ_ROL_USUARIO.NEXTVAL INTO lnu_codRolUsuario FROM DUAL;   

							BEGIN

								-- ---------------------------------------------------------------------
								-- Se ingresa el perfil
								-- --------------------------------------------------------------------- 
								INSERT INTO VDIR_ROL_USUARIO
								(
								    COD_ROL_USUARIO,
									COD_USUARIO,
									COD_ROL
								) 
								VALUES 
								(
									lnu_codRolUsuario,
									lnu_codUsuario,
									inu_codPerfil
								);

							EXCEPTION WHEN OTHERS THEN

								lnu_error := 1;
								RAISE_APPLICATION_ERROR(-20001,'Ocurri&oacute; un error al guardar el perfil: '||SQLERRM); 

							END; 						

						END IF;

					END IF;			

				END IF;

			END IF;

		END IF;

	END prGuardarUsuario;

	-- ---------------------------------------------------------------------
	-- prActualizarUsuario
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarUsuario
	(
	    inu_codUsuario   IN VDIR_USUARIO.COD_USUARIO%TYPE,
        inu_codPerfil    IN VDIR_ROL_USUARIO.COD_ROL%TYPE,
		inu_codEstado    IN VDIR_USUARIO.COD_ESTADO%TYPE
    )
	IS

	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_USUARIOS
	 Caso de Uso : 
	 Descripci�n : Procedimiento que actualiza el usuario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	    inu_codPersona   C�digo de la persona
	    inu_codUsuario   C�digo del usuario
		inu_codPerfil    C�digo del perfil
		inu_codEstado    C�digo del estado
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */

	    lnu_error NUMBER(1) := 0;

	BEGIN

		BEGIN

		    -- ---------------------------------------------------------------------
			-- Se actualiza el estado del usuario
			-- --------------------------------------------------------------------- 
			UPDATE VDIR_USUARIO
			   SET COD_ESTADO  = inu_codEstado
		     WHERE COD_USUARIO = inu_codUsuario;

		EXCEPTION WHEN OTHERS THEN

		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurri&oacute; un error al actualizar la tarifa: '||SQLERRM); 

		END;

		-- ---------------------------------------------------------------------
		-- Si no ocurri� ningun error
		-- --------------------------------------------------------------------- 
		IF lnu_error = 0 THEN

		    BEGIN

				-- ---------------------------------------------------------------------
				-- Se actualiza el perfil del usuario
				-- --------------------------------------------------------------------- 
				UPDATE VDIR_ROL_USUARIO
				   SET COD_ROL     = inu_codPerfil
				 WHERE COD_USUARIO = inu_codUsuario;

			EXCEPTION WHEN OTHERS THEN

				lnu_error := 1;
				RAISE_APPLICATION_ERROR(-20001,'Ocurri&oacute; un error al actualizar la tarifa: '||SQLERRM); 

			END;

		END IF;

	END prActualizarUsuario;

	-- ---------------------------------------------------------------------
	-- prActualizarClave
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarClave
	(
	    inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE,
        ivc_clave      IN VDIR_USUARIO.CLAVE%TYPE
    )
	IS

	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_USUARIOS
	 Caso de Uso : 
	 Descripci�n : Procedimiento que actualiza la clave del usuario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 01-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	    inu_codUsuario   C�digo del usuario
		ivc_clave        Clave nueva ingresada por el usuario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */

	BEGIN

		BEGIN

		    -- ---------------------------------------------------------------------
			-- Se actualiza la clave del usuario
			-- --------------------------------------------------------------------- 
			UPDATE VDIR_USUARIO
			   SET CLAVE       = ivc_clave
		     WHERE COD_USUARIO = inu_codUsuario;

		EXCEPTION WHEN OTHERS THEN

		    RAISE_APPLICATION_ERROR(-20001,'Ocurri&oacute; un error al actualizar la clave: '||SQLERRM); 

		END;

	END prActualizarClave;

END VDIR_PACK_REGISTRO_USUARIOS;

/
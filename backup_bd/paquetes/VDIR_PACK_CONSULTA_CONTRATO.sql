/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE SALUDMP.VDIR_PACK_CONSULTA_CONTRATO AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_CONTRATO
 Caso de Uso : 
 Descripción : Procesos para la consulta los archivos de contratos
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 20-02-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */

	-- ---------------------------------------------------------------------
	-- Declaracion de estructuras dinamicas
	-- ---------------------------------------------------------------------
	TYPE type_cursor IS REF CURSOR;
    TYPE type_cadena IS TABLE OF VARCHAR2(2000)
            INDEX BY BINARY_INTEGER;
            
-- ---------------------------------------------------------------------
    -- fn_CadenatoArray
    -- ---------------------------------------------------------------------            
    FUNCTION fn_CadenatoArray
    (
        pvc_cadena       VARCHAR2 ,
        pch_separador CHAR DEFAULT ','
    )
    RETURN type_cadena;
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
	
	FUNCTION fnGetValidaInclusion
    (
        inu_codAfiliacion IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE
    )
	RETURN type_cursor;
	
	FUNCTION fnGetContrato
    (      	
		inu_codPrograma IN VDIR_PROGRAMA.COD_PROGRAMA%TYPE,
        inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN VARCHAR2;


END VDIR_PACK_CONSULTA_CONTRATO;

/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY SALUDMP.VDIR_PACK_CONSULTA_CONTRATO AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_CONTRATO
 Caso de Uso : 
 Descripción : Procesos para la consulta los archivos de contratos
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 20-02-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */
FUNCTION fn_CadenatoArray
    (
    pvc_cadena       VARCHAR2 ,
    pch_separador CHAR DEFAULT ','
    )
    RETURN type_cadena IS
    
    TYPE type_posicion IS TABLE OF INTEGER
      INDEX BY BINARY_INTEGER;
  
      ltb_posiciones type_posicion;
       ltb_datos        type_cadena;
    
    li_posicion_vector PLS_INTEGER;
    li_pos_simbolo        PLS_INTEGER;
    li_pos_simbolo_tmp PLS_INTEGER;
    li_nro_palabras       PLS_INTEGER;
    li_pos_inicial       PLS_INTEGER;
    li_limite           PLS_INTEGER;
    x                   PLS_INTEGER := 0;

      BEGIN
           -- Obtiene las Posiciones del Símbolo Separador de Datos
        li_posicion_vector := 1;
        li_pos_simbolo     := 1;
        LOOP
            li_pos_simbolo_tmp := INSTR(pvc_cadena,pch_separador,li_pos_simbolo);

            IF(li_pos_simbolo_tmp IS NULL) THEN
                li_pos_simbolo_tmp := 0;
            END IF;      
            
            IF li_pos_simbolo_tmp > 0 THEN
               ltb_posiciones(li_posicion_vector) := li_pos_simbolo_tmp;
               li_pos_simbolo := li_pos_simbolo_tmp + 1;
               li_posicion_vector := li_posicion_vector + 1;
            END IF;
          EXIT WHEN li_pos_simbolo_tmp = 0;
        END LOOP;
        -- Almacena las Palabras en un Arreglo
        li_nro_palabras := ltb_posiciones.COUNT + 1;
        li_pos_simbolo := 1;
        li_pos_inicial := 1;
        li_limite := li_nro_palabras - 1;
        

        FOR i IN 1..li_limite LOOP
            ltb_datos(i) := SUBSTR(pvc_cadena,li_pos_inicial,ltb_posiciones(i) - li_pos_inicial);    
            li_pos_inicial := ltb_posiciones(i) + 1;
            x:=i;
        END LOOP;
        x := x + 1;
        ltb_datos(x) := SUBSTR(pvc_cadena,li_pos_inicial,(LENGTH(pvc_Cadena) - li_pos_inicial) + 1);

        RETURN ltb_datos;
    END fn_CadenatoArray;
	-- ---------------------------------------------------------------------
    -- fnGetDatosContrato
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosContrato
    (
      	inu_codPersona  IN VDIR_PERSONA.COD_PERSONA%TYPE,
		inu_codPrograma IN VDIR_PROGRAMA.COD_PROGRAMA%TYPE,
        inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN VARCHAR2 IS


	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_CONTRATO
	 Caso de Uso : 
	 Descripción : Retorna una cadena con los datos llenos del contrato
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 20-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:	
	 inu_codPersona    Código de la persona contratante
	 inu_codPrograma   Código del programa asociado al beneficiario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */

	    CURSOR cu_contratante(lty_pago NUMBER) IS
		SELECT usua.cod_plan tipoPlan,
               pers.nombre_1||' '|| pers.nombre_2||' '||pers.apellido_1||' '||pers.apellido_2 nombreContratante,
			   pers.numero_identificacion numeroIdentificacion,
			   UPPER(usua.corte) corte,
			   '0' tarifaCuota,
			   lty_pago formaPago,
			   '1' periodoPago,
			   TO_CHAR(SYSDATE, 'YY') yearFirma,
			   VDIR_PACK_UTILIDADES.fn_getMonthSpainish(CAST(TO_CHAR(SYSDATE, 'MM') AS INTEGER)) mesFirma,--TO_CHAR(SYSDATE, 'MONTH') mesFirma, --Fecha en letrras
			   TO_CHAR(SYSDATE, 'DD') diaFirma,
			   TO_CHAR(SYSDATE, 'YYYY') yearContratacion,
			   TO_CHAR(SYSDATE, 'MM') mesContratacion,
			   TO_CHAR(SYSDATE, 'DD') diaContratacion,
			   pers.email,
			   tiid.des_abr
		  FROM VDIR_PERSONA pers,
		       VDIR_USUARIO usua,
			   VDIR_TIPO_IDENTIFICACION tiid			   
		 WHERE pers.cod_persona             = usua.cod_persona 
		   AND pers.cod_tipo_identificacion = tiid.cod_tipo_identificacion
		   AND pers.cod_persona             = inu_codPersona;

		CURSOR cu_beneficiarios IS
		SELECT pers.nombre_1||' '|| pers.nombre_2||' '||pers.apellido_1||' '||pers.apellido_2 AS nombreBeneficiario,
		       pers.numero_identificacion AS numeroIdentificacion,
               (SELECT valor FROM vdir_tarifa 
                    WHERE cod_tarifa  = VDIR_PACK_REGISTRO_PRODUCTOS.fn_get_tarifa(bepo.cod_beneficiario, bepo.cod_programa, bepo.cod_afiliacion)) AS val_tarifa
	      FROM VDIR_PERSONA pers,
		       VDIR_CONTRATANTE_BENEFICIARIO cobe,
			   VDIR_BENEFICIARIO_PROGRAMA bepo
	     WHERE cobe.cod_beneficiario = pers.cod_persona
		   AND cobe.cod_beneficiario = bepo.cod_beneficiario
           AND cobe.cod_afiliacion = bepo.cod_afiliacion
           AND cobe.cod_afiliacion = inu_codAfiliacion
		   AND cobe.cod_contratante  = inu_codPersona
		   AND bepo.cod_programa     = inu_codPrograma
		   AND bepo.cod_estado       = 1;
		   
        CURSOR CU_FORMAPAGO IS
        select vf.COD_FORMA_PAGO from 
            vdir_factura vf,
            vdir_factura_detalle fd,
            vdir_beneficiario_programa bp
            where bp.COD_AFILIACION = inu_codAfiliacion
            and bp.COD_BENEFICIARIO = inu_codPersona
            and bp.COD_PROGRAMA = inu_codPrograma
            and fd.COD_BENEFICIARIO_PROGRAMA = bp.COD_BENEFICIARIO_PROGRAMA
            and fd.COD_FACTURA = vf.COD_FACTURA;
            
        CURSOR CU_PARAMETRO IS
		SELECT VALOR_PARAMETRO FROM VDIR_PARAMETRO
            WHERE COD_PARAMETRO = 86;

		ltc_contratante   cu_contratante%ROWTYPE;
		ltc_beneficiarios cu_beneficiarios%ROWTYPE;
		lvc_datosContrato VARCHAR2(32767);
		lnu_nroContrato   NUMBER(16);
		lnu_i             NUMBER(3) := 1;
		lnu_val_tarifa    NUMBER(16) := 0;
		lvh_formatMil_tarifa VARCHAR2(100);
		lnu_forma_pago      NUMBER(2);
		ltd_fecha       DATE;
		lvc_cortes      VARCHAR2(2000);		
		lty_array_cad type_cadena; 
		
	BEGIN

		-- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_CONTRATO.NEXTVAL INTO lnu_nroContrato FROM DUAL;   

		lvc_datosContrato := '';
        
		
		OPEN CU_FORMAPAGO;
		FETCH CU_FORMAPAGO INTO lnu_forma_pago;
		CLOSE CU_FORMAPAGO;

		 OPEN cu_contratante(lnu_forma_pago); 
		FETCH cu_contratante INTO ltc_contratante; 
		CLOSE cu_contratante;
		
		OPEN CU_PARAMETRO; 
		FETCH CU_PARAMETRO INTO lvc_cortes; 
		CLOSE CU_PARAMETRO;

		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||lnu_nroContrato||'","fieldName": "txtNumeroContrato"},';
        lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||lnu_nroContrato||'","fieldName": "txtNumeroContrato1"},';
        lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||lnu_nroContrato||'","fieldName": "txtNumeroContrato2"},';

		-- ---------------------------------------------------------------------
		-- Si el tipo de Plan es familiar
		-- --------------------------------------------------------------------- 
		IF ltc_contratante.tipoPlan = 2 THEN

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPlanFamiliar"},';		   

		-- ---------------------------------------------------------------------
		-- Si el tipo de Plan es colectivo
		-- --------------------------------------------------------------------- 	
		ELSIF ltc_contratante.tipoPlan = 3 THEN

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPlanColectivo"},';	

		-- ---------------------------------------------------------------------
		-- Si el tipo de Plan es asociado
		-- ---------------------------------------------------------------------
		ELSIF ltc_contratante.tipoPlan = 1 THEN		

			lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPlanAsociado"},';

		END IF;

		lty_array_cad := VDIR_PACK_CONSULTA_CONTRATO.fn_CadenatoArray(lvc_cortes);
		IF ltc_contratante.corte IS NULL THEN
               IF (EXTRACT(DAY FROM SYSDATE) <= 15) THEN 
				   ltd_fecha := TO_DATE('16/'||TO_CHAR(SYSDATE,'MM/YYYY'),'DD/MM/YYYY'); 
			   ELSE 
			       ltd_fecha := TO_DATE('01/'||TO_CHAR(ADD_MONTHS(SYSDATE, 1),'MM/YYYY'),'DD/MM/YYYY'); 
			   END IF;			  
		ELSE 
		
            IF ltc_contratante.corte IN (lty_array_cad(1),lty_array_cad(2),lty_array_cad(3),lty_array_cad(4),lty_array_cad(5)) THEN
                IF (EXTRACT(DAY FROM SYSDATE) <= 15) THEN 
                    ltd_fecha := TO_DATE('16/'||TO_CHAR(SYSDATE,'MM/YYYY'),'DD/MM/YYYY'); 
                ELSE
                    ltd_fecha := TO_DATE('16/'||TO_CHAR(ADD_MONTHS(SYSDATE, 1),'MM/YYYY'),'DD/MM/YYYY'); 
                END IF;
            ELSIF ltc_contratante.corte IN (lty_array_cad(6),lty_array_cad(7)) THEN
                ltd_fecha := TO_DATE('01/'||TO_CHAR(ADD_MONTHS(SYSDATE, 1),'MM/YYYY'),'DD/MM/YYYY'); 
            END IF;
               
		END IF;
		
           lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.nombreContratante             ||'","fieldName": "txtNombreContratante"},';	
           lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.numeroIdentificacion          ||'","fieldName": "txtNumeroIdentificacion"},';
           lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ltd_fecha, 'YYYY')||'","fieldName": "txtYearVigencia"},';
           lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ltd_fecha, 'MM')  ||'","fieldName": "txtMesVigencia"},';
           lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ltd_fecha, 'DD')  ||'","fieldName": "txtDiaVigencia"},';
           lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ADD_MONTHS(ltd_fecha, 12), 'DD/MM/YYYY')||'","fieldName": "txtVigencia"},';
    	--lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.tarifaCuota                   ||'","fieldName": "txtTarifaCuota"},';

		OPEN cu_beneficiarios; 
	    LOOP 
	    FETCH cu_beneficiarios INTO ltc_beneficiarios; 
		    EXIT WHEN cu_beneficiarios%NOTFOUND; 

			lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_beneficiarios.nombreBeneficiario  ||'","fieldName": "txtNombreBeneficiario'||lnu_i||'"},';
		  	lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_beneficiarios.numeroIdentificacion||'","fieldName": "txtNumIdBeneficiario'||lnu_i||'"},';
		    lnu_i := lnu_i + 1;
            lnu_val_tarifa := lnu_val_tarifa + ltc_beneficiarios.val_tarifa;

	    END LOOP; 
	    CLOSE cu_beneficiarios;
        lvh_formatMil_tarifa := VDIR_PACK_UTILIDADES.fn_getFormatMiles(lnu_val_tarifa,0,'$');--TRIM(TO_CHAR(lnu_val_tarifa, '$999G999G999G999G999'));
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||lvh_formatMil_tarifa                   ||'","fieldName": "txtTarifaCuota"},';
		-- ---------------------------------------------------------------------
		-- Si la forma de pago es Efectivo
		-- ---------------------------------------------------------------------
		IF ltc_contratante.formaPago = 1 THEN

	    	lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPagoEfectivo"},';

		-- ---------------------------------------------------------------------
		-- Si la forma de pago es Debito
		-- ---------------------------------------------------------------------
		ELSIF ltc_contratante.formaPago = 2 THEN

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPagoDebito"},';

		-- ---------------------------------------------------------------------
		-- Si la forma de pago es Cheque
		-- ---------------------------------------------------------------------
		ELSIF ltc_contratante.formaPago = 3 THEN

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPagoCheque"},';		    

		-- ---------------------------------------------------------------------
		-- Si la forma de pago es Credito
		-- ---------------------------------------------------------------------
		ELSE

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPagoCredito"},';

		END IF;

		-- ---------------------------------------------------------------------
		-- Si periodo de pago es Mensual
		-- ---------------------------------------------------------------------
		IF ltc_contratante.periodoPago = 1 THEN

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPeriodoMensual"},';	

		-- ---------------------------------------------------------------------
		-- Si periodo de pago es Trimestral	
		-- ---------------------------------------------------------------------
		ELSIF ltc_contratante.periodoPago = 2 THEN

		     lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPeriodoTrimestral"},';	

        -- ---------------------------------------------------------------------
		-- Si periodo de pago es Semestral	
		-- ---------------------------------------------------------------------
		ELSIF ltc_contratante.periodoPago = 3 THEN

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPeriodoSemestral"},';	
		-- ---------------------------------------------------------------------
		-- Si periodo de pago es Anual
		-- ---------------------------------------------------------------------
		ELSE

		    lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "S","fieldName": "txtPeriodoAnual"},';	 

		END IF;

		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.diaFirma||'","fieldName": "txtDiaFirma"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.mesFirma||'","fieldName": "txtMesFirma"},';		
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.yearFirma||'","fieldName": "txtYearFirma"},';		
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.nombreContratante||'","fieldName": "txtNombreContratante2"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.numeroIdentificacion||'","fieldName": "txtNumeroIdentificacion2"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.yearContratacion||'","fieldName": "txtYearSolicitud"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.mesContratacion||'","fieldName": "txtMesSolicitud"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.diaContratacion||'","fieldName": "txtDiaSolicitud"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.yearContratacion||'","fieldName": "txtYearAceptacion"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.mesContratacion||'","fieldName": "txtMesAceptacion"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.diaContratacion||'","fieldName": "txtDiaAceptacion"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.yearContratacion||'","fieldName": "txtYearContratacion"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.mesContratacion||'","fieldName": "txtMesContratacion"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.diaContratacion||'","fieldName": "txtDiaContratacion"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.des_abr||': '||ltc_contratante.numeroIdentificacion||'","fieldName": "txtNumeroIdentificacion3"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.email||'","fieldName": "txtEmailContratante"}';


		RETURN lvc_datosContrato;

	END fnGetDatosContrato;

	-- ---------------------------------------------------------------------
    -- fnGetValidaContrato
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaContrato
    (
        inu_codAfiliacion IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE,
		inu_codPrograma   IN VDIR_PERSONA_CONTRATO.COD_PROGRAMA%TYPE
    )
	RETURN NUMBER IS

	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_CONTRATO
	 Caso de Uso : 
	 Descripción : Retorna 1 = Si / 0 = No si el contrante firmo el contrato
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 20-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 inu_codAfiliacion       Código de la afiliación
	 inu_codPersona          Código de la persona contratante
	 inu_codPrograma         Código del programa
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */

	    CURSOR cu_valida_contrato IS
		SELECT COUNT(1)
		  FROM VDIR_PERSONA_CONTRATO pc,
                VDIR_CONTRATANTE_BENEFICIARIO CB
	     WHERE PC.COD_AFILIACION = inu_codAfiliacion		   
		   AND PC.COD_PROGRAMA   = inu_codPrograma
		   AND CB.COD_BENEFICIARIO = inu_codPersona
		   AND CB.COD_AFILIACION = pc.COD_AFILIACION;

		lnu_validaContrato NUMBER(1) := 0;
        lnu_respuesta   NUMBER(1);

	BEGIN

		 OPEN cu_valida_contrato; 
		FETCH cu_valida_contrato INTO lnu_validaContrato; 
		CLOSE cu_valida_contrato;
        
		IF lnu_validaContrato = 0 THEN
            lnu_respuesta := 0;
		ELSE
            lnu_respuesta := 1;
		END IF;
		
		RETURN lnu_respuesta;

	END fnGetValidaContrato;
	


FUNCTION fnGetValidaInclusion
    (
        inu_codAfiliacion IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE
    )RETURN type_cursor IS
    ltc_datos type_cursor;
 BEGIN 
     BEGIN
        OPEN ltc_datos FOR
        SELECT 
            CB.COD_BENEFICIARIO as "benficiario",
            VP.COD_PROGRAMA AS "programa",
            PR.DES_PROGRAMA AS "des_programa"
            FROM
        VDIR_CONTRATANTE_BENEFICIARIO CB,
        VDIR_BENEFICIARIO_PROGRAMA VP,
        VDIR_PROGRAMA PR
        WHERE CB.COD_AFILIACION = VP.COD_AFILIACION
        AND CB.COD_BENEFICIARIO = VP.COD_BENEFICIARIO
        AND VP.COD_PROGRAMA = PR.COD_PROGRAMA 
        AND CB.COD_AFILIACION = inu_codAfiliacion  
        AND CB.COD_CONTRATANTE = inu_codPersona
        AND nvl(CB.COD_TIPO_SOLICITUD,0) <> 1;      
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            OPEN ltc_datos FOR
            SELECT -1 as "benficiario" FROM DUAL;
    END;       

    RETURN ltc_datos;

 END fnGetValidaInclusion;
 
 FUNCTION fnGetContrato
    (
		inu_codPrograma IN VDIR_PROGRAMA.COD_PROGRAMA%TYPE,
        inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN VARCHAR2 IS
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_CONTRATO
	 Caso de Uso : 
	 Descripción : Retorna contrato
	 ----------------------------------------------------------------------
	 Autor : jors.castro@iteria.com
	 Fecha : 10/09/2019
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 inu_codAfiliacion       Código de la afiliación
	 inu_codPrograma         Código del programa
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
	 CURSOR cu_contrato IS
		SELECT pc.NUMERO_CONTRATO_ADOBE
		  FROM VDIR_PERSONA_CONTRATO pc               
	     WHERE PC.COD_AFILIACION = inu_codAfiliacion		   
		   AND PC.COD_PROGRAMA   = inu_codPrograma
		   group by	pc.NUMERO_CONTRATO_ADOBE;
    
    lvc_contrato VARCHAR2(1000);
	
BEGIN
    BEGIN
        OPEN cu_contrato; 
		FETCH cu_contrato INTO lvc_contrato; 
		CLOSE cu_contrato;
		
		RETURN lvc_contrato;
    END;
        
END fnGetContrato;
END VDIR_PACK_CONSULTA_CONTRATO;
/


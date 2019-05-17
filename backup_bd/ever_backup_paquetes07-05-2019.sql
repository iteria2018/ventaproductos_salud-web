create or replace PACKAGE           "VDIR_PACK_UTILIDADES" AS 
 
   
   FUNCTION VDIR_FN_GETCOLECCION_WHERE(p_nom_cod_tabla IN VARCHAR2,p_nom_des_tabla IN VARCHAR2,p_nom_table IN VARCHAR2,p_aux_where IN VARCHAR2,p_fila_order IN VARCHAR2) RETURN sys_refcursor;

   ------------------------------------------------------------------------------FUNCION PARA TRAER LA DESCRIPCION DE UNA PARAMETRO 
    FUNCTION VDIR_FN_GET_PARAMETRO(p_codigoParametro IN NUMBER) RETURN VARCHAR2;

   ----------------------------------------------------------------------------  FUNCION PARA TRAER LOS DAOS DE LA PERSONA,USUAIRO Y ROLES 
   FUNCTION VDIR_FN_GET_DATOS_PERSONA(p_identificacion IN vdir_persona.numero_identificacion%TYPE) RETURN sys_refcursor;

   ------------------------------------------------------------------------------FUNCION PARA TRAER LOS ROLES QUE TIENE UNA PERSONA 
    FUNCTION VDIR_FN_GET_ROLES_PERSONA(p_cod_user IN vdir_usuario.cod_usuario%TYPE) RETURN VARCHAR2;

     TYPE type_cursor IS REF CURSOR;

    TYPE datasplit_record IS RECORD(
       idx NUMBER, 
       dato VARCHAR2(4000)
    );

    TYPE datasplit_table IS TABLE OF datasplit_record;

     /* ------------------------------------------
     fn_splitData: funcion para retornar tabla con los datos de una cadena separados por un caracter
     -- ------------------------------------------  */
     FUNCTION fn_splitData
     (
        P_STRING_DATA IN VARCHAR2,
        P_SEPARATOR IN VARCHAR2
     )RETURN datasplit_table PIPELINED;

     ----------------------------------------------------------------------------  FUNCION PARA TRAER LOS DATOS DE PAGAR EN PAYU 
    FUNCTION VDIR_FN_GET_DATOS_PAGO(p_cod_afiliacion  vdir_afiliacion.cod_afiliacion%TYPE) RETURN sys_refcursor;

    /*---------------------------------------------------------------------
    fn_getMonthSpainish: funcion para obtener el nombre del un mes en español
    ----------------------------------------------------------------------- */  
    FUNCTION fn_getMonthSpainish
    (
        p_num_mes IN INTEGER
    )RETURN VARCHAR2;

    /*---------------------------------------------------------------------
      fn_getFormatMiles: funcion para obtener el formateo a miles de un numero entero o decimal
     ----------------------------------------------------------------------- */  
     FUNCTION fn_getFormatMiles
     (
        p_numero IN INTEGER,
        p_incluir_decimal IN INTEGER,
        p_prefijo IN CHAR
     )RETURN VARCHAR2;
     
     ------------------------------------------------------------------------------FUNCION PARA TRAER LOS PROGRAMAS DE UN CONTRATANTE PARA UNA AFLIACION 
    FUNCTION VDIR_FN_GET_PROGRAMAS(p_cod_afiliacion  vdir_afiliacion.cod_afiliacion%TYPE) RETURN VARCHAR2;

     
     /*---------------------------------------------------------------------
      VDIR_FN_GET_DATOS_KIT BIENVENIDA: funcion para obtener los datos del kit de bienvenida
     ----------------------------------------------------------------------- */
   FUNCTION VDIR_FN_GET_DATOS_KIT_BIENV(p_cod_afiliacion  vdir_afiliacion.cod_afiliacion%TYPE) RETURN sys_refcursor;


END VDIR_PACK_UTILIDADES;
/

create or replace PACKAGE BODY           "VDIR_PACK_UTILIDADES" AS

  FUNCTION VDIR_FN_GETCOLECCION_WHERE(p_nom_cod_tabla IN VARCHAR2,p_nom_des_tabla IN VARCHAR2,p_nom_table IN VARCHAR2,p_aux_where IN VARCHAR2,p_fila_order IN VARCHAR2) RETURN sys_refcursor 
  AS
   
    vl_cursor sys_refcursor; 
    vl_cadena VARCHAR2(3000) DEFAULT '';   
    vl_existe_where VARCHAR2(4000);
    vl_fila_order VARCHAR2(50);    

  BEGIN

   IF(p_aux_where IS NOT NULL) THEN    
      vl_existe_where := ' WHERE ' ||p_aux_where;
   ELSE
      vl_existe_where := '';
   END IF; 

   vl_fila_order := 'ORDER BY '||p_fila_order;

   vl_cadena := 'SELECT ' ||p_nom_cod_tabla || ' AS codigo ,' || p_nom_des_tabla || ' AS nombre FROM ' || p_nom_table || vl_existe_where||' '||vl_fila_order;   

      OPEN vl_cursor
       FOR 
         vl_cadena;

  RETURN vl_cursor;

  END VDIR_FN_GETCOLECCION_WHERE;

  -----------------------------------------------------------------------FUNCION PARA TRAER LA DESCRIPCION DE UN PARAMETRO

  FUNCTION VDIR_FN_GET_PARAMETRO(p_codigoParametro IN NUMBER) 
    RETURN VARCHAR2
    AS  

    v_retorno VARCHAR2(4000);

    BEGIN

      BEGIN     
        SELECT 
          VALOR_PARAMETRO  INTO v_retorno
        FROM 
          VDIR_PARAMETRO 
        WHERE
         COD_PARAMETRO = p_codigoParametro;
      EXCEPTION WHEN OTHERS THEN
       v_retorno := '';
      END;       

    RETURN v_retorno;

    END VDIR_FN_GET_PARAMETRO; 

   ----------------------------------------------------------------------------  FUNCION PARA TRAER LOS DAOS DE LA PERSONA,USUAIRO Y ROLES 
   FUNCTION VDIR_FN_GET_DATOS_PERSONA(p_identificacion IN vdir_persona.numero_identificacion%TYPE) 

   RETURN sys_refcursor 
   AS

   vl_cursor sys_refcursor;   

    BEGIN

  OPEN vl_cursor
    FOR 
     SELECT
        persona.cod_persona ,
        persona.cod_tipo_identificacion,
        ti.DES_TIPO_IDENTIFICACION AS DES_TIP_IDENT_LONG,
        ti.DES_ABR AS DES_TIP_IDENT_SMALL,
        persona.numero_identificacion,
        persona.nombre_1,
        persona.nombre_2,
        persona.apellido_1,
        persona.apellido_2,
        COALESCE(persona.nombre_1,' ')||' '|| COALESCE(persona.nombre_2,' ')||' '|| COALESCE(persona.apellido_1,' ')||' '||COALESCE(persona.apellido_2,' ') AS NOMBRE_COMPLETO,
        persona.fecha_nacimiento,
        18 as EDAD,
        --trunc(months_between(sysdate, to_char(persona.fecha_nacimiento,'dd/mm/yyyy'))/12) as EDAD,
        persona.telefono,
        persona.email,
        persona.direccion,
        persona.cod_sexo,
        sexo.des_sexo as DESCRIPCION_LONG_SEXO,
        sexo.DES_ABR as DESCRIPCION_SMALL_SEXO,
        persona.cod_municipio,
        persona.fecha_creacion,
        persona.cod_estado,
        persona.celular,
        usu.COD_USUARIO,
        usu.CLAVE,
        usu.LOGIN,
        VDIR_FN_GET_ROLES_PERSONA(usu.COD_USUARIO) as ROLESS
    FROM
        vdir_persona persona

        INNER JOIN vdir_usuario usu
         ON usu.cod_persona = persona.cod_persona

        LEFT JOIN VDIR_SEXO sexo
         ON sexo.cod_sexo = persona.cod_sexo

        INNER JOIN  VDIR_TIPO_IDENTIFICACION ti
         ON ti.COD_TIPO_IDENTIFICACION =persona.COD_TIPO_IDENTIFICACION

    WHERE
       persona.numero_identificacion = p_identificacion
       AND usu.COD_ESTADO = 1; 

    RETURN vl_cursor;      

    END VDIR_FN_GET_DATOS_PERSONA; 

  ------------------------------------------------------------------------------FUNCION PARA TRAER LOS ROLES QUE TIENE UNA PERSONA 
    FUNCTION VDIR_FN_GET_ROLES_PERSONA(p_cod_user IN vdir_usuario.cod_usuario%TYPE) RETURN VARCHAR2

    IS
    json_datos VARCHAR2(4000);
    BEGIN

      FOR FILA IN (
                     SELECT 
                        ROL.COD_ROL ,
                        ROL.DES_ROL
                      FROM 
                        VDIR_ROL_USUARIO ROL_USER

                        INNER JOIN VDIR_ROL ROL 
                         ON ROL.COD_ROL = ROL_USER.COD_ROL
                      WHERE 
                        ROL_USER.COD_USUARIO = p_cod_user
                        ) LOOP

      JSON_DATOS:= JSON_DATOS ||'{';      
      JSON_DATOS:= JSON_DATOS ||'"CODIGO": "'||FILA.COD_ROL||'",';
      JSON_DATOS:= JSON_DATOS ||'"NOMBRE": "'||FILA.DES_ROL||'"';
      JSON_DATOS:= JSON_DATOS ||'},';

   END LOOP;
    JSON_DATOS:=SUBSTR(JSON_DATOS, 1,LENGTH(JSON_DATOS)-1);
    JSON_DATOS:= JSON_DATOS || ']'; 

    RETURN json_datos; 

    END VDIR_FN_GET_ROLES_PERSONA;


 /*---------------------------------------------------------------------
  fn_splitData: funcion para retornar tabla con los datos de una cadena separados por un caracter
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 02-01-2019
 ----------------------------------------------------------------------- */  
 FUNCTION fn_splitData
 (
    P_STRING_DATA IN VARCHAR2,
    P_SEPARATOR IN VARCHAR2
 )RETURN datasplit_table PIPELINED
 IS
     ltc_datos type_cursor;
     rec datasplit_record;
 BEGIN

    --OPEN ltc_datos FOR
    FOR registro IN  (SELECT level AS IDX, regexp_substr(P_STRING_DATA,'[^'|| P_SEPARATOR ||']+', 1, level) DATO from dual
                    connect by regexp_substr(P_STRING_DATA, '[^'|| P_SEPARATOR ||']+', 1, level) is not null)
    LOOP
        SELECT 
            registro.idx, 
            registro.dato
            INTO rec
        FROM DUAL;

        PIPE ROW(rec);

    END LOOP;

    --RETURN ltc_datos;
    RETURN;

 END fn_splitData;

----------------------------------------------------------------------------  FUNCION PARA TRAER LOS DATOS DE PAGAR EN PAYU 
    FUNCTION VDIR_FN_GET_DATOS_PAGO(p_cod_afiliacion IN vdir_afiliacion.cod_afiliacion%TYPE) 

   RETURN sys_refcursor 
   AS

   vl_cursor sys_refcursor;   

    BEGIN

  OPEN vl_cursor
    FOR 
        SELECT  
            DISTINCT
             factura.cod_factura AS CODIGO_FACTURA,
             factura.total_pagar as AMOUNT,
             COALESCE(persona.nombre_1,' ')||' '|| COALESCE(persona.nombre_2,' ')||' '|| COALESCE(persona.apellido_1,' ')||' '||COALESCE(persona.apellido_2,' ') AS NOMBRE_COMPLETO,
             persona.email AS EMAIL,
             persona.NUMERO_IDENTIFICACION AS NUMERO_IDENTIFICACION,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(27) AS MERCHANTID,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(28) AS ACCOUNTID,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(29) AS DESCRIPTION,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(30) AS CURRENCY,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(31) AS TESTT,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(3) AS BASEURL,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(32) AS APIKEY,
             (SELECT SUM(CANTIDAD) FROM VDIR_FACTURA_DETALLE WHERE COD_FACTURA = factura.COD_FACTURA) AS CANTIDAD,
             pr.DES_PROGRAMA_ABR AS PROGRAMA,
             pl.DES_PLAN_ABR AS TIPO_PLAN,
             VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(58) AS URL_EJECUCION      
        FROM
            vdir_factura factura

            INNER JOIN vdir_contratante_beneficiario cb
             ON cb.cod_afiliacion = factura.cod_afiliacion

            INNER JOIN vdir_beneficiario_programa bp
             ON bp.cod_afiliacion = factura.cod_afiliacion

            INNER JOIN vdir_programa pr
             ON pr.cod_programa = bp.cod_programa

            INNER JOIN vdir_persona persona
             ON persona.cod_persona = cb.cod_contratante

            INNER JOIN  vdir_usuario usu
             ON usu.cod_persona = persona.cod_persona

            INNER JOIN vdir_plan pl
             ON pl.cod_plan = usu.cod_plan            

            INNER JOIN VDIR_PERSONA_TIPOPER ptp
             ON ptp.cod_persona = persona.cod_persona     

            WHERE
              ptp.COD_TIPO_PERSONA = 1
              AND factura.cod_afiliacion = p_cod_afiliacion; 

    RETURN vl_cursor;      

    END VDIR_FN_GET_DATOS_PAGO;

 /*---------------------------------------------------------------------
  fn_getMonthSpainish: funcion para obtener el nombre del un mes en español
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 03-04-2019
 ----------------------------------------------------------------------- */  
 FUNCTION fn_getMonthSpainish
 (
    p_num_mes IN INTEGER
 )RETURN VARCHAR2
 IS
     ltc_mes VARCHAR2(10);
     ltc_cadena_meses VARCHAR(200);
 BEGIN
    --Traer cadena de meses separados pod guin medio (-) 
    ltc_cadena_meses := VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(55);
    --Traer nombre del mes en de acuerdo al parametro entero ingresado
    SELECT
        dato INTO ltc_mes
    FROM
        TABLE(VDIR_PACK_UTILIDADES.fn_splitData(ltc_cadena_meses,'-'))
    WHERE
        idx = p_num_mes;    

    RETURN ltc_mes;

 END fn_getMonthSpainish;

  /*---------------------------------------------------------------------
  fn_getFormatMiles: funcion para obtener el formateo a miles de un numero entero o decimal
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 03-04-2019
 ----------------------------------------------------------------------- */  
 FUNCTION fn_getFormatMiles
 (
    p_numero IN INTEGER,
    p_incluir_decimal IN INTEGER,
    p_prefijo IN CHAR
 )RETURN VARCHAR2
 IS
     lnu_format VARCHAR2(300);
     lnu_tipo_format VARCHAR2(300);
 BEGIN

    IF p_incluir_decimal = 1 THEN
        lnu_format := TRIM(TO_CHAR(p_numero, p_prefijo || '999G999G999G999G999D99'));
    ELSE
        lnu_format := TRIM(TO_CHAR(p_numero, p_prefijo || '999G999G999G999G999'));
    END IF;

    RETURN lnu_format;

 END fn_getFormatMiles;
 
 ----------------------------------------------------------------------------------------------------------
         ----------------VDIR_FN_GET_PROGRAMAS
 ---------------------------------------------------------------------------------------------------------------
 
 FUNCTION VDIR_FN_GET_PROGRAMAS(p_cod_afiliacion  vdir_afiliacion.cod_afiliacion%TYPE) RETURN VARCHAR2
 
 IS 
 
  V_CADENA VARCHAR2(10000);
 
 BEGIN
 
   V_CADENA := '';
 
    FOR FILA IN (SELECT   
                    DISTINCT
                    pr.des_programa as PROGRAMA                    
                 FROM
                    vdir_factura f
                    
                    INNER JOIN vdir_factura_detalle fd
                     ON fd.cod_factura = f.cod_factura
                     
                    INNER JOIN vdir_beneficiario_programa bp
                     ON bp.cod_afiliacion = f.cod_afiliacion                  
                     
                    INNER JOIN  vdir_programa pr
                     ON pr.cod_programa = bp.cod_programa
                     
                 WHERE
                    f.cod_afiliacion = p_cod_afiliacion) LOOP
    
    V_CADENA := V_CADENA||','||FILA.PROGRAMA;
    
    END LOOP;
    
     V_CADENA := SUBSTR(V_CADENA,2,LENGTH(V_CADENA));
  
    RETURN V_CADENA;
 
 END;
 
 ----------------------------------------------------------------------------------------------------------
         ----------------VDIR_FN_GET_DATOS_KIT_BIENV
 ---------------------------------------------------------------------------------------------------------------
 FUNCTION VDIR_FN_GET_DATOS_KIT_BIENV(p_cod_afiliacion  vdir_afiliacion.cod_afiliacion%TYPE) RETURN sys_refcursor
 
 IS
 
 vl_cursor sys_refcursor; 
 
 BEGIN 
  
  OPEN vl_cursor
    FOR
    
        SELECT   
            COALESCE(per.nombre_1,' ')||' '|| COALESCE(per.nombre_2,' ')||' '|| COALESCE(per.apellido_1,' ')||' '||COALESCE(per.apellido_2,' ') AS NOMBRE_COMPLETO,
            per.email as CORREO,
            VDIR_FN_GET_PROGRAMAS(f.cod_afiliacion) as PROGRAMAS,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(59) AS PARAM59,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(60) AS PARAM60,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(61) AS PARAM61,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(62) AS PARAM62,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(63) AS PARAM63,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(64) AS PARAM64,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(65) AS PARAM65,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(66) AS PARAM66,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(67) AS PARAM67,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(68) AS PARAM68,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(69) AS PARAM69,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(70) AS PARAM70,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(71) AS PARAM71,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(72) AS PARAM72,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(73) AS PARAM73,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(74) AS PARAM74,
            VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(75) AS PARAM75
         FROM
            vdir_factura f
            
            INNER JOIN vdir_factura_detalle fd
             ON fd.cod_factura = f.cod_factura
             
            INNER JOIN vdir_contratante_beneficiario cb
             ON cb.cod_afiliacion = f.cod_afiliacion
            
            INNER JOIN vdir_persona per
             ON per.cod_persona = cb.cod_contratante            
             
         WHERE
            f.cod_afiliacion = p_cod_afiliacion;
    
      
 
  RETURN  vl_cursor;
 
 END VDIR_FN_GET_DATOS_KIT_BIENV;
 

END VDIR_PACK_UTILIDADES;
/

create or replace PACKAGE VDIR_PACK_ENCUESTAS AS 

--FUNCION PARA TRAER UNA ENCUESTA DE SARLAF-------------------------------
    FUNCTION VDIR_FN_GET_ENCUESTA_SARLAF(p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE ,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB;

 --FUNCION PARA TRAER UNA LISTA DE MONEDAS
   FUNCTION VDIR_FN_GET_LIST_MONEDA RETURN VARCHAR2;

  --FUNCION PARA TRAER UNA LISTA DE PARENTESCOS
   FUNCTION VDIR_FN_GET_LIST_PARENTESCO RETURN VARCHAR2;

   --PROCEDIMIENTO PARA GUARDAR LA ENCUESTA
   PROCEDURE VDIR_FN_GUARDAR_ENCUESTA(p_codigo_encuesta IN VDIR_ENCUESTA.COD_ENCUESTA%TYPE,p_codigo_pregunta IN VDIR_PREGUNTA.COD_PREGUNTA%TYPE,p_codigo_respuesta IN VDIR_RESPUESTA.COD_RESPUESTA%TYPE,p_cod_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,p_valor_respuesta IN VDIR_RESPUESTAS_MARCADAS.VALOR_RESPUESTA%TYPE,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE,p_respuesta OUT VARCHAR2);

 --FUNCION PARA TRAER LA ENCUESTA SARLAF YA DILIGENCIADA-------------------------------
   FUNCTION VDIR_FN_GET_DATOS_ENCT(p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB;

   --FUNCION PARA TRAER UNA ENCUESTA DE SALUD-------------------------------
    FUNCTION VDIR_FN_GET_ENCUESTA_DE_SALUD(p_edad IN NUMBER,p_sexo IN NUMBER,p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE ,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB; 

    --FUNCION PARA TRAER LA ENCUESTA DE SALUD YA DILIGENCIADA-------------------------------
   FUNCTION VDIR_FN_GET_DATOS_ENCT_SALUD(p_edad IN NUMBER,p_sexo IN NUMBER,p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB;

    -- ---------------------------------------------------------------------
    -- fnGetValidaEncuesta
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaEncuesta
    (
        inu_codAfiliacion IN VDIR_ENCUESTA_PERSONA.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_ENCUESTA_PERSONA.COD_PERSONA%TYPE,
		inu_codEncuesta   IN VDIR_ENCUESTA_PERSONA.COD_ENCUESTA%TYPE
    )
	RETURN NUMBER;

    -- ---------------------------------------------------------------------
    -- VDIR_FN_VALIDA_ENCUESTA_SALUD
    -- ---------------------------------------------------------------------

   FUNCTION VDIR_FN_VALIDA_ENCUESTA_SALUD
   (
        p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE       
    ) 
    RETURN sys_refcursor; 

END VDIR_PACK_ENCUESTAS;

/

create or replace PACKAGE BODY VDIR_PACK_ENCUESTAS AS

 FUNCTION VDIR_FN_GET_LIST_MONEDA RETURN VARCHAR2 AS
 vl_option VARCHAR2(2000);

 BEGIN

    vl_option := ' <option value="-1">Seleccione una moneda</option>'; 

     FOR fila IN (SELECT
                    cod_moneda,
                    des_moneda                    
                  FROM
                        vdir_moneda
                    WHERE
                        cod_estado = 1) LOOP

      vl_option := vl_option||' <option value='||fila.cod_moneda||'>'||fila.des_moneda||'</option>';                 

     END LOOP; 

     RETURN '<select disabled id="moneda" name="moneda" class="form-control lista-vd">'||vl_option||'</select>';


 END VDIR_FN_GET_LIST_MONEDA;

--FUNCION PARA TRAER UNA LISTA DE PARENTESCOS-----------------------------------------------
   FUNCTION VDIR_FN_GET_LIST_PARENTESCO RETURN VARCHAR2 AS 

   vl_option VARCHAR2(2000);

   BEGIN

       vl_option := ' <option value="-1">Seleccione un parentesco</option>'; 

     FOR fila IN (SELECT
                    cod_parentesco,
                    des_parentesco                    
                  FROM
                        vdir_parentesco
                    WHERE
                        cod_estado = 1) LOOP

      vl_option := vl_option||' <option value='||fila.cod_parentesco||'>'||fila.des_parentesco||'</option>';                 

     END LOOP; 

     RETURN '<select disabled id="parentesco" name="parentesco" class="form-control lista-vd">'||vl_option||'</select>';


   END VDIR_FN_GET_LIST_PARENTESCO;

-----------------------------------------------------------------------------

 FUNCTION VDIR_FN_GET_ENCUESTA_SARLAF(p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE ,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB AS
   vl_cadena CLOB;

   vl_form_ini VARCHAR2(100);
   vl_form_fin VARCHAR2(40);   
   vl_row_respuesta CLOB; 
   vl_row_pregunta CLOB; 
   vl_style VARCHAR2(50);
   vl_filset_ini VARCHAR2(50);
   vl_filset_fin VARCHAR2(50);
   vl_legend VARCHAR2(50);
   vl_cod_modulo NUMBER;   
   vl_filset_all CLOB;
   vl_nombre_ant_modulo VARCHAR2(100);
   vl_value_check VARCHAR2(5);
   vl_existe_encuesta NUMBER;
   lnu_index NUMBER(12) := 0;
   lnu_index_resp NUMBER(12) := 0;   

  BEGIN

     SELECT 
        COUNT(EP.COD_ENCUESTA_PERSONA) INTO vl_existe_encuesta
      FROM 
        VDIR_ENCUESTA_PERSONA EP

        INNER JOIN VDIR_PERSONA P
         ON P.COD_PERSONA = EP.COD_PERSONA    

        INNER JOIN VDIR_PERSONA_TIPOPER TIPOP
         ON TIPOP.COD_PERSONA = P.COD_PERSONA

      WHERE
        EP.COD_AFILIACION = p_codigo_afiliacion
        AND EP.COD_PERSONA = p_codigo_persona
        AND TIPOP.COD_TIPO_PERSONA = 1
		AND EP.COD_ENCUESTA = 1;        

  IF vl_existe_encuesta = 0 THEN

      vl_form_ini := '<div class="container" id="form_div" name="form_div">';
      vl_form_fin := '</div>';
      vl_filset_ini := '<fieldset class="fieldset-vd">';
      vl_filset_fin := '</fieldset>';
      vl_filset_all := '';      
      vl_cod_modulo := 0;
      vl_nombre_ant_modulo := '';

       FOR fila IN (SELECT
                        preg.cod_pregunta,
                        preg.des_pregunta,
                        modu.des_modulo,
                        modu.cod_modulo
                    FROM
                        vdir_pregunta preg

                        INNER JOIN vdir_modulo_encuesta modu
                         ON modu.cod_modulo = preg.cod_modulo
                    WHERE
                       preg.cod_encuesta = 1 ORDER BY preg.cod_modulo, preg.numero_pregunta)  LOOP 
         vl_row_respuesta := '';
         vl_style := '';         
          FOR fila2 IN(SELECT
                            cod_respuesta,
                            des_respuesta,
                            puntuacion

                        FROM
                            vdir_respuesta
                        WHERE
                           cod_pregunta = fila.cod_pregunta  ORDER BY numero_respuesta) 
        LOOP
                IF fila2.cod_respuesta NOT IN(25,26,27,30,31,32,33,36,37,38,41,42,43,46,47,48,49,50,51) THEN  
                    vl_value_check := '0';                   
                    
                  IF(fila2.des_respuesta = 'SI') THEN
                    vl_value_check := '1';                 
                  END IF;
                  
                  IF fila2.cod_respuesta IN(19,20,21,22,23,24) THEN
                  
                        vl_row_respuesta := vl_row_respuesta || '                        
                                                               <div class="form-check div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">
                                                                    <label class="form-check-label">
                                                                      <input class="form-check-input" type="checkbox" value="'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" name="radio_respuesta_n_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" id="radio_respuesta_n_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" > '||fila2.des_respuesta||'
                                                                      <span class="form-check-sign">
                                                                        <span class="check"></span>
                                                                      </span>
                                                                    </label>
                                                                </div>
                                                            ';                  
                  
                  ELSE
                        vl_row_respuesta := vl_row_respuesta || '
                                                                <div class="form-check div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">                                                 
                                                                    <label class="radio-inline form-check-label">
                                                                      <input class="form-check-input"  type="radio" name="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" id="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" value="'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"> '||fila2.des_respuesta||'
                                                                       <span class="circle">
                                                                        <span class="check"></span>
                                                                      </span>
                                                                    </label>
                                                                </div>
                                                            ';
                 END IF;
                 
                 ELSIF fila2.cod_respuesta = 33 THEN
                      vl_row_respuesta := vl_row_respuesta || '<div class="col-lg-6 div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">' ||fila2.des_respuesta||VDIR_PACK_ENCUESTAS.VDIR_FN_GET_LIST_MONEDA||'</div>';                      
                 ELSIF fila2.cod_respuesta = 48 THEN
                     vl_row_respuesta := vl_row_respuesta || '<div class="col-lg-12 div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">' || fila2.des_respuesta||VDIR_PACK_ENCUESTAS.VDIR_FN_GET_LIST_PARENTESCO||'</div> <br>'; 
                 ELSE   
                     IF lnu_index_resp = 0 THEN
					    vl_row_respuesta := vl_row_respuesta || '<div class="row">';
					END IF;				 
                   vl_row_respuesta := vl_row_respuesta || '<div class="col-lg-6 div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">' ||fila2.des_respuesta||'</div>';
                   lnu_index_resp := lnu_index_resp + 1;
				 END IF;
          END LOOP; 
		  IF lnu_index_resp <> 0 THEN
		     vl_row_respuesta := vl_row_respuesta || '</div>';
		  END IF;
		  lnu_index_resp := 0;

          IF vl_cod_modulo <> fila.cod_modulo AND vl_cod_modulo > 0 THEN
            -- vl_cod_modulo := fila.cod_modulo;           
             vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
             vl_row_pregunta := '';
			 lnu_index := 0;
          END IF;

          vl_cod_modulo := fila.cod_modulo; 
          vl_nombre_ant_modulo := fila.des_modulo;

			IF lnu_index = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '<div class="row">'; 

            ELSIF MOD(lnu_index,3) = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '</div><div class="row">';  

			END IF;

          /*IF fila.cod_pregunta = 7  THEN          
                vl_style := 'style="display:none"';
          END IF;         


            vl_row_pregunta := vl_row_pregunta || '<div class="row">
                                                       <div '||vl_style||' class="col-lg-12 col-md-12 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">
                                                         <div class="title">
                                                                <h4 class="obligatorio">'||fila.des_pregunta||'</h4>
                                                         </div>                                                         
                                                           '||vl_row_respuesta||'
                                                        </div>
                                                    </div>'; */

           IF fila.cod_pregunta = 6 OR fila.cod_pregunta = 34 OR fila.cod_pregunta = 35 OR fila.cod_pregunta = 36 THEN

			    vl_row_pregunta := vl_row_pregunta || '<div class="col-lg-6 col-md-6 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">';

			ELSIF (fila.cod_pregunta = 38 OR fila.cod_pregunta = 37) THEN

			    vl_row_pregunta := vl_row_pregunta || '<div class="col-lg-12 col-md-12 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">';
			ELSE 

			    vl_row_pregunta := vl_row_pregunta || '<div class="col-lg-4 col-md-4 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">';
			END IF;
            vl_row_pregunta := vl_row_pregunta || '<div class="" style="min-height: 36px;">
														<p class="obligatorio text-muted text-justify"><strong>'||fila.des_pregunta||'</strong></p>
													 </div>                                                         
													   '||vl_row_respuesta||'
													</div>';          

            lnu_index := lnu_index + 1;

      END LOOP;
    IF vl_row_pregunta IS NOT NULL AND vl_row_pregunta <> ' ' THEN
        vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
        lnu_index := 0;
	END IF;

     vl_cadena :=  vl_form_ini||vl_filset_all||vl_form_fin;
  ELSE 
     vl_cadena := VDIR_FN_GET_DATOS_ENCT(p_codigo_afiliacion,p_codigo_persona);
  END IF;

    RETURN vl_cadena;
  END VDIR_FN_GET_ENCUESTA_SARLAF;

  ---------------------------------------------------------GUARDAR ENCUESTA

  --PROCEDIMIENTO PARA GUARDAR LA ENCUESTA
    PROCEDURE VDIR_FN_GUARDAR_ENCUESTA(p_codigo_encuesta IN VDIR_ENCUESTA.COD_ENCUESTA%TYPE,p_codigo_pregunta IN VDIR_PREGUNTA.COD_PREGUNTA%TYPE,p_codigo_respuesta IN VDIR_RESPUESTA.COD_RESPUESTA%TYPE,p_cod_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,p_valor_respuesta IN VDIR_RESPUESTAS_MARCADAS.VALOR_RESPUESTA%TYPE,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE,p_respuesta OUT VARCHAR2)

   AS
   vl_cod_encuesta_afiliacion vdir_encuesta_persona.cod_encuesta_persona%TYPE;

   BEGIN 

   p_respuesta := 'Operaci&oacute;n realizada correctamente.';

   BEGIN 
    SELECT
        cod_encuesta_persona INTO  vl_cod_encuesta_afiliacion      
    FROM
        vdir_encuesta_persona
    WHERE 
       cod_encuesta = p_codigo_encuesta
       AND cod_afiliacion = p_cod_afiliacion
       AND cod_persona = p_codigo_persona;
   EXCEPTION WHEN OTHERS THEN
      vl_cod_encuesta_afiliacion := NULL;
   END;

   IF vl_cod_encuesta_afiliacion IS NULL THEN

        SELECT VDIR_SEQ_AFILIACION_ENCUESTA.NEXTVAL INTO vl_cod_encuesta_afiliacion  FROM DUAL;

        INSERT INTO vdir_encuesta_persona (
            cod_encuesta_persona,
            cod_afiliacion,
            cod_encuesta,
            cod_persona
        ) VALUES (
            vl_cod_encuesta_afiliacion,
            p_cod_afiliacion,
            p_codigo_encuesta,
            p_codigo_persona
        );

    END IF;

   MERGE INTO vdir_respuestas_marcadas resmar
   USING (
           SELECT
            vl_cod_encuesta_afiliacion AS cod_encuesta_afiliacion,
            p_codigo_pregunta  AS codigo_pregunta,
            p_codigo_respuesta  AS codigo_respuesta
          FROM
             DUAL   
      ) resmar2
   ON (resmar.cod_encuesta_persona = resmar2.cod_encuesta_afiliacion AND resmar.cod_pregunta = resmar2.codigo_pregunta AND resmar.cod_respuesta = resmar2.codigo_respuesta)   
   WHEN NOT MATCHED THEN 

    INSERT (
        cod_respuestas_marcadas,
        cod_encuesta_persona,
        cod_pregunta,
        cod_respuesta,
        valor_respuesta
    ) VALUES (
        VDIR_SEQ_RESPUESTAS_MARCADAS.NEXTVAL,
        vl_cod_encuesta_afiliacion,
        p_codigo_pregunta,
        p_codigo_respuesta,
        p_valor_respuesta
    );

    --COMMIT --El comit se hace en el php;

  EXCEPTION 
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, 'error al guardar la encuesta.');
    p_respuesta := '-1';
  ROLLBACK;


   END VDIR_FN_GUARDAR_ENCUESTA;

   --FUNCION PARA TRAER LA ENCUESTA SARLAF YA DILIGENCIADA-------------------------------
   FUNCTION VDIR_FN_GET_DATOS_ENCT(p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB

   AS
    vl_cadena CLOB;

    vl_form_ini VARCHAR2(100);
    vl_form_fin VARCHAR2(40);   
    vl_row_respuesta CLOB; 
    vl_row_pregunta CLOB; 
    vl_style VARCHAR2(50);
    vl_filset_ini VARCHAR2(50);
    vl_filset_fin VARCHAR2(50);
    vl_legend VARCHAR2(50);
    vl_cod_modulo NUMBER;    
    vl_filset_all CLOB;
    vl_nombre_ant_modulo VARCHAR2(100);
    vl_checked VARCHAR2(100);
    vl_value_check VARCHAR2(5);
	lnu_index NUMBER(12) := 0;
	lnu_index_resp NUMBER(12) := 0;
    vl_hide_pregunta VARCHAR2(20);

   BEGIN

      vl_form_ini := '<div class="container" id="form_div" name="form_div">';
      vl_form_fin := '</div>';
      vl_filset_ini := '<fieldset class="fieldset-vd">';
      vl_filset_fin := '</fieldset>';
      vl_filset_all := '';      
      vl_cod_modulo := 0;
      vl_nombre_ant_modulo := '';
      vl_checked := '';
      vl_hide_pregunta := '';

       FOR fila IN (SELECT                       
                        preg.cod_pregunta,
                        preg.des_pregunta,
                        modu.des_modulo,
                        modu.cod_modulo
                    FROM
                        vdir_pregunta preg                        

                        INNER JOIN vdir_modulo_encuesta modu
                         ON modu.cod_modulo = preg.cod_modulo                        

                    WHERE
                       preg.cod_encuesta = 1 ORDER BY preg.cod_modulo, preg.numero_pregunta)  LOOP 
         vl_row_respuesta := '';                
          FOR fila2 IN(SELECT

                            re.cod_respuesta,
                            re.des_respuesta,
                            re.puntuacion,
                            (SELECT  
                              (CASE WHEN rm.cod_respuesta IS NOT NULL THEN 'checked' ELSE ' ' END)                          
                               FROM
                                 vdir_respuestas_marcadas rm 

                                 INNER JOIN vdir_encuesta_persona afe
                                  ON afe.COD_ENCUESTA_PERSONA = rm.COD_ENCUESTA_PERSONA

                                 INNER JOIN  vdir_persona_tipoper per
                                  ON per.cod_persona = afe.cod_persona

                                 WHERE
                                   rm.cod_respuesta = re.cod_respuesta
                                   AND afe.COD_AFILIACION = p_codigo_afiliacion
                                   AND rm.cod_pregunta = fila.cod_pregunta
                                   AND afe.cod_persona = p_codigo_persona
                                   AND per.cod_tipo_persona = 1) AS checked,
                            (SELECT  
                               rm.valor_respuesta                      
                               FROM
                                 vdir_respuestas_marcadas rm 

                                 INNER JOIN vdir_encuesta_persona afe
                                  ON afe.COD_ENCUESTA_PERSONA = rm.COD_ENCUESTA_PERSONA

                                 INNER JOIN  vdir_persona_tipoper per
                                  ON per.cod_persona = afe.cod_persona 

                                 WHERE
                                   rm.cod_respuesta = re.cod_respuesta
                                   AND afe.COD_AFILIACION = p_codigo_afiliacion
                                   AND rm.cod_pregunta = fila.cod_pregunta
                                   AND afe.cod_persona = p_codigo_persona
                                   AND per.cod_tipo_persona = 1) AS val_respuesta       


                        FROM
                            vdir_respuesta re                             

                        WHERE
                           re.cod_pregunta = fila.cod_pregunta  ORDER BY re.numero_respuesta) 
        LOOP       
                 
             /*IF fila2.cod_respuesta = 18 AND fila2.val_respuesta = 'NO' THEN  
                vl_hide_pregunta := 'style=''display:none''';
             END IF;*/
                 
                IF fila2.cod_respuesta NOT IN(25,26,27,30,31,32,33,36,37,38,41,42,43,46,47,48,49,50,51) THEN 
                    vl_value_check := '0';
                  IF(fila2.des_respuesta = 'SI') THEN
                    vl_value_check := '1';                 
                  END IF;
                  
                   IF fila2.cod_respuesta IN(19,20,21,22,23,24) THEN
                  
                        vl_row_respuesta := vl_row_respuesta || '                        
                                                               <div class="form-check div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">
                                                                    <label class="form-check-label">
                                                                      <input disabled class="form-check-input" '||fila2.checked||' type="checkbox" value="'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" name="radio_respuesta_n_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" id="radio_respuesta_n_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" > '||fila2.des_respuesta||'
                                                                      <span class="form-check-sign">
                                                                        <span class="check"></span>
                                                                      </span>
                                                                    </label>
                                                                </div>
                                                            ';                  
                  
                  ELSE
                        vl_row_respuesta := vl_row_respuesta || '
                                                                <div class="form-check form-check-inline div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">                                                 
                                                                    <label class="radio-inline form-check-label">
                                                                      <input disabled class="form-check-input" '||fila2.checked||' type="radio" name="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" id="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" value="'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"> '||fila2.des_respuesta||'
                                                                       <span class="circle">
                                                                        <span class="check"></span>
                                                                      </span>
                                                                    </label>
                                                                </div>
                                                            ';
                  END IF;
                  
                   /*vl_row_respuesta := vl_row_respuesta || '
                                                                <div class="form-check form-check-inline div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">                                                 
                                                                    <label class="radio-inline form-check-label">
                                                                      <input disabled class="form-check-input" '||fila2.checked||' type="radio" name="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" id="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" value="'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"> '||fila2.des_respuesta||'
                                                                       <span class="circle">
                                                                        <span class="check"></span>
                                                                      </span>
                                                                    </label>
                                                                </div>
                                                            ';*/
                 ELSIF fila2.cod_respuesta = 33 THEN
                      vl_row_respuesta := vl_row_respuesta || '<div class="col-lg-6 div_container_respuesta" data-val_respuesta = "'||fila2.val_respuesta||'" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">' ||fila2.des_respuesta||VDIR_PACK_ENCUESTAS.VDIR_FN_GET_LIST_MONEDA||'</div>';                      
                 ELSIF fila2.cod_respuesta = 48 THEN
                     vl_row_respuesta := vl_row_respuesta || '<div class="col-lg-12 div_container_respuesta" data-val_respuesta = "'||fila2.val_respuesta||'" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">' || fila2.des_respuesta||VDIR_PACK_ENCUESTAS.VDIR_FN_GET_LIST_PARENTESCO||'</div> <br>'; 
                 ELSIF fila2.cod_respuesta = 49 OR fila2.cod_respuesta = 50 OR fila2.cod_respuesta = 27 OR fila2.cod_respuesta = 25 OR fila2.cod_respuesta = 26 THEN
                     vl_row_respuesta := vl_row_respuesta || '<div class="col-lg-12 div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" data-val_respuesta = "'||fila2.val_respuesta||'">' ||fila2.des_respuesta||'</div>';                
				 ELSE 
                    IF lnu_index_resp = 0 THEN
					    vl_row_respuesta := vl_row_respuesta || '<div class="row">';
					END IF;
                   vl_row_respuesta := vl_row_respuesta || '<div class="col-lg-6 div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" data-val_respuesta = "'||fila2.val_respuesta||'">' ||fila2.des_respuesta||'</div>';
                    lnu_index_resp := lnu_index_resp + 1;
				END IF;
          END LOOP;
		  IF lnu_index_resp <> 0 THEN
		     vl_row_respuesta := vl_row_respuesta || '</div>';
		  END IF;
		  lnu_index_resp := 0;

          IF vl_cod_modulo <> fila.cod_modulo AND vl_cod_modulo > 0 THEN                      
             vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
             vl_row_pregunta := '';
			 lnu_index := 0;
          END IF;

          vl_cod_modulo := fila.cod_modulo; 
          vl_nombre_ant_modulo := fila.des_modulo;        

            IF lnu_index = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '<div class="row">'; 

            ELSIF MOD(lnu_index,3) = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '</div><div class="row">';  

			END IF;

			IF fila.cod_pregunta = 6 OR fila.cod_pregunta = 34 OR fila.cod_pregunta = 35 OR fila.cod_pregunta = 36 THEN

			    vl_row_pregunta := vl_row_pregunta || '<div  class="col-lg-6 col-md-6 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">';

			ELSIF (fila.cod_pregunta = 38 OR fila.cod_pregunta = 37) THEN

			    vl_row_pregunta := vl_row_pregunta || '<div class="col-lg-12 col-md-12 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">';
			
            --ELSIF (fila.cod_pregunta = 7) THEN
                --vl_row_pregunta := vl_row_pregunta || '<div '||vl_hide_pregunta||' class="col-lg-4 col-md-4 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">';                
            ELSE 
               vl_row_pregunta := vl_row_pregunta || '<div class="col-lg-4 col-md-4 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">';
			END IF;
            vl_row_pregunta := vl_row_pregunta || '<div class="" style="min-height: 36px;">
														<p class="obligatorio text-muted text-justify"><strong>'||fila.des_pregunta||'</strong></p>
													 </div>                                                         
													   '||vl_row_respuesta||'
													</div>';          

            lnu_index := lnu_index + 1;
      END LOOP;
    IF vl_row_pregunta IS NOT NULL AND vl_row_pregunta <> ' ' THEN
        vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
		lnu_index := 0;
    END IF;      

     vl_cadena :=  vl_form_ini||vl_filset_all||vl_form_fin;


    RETURN vl_cadena;


   END VDIR_FN_GET_DATOS_ENCT;

   -------------------------------FUNCION PARA  PINTAR LA ENCUESTA DE SALUD

 FUNCTION VDIR_FN_GET_ENCUESTA_DE_SALUD(p_edad IN NUMBER,p_sexo IN NUMBER,p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE ,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB AS
   vl_cadena CLOB;

   vl_form_ini VARCHAR2(100);
   vl_form_fin VARCHAR2(40);   
   vl_row_respuesta CLOB; 
   vl_row_pregunta CLOB; 
   vl_style VARCHAR2(50);
   vl_filset_ini VARCHAR2(50);
   vl_filset_fin VARCHAR2(50);
   vl_legend VARCHAR2(50);
   vl_cod_modulo NUMBER;   
   vl_filset_all CLOB;
   vl_nombre_ant_modulo VARCHAR2(100);
   vl_value_check VARCHAR2(4);
   vl_existe_encuesta NUMBER;
   lnu_index NUMBER(12) := 0;

  BEGIN      

      SELECT 
        COUNT(EP.COD_ENCUESTA_PERSONA) INTO vl_existe_encuesta
      FROM 
        VDIR_ENCUESTA_PERSONA EP

        INNER JOIN VDIR_PERSONA P
         ON P.COD_PERSONA = EP.COD_PERSONA    

        INNER JOIN VDIR_PERSONA_TIPOPER TIPOP
         ON TIPOP.COD_PERSONA = P.COD_PERSONA

      WHERE
        EP.COD_AFILIACION = p_codigo_afiliacion
        AND EP.COD_PERSONA = p_codigo_persona
        AND TIPOP.COD_TIPO_PERSONA = 2
		AND EP.COD_ENCUESTA = 2;

  IF  vl_existe_encuesta = 0 THEN

      vl_form_ini := '<div class="container" id="form_div_salud" name="form_div_salud">';
      vl_form_fin := '</div>';
      vl_filset_ini := '<fieldset class="fieldset-vd">';
      vl_filset_fin := '</fieldset>';
      vl_filset_all := '';      
      vl_cod_modulo := 0;
      vl_nombre_ant_modulo := '';

       FOR fila IN (SELECT
                        preg.cod_pregunta,
                        preg.des_pregunta,
                        modu.des_modulo,
                        modu.cod_modulo
                    FROM
                        vdir_pregunta preg

                        INNER JOIN vdir_modulo_encuesta modu
                         ON modu.cod_modulo = preg.cod_modulo
                    WHERE
                       preg.cod_encuesta = 2 ORDER BY preg.cod_modulo, preg.numero_pregunta)  LOOP 
         vl_row_respuesta := '';
         vl_style := '';         

         IF fila.cod_pregunta = 10 THEN
               vl_style := 'style="display:none"';
          END IF;

          IF fila.cod_pregunta IN(8,9) AND p_sexo = 1  THEN          
                vl_style := 'style="display:none"';              
          END IF;   

          IF fila.cod_pregunta IN(29,30) AND p_edad > 6  THEN          
                vl_style := 'style="display:none"';              
          END IF;  
          FOR fila2 IN(SELECT
                            cod_respuesta,
                            des_respuesta,
                            puntuacion

                        FROM
                            vdir_respuesta
                        WHERE
                           cod_pregunta = fila.cod_pregunta  ORDER BY numero_respuesta) 
        LOOP

                IF fila2.cod_respuesta IN(52,53,55,56,57,58,59,61,62,64,65,67,68,70,71,73,74,76,77,79,80,82,83,85,86,88,89,91,92,94,95,97,98,100,101,103,104,106,107,109,110,112,113,115,116,120,121,123,124,125,126,127,128,129,130) THEN
                  vl_value_check := '0';
                  IF(fila2.des_respuesta = 'SI') THEN
                    vl_value_check := '1';                 
                  END IF;
                   vl_row_respuesta := vl_row_respuesta || '
                                                                <div class="form-check form-check-inline div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">                                                 
                                                                    <label class="radio-inline form-check-label">
                                                                      <input class="form-check-input"  type="radio" name="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" id="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-value="'||vl_value_check||'" value="'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"> '||fila2.des_respuesta||'
                                                                       <span class="circle">
                                                                        <span class="check"></span>
                                                                      </span>
                                                                    </label>
                                                                </div>
                                                            ';
                 ELSIF fila2.cod_respuesta IN(118,119) THEN
                   vl_row_respuesta := vl_row_respuesta || '<div class="div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"><input type="text" id="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" name="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" class="form-control campo-vd col-sm-9" maxlength="4"></div>';
                 ELSE               
                   vl_row_respuesta := vl_row_respuesta || '<div class="div_container_respuesta d-none"  data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"><label>Especificar</label><input type="text" id="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" name="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" class="form-control campo-vd col-sm-9" maxlength="400"></div>';                
                 END IF;
          END LOOP; 

          IF vl_cod_modulo <> fila.cod_modulo AND vl_cod_modulo > 0 THEN
            -- vl_cod_modulo := fila.cod_modulo;           
             vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
             vl_row_pregunta := '';
			 lnu_index := 0;
          END IF;

          vl_cod_modulo := fila.cod_modulo; 
          vl_nombre_ant_modulo := fila.des_modulo; 

            IF lnu_index = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '<div class="row">'; 

            ELSIF MOD(lnu_index,2) = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '</div><div class="row">';  

			END IF;
            vl_row_pregunta := vl_row_pregunta || '<div '||vl_style||' class=" col-lg-6 col-md-6 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">
                                                        <div class="" style="min-height: 60px;">
                                                                <p class="obligatorio text-muted text-justify">'||fila.des_pregunta||'</p>
                                                         </div>                                                         
                                                           '||vl_row_respuesta||'
                                                        </div>'; 

            lnu_index := lnu_index + 1;

      END LOOP;
    IF vl_row_pregunta IS NOT NULL AND vl_row_pregunta <> ' ' THEN
        vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
		lnu_index := 0;
    END IF;

     --vl_cadena :=  vl_form_ini||vl_row_pregunta||vl_form_fin;
     vl_cadena :=  vl_form_ini||vl_filset_all||vl_form_fin;

   ELSE
    vl_cadena := VDIR_FN_GET_DATOS_ENCT_SALUD(p_edad,p_sexo,p_codigo_afiliacion,p_codigo_persona);
   END IF;

    RETURN vl_cadena;
  END VDIR_FN_GET_ENCUESTA_DE_SALUD;

  --FUNCION PARA TRAER LA ENCUESTA DE SALUD YA DILIGENCIADA-------------------------------
   FUNCTION VDIR_FN_GET_DATOS_ENCT_SALUD(p_edad IN NUMBER,p_sexo IN NUMBER,p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE,p_codigo_persona IN VDIR_PERSONA.COD_PERSONA%TYPE) RETURN CLOB

   AS
    vl_cadena CLOB;

    vl_form_ini VARCHAR2(100);
    vl_form_fin VARCHAR2(40);   
    vl_row_respuesta CLOB; 
    vl_row_pregunta CLOB; 
    vl_style VARCHAR2(50);
    vl_filset_ini VARCHAR2(50);
    vl_filset_fin VARCHAR2(50);
    vl_legend VARCHAR2(50);
    vl_cod_modulo NUMBER;    
    vl_filset_all CLOB;
    vl_nombre_ant_modulo VARCHAR2(100);
    vl_checked VARCHAR2(100);
    vl_value_check VARCHAR2(5);
	lnu_index NUMBER(12) := 0;
    vl_style_preg_10 VARCHAR2(50);

   BEGIN

      vl_form_ini := '<div class="container" id="form_div_salud" name="form_div_salud">';
      vl_form_fin := '</div>';
      vl_filset_ini := '<fieldset class="fieldset-vd">';
      vl_filset_fin := '</fieldset>';
      vl_filset_all := '';      
      vl_cod_modulo := 0;
      vl_nombre_ant_modulo := '';
      vl_checked := '';

       FOR fila IN (SELECT                       
                        preg.cod_pregunta,
                        preg.des_pregunta,
                        modu.des_modulo,
                        modu.cod_modulo
                    FROM
                        vdir_pregunta preg                        

                        INNER JOIN vdir_modulo_encuesta modu
                         ON modu.cod_modulo = preg.cod_modulo                        

                    WHERE
                       preg.cod_encuesta = 2 ORDER BY preg.cod_modulo, preg.numero_pregunta)  LOOP 
         vl_row_respuesta := ''; 
          vl_style := ''; 

          IF fila.cod_pregunta IN(8,9,10) AND p_sexo = 1  THEN          
                vl_style := 'style="display:none"';              
          END IF;   

          IF fila.cod_pregunta IN(29,30) AND p_edad > 6  THEN          
                vl_style := 'style="display:none"';              
          END IF;  

          FOR fila2 IN(SELECT

                            re.cod_respuesta,
                            re.des_respuesta,
                            re.puntuacion,
                            (SELECT  
                              (CASE WHEN rm.cod_respuesta IS NOT NULL THEN 'checked' ELSE ' ' END)                          
                               FROM
                                 vdir_respuestas_marcadas rm 

                                 INNER JOIN vdir_encuesta_persona afe
                                  ON afe.COD_ENCUESTA_PERSONA = rm.COD_ENCUESTA_PERSONA

                                 INNER JOIN  vdir_persona_tipoper per
                                  ON per.cod_persona = afe.cod_persona 

                                 WHERE
                                   rm.cod_respuesta = re.cod_respuesta
                                   AND afe.COD_AFILIACION = p_codigo_afiliacion
                                   AND rm.cod_pregunta = fila.cod_pregunta
                                   AND afe.cod_persona = p_codigo_persona
                                   AND per.cod_tipo_persona = 2) AS checked,
                            (SELECT  
                               rm.valor_respuesta                      
                               FROM
                                 vdir_respuestas_marcadas rm 

                                 INNER JOIN vdir_encuesta_persona afe
                                  ON afe.COD_ENCUESTA_PERSONA = rm.COD_ENCUESTA_PERSONA

                                 INNER JOIN  vdir_persona_tipoper per
                                  ON per.cod_persona = afe.cod_persona 

                                 WHERE
                                   rm.cod_respuesta = re.cod_respuesta
                                   AND afe.COD_AFILIACION = p_codigo_afiliacion
                                   AND rm.cod_pregunta = fila.cod_pregunta
                                   AND afe.cod_persona = p_codigo_persona
                                   AND per.cod_tipo_persona = 2) AS val_respuesta       


                        FROM
                            vdir_respuesta re                             

                        WHERE
                           re.cod_pregunta = fila.cod_pregunta  ORDER BY re.numero_respuesta) 
        LOOP       


                IF fila2.cod_respuesta IN(52,53,55,56,57,58,59,61,62,64,65,67,68,70,71,73,74,76,77,79,80,82,83,85,86,88,89,91,92,94,95,97,98,100,101,103,104,106,107,109,110,112,113,115,116,120,121,123,124,125,126,127,128,129,130) THEN
                    vl_value_check := '0';
                  IF(fila2.des_respuesta = 'SI') THEN
                    vl_value_check := '1';                 
                  END IF;

                  IF  fila.cod_pregunta = 9 AND fila2.cod_respuesta = 55 THEN
                      vl_style_preg_10 := 'SI';
                  END IF;

                   vl_row_respuesta := vl_row_respuesta || '
                                                                <div class="form-check form-check-inline div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'">                                                 
                                                                    <label class="radio-inline form-check-label">                                                                     
                                                                      <input disabled class="form-check-input" '||fila2.checked||' type="radio" name="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" id="radio_respuesta_n_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-value="'||vl_value_check||'" value="'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"> '||fila2.des_respuesta||' 
                                                                       <span class="circle">
                                                                        <span class="check"></span>
                                                                      </span>
                                                                    </label>
                                                                </div>
                                                            ';
                ELSIF fila2.cod_respuesta IN(118,119) THEN
                   vl_row_respuesta := vl_row_respuesta || '<div class="div_container_respuesta" data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"><input type="text" id="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" name="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" value="'||fila2.val_respuesta||'" class="form-control campo-vd col-sm-9" maxlength="4"></div>';
                 ELSE               
                   vl_row_respuesta := vl_row_respuesta || '<div class="div_container_respuesta d-none"  data-respuesta = "'||CAST(fila2.cod_respuesta AS VARCHAR2)||'"><label>Especificar</label><input type="text" id="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" name="inp_'||CAST(fila2.cod_respuesta AS VARCHAR2)||'" value="'||fila2.val_respuesta||'" class="form-control campo-vd col-sm-9" maxlength="400"></div>';                
                 END IF;
          END LOOP;  

          IF vl_cod_modulo <> fila.cod_modulo AND vl_cod_modulo > 0 THEN                      
             vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
             vl_row_pregunta := '';
			 lnu_index := 0;
          END IF;

          vl_cod_modulo := fila.cod_modulo; 
          vl_nombre_ant_modulo := fila.des_modulo;        

            IF lnu_index = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '<div class="row">'; 

            ELSIF MOD(lnu_index,2) = 0 THEN

			    vl_row_pregunta := vl_row_pregunta || '</div><div class="row">';  

			END IF;

             IF fila.cod_pregunta = 10 AND vl_style_preg_10 = 'SI' AND p_sexo = 2 THEN
                  vl_style := 'style="display:inline"';
             END IF;
            vl_row_pregunta := vl_row_pregunta || '<div '||vl_style||' class="col-lg-6 col-md-6 col-sm-12 div_container_pregunta" id="pregunta_'||CAST(fila.cod_pregunta AS VARCHAR2)||'" data-pregunta = "'||CAST(fila.cod_pregunta AS VARCHAR2)||'">
                                                         <div class="" style="min-height: 60px;">
                                                                <p class="obligatorio text-muted text-justify">'||fila.des_pregunta||'</p>
                                                         </div>                                                         
                                                           '||vl_row_respuesta||'
                                                        </div>';          

            lnu_index := lnu_index + 1;
      END LOOP;
    IF vl_row_pregunta IS NOT NULL AND vl_row_pregunta <> ' ' THEN
        vl_filset_all := vl_filset_all || vl_filset_ini||'<legend class="legend-vd">'||vl_nombre_ant_modulo||'</legend>'||vl_row_pregunta||vl_filset_fin;
		lnu_index := 0;
    END IF;      

     vl_cadena :=  vl_form_ini||vl_filset_all||vl_form_fin;


    RETURN vl_cadena;


   END VDIR_FN_GET_DATOS_ENCT_SALUD;

	-- ---------------------------------------------------------------------
    -- fnGetValidaEncuesta
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaEncuesta
    (
        inu_codAfiliacion IN VDIR_ENCUESTA_PERSONA.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_ENCUESTA_PERSONA.COD_PERSONA%TYPE,
		inu_codEncuesta   IN VDIR_ENCUESTA_PERSONA.COD_ENCUESTA%TYPE
    )
	RETURN NUMBER IS

	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_ENCUESTAS
	 Caso de Uso : 
	 Descripción : Retorna 1 = Si / 0 = No si la persona lleno la encuesta
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 15-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 inu_codAfiliacion       Código de la afiliación
	 inu_codPersona          Código de la persona contratante / beneficiario
	 inu_codEncuesta         Código de la encuesta
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */

	    CURSOR cu_valida_encuesta IS
		SELECT COUNT(1)
		  FROM VDIR_ENCUESTA_PERSONA
	     WHERE COD_AFILIACION = inu_codAfiliacion
		   AND COD_PERSONA    = inu_codPersona
		   AND COD_ENCUESTA   = inu_codEncuesta;

		lnu_validaEncuesta NUMBER(1) := 0;

	BEGIN

		 OPEN cu_valida_encuesta; 
		FETCH cu_valida_encuesta INTO lnu_validaEncuesta; 
		CLOSE cu_valida_encuesta;

		RETURN lnu_validaEncuesta;

	END fnGetValidaEncuesta;


    -- ---------------------------------------------------------------------
    -- VDIR_FN_VALIDA_ENCUESTA_SALUD
    -- ---------------------------------------------------------------------
    FUNCTION VDIR_FN_VALIDA_ENCUESTA_SALUD
    (
        p_codigo_afiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE        
    )
	RETURN sys_refcursor 
    AS

    vl_retorno VARCHAR2(500);
    vl_cursor sys_refcursor; 

	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_ENCUESTAS
	 Caso de Uso : 
	 Descripción : Retorna -1 = No / el nombre del beneficiario
	 ----------------------------------------------------------------------
	 Autor : ever.orlando.hidalgo@kalettre.com
	 Fecha : 18-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 p_codigo_afiliacion       Código de la afiliación		 
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
    BEGIN 
      OPEN vl_cursor
       FOR        
           SELECT DISTINCT
              COALESCE(persona.nombre_1,' ')||' '|| COALESCE(persona.nombre_2,' ')||' '|| COALESCE(persona.apellido_1,' ')||' '||COALESCE(persona.apellido_2,' ') AS BENEFICIARIO                                   
           FROM
             vdir_respuestas_marcadas rm 

             INNER JOIN vdir_encuesta_persona afe
              ON afe.COD_ENCUESTA_PERSONA = rm.COD_ENCUESTA_PERSONA

             INNER JOIN vdir_persona persona
              ON persona.cod_persona = afe.cod_persona 

             INNER JOIN  vdir_persona_tipoper per
              ON per.cod_persona = afe.cod_persona 

             INNER JOIN vdir_respuesta res
              ON res.cod_respuesta = rm.cod_respuesta 

             INNER JOIN vdir_contratante_beneficiario cb
              ON cb.COD_BENEFICIARIO = afe.cod_persona
              AND cb.COD_AFILIACION =  afe.COD_AFILIACION

             INNER JOIN vdir_beneficiario_programa bp
              ON bp.COD_BENEFICIARIO = persona.COD_PERSONA
			  AND bp.COD_AFILIACION =  afe.COD_AFILIACION

             INNER JOIN vdir_programa pg
              ON pg.COD_PROGRAMA = bp.COD_PROGRAMA			  

             WHERE                                       
               afe.COD_AFILIACION = p_codigo_afiliacion 
               AND per.cod_tipo_persona = 2
               AND afe.cod_encuesta = 2			   
               AND TRIM(res.des_respuesta) = 'SI'
               AND rm.COD_RESPUESTA <> 112 
			   AND pg.COD_PRODUCTO = 1;          


		RETURN vl_cursor;

	END VDIR_FN_VALIDA_ENCUESTA_SALUD;


END VDIR_PACK_ENCUESTAS;

/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE VDIR_PACK_BANDEJA_OPERACIONES AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_BANDEJA_OPERACIONES
 Caso de Uso : 
 Descripción : Procesos para realizar la gestión de la bandeja de 
               operaciones
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 14-02-2018  
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
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_BANDEJA_OPERACIONES
 Caso de Uso : 
 Descripción : Procesos para realizar la gestión de la bandeja de 
               operaciones
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 14-02-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripción : Procedimiento que guarda las gestiones realizadas para 
	               la solicitud
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codAfiliacion    Código de la afiliación
	   inu_codUsuario       Código del usuario 
	   ivc_desValorAnterior Descripción del valor anterior
	   ivc_desValorNuevo    Descripción del valor nuevo 
	   ivc_observacion      Observación
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al guardar el registro en la bitacora: '||SQLERRM); 
		
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripción : Procedimiento que actualiza el estado de la solicitud
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codAfiliacion Código de la afiliacón
	   inu_codEstado     Código del estado de la solicitud
	   idt_fechaGestion  Fecha de gestión de la solicitud
	   inu_codUsuario    Código del usuario que realiza la gestión
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al actualizar la afiliación: '||SQLERRM); 
		
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripción : Procedimiento que guarda en la cola de la bandeja de 
	               operaciones
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codUsuario     Código del usuario 
	   inu_codAfiliacion  Código de la afiliación
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
			-- Se actualiza el estado de la afiliación a "en gestión"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, 5);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al guardar la solicitud en la cola: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurrió ningun error
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
				'Se toma la solicitud para realizarle gestión'
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripción : Procedimiento que elimina la solicitud de la cola
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codUsuario           Código del usuario 
	   inu_codAfiliacion        Código de la afiliación
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
	   	lnu_error NUMBER(1)  := 0;
	
	BEGIN
		
	  	BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se elimina la solicitud de la cola
			-- --------------------------------------------------------------------- 
			DELETE FROM VDIR_COLA_SOLICITUD WHERE COD_AFILIACION = inu_codAfiliacion;
			
			-- ---------------------------------------------------------------------
			-- Se actualiza el estado de la afiliación a "Validado"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, 6,SYSDATE,inu_codUsuario);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al eliminar la solicitud en la cola: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurrió ningun error
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
				'Se realiza la validación de la solicitud'
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripción : Procedimiento que actualiza la solicitud en la cola
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:	  
	   inu_codUsuario           Código del usuario 
	   inu_codAfiliacion        Código de la afiliación
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
			-- Se actualiza el estado de la afiliación a "en gestión"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, 5);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al actualizar la solicitud en la cola: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurrió ningun error
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_BANDEJA_OPERACIONES
	 Caso de Uso : 
	 Descripción : Procedimiento que deja pendiente la solicitud para el 
	               usuario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codUsuario       Código del usuario 
	   inu_codAfiliacion    Código de la afiliación
	   inu_tipoGestion      Tipo de gestión 1 = Si se deja pendiente 
	                        / 2 = Se retoma la solicitud
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
			    lvc_descripcion := 'Se retoma la solicitud para realizarle gestión'; 
			
			END IF;
		  	-- ---------------------------------------------------------------------
			-- Se actualiza el estado de la afiliación a "pendiente"
			-- --------------------------------------------------------------------- 
			VDIR_PACK_BANDEJA_OPERACIONES.prActualizaAfiliacion(inu_codAfiliacion, lnu_codEstado);
			
		EXCEPTION WHEN OTHERS THEN
		
		    lnu_error := 1;
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al dejar pendiente la solicitud: '||SQLERRM); 
		
		END;		
		
		-- ---------------------------------------------------------------------
		-- Si no ocurrió ningun error
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

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE VDIR_PACK_CONSULTA_CONTRATO AS
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
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VDIR_PACK_CONSULTA_CONTRATO AS
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
	 
	    CURSOR cu_contratante IS
		SELECT usua.cod_plan tipoPlan,
               pers.nombre_1||' '|| pers.nombre_2||' '||pers.apellido_1||' '||pers.apellido_2 nombreContratante,
			   pers.numero_identificacion numeroIdentificacion,
			   CASE WHEN EXTRACT(DAY FROM SYSDATE) <= 15 THEN 
				   TO_DATE('16/'||TO_CHAR(SYSDATE,'MM/YYYY'),'DD/MM/YYYY') 
			   ELSE 
			       TO_DATE('01/'||TO_CHAR(ADD_MONTHS(SYSDATE, 1),'MM/YYYY'),'DD/MM/YYYY') 
			   END fechaVigencia,
			   '0' tarifaCuota,
			   '2' formaPago,
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
               	
		ltc_contratante   cu_contratante%ROWTYPE;
		ltc_beneficiarios cu_beneficiarios%ROWTYPE;
		lvc_datosContrato VARCHAR2(32767);
		lnu_nroContrato   NUMBER(16);
		lnu_i             NUMBER(3) := 1;
		lnu_val_tarifa    NUMBER(16) := 0;
		lvh_formatMil_tarifa VARCHAR2(100);
	BEGIN
		
		-- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_CONTRATO.NEXTVAL INTO lnu_nroContrato FROM DUAL;   
		
		lvc_datosContrato := '';
		
		
		 OPEN cu_contratante; 
		FETCH cu_contratante INTO ltc_contratante; 
		CLOSE cu_contratante;
		
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
				
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.nombreContratante             ||'","fieldName": "txtNombreContratante"},';	
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||ltc_contratante.numeroIdentificacion          ||'","fieldName": "txtNumeroIdentificacion"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ltc_contratante.fechaVigencia, 'YYYY')||'","fieldName": "txtYearVigencia"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ltc_contratante.fechaVigencia, 'MM')  ||'","fieldName": "txtMesVigencia"},';
        lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ltc_contratante.fechaVigencia, 'DD')  ||'","fieldName": "txtDiaVigencia"},';
		lvc_datosContrato := lvc_datosContrato||'{"defaultValue": "'||TO_CHAR(ADD_MONTHS(ltc_contratante.fechaVigencia, 12), 'DD/MM/YYYY')||'","fieldName": "txtVigencia"},';
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
		  FROM VDIR_PERSONA_CONTRATO
	     WHERE COD_AFILIACION = inu_codAfiliacion
		   AND COD_PERSONA    = inu_codPersona
		   AND COD_PROGRAMA   = inu_codPrograma;
				
		lnu_validaContrato NUMBER(1) := 0;
		
	BEGIN
		
		 OPEN cu_valida_contrato; 
		FETCH cu_valida_contrato INTO lnu_validaContrato; 
		CLOSE cu_valida_contrato;
		
		RETURN lnu_validaContrato;
	 
	END fnGetValidaContrato;
  
 
END VDIR_PACK_CONSULTA_CONTRATO;
/

CREATE OR REPLACE PACKAGE VDIR_PACK_CONSULTA_FILE AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_FILE
 Caso de Uso : 
 Descripci�n : Procesos para la consulta los archivos adjuntos - VENTA DIRECTA
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
    -- fnGetValidaDocumentos
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaDocumentos
    (
        inu_codAfiliacion IN VDIR_FILE_BENEFICIARIO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_FILE_BENEFICIARIO.COD_BENEFICIARIO%TYPE
    )
	RETURN NUMBER;
	
	-- ---------------------------------------------------------------------
    -- fnGetDocumentosBeneficiario
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDocumentosBeneficiario
    (
        inu_codAfiliacion IN VDIR_FILE_BENEFICIARIO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_FILE_BENEFICIARIO.COD_BENEFICIARIO%TYPE
    )
	RETURN type_cursor;
	
  
END VDIR_PACK_CONSULTA_FILE;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_CONSULTA_FILE AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_FILE
 Caso de Uso : 
 Descripci�n : Procesos para la consulta los archivos adjuntos - VENTA DIRECTA
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
    -- fnGetValidaDocumentos
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaDocumentos
    (
        inu_codAfiliacion IN VDIR_FILE_BENEFICIARIO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_FILE_BENEFICIARIO.COD_BENEFICIARIO%TYPE
    )
	RETURN NUMBER IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_FILE
	 Caso de Uso : 
	 Descripci�n : Retorna 1 = Si / 0 = No si el beneficiario tiene los 
	               documentos
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 23-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 inu_codAfiliacion       C�digo de la afiliaci�n
	 inu_codPersona          C�digo de la persona contratante / beneficiario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    CURSOR cu_valida_archivo IS
		SELECT COUNT(1)
		  FROM VDIR_FILE_BENEFICIARIO fibe,
		       VDIR_FILE              vfil		  
	     WHERE 
		 	fibe.cod_file = vfil.cod_file
		   	AND vfil.cod_tipo_file IN (6,7)
		 	AND fibe.COD_AFILIACION   = inu_codAfiliacion
		   	AND fibe.COD_BENEFICIARIO = inu_codPersona;
				
		lnu_validaArchivo NUMBER(1) := 0;
		
	BEGIN
		
		 OPEN cu_valida_archivo; 
		FETCH cu_valida_archivo INTO lnu_validaArchivo; 
		CLOSE cu_valida_archivo;
		
		RETURN lnu_validaArchivo;
	 
	END fnGetValidaDocumentos;
	
	-- ---------------------------------------------------------------------
    -- fnGetDocumentosBeneficiario
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDocumentosBeneficiario
    (
        inu_codAfiliacion IN VDIR_FILE_BENEFICIARIO.COD_AFILIACION%TYPE,
		inu_codPersona    IN VDIR_FILE_BENEFICIARIO.COD_BENEFICIARIO%TYPE
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_FILE
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de las documentos por beneficiarip
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 23-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 inu_codAfiliacion       C�digo de la afiliaci�n
	 inu_codPersona          C�digo de la persona contratante / beneficiario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vfil.des_file,
		       vfil.ruta
		  FROM VDIR_FILE_BENEFICIARIO fibe,
		       VDIR_FILE              vfil
	 	 WHERE fibe.cod_file = vfil.cod_file
		   AND vfil.cod_tipo_file IN (6,7)
		   AND fibe.cod_afiliacion = inu_codAfiliacion
		   AND fibe.cod_beneficiario = inu_codPersona;
		   
		RETURN ltc_datos;
	 
	END fnGetDocumentosBeneficiario;
  
 
END VDIR_PACK_CONSULTA_FILE;
/
CREATE OR REPLACE PACKAGE VDIR_PACK_CONSULTA_LINEAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_LINEAS
 Caso de Uso : 
 Descripción : Procesos para la consulta los productos - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 23-01-2018  
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
 
	-- ---------------------------------------------------------------------
    -- fnGetLineas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetLineas RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetProductos
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProductos RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetProgramas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProgramas 
	(
		inu_codProducto IN VDIR_PRODUCTO.COD_PRODUCTO%TYPE
	)
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetPlanes
    -- ---------------------------------------------------------------------
    FUNCTION fnGetPlanes RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetEstados
    -- ---------------------------------------------------------------------
    FUNCTION fnGetEstados
	(
	    inuTipo IN VDIR_ESTADO.IND_TIPO%TYPE DEFAULT 1
	)
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetPlanPrograma
    -- ---------------------------------------------------------------------
    FUNCTION fnGetPlanPrograma
	(
	    inuCodPlanPrograma IN VDIR_PLAN_PROGRAMA.COD_PLAN_PROGRAMA%TYPE
	)
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetCoberturas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetCoberturas
    (
        inu_codPrograma IN VDIR_PLAN_PROGRAMA.COD_PROGRAMA%TYPE,
		inu_codPlan     IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN type_cursor;
	
  
END VDIR_PACK_CONSULTA_LINEAS;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_CONSULTA_LINEAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_LINEAS
 Caso de Uso : 
 Descripción : Procesos para la consulta los archivos adjuntos - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 23-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */
 
	-- ---------------------------------------------------------------------
    -- fnGetLineas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetLineas RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_LINEAS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los datos de los productos y 
	               programas asociados a un plan y coberturas
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 24-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT plpr.cod_plan_programa,
		       prog.cod_programa,
		       prog.des_programa,
			   prod.des_producto,
			   vpla.des_plan,
			   vest.des_estado,
			   plpr.cobertura_inicial,
			   plpr.cobertura_final
		  FROM VDIR_PROGRAMA      prog,
		       VDIR_PRODUCTO      prod,
			   VDIR_PLAN_PROGRAMA plpr,
			   VDIR_PLAN          vpla,
			   VDIR_ESTADO        vest
	 	 WHERE prog.cod_producto = prod.cod_producto
		   AND prog.cod_programa = plpr.cod_programa
		   AND plpr.cod_plan     = vpla.cod_plan
		   AND plpr.cod_estado   = vest.cod_estado;
		   
		RETURN ltc_datos;
	 
	END fnGetLineas;
	
	-- ---------------------------------------------------------------------
    -- fnGetProductos
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProductos RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_LINEAS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los productos
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 24-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT prod.cod_producto,
			   prod.des_producto
		  FROM VDIR_PRODUCTO prod
	 	 WHERE prod.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetProductos;
		
	-- ---------------------------------------------------------------------
    -- fnGetProgramas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProgramas 
	(
		inu_codProducto IN VDIR_PRODUCTO.COD_PRODUCTO%TYPE
	)	
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_LINEAS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los programas
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 24-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT prog.cod_programa,
		       prog.des_programa
		  FROM VDIR_PROGRAMA prog
	 	 WHERE prog.cod_estado   = 1
		   AND prog.cod_producto = inu_codProducto;
		   
		RETURN ltc_datos;
	 
	END fnGetProgramas;
	
	-- ---------------------------------------------------------------------
    -- fnGetPlanes
    -- ---------------------------------------------------------------------
    FUNCTION fnGetPlanes RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_LINEAS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los planes
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 24-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vpla.cod_plan,
			   vpla.des_plan
		  FROM VDIR_PLAN vpla
	 	 WHERE vpla.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetPlanes;
	
	-- ---------------------------------------------------------------------
    -- fnGetEstados
    -- ---------------------------------------------------------------------
    FUNCTION fnGetEstados 
	(
	    inuTipo IN VDIR_ESTADO.IND_TIPO%TYPE DEFAULT 1
	)
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_LINEAS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los estados
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 24-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vest.cod_estado,
			   vest.des_estado
		  FROM VDIR_ESTADO vest
		 WHERE vest.ind_tipo = inuTipo;
		   
		RETURN ltc_datos;
	 
	END fnGetEstados;
	
	-- ---------------------------------------------------------------------
    -- fnGetPlanPrograma
    -- ---------------------------------------------------------------------
    FUNCTION fnGetPlanPrograma
	(
	    inuCodPlanPrograma IN VDIR_PLAN_PROGRAMA.COD_PLAN_PROGRAMA%TYPE
	)
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_LINEAS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los datos del plan programa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 24-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT plpr.cod_plan_programa, 
		       prog.cod_producto,
		       prog.cod_programa,
		       plpr.cod_plan,
			   plpr.cod_estado,
			   plpr.cobertura_inicial,
			   plpr.cobertura_final,
               plpr.cod_programa_homologa
		  FROM VDIR_PROGRAMA      prog,
			   VDIR_PLAN_PROGRAMA plpr
	 	 WHERE prog.cod_programa = plpr.cod_programa
		   AND plpr.cod_plan_programa = inuCodPlanPrograma;
		   
		RETURN ltc_datos;
	 
	END fnGetPlanPrograma;
	
	-- ---------------------------------------------------------------------
    -- fnGetCoberturas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetCoberturas
    (
        inu_codPrograma IN VDIR_PLAN_PROGRAMA.COD_PROGRAMA%TYPE,
		inu_codPlan     IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_PRODUCTOS
	 Caso de Uso : 
	 Descripción : Retorna los datos de las imagenes para un programa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 04-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 inu_codPrograma   Código del programa
	 inu_codPlan       Código del plan
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT plpr.cobertura_inicial,
			   plpr.cobertura_final,
			   prog.des_programa
		  FROM VDIR_PROGRAMA      prog,
			   VDIR_PLAN_PROGRAMA plpr
	 	 WHERE prog.cod_programa = plpr.cod_programa
		   AND plpr.cod_programa = inu_codPrograma
		   AND plpr.cod_plan     = inu_codPlan;
		   
		RETURN ltc_datos;
	 
	END fnGetCoberturas;
   
END VDIR_PACK_CONSULTA_LINEAS;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE VDIR_PACK_CONSULTA_SOLICITUD AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_SOLICITUD
 Caso de Uso : 
 Descripci�n : Procesos para la consulta las afiliaciones - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 08-02-2018  
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
    -- fnGetSolicitudesGestionar
    -- ---------------------------------------------------------------------
    FUNCTION fnGetSolicitudesGestionar
    (
	    inu_codEstado     IN VDIR_AFILIACION.COD_ESTADO%TYPE DEFAULT 7,
        inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE DEFAULT NULL,
		ivc_fechaInicia   IN VARCHAR2 DEFAULT NULL,
		ivc_fechaFinal    IN VARCHAR2 DEFAULT NULL
    )
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetSolicitudes
    -- ---------------------------------------------------------------------
    FUNCTION fnGetSolicitudes
    (
	    inu_codEstado           IN VDIR_AFILIACION.COD_ESTADO%TYPE DEFAULT NULL,
        inu_codAfiliacion       IN VDIR_AFILIACION.COD_AFILIACION%TYPE DEFAULT NULL,
		ivc_fechaRadicaInicia   IN VARCHAR2 DEFAULT NULL,
		ivc_fechaRadicaFinal    IN VARCHAR2 DEFAULT NULL,
		ivc_fechaGestionInicia  IN VARCHAR2 DEFAULT NULL,
		ivc_fechaGestionFinal   IN VARCHAR2 DEFAULT NULL
    )
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetDatosContratante
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosContratante
    (
	    inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetDatosBeneficiarios
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosBeneficiarios
    (
	    inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetTipoCompras
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTipoCompras
    (
	    inu_codAfiliacion   IN VDIR_BENEFICIARIO_PROGRAMA.COD_AFILIACION%TYPE,
		inu_codBeneficiario IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE,
		inu_codPlan         IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN VARCHAR2; 
	
	-- ---------------------------------------------------------------------
    -- fnGetFechasServicio
    -- ---------------------------------------------------------------------
    FUNCTION fnGetFechasServicio
    (
	    inu_codAfiliacion IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		inu_codContrante  IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE,
		inu_codPlan       IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN VARCHAR2; 
	
	-- ---------------------------------------------------------------------
    -- fnGetProgramas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProgramas
    (
	    inu_codAfiliacion   IN VDIR_BENEFICIARIO_PROGRAMA.COD_AFILIACION%TYPE,
		inu_codBeneficiario IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE,
		inu_codPlan         IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN VARCHAR2; 
	
	-- ---------------------------------------------------------------------
    -- fnGetTarifas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTarifas
    (
	    inu_codAfiliacion   IN VDIR_BENEFICIARIO_PROGRAMA.COD_AFILIACION%TYPE,
		inu_codBeneficiario IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE
    )
	RETURN VARCHAR2; 
	
	-- ---------------------------------------------------------------------
    -- fnGetDatosBitacora
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosBitacora
    (
	    inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetValidaExisteCola
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaExisteCola
    (
	    inu_codAfiliacion   IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE,
		inu_codUsuario      IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE
    )
	RETURN NUMBER; 
	
	-- ---------------------------------------------------------------------
    -- fnGetNombreUsuarioCola
    -- ---------------------------------------------------------------------
    FUNCTION fnGetNombreUsuarioCola
    (
	    inu_codAfiliacion IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    )
	RETURN VARCHAR2; 
	
	-- ---------------------------------------------------------------------
    -- fnGetSolicitudesPendientes
    -- ---------------------------------------------------------------------
    FUNCTION fnGetSolicitudesPendientes
    (
	    inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE
    )
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetValidaSolicitudEnGestion
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaSolicitudEnGestion
    (
	  	inu_codUsuario      IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE
    )
	RETURN NUMBER; 
	  
END VDIR_PACK_CONSULTA_SOLICITUD;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VDIR_PACK_CONSULTA_SOLICITUD AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_SOLICITUD
 Caso de Uso : 
 Descripci�n : Procesos para la consulta las afiliaciones - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 08-02-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 	
	-- ---------------------------------------------------------------------
    -- fnGetSolicitudesGestionar
    -- ---------------------------------------------------------------------
    FUNCTION fnGetSolicitudesGestionar
    (
	    inu_codEstado     IN VDIR_AFILIACION.COD_ESTADO%TYPE DEFAULT 7,
        inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE DEFAULT NULL,
		ivc_fechaInicia   IN VARCHAR2 DEFAULT NULL,
		ivc_fechaFinal    IN VARCHAR2 DEFAULT NULL	
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de las afiliaciones
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 08-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	    inu_codAfiliacion  N�mero de la solicitud o c�digo de la afiliaci�n
		idt_fechaInicia    Fecha Inicial de radicaci�n
		idt_fechaFinal     Fecha Final de radicaci�n
		inu_codEstado      C�digo del estado de la afiliaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    lvc_query VARCHAR2(32767);
		ltc_datos type_cursor;
	
	BEGIN 
	 
		lvc_query := 'SELECT afil.cod_afiliacion,
						     INITCAP(pers.nombre_1) nombre_1,
						     INITCAP(pers.apellido_1) apellido_1,
						     plan.des_plan,
						     esta.des_estado,
	                         TO_CHAR(afil.fecha_creacion, ''dd/mm/yyyy'') fecha_radicacion,
							 esta.cod_estado
					    FROM VDIR_AFILIACION               afil,
						     VDIR_ENCUESTA_PERSONA         cobe,
						     VDIR_PERSONA                  pers,
						     VDIR_USUARIO                  usua,
						     VDIR_ESTADO                   esta,
						     VDIR_PLAN                     plan
					   WHERE afil.cod_afiliacion  = cobe.cod_afiliacion
					     AND cobe.cod_persona     = pers.cod_persona 
					     AND pers.cod_persona     = usua.cod_persona
					     AND usua.cod_plan        = plan.cod_plan
					     AND afil.cod_estado      = esta.cod_estado
					     AND cobe.cod_encuesta    = 1
						 AND afil.cod_estado	  <> 3';

		IF inu_codEstado <> -1  AND inu_codEstado IS NOT NULL THEN
			lvc_query := lvc_query||' AND afil.cod_estado = '||inu_codEstado;
		END IF;

		IF inu_codAfiliacion IS NOT NULL THEN
		
		    lvc_query := lvc_query||' AND afil.cod_afiliacion = '||inu_codAfiliacion;
			
		END IF;		
			
		IF ivc_fechaInicia IS NOT NULL AND ivc_fechaFinal IS NOT NULL THEN
		
		lvc_query := lvc_query||' AND TO_DATE(TO_CHAR(afil.fecha_creacion,''dd/mm/yyyy''),''dd/mm/yyyy'') BETWEEN TO_DATE('''||ivc_fechaInicia||''',''dd/mm/yyyy'') AND TO_DATE('''||ivc_fechaFinal||''',''dd/mm/yyyy'')';
			
		END IF;
		
		--DBMS_OUTPUT.PUT_LINE(lvc_query);
		--Se retorna el cursor
		OPEN ltc_datos FOR lvc_query;		
		   
		RETURN ltc_datos;
	 
	END fnGetSolicitudesGestionar;
	
	-- ---------------------------------------------------------------------
    -- fnGetSolicitudes
    -- ---------------------------------------------------------------------
    FUNCTION fnGetSolicitudes
    (
	    inu_codEstado           IN VDIR_AFILIACION.COD_ESTADO%TYPE DEFAULT NULL,
        inu_codAfiliacion       IN VDIR_AFILIACION.COD_AFILIACION%TYPE DEFAULT NULL,
		ivc_fechaRadicaInicia   IN VARCHAR2 DEFAULT NULL,
		ivc_fechaRadicaFinal    IN VARCHAR2 DEFAULT NULL,
		ivc_fechaGestionInicia  IN VARCHAR2 DEFAULT NULL,
		ivc_fechaGestionFinal   IN VARCHAR2 DEFAULT NULL
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de las afiliaciones
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 08-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	    inu_codEstado           C�digo del estado de la afiliaci�n
	    inu_codAfiliacion       N�mero de la solicitud o c�digo de la afiliaci�n		
		ivc_fechaRadicaInicia   Fecha Inicial de radicaci�n
		ivc_fechaRadicaFinal    Fecha Final de radicaci�n
		ivc_fechaGestionInicia  Fecha Inicial de radicaci�n
		ivc_fechaGestionFinal   Fecha Final de radicaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
	    lvc_query VARCHAR2(32767);
		ltc_datos type_cursor;
	
	BEGIN 
	 
		lvc_query := 'SELECT afil.cod_afiliacion,
						     INITCAP(pers.nombre_1) nombre_1,
						     INITCAP(pers.apellido_1) apellido_1,
						     plan.des_plan,
						     esta.des_estado,
	                         TO_CHAR(afil.fecha_creacion, ''dd/mm/yyyy'') fecha_radicacion,
							 esta.cod_estado,
							 TO_CHAR(afil.fecha_gestion, ''dd/mm/yyyy'') fecha_gestion,
	                         (SELECT CONCAT(CONCAT(INITCAP(per.nombre_1), '' ''),INITCAP(per.apellido_1)) nombre_usuario
							    FROM VDIR_PERSONA per,
						             VDIR_USUARIO usu
							   WHERE per.cod_persona = usu.cod_persona
							     AND afil.cod_usuario_gestion = usu.cod_usuario) usuario_gestion,
						     (SELECT CONCAT(CONCAT(INITCAP(per.nombre_1), '' ''),INITCAP(per.apellido_1)) nombre_usuario
							    FROM VDIR_PERSONA per,
						             VDIR_USUARIO usu,
									 VDIR_COLA_SOLICITUD coso
							   WHERE per.cod_persona = usu.cod_persona
							     AND coso.cod_usuario= usu.cod_usuario
								 AND coso.cod_afiliacion = afil.cod_afiliacion) usuario_toma
					    FROM VDIR_AFILIACION               afil,
						     VDIR_ENCUESTA_PERSONA         cobe,
						     VDIR_PERSONA                  pers,
						     VDIR_USUARIO                  usua,
						     VDIR_ESTADO                   esta,
						     VDIR_PLAN                     plan
					   WHERE afil.cod_afiliacion  = cobe.cod_afiliacion
					     AND cobe.cod_persona     = pers.cod_persona 
					     AND pers.cod_persona     = usua.cod_persona
					     AND usua.cod_plan        = plan.cod_plan
					     AND afil.cod_estado      = esta.cod_estado
					     AND cobe.cod_encuesta    = 1
						 AND esta.ind_tipo        = 2
						 AND afil.cod_estado	  <> 3';
						 
		IF inu_codEstado IS NOT NULL THEN
		
		    lvc_query := lvc_query||' AND afil.cod_estado = '||inu_codEstado;
			
		END IF;		
						 
		IF inu_codAfiliacion IS NOT NULL THEN
		
		    lvc_query := lvc_query||' AND afil.cod_afiliacion = '||inu_codAfiliacion;
			
		END IF;		
			
		IF ivc_fechaRadicaInicia IS NOT NULL AND ivc_fechaRadicaFinal IS NOT NULL THEN
		
		    lvc_query := lvc_query||' AND TO_DATE(TO_CHAR(afil.fecha_creacion,''dd/mm/yyyy''),''dd/mm/yyyy'') BETWEEN TO_DATE('''||ivc_fechaRadicaInicia||''',''dd/mm/yyyy'') AND TO_DATE('''||ivc_fechaRadicaFinal||''',''dd/mm/yyyy'')';
			
		END IF;
		
		IF ivc_fechaGestionInicia IS NOT NULL AND ivc_fechaGestionFinal IS NOT NULL THEN
		
		    lvc_query := lvc_query||' AND TO_DATE(TO_CHAR(afil.fecha_gestion,''dd/mm/yyyy''),''dd/mm/yyyy'') BETWEEN TO_DATE('''||ivc_fechaGestionInicia||''',''dd/mm/yyyy'') AND TO_DATE('''||ivc_fechaGestionFinal||''',''dd/mm/yyyy'')';
			
		END IF;
		
        lvc_query := lvc_query||' ORDER BY esta.des_estado asc, afil.fecha_creacion desc ';
		--DBMS_OUTPUT.PUT_LINE(lvc_query);
		--Se retorna el cursor
		OPEN ltc_datos FOR lvc_query;		
		   
		RETURN ltc_datos;
	 
	END fnGetSolicitudes;

	
	-- ---------------------------------------------------------------------
    -- fnGetDatosContratante
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosContratante
    (
	    inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los datos del contratante por afiliaci�n
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 13-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codAfiliacion   C�digo de la afiliaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
	    SELECT TO_CHAR(afil.fecha_creacion, 'yyyy-mm-dd') fecha_radicacion,
               pers.apellido_1,
               pers.apellido_2,
               pers.nombre_1,
               pers.nombre_2,
               sexo.des_abr genero,
               tiid.des_abr tipo_identificacion,
               pers.numero_identificacion,
               TO_CHAR(pers.fecha_nacimiento, 'yyyy-mm-dd') fecha_nacimiento,
               (SELECT pais.abr_pais
                  FROM VDIR_PAIS         pais,
                       VDIR_DEPARTAMENTO depa
                 WHERE pais.cod_pais         = depa.cod_pais
                   AND depa.cod_departamento = muni.cod_departamento) nacionalidad,
               esci.abr_estado_civil,
               veps.des_eps,
               tivi.abr_tipo_via, 
               pers.dir_num_via,
               pers.dir_num_placa,
               pers.dir_complemento,
               '01' pais,
               pers.cod_municipio,
               pers.cod_municipio barrio,
               pers.cod_municipio codigo_dane,
               pers.telefono,
               pers.email,
               pers.cod_persona,
               afil.cod_afiliacion
		  FROM VDIR_AFILIACION               afil,
			   VDIR_CONTRATANTE_BENEFICIARIO cobe,
			   VDIR_PERSONA                  pers,
			   VDIR_SEXO                     sexo,
			   VDIR_TIPO_IDENTIFICACION      tiid,
			   VDIR_MUNICIPIO                muni,
			   VDIR_ESTADO_CIVIL             esci,
			   VDIR_EPS                      veps,
			   VDIR_TIPO_VIA                 tivi
	     WHERE afil.cod_afiliacion          = cobe.cod_afiliacion
		   AND cobe.cod_contratante         = pers.cod_persona 
		   --AND cobe.cod_beneficiario        = pers.cod_persona
		   AND pers.cod_sexo                = sexo.cod_sexo
		   AND pers.cod_tipo_identificacion = tiid.cod_tipo_identificacion
		   AND pers.cod_municipio           = muni.cod_municipio
		   AND pers.cod_estado_civil        = esci.cod_estado_civil
		   AND pers.cod_eps                 = veps.cod_eps
		   AND pers.dir_tipo_via            = tivi.cod_tipo_via
		   AND afil.cod_afiliacion          = inu_codAfiliacion;
		   
		RETURN ltc_datos;
	 
	END fnGetDatosContratante;
	
	-- ---------------------------------------------------------------------
    -- fnGetDatosBeneficiarios
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosBeneficiarios
    (
	    inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los datos del beneficiario por afiliaci�n
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 13-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codAfiliacion   C�digo de la afiliaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
	    SELECT vdpa.abr_parentesco parentesco,
                TO_CHAR(afil.fecha_creacion, 'yyyy-mm-dd') fecha_radicacion,
                pers.apellido_1,
                pers.apellido_2,
                pers.nombre_1,
                pers.nombre_2,
                sexo.des_abr genero,
                tiid.des_abr tipo_identificacion,
                pers.numero_identificacion,
                TO_CHAR(pers.fecha_nacimiento, 'yyyy-mm-dd') fecha_nacimiento,
                (SELECT pais.abr_pais
                   FROM VDIR_PAIS         pais,
                        VDIR_DEPARTAMENTO depa
                  WHERE pais.cod_pais         = depa.cod_pais
                    AND depa.cod_departamento = muni.cod_departamento) nacionalidad,
                esci.abr_estado_civil,
                veps.des_eps,
                tivi.abr_tipo_via, 
                pers.dir_num_via,
                pers.dir_num_placa,
                pers.dir_complemento,
                '01' pais,
                pers.cod_municipio,
                pers.cod_municipio barrio,
                pers.cod_municipio codigo_dane,
                pers.telefono,
                pers.email,				
				VDIR_PACK_CONSULTA_SOLICITUD.fnGetTipoCompras(afil.cod_afiliacion, pers.cod_persona,vusu.cod_plan) tipo_venta,
				VDIR_PACK_CONSULTA_SOLICITUD.fnGetProgramas(afil.cod_afiliacion, pers.cod_persona,vusu.cod_plan) cod_programas,
				VDIR_PACK_CONSULTA_SOLICITUD.fnGetTarifas(afil.cod_afiliacion, pers.cod_persona) cod_tarifas,
				VDIR_PACK_CONSULTA_SOLICITUD.fnGetFechasServicio(afil.cod_afiliacion, cobe.cod_contratante,vusu.cod_plan) fecha_inicio_servicio,		
				pers.cod_persona,
                afil.cod_afiliacion,
                pers.cod_sexo,
                TRUNC(MONTHS_BETWEEN(SYSDATE,pers.fecha_nacimiento)/12) edad,
				VDIR_PACK_ENCUESTAS.fnGetValidaEncuesta(afil.cod_afiliacion, pers.cod_persona,'2') ind_encuesta_salud
		  FROM VDIR_AFILIACION               afil,
			   VDIR_CONTRATANTE_BENEFICIARIO cobe,
			   VDIR_PERSONA                  pers,
			   VDIR_SEXO                     sexo,
			   VDIR_TIPO_IDENTIFICACION      tiid,
			   VDIR_MUNICIPIO                muni,
			   VDIR_ESTADO_CIVIL             esci,
			   VDIR_EPS                      veps,
			   VDIR_TIPO_VIA                 tivi,
			   VDIR_PARENTESCO               vdpa,
			   VDIR_USUARIO                  vusu
	     WHERE afil.cod_afiliacion          = cobe.cod_afiliacion
		   AND cobe.cod_beneficiario        = pers.cod_persona 
		   AND pers.cod_sexo                = sexo.cod_sexo
		   AND pers.cod_tipo_identificacion = tiid.cod_tipo_identificacion
		   AND pers.cod_municipio           = muni.cod_municipio
		   AND pers.cod_estado_civil        = esci.cod_estado_civil
		   AND pers.cod_eps                 = veps.cod_eps
		   AND pers.dir_tipo_via            = tivi.cod_tipo_via
		   AND cobe.cod_parentesco          = vdpa.cod_parentesco
		   AND cobe.cod_contratante         = vusu.cod_persona
		   AND afil.cod_afiliacion          = inu_codAfiliacion;
		   
		RETURN ltc_datos;
	 
	END fnGetDatosBeneficiarios;
   
    -- ---------------------------------------------------------------------
    -- fnGetTipoCompras
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTipoCompras
    (
	    inu_codAfiliacion   IN VDIR_BENEFICIARIO_PROGRAMA.COD_AFILIACION%TYPE,
		inu_codBeneficiario IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE,
		inu_codPlan         IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN VARCHAR2 IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los tipos de compras por programa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 21-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codAfiliacion   C�digo de la afiliaci�n
	 inu_codBeneficiario C�digo del beneficiario
	 inu_codPlan         C�digo del plan
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
		lvc_desTipoSolicitud VARCHAR2(4000);
	
	BEGIN 
	 
	    FOR fila IN (SELECT tiso.des_tipo_solicitud
			           FROM VDIR_BENEFICIARIO_PROGRAMA bepr,
					        VDIR_PLAN_PROGRAMA         plpr,
					        VDIR_TIPO_SOLICITUD        tiso
					  WHERE bepr.cod_programa       = plpr.cod_programa 
					    AND bepr.cod_tipo_solicitud = tiso.cod_tipo_solicitud
					    AND bepr.cod_beneficiario   = inu_codBeneficiario
					    AND bepr.cod_afiliacion     = inu_codAfiliacion
		                AND plpr.cod_plan           = inu_codPlan)
		LOOP					
			lvc_desTipoSolicitud := lvc_desTipoSolicitud || fila.des_tipo_solicitud || ',';			
		END LOOP;
		
		lvc_desTipoSolicitud := SUBSTR(lvc_desTipoSolicitud, 1,LENGTH(lvc_desTipoSolicitud)-1);
		
		RETURN lvc_desTipoSolicitud;   		
	 
	END fnGetTipoCompras;
	
	-- ---------------------------------------------------------------------
    -- fnGetFechasServicio
    -- ---------------------------------------------------------------------
    FUNCTION fnGetFechasServicio
    (
	    inu_codAfiliacion IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		inu_codContrante  IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE,
		inu_codPlan       IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN VARCHAR2 IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna las fechas de inicio de los servicios
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 21-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codAfiliacion   C�digo de la afiliaci�n
	 inu_codContrante    C�digo del contratante
	 inu_codPlan         C�digo del plan
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
		lvc_fechasServicio VARCHAR2(4000);
	
	BEGIN 	 

	 
	    FOR fila IN (SELECT CASE WHEN EXTRACT(DAY FROM peco.fecha_creacion) <= 15 THEN 
		                        TO_CHAR(peco.fecha_creacion,'YYYY-MM')||'-16'
                            ELSE 
                                TO_CHAR(ADD_MONTHS(peco.fecha_creacion, 1),'YYYY-MM')||'-01'
                            END fecha_inicio_servicio
			           FROM VDIR_PERSONA_CONTRATO peco,
					        VDIR_PLAN_PROGRAMA    plpr
					  WHERE peco.cod_programa   = plpr.cod_programa 					  
					    AND peco.cod_persona    = inu_codContrante
					    AND peco.cod_afiliacion = inu_codAfiliacion
		                AND plpr.cod_plan       = inu_codPlan)
		LOOP					
			lvc_fechasServicio := lvc_fechasServicio || fila.fecha_inicio_servicio || ',';			
		END LOOP;
		
		lvc_fechasServicio := SUBSTR(lvc_fechasServicio, 1,LENGTH(lvc_fechasServicio)-1);
		
		RETURN lvc_fechasServicio;   		
	 
	END fnGetFechasServicio;
	
    -- ---------------------------------------------------------------------
    -- fnGetProgramas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProgramas
    (
	    inu_codAfiliacion   IN VDIR_BENEFICIARIO_PROGRAMA.COD_AFILIACION%TYPE,
		inu_codBeneficiario IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE,
		inu_codPlan         IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
    )
	RETURN VARCHAR2 IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los c�digos de los programas por cada beneficiario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codAfiliacion   C�digo de la afiliaci�n
	 inu_codBeneficiario C�digo del beneficiario
	 inu_codPlan         C�digo del plan
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
		lvc_codProgramas  VARCHAR2(4000);
	
	BEGIN 
	 
	    FOR fila IN (SELECT plpr.cod_programa_homologa
			           FROM VDIR_BENEFICIARIO_PROGRAMA bepr,
					        VDIR_PLAN_PROGRAMA         plpr
					  WHERE bepr.cod_programa     = plpr.cod_programa
					    AND bepr.cod_beneficiario = inu_codBeneficiario
					    AND bepr.cod_afiliacion   = inu_codAfiliacion
						AND plpr.cod_plan         = inu_codPlan
						AND plpr.cod_estado       = 1)
		LOOP					
			lvc_codProgramas := lvc_codProgramas || fila.cod_programa_homologa || ',';			
		END LOOP;
		
		lvc_codProgramas := SUBSTR(lvc_codProgramas, 1,LENGTH(lvc_codProgramas)-1);
		
		RETURN lvc_codProgramas;   		
	 
	END fnGetProgramas;
	
	-- ---------------------------------------------------------------------
    -- fnGetTarifas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTarifas
    (
	    inu_codAfiliacion   IN VDIR_BENEFICIARIO_PROGRAMA.COD_AFILIACION%TYPE,
		inu_codBeneficiario IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE
    )
	RETURN VARCHAR2 IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los c�digos de las tarifas por cada beneficiario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codAfiliacion   C�digo de la afiliaci�n
	 inu_codBeneficiario C�digo del beneficiario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
		lvc_codTarifas VARCHAR2(4000);
	
	BEGIN 
	 
	    FOR fila IN (SELECT vtar.cod_tarifa_mp
			           FROM VDIR_BENEFICIARIO_PROGRAMA bepr,
					        VDIR_TARIFA                vtar
					  WHERE bepr.cod_tarifa       = vtar.cod_tarifa
					    AND bepr.cod_beneficiario = inu_codBeneficiario
					    AND bepr.cod_afiliacion   = inu_codAfiliacion)
		LOOP	
			lvc_codTarifas := lvc_codTarifas || fila.cod_tarifa_mp|| ',';				
		END LOOP;
		
		lvc_codTarifas := SUBSTR(lvc_codTarifas, 1,LENGTH(lvc_codTarifas)-1);
		   
		RETURN lvc_codTarifas;   		
	 
	END fnGetTarifas;
	
	-- ---------------------------------------------------------------------
    -- fnGetDatosBitacora
    -- ---------------------------------------------------------------------
    FUNCTION fnGetDatosBitacora
    (
	    inu_codAfiliacion IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de la trazabilidad realizada a la
	               afiliaci�n
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codAfiliacion   C�digo de la afiliaci�n
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
	    SELECT TO_CHAR(biso.fecha_bitacora,'dd/mm/yyyy HH24:MI:SS') fecha_bitacora, 
		       pers.nombre_1||' '||pers.apellido_1 nombre_persona,
			   biso.observacion		
		  FROM VDIR_BITACORA_SOLICITUD biso,
		       VDIR_USUARIO            vusu,
			   VDIR_PERSONA            pers
	     WHERE biso.cod_usuario    = vusu.cod_usuario
		   AND vusu.cod_persona    = pers.cod_persona
		   AND biso.cod_afiliacion = inu_codAfiliacion
		   ORDER BY biso.fecha_bitacora DESC;
		   
		RETURN ltc_datos;
	 
	END fnGetDatosBitacora;
	
	-- ---------------------------------------------------------------------
    -- fnGetValidaExisteCola
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaExisteCola
    (
	    inu_codAfiliacion   IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE,
		inu_codUsuario      IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE
    )
	RETURN NUMBER IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Indica si la afiliaci�n existe en la cola
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codAfiliacion    C�digo de la afiliaci�n
	   inu_codUsuario       C�digo del usuario 	   
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		lnu_valida            NUMBER(1)  := 0;
		lnu_codColaSolicitud  VDIR_COLA_SOLICITUD.COD_COLA_SOLICITUD%TYPE;  		
	
	BEGIN 	 
	 
	    BEGIN 
		
			SELECT cod_cola_solicitud 
			  INTO lnu_codColaSolicitud       
			  FROM VDIR_COLA_SOLICITUD
			 WHERE cod_afiliacion = inu_codAfiliacion
			   AND cod_usuario    = inu_codUsuario;  
			
			IF lnu_codColaSolicitud IS NOT NULL THEN
			
				-- ---------------------------------------------------------------------
				-- El usuario va a retomar la solicitud
				-- ---------------------------------------------------------------------
				lnu_valida := 1;
				
			END IF;					
			
		EXCEPTION WHEN OTHERS THEN  
			lnu_valida := 0;
		END;
		
		IF lnu_valida = 0 THEN
		
		    BEGIN 
			    
				SELECT cod_cola_solicitud 
				  INTO lnu_codColaSolicitud       
				  FROM VDIR_COLA_SOLICITUD
				 WHERE cod_afiliacion = inu_codAfiliacion;  
				 
				IF lnu_codColaSolicitud IS NOT NULL THEN
				
					-- ---------------------------------------------------------------------
					-- El usuario se va a reasignar la solicitud de otro usuario
					-- ---------------------------------------------------------------------
					lnu_valida := 2;		
					  
				END IF;
				
		    EXCEPTION WHEN OTHERS THEN  
				lnu_valida := 0;
			END;		
				
		END IF;		
	
		RETURN lnu_valida;
	 
	END fnGetValidaExisteCola;	
	
	-- ---------------------------------------------------------------------
    -- fnGetNombreUsuarioCola
    -- ---------------------------------------------------------------------
    FUNCTION fnGetNombreUsuarioCola
    (
	    inu_codAfiliacion IN VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE
    )
	RETURN VARCHAR2 IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna el nombre del usuario que tiene la solicitud 
	               en la cola	  
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	   inu_codAfiliacion    C�digo de la afiliaci�n 
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		lnu_nombreUsuario VARCHAR2(1000);		
	
	BEGIN 
	 		
		SELECT pers.nombre_1||' '||pers.apellido_1 nombre_persona 
		  INTO lnu_nombreUsuario       
		  FROM VDIR_COLA_SOLICITUD coso,
		       VDIR_USUARIO        vusu,
			   VDIR_PERSONA        pers
		 WHERE coso.cod_usuario    = vusu.cod_usuario
		   AND vusu.cod_persona    = pers.cod_persona
		   AND coso.cod_afiliacion = inu_codAfiliacion;   
		
			   
		RETURN lnu_nombreUsuario;
	 
	END fnGetNombreUsuarioCola;		
	
	-- ---------------------------------------------------------------------
    -- fnGetSolicitudesPendientes
    -- ---------------------------------------------------------------------
    FUNCTION fnGetSolicitudesPendientes
    (
	    inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE
    )
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de las solicitudes pendientes
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :       Descripci�n:
	 inu_codUsuario      C�digo del usuario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
	    SELECT afil.cod_afiliacion,
			   pers.nombre_1,
			   pers.apellido_1,
			   plan.des_plan,
			   esta.des_estado,
			   TO_CHAR(afil.fecha_creacion, 'dd/mm/yyyy') fecha_radicacion,
			   esta.cod_estado
		  FROM VDIR_AFILIACION               afil,
		  	   VDIR_ENCUESTA_PERSONA         cobe,
			   VDIR_PERSONA                  pers,
			   VDIR_USUARIO                  usua,
			   VDIR_ESTADO                   esta,
			   VDIR_PLAN                     plan,
			   VDIR_COLA_SOLICITUD           coso
	     WHERE afil.cod_afiliacion  = cobe.cod_afiliacion
		   AND cobe.cod_persona     = pers.cod_persona 
		   AND pers.cod_persona     = usua.cod_persona
		   AND usua.cod_plan        = plan.cod_plan
		   AND afil.cod_estado      = esta.cod_estado
		   AND afil.cod_afiliacion  = coso.cod_afiliacion
		   AND cobe.cod_encuesta    = 1		   
		   AND afil.cod_estado      = 4
		   AND coso.cod_usuario     = inu_codUsuario;
		   
		RETURN ltc_datos;
	 
	END fnGetSolicitudesPendientes;
	
	-- ---------------------------------------------------------------------
    -- fnGetValidaSolicitudEnGestion
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaSolicitudEnGestion
    (
	  	inu_codUsuario      IN VDIR_COLA_SOLICITUD.COD_USUARIO%TYPE
    )
	RETURN NUMBER IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_SOLICITUD
	 Caso de Uso : 
	 Descripci�n : Valida si el usuario actual tiene una solicitud en gesti�n
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-02-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:	  
	   inu_codUsuario       C�digo del usuario 	   
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		lnu_codAfiliacion VDIR_COLA_SOLICITUD.COD_AFILIACION%TYPE;  		
	
	BEGIN 	 
	 
	    BEGIN 
		
			SELECT coso.cod_afiliacion 
			  INTO lnu_codAfiliacion       
			  FROM VDIR_COLA_SOLICITUD coso,
			       VDIR_AFILIACION     vafi
			 WHERE coso.cod_afiliacion = vafi.cod_afiliacion 
			   AND vafi.cod_estado     = 5
			   AND coso.cod_usuario    = inu_codUsuario; 						
			
		EXCEPTION WHEN OTHERS THEN  
			lnu_codAfiliacion := NULL;
		END;
			
		RETURN lnu_codAfiliacion;
	 
	END fnGetValidaSolicitudEnGestion;	
			
END VDIR_PACK_CONSULTA_SOLICITUD;
/

CREATE OR REPLACE PACKAGE VDIR_PACK_CONSULTA_TARIFAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_TARIFAS
 Caso de Uso : 
 Descripci�n : Procesos para la consulta las tarifas - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 28-01-2019 
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
    -- fnGetTarifas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTarifas RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetTipoTarifas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTipoTarifas RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetProgramasPlan
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProgramasPlan 
	(
		inu_codPlan IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
	)
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetGeneros
    -- ---------------------------------------------------------------------
    FUNCTION fnGetGeneros RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetCondicionTarifa
    -- ---------------------------------------------------------------------
    FUNCTION fnGetCondicionTarifa RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetNumUsuarios
    -- ---------------------------------------------------------------------
    FUNCTION fnGetNumUsuarios RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetTarifa
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTarifa 
	(
		inu_codTarifa IN VDIR_TARIFA.COD_TARIFA%TYPE
	)
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetExisteTarifa
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExisteTarifa 
	(
		ivc_codTarifaMP  IN VDIR_TARIFA.COD_TARIFA_MP%TYPE
	)
	RETURN VDIR_TARIFA.COD_TARIFA%TYPE;
	  
END VDIR_PACK_CONSULTA_TARIFAS;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_CONSULTA_TARIFAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_TARIFAS
 Caso de Uso : 
 Descripci�n : Procesos para la consulta las tarifas - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 28-01-2019 
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 
	-- ---------------------------------------------------------------------
    -- fnGetTarifas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTarifas RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de los datos de los productos 
	               asociados a las tarifas
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT tari.cod_tarifa,
		       prod.des_producto,
			   prog.des_programa,
			   vpla.des_plan,
			   vtta.des_tipo_tarifa,
			   TO_CHAR(tari.fecha_vige_inicial, 'dd/mm/yyyy') fecha_vige_inicial,
			   TO_CHAR(tari.fecha_vige_fin, 'dd/mm/yyyy') fecha_vige_fin,
			   vest.des_estado,
			   cota.des_condicion_tarifa,
			   vsex.des_sexo
		  FROM VDIR_TARIFA           tari,
		       VDIR_PLAN_PROGRAMA    plpr,
		       VDIR_PROGRAMA         prog,
		       VDIR_PRODUCTO         prod,
			   VDIR_PLAN             vpla,
			   VDIR_ESTADO           vest,
			   VDIR_TIPO_TARIFA      vtta,
			   VDIR_CONDICION_TARIFA cota,
			   VDIR_SEXO             vsex
	 	 WHERE tari.cod_plan_programa     = plpr.cod_plan_programa
		    AND plpr.cod_programa         = prog.cod_programa
			AND plpr.cod_plan             = vpla.cod_plan
			AND prog.cod_producto         = prod.cod_producto
			AND tari.cod_estado           = vest.cod_estado
			AND tari.cod_tipo_tarifa      = vtta.cod_tipo_tarifa
			AND tari.cod_condicion_tarifa = cota.cod_condicion_tarifa
			AND tari.cod_sexo             = vsex.cod_sexo(+)
			AND vest.cod_estado			  iN (1,2);
		   
		RETURN ltc_datos;
	 
	END fnGetTarifas;
	
	-- ---------------------------------------------------------------------
    -- fnGetTipoTarifas
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTipoTarifas RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de los tipos de tarifas
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vtta.cod_tipo_tarifa,
		       vtta.des_tipo_tarifa
		  FROM VDIR_TIPO_TARIFA   vtta			   
	 	 WHERE vtta.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetTipoTarifas;
	
	-- ---------------------------------------------------------------------
    -- fnGetProgramasPlan
    -- ---------------------------------------------------------------------
    FUNCTION fnGetProgramasPlan 
	(
		inu_codPlan IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
	)
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de los productos y programas por plan
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT plpr.cod_plan_programa,
		       prod.des_producto||' - '||prog.des_programa des_plan_programa
		  FROM VDIR_PLAN_PROGRAMA plpr,
		       VDIR_PROGRAMA      prog,
			   VDIR_PRODUCTO      prod
	 	 WHERE plpr.cod_programa = prog.cod_programa
		   AND prog.cod_producto = prod.cod_producto
		   AND plpr.cod_estado   = 1
		   AND plpr.cod_plan     = inu_codPlan;
		   
		RETURN ltc_datos;
	 
	END fnGetProgramasPlan;
	
	-- ---------------------------------------------------------------------
    -- fnGetGeneros
    -- ---------------------------------------------------------------------
    FUNCTION fnGetGeneros RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de los tipos de generos
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vsex.cod_sexo,
		       vsex.des_sexo
		  FROM VDIR_SEXO vsex			   
	 	 WHERE vsex.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetGeneros;
	
	-- ---------------------------------------------------------------------
    -- fnGetCondicionTarifa
    -- ---------------------------------------------------------------------
    FUNCTION fnGetCondicionTarifa RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de los tipos condicion por tarifa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vcot.cod_condicion_tarifa,
		       vcot.des_condicion_tarifa
		  FROM VDIR_CONDICION_TARIFA vcot			   
	 	 WHERE vcot.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetCondicionTarifa;
	
	-- ---------------------------------------------------------------------
    -- fnGetNumUsuarios
    -- ---------------------------------------------------------------------
    FUNCTION fnGetNumUsuarios RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de los n�meros de usuarios por tarifa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vnut.cod_num_usuarios_tarifa,
		       vnut.des_num_usuarios_tarifa
		  FROM VDIR_NUM_USUARIOS_TARIFA vnut			   
	 	 WHERE vnut.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetNumUsuarios;
	
	-- ---------------------------------------------------------------------
    -- fnGetTarifa
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTarifa 
	(
		inu_codTarifa IN VDIR_TARIFA.COD_TARIFA%TYPE
	)
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna los datos de la tarifa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT tari.cod_tarifa,
		       tari.cod_plan_programa,
			   plpr.cod_plan,
			   tari.cod_estado,
			   tari.cod_tipo_tarifa,
			   tari.valor,
			   TO_CHAR(tari.fecha_vige_inicial , 'dd/mm/yyyy') fecha_vige_inicial,
			   TO_CHAR(tari.fecha_vige_fin, 'dd/mm/yyyy') fecha_vige_fin,
			   tari.cod_condicion_tarifa,
			   tari.cod_num_usuarios_tarifa,
			   tari.cod_sexo,
			   tari.edad_inicial,
			   tari.edad_final,
			   tari.cod_tarifa_mp
		  FROM VDIR_TARIFA        tari,
		       VDIR_PLAN_PROGRAMA plpr
	 	 WHERE tari.cod_plan_programa = plpr.cod_plan_programa 
		   AND tari.cod_tarifa        = inu_codTarifa;
		   
		RETURN ltc_datos;
	 
	END fnGetTarifa;
	
	-- ---------------------------------------------------------------------
    -- fnGetExisteTarifa
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExisteTarifa 
	(
		ivc_codTarifaMP  IN VDIR_TARIFA.COD_TARIFA_MP%TYPE
	)
	RETURN VDIR_TARIFA.COD_TARIFA%TYPE IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnolog�a Inform�tica Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_TARIFAS
	 Caso de Uso : 
	 Descripci�n : Retorna el c�digo de la tarifa si existe
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Par�metros :     Descripci�n:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificaci�n
	 ----------------------------------------------------------------- */
	 
		lnu_codTarifa VDIR_TARIFA.COD_TARIFA%TYPE;
	
	BEGIN 
	 
		BEGIN 
		
			SELECT cod_tarifa INTO lnu_codTarifa       
              FROM VDIR_TARIFA
             WHERE UPPER(COD_TARIFA_MP) = UPPER(ivc_codTarifaMP)
			   AND cod_estado = 1;
			   
		EXCEPTION WHEN OTHERS THEN  
			lnu_codTarifa := NULL;
		END;       
			   
		RETURN lnu_codTarifa;
	 
	END fnGetExisteTarifa;	
		
END VDIR_PACK_CONSULTA_TARIFAS;
/

CREATE OR REPLACE PACKAGE VDIR_PACK_CONSULTA_USUARIOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_USUARIOS
 Caso de Uso : 
 Descripción : Procesos para la consulta los usuarios - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 29-01-2019 
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
 
	-- ---------------------------------------------------------------------
    -- fnGetUsuarios
    -- ---------------------------------------------------------------------
    FUNCTION fnGetUsuarios RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetTiposIdentificacion
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTiposIdentificacion RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetPerfiles
    -- ---------------------------------------------------------------------
    FUNCTION fnGetPerfiles RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetUsuario
    -- ---------------------------------------------------------------------
    FUNCTION fnGetUsuario 
	(
		inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE,
		inu_codPersona IN VDIR_USUARIO.COD_PERSONA%TYPE,
		inu_codPerfil  IN VDIR_ROL_USUARIO.COD_ROL%TYPE
	)
	RETURN type_cursor;
	
	-- ---------------------------------------------------------------------
    -- fnGetExistePersona
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExistePersona 
	(
		inu_codTipoId IN VDIR_PERSONA.COD_TIPO_IDENTIFICACION%TYPE,
        inu_nroId     IN VDIR_PERSONA.NUMERO_IDENTIFICACION%TYPE
	)
	RETURN VDIR_PERSONA.COD_PERSONA%TYPE;
	
	-- ---------------------------------------------------------------------
    -- fnGetExisteLogin
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExisteLogin 
	(
		ivc_login  IN VDIR_USUARIO.LOGIN%TYPE
	)
	RETURN VDIR_USUARIO.COD_USUARIO%TYPE;
	
	-- ---------------------------------------------------------------------
    -- fnGetExistePerfil
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExistePerfil 
	(
		inu_codUsuario   IN VDIR_ROL_USUARIO.COD_USUARIO%TYPE,
        inu_codPerfil    IN VDIR_ROL_USUARIO.COD_ROL%TYPE
	)
	RETURN VDIR_ROL_USUARIO.COD_ROL_USUARIO%TYPE;
	
	-- ---------------------------------------------------------------------
    -- fnGetValidaClaveActual
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaClaveActual 
	(
		inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE,
        ivc_clave      IN VDIR_USUARIO.CLAVE%TYPE
	)
	RETURN VDIR_USUARIO.COD_USUARIO%TYPE;
			  
END VDIR_PACK_CONSULTA_USUARIOS;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_CONSULTA_USUARIOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_CONSULTA_USUARIOS
 Caso de Uso : 
 Descripción : Procesos para la consulta los usuarios - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 29-01-2019 
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */
 
	-- ---------------------------------------------------------------------
    -- fnGetUsuarios
    -- ---------------------------------------------------------------------
    FUNCTION fnGetUsuarios RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los usuarios
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 29-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT tiid.des_abr,
			   pers.numero_identificacion,
			   pers.nombre_1,
			   pers.apellido_1,
			   usua.login,
			   pers.email,
			   vrol.des_rol,
			   pers.cod_persona,
			   usua.cod_usuario,
			   vrol.cod_rol
		  FROM VDIR_USUARIO             usua,
		       VDIR_PERSONA             pers,
			   VDIR_TIPO_IDENTIFICACION tiid,
			   VDIR_ROL_USUARIO         rous,
			   VDIR_ROL                 vrol
	 	 WHERE usua.cod_persona             = pers.cod_persona
		   AND pers.cod_tipo_identificacion = tiid.cod_tipo_identificacion
		   AND usua.cod_usuario             = rous.cod_usuario
		   AND rous.cod_rol                 = vrol.cod_rol
		   AND rous.cod_rol                 <> 1;
		   
		RETURN ltc_datos;
	 
	END fnGetUsuarios;
	
	-- ---------------------------------------------------------------------
    -- fnGetTiposIdentificacion
    -- ---------------------------------------------------------------------
    FUNCTION fnGetTiposIdentificacion RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los tipos de identificación
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 30-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT tiid.cod_tipo_identificacion,
		       tiid.des_tipo_identificacion
		  FROM VDIR_TIPO_IDENTIFICACION tiid			   
	 	 WHERE tiid.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetTiposIdentificacion;
	
	-- ---------------------------------------------------------------------
    -- fnGetPerfiles
    -- ---------------------------------------------------------------------
    FUNCTION fnGetPerfiles RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna los datos de los perfiles
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 30-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT vrol.cod_rol,
		       vrol.des_rol
		  FROM VDIR_ROL vrol			   
	 	 WHERE vrol.cod_estado = 1;
		   
		RETURN ltc_datos;
	 
	END fnGetPerfiles;
	
	-- ---------------------------------------------------------------------
    -- fnGetUsuario
    -- ---------------------------------------------------------------------
    FUNCTION fnGetUsuario 
	(
		inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE,
		inu_codPersona IN VDIR_USUARIO.COD_PERSONA%TYPE,
		inu_codPerfil  IN VDIR_ROL_USUARIO.COD_ROL%TYPE
	)
	RETURN type_cursor IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna los datos del usuario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		ltc_datos type_cursor;
	
	BEGIN 
	 
		  OPEN ltc_datos FOR
		SELECT pers.cod_tipo_identificacion,
			   pers.numero_identificacion,
			   pers.nombre_1,
			   pers.nombre_2,
			   pers.apellido_1,
			   pers.apellido_2,
			   pers.email,
			   pers.telefono,
			   rous.cod_rol,
			   usua.login,
			   usua.cod_estado,
			   pers.cod_persona,
			   usua.cod_usuario,
			   usua.clave
		  FROM VDIR_USUARIO      usua,
		       VDIR_PERSONA      pers,
			   VDIR_ROL_USUARIO  rous
	 	 WHERE usua.cod_persona  = pers.cod_persona
		   AND usua.cod_usuario  = rous.cod_usuario
		   AND pers.cod_persona  = inu_codPersona
		   AND usua.cod_usuario  = inu_codUsuario
		   AND rous.cod_rol      = inu_codPerfil;
		   
		RETURN ltc_datos;
	 
	END fnGetUsuario;
	
	-- ---------------------------------------------------------------------
    -- fnGetExistePersona
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExistePersona 
	(
		inu_codTipoId IN VDIR_PERSONA.COD_TIPO_IDENTIFICACION%TYPE,
        inu_nroId     IN VDIR_PERSONA.NUMERO_IDENTIFICACION%TYPE
	)
	RETURN VDIR_PERSONA.COD_PERSONA%TYPE IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna el código de la persona
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		lnu_codPersona VDIR_PERSONA.COD_PERSONA%TYPE;
	
	BEGIN 
	 
		BEGIN 
		
			SELECT cod_persona 
			  INTO lnu_codPersona   
			  FROM VDIR_PERSONA 
			 WHERE numero_identificacion   = inu_nroId 
			   AND cod_tipo_identificacion = inu_codTipoId;
			   
		EXCEPTION WHEN OTHERS THEN  
			lnu_codPersona := NULL;
		END;       
			   
		RETURN lnu_codPersona;
	 
	END fnGetExistePersona;
	
	-- ---------------------------------------------------------------------
    -- fnGetExisteLogin
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExisteLogin 
	(
		ivc_login  IN VDIR_USUARIO.LOGIN%TYPE
	)
	RETURN VDIR_USUARIO.COD_USUARIO%TYPE IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna el código del usuario si el login existe
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		lnu_codUsuario VDIR_USUARIO.COD_USUARIO%TYPE;
	
	BEGIN 
	 
		BEGIN 
		
			SELECT cod_usuario INTO lnu_codUsuario       
              FROM VDIR_USUARIO
             WHERE UPPER(login) = UPPER(ivc_login);
			   
		EXCEPTION WHEN OTHERS THEN  
			lnu_codUsuario := NULL;
		END;       
			   
		RETURN lnu_codUsuario;
	 
	END fnGetExisteLogin;
	
	-- ---------------------------------------------------------------------
    -- fnGetExistePerfil
    -- ---------------------------------------------------------------------
    FUNCTION fnGetExistePerfil 
	(
		inu_codUsuario   IN VDIR_ROL_USUARIO.COD_USUARIO%TYPE,
        inu_codPerfil    IN VDIR_ROL_USUARIO.COD_ROL%TYPE
	)
	RETURN VDIR_ROL_USUARIO.COD_ROL_USUARIO%TYPE IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna el código del usuario asocido al rol
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		lnu_codRolUsuario VDIR_ROL_USUARIO.COD_ROL_USUARIO%TYPE;
	
	BEGIN 
	 
		BEGIN 
		
			SELECT cod_rol_usuario INTO lnu_codRolUsuario       
              FROM VDIR_ROL_USUARIO
             WHERE cod_usuario = inu_codUsuario
			   AND cod_rol     = inu_codPerfil;
			   
		EXCEPTION WHEN OTHERS THEN  
			lnu_codRolUsuario := NULL;
		END;       
			   
		RETURN lnu_codRolUsuario;
	 
	END fnGetExistePerfil;
	
	-- ---------------------------------------------------------------------
    -- fnGetValidaClaveActual
    -- ---------------------------------------------------------------------
    FUNCTION fnGetValidaClaveActual 
	(
		inu_codUsuario IN VDIR_USUARIO.COD_USUARIO%TYPE,
        ivc_clave      IN VDIR_USUARIO.CLAVE%TYPE
	)
	RETURN VDIR_USUARIO.COD_USUARIO%TYPE IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_CONSULTA_USUARIOS
	 Caso de Uso : 
	 Descripción : Retorna el código del usuario si la clave es correcta
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 01-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		lnu_codUsuario VDIR_USUARIO.COD_USUARIO%TYPE;
	
	BEGIN 
	 
		BEGIN 
		
			SELECT cod_usuario INTO lnu_codUsuario       
              FROM VDIR_USUARIO
             WHERE cod_usuario = inu_codUsuario
			   AND clave       = ivc_clave;
			   
		EXCEPTION WHEN OTHERS THEN  
			lnu_codUsuario := NULL;
		END;       
			   
		RETURN lnu_codUsuario;
	 
	END fnGetValidaClaveActual;
		
END VDIR_PACK_CONSULTA_USUARIOS;
/

create or replace PACKAGE VDIR_PACK_ENVIAR_EMAIL AS 

  FUNCTION send_email(REMITE IN VARCHAR2,DESTINO IN VARCHAR2, ASUNTO IN VARCHAR2, MENSAJE IN VARCHAR2,PUERTO IN NUMBER,SERVIDOR IN VARCHAR2,USUARIO IN VARCHAR2,CLAVE IN VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION send_email2(REMITE IN VARCHAR2,DESTINO IN VARCHAR2, ASUNTO IN VARCHAR2, MENSAJE IN VARCHAR2,PUERTO IN NUMBER,SERVIDOR IN VARCHAR2,USUARIO IN VARCHAR2,CLAVE IN VARCHAR2, MENSAJE2 IN VARCHAR2) RETURN VARCHAR2;
   
  PROCEDURE add_destinatatios(P_MAIL_CONN IN OUT UTL_SMTP.CONNECTION,P_LIST IN VARCHAR2);   
  

END VDIR_PACK_ENVIAR_EMAIL;

/

create or replace PACKAGE BODY VDIR_PACK_ENVIAR_EMAIL AS

  FUNCTION send_email(REMITE IN VARCHAR2,DESTINO IN VARCHAR2, ASUNTO IN VARCHAR2, MENSAJE IN VARCHAR2,PUERTO IN NUMBER,SERVIDOR IN VARCHAR2,USUARIO IN VARCHAR2,CLAVE IN VARCHAR2)
RETURN VARCHAR2
AS                                                         
    remitente varchar2(100);                                                    
    conn_mail UTL_SMTP.connection;                                              
    l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*='; 
    varData BLOB;    
    
  BEGIN     
                                          
    if (remite is null) then                                                    
      remitente := 'noresponder@coomeva.com.co';                                   
    else
      remitente := remite;
    end if;                                                                     
                                                                                
    conn_mail := UTL_SMTP.open_connection(servidor, puerto);     
    UTL_SMTP.helo(conn_mail, servidor);                                         
    UTL_SMTP.mail(conn_mail, remitente);  
    add_destinatatios(conn_mail,destino);
   -- UTL_SMTP.rcpt(conn_mail, destino);                                          
                                                                                
    UTL_SMTP.open_data(conn_mail);                                              
                                                                                
    UTL_SMTP.write_data(conn_mail, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.CRLF);                                                     
                                                                                
    UTL_SMTP.write_data(conn_mail, 'To: ' || destino || UTL_TCP.CRLF);          
    UTL_SMTP.write_data(conn_mail, 'From: ' || remitente || UTL_TCP.CRLF);      
    UTL_SMTP.write_data(conn_mail, 'Subject: ' || asunto || UTL_TCP.CRLF);      
    UTL_SMTP.write_data(conn_mail, 'Reply-To: ' || remitente || UTL_TCP.CRLF);  
    
    
    UTL_smtp.write_data(conn_mail, 'MIME-Version: ' || '1.0' || UTL_TCP.CRLF);
    UTL_smtp.write_data(conn_mail, 'Content-Type: ' || 'text/plain; charset=iso-8859-15' || UTL_TCP.CRLF);
    UTL_SMTP.write_data(conn_mail, 'Content-Type:'|| 'text/html; ' || UTL_TCP.crlf);
    UTL_smtp.write_data(conn_mail, 'Content-Transfer-Encoding: ' || '8bit' || UTL_TCP.CRLF);
    
    -- Deja un espacio para separar el cuerpo de la cabecera
    UTL_SMTP.write_data(conn_mail, UTL_TCP.CRLF);
    varData := utl_raw.cast_to_raw(MENSAJE); 
    UTL_smtp.write_raw_data(conn_mail, varData);
    UTL_SMTP.close_data(conn_mail);
    UTL_SMTP.quit(conn_mail);

  RETURN 'OK';
  
  END send_email;
  
  -----------------------------------------------------------
  
  FUNCTION send_email2(REMITE IN VARCHAR2,DESTINO IN VARCHAR2, ASUNTO IN VARCHAR2, MENSAJE IN VARCHAR2,PUERTO IN NUMBER,SERVIDOR IN VARCHAR2,USUARIO IN VARCHAR2,CLAVE IN VARCHAR2,MENSAJE2 IN VARCHAR2)
RETURN VARCHAR2
AS                                                         
    remitente varchar2(100);                                                    
    conn_mail UTL_SMTP.connection;                                              
    l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*='; 
    varData BLOB;    
    
  BEGIN       
                                          
    if (remite is null) then                                                    
      remitente := 'noresponder@coomeva.com.co';                                   
    else
      remitente := remite;
    end if;                                                                     
                                                                                
    conn_mail := UTL_SMTP.open_connection(servidor, puerto);     
    UTL_SMTP.helo(conn_mail, servidor);                                         
    UTL_SMTP.mail(conn_mail, remitente);  
    add_destinatatios(conn_mail,destino);
   -- UTL_SMTP.rcpt(conn_mail, destino);                                          
                                                                                
    UTL_SMTP.open_data(conn_mail);                                              
                                                                                
    UTL_SMTP.write_data(conn_mail, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.CRLF);                                                     
                                                                                
    UTL_SMTP.write_data(conn_mail, 'To: ' || destino || UTL_TCP.CRLF);          
    UTL_SMTP.write_data(conn_mail, 'From: ' || remitente || UTL_TCP.CRLF);      
    UTL_SMTP.write_data(conn_mail, 'Subject: ' || asunto || UTL_TCP.CRLF);      
    UTL_SMTP.write_data(conn_mail, 'Reply-To: ' || remitente || UTL_TCP.CRLF);  
    
    
    UTL_smtp.write_data(conn_mail, 'MIME-Version: ' || '1.0' || UTL_TCP.CRLF);
    UTL_smtp.write_data(conn_mail, 'Content-Type: ' || 'text/plain; charset=iso-8859-15' || UTL_TCP.CRLF);
    UTL_SMTP.write_data(conn_mail, 'Content-Type:'|| 'text/html; ' || UTL_TCP.crlf);
    UTL_smtp.write_data(conn_mail, 'Content-Transfer-Encoding: ' || '8bit' || UTL_TCP.CRLF);
    
    -- Deja un espacio para separar el cuerpo de la cabecera
    UTL_SMTP.write_data(conn_mail, UTL_TCP.CRLF);
    varData := utl_raw.cast_to_raw(MENSAJE||MENSAJE2); 
    UTL_smtp.write_raw_data(conn_mail, varData);
    UTL_SMTP.close_data(conn_mail);
    UTL_SMTP.quit(conn_mail);

  RETURN 'OK';
  
  END send_email2;
 --------------------------------------------------------------------------------------------------------- 
  
  PROCEDURE add_destinatatios(P_MAIL_CONN IN OUT UTL_SMTP.CONNECTION,P_LIST IN VARCHAR2) 
  AS 
  
  l_tab NEXOS_string_api.t_split_array;
  BEGIN
  
   IF (TRIM(p_list) IS NOT NULL) THEN
      l_tab := NEXOS_string_api.split_text(p_list);
      FOR i IN 1 .. l_tab.COUNT LOOP
        UTL_SMTP.rcpt(p_mail_conn, TRIM(l_tab(i)));
      END LOOP;
   END IF;  
  
  END;
  
END VDIR_PACK_ENVIAR_EMAIL;

/

create or replace PACKAGE           "VDIR_PACK_INICIO_SESSION" AS 

  ----------------------------------------------- FUNCION PARA TRAER DATOS DEL TIPO DE DOCUMENTO  
  FUNCTION VDIR_FN_GET_TIPO_DOCUMENTO RETURN sys_refcursor;

   ----------------------------------------------- FUNCION PARA TRAER DATOS DEL SEXO  
  FUNCTION VDIR_FN_GET_SEXO RETURN sys_refcursor;

  ------------------------------------------------ PROCEDIMIENTO PARA GUARDAR EL USUARIO  
  PROCEDURE VDIR_SP_GUARDAR_USUARIO (
                             p_tipo_identificacion IN VDIR_PERSONA.COD_TIPO_IDENTIFICACION%TYPE,                            
                             p_numero_identificacion IN VDIR_PERSONA.NUMERO_IDENTIFICACION%TYPE,
                             p_nombre_1 IN VDIR_PERSONA.NOMBRE_1%TYPE,
                             p_nombre_2 IN VDIR_PERSONA.NOMBRE_2%TYPE,
                             p_apellido_1 IN VDIR_PERSONA.APELLIDO_1%TYPE,
                             p_apellido_2 IN VDIR_PERSONA.APELLIDO_2%TYPE,
                             p_fecha_nacimiento IN DATE, 
                             p_cod_sexo IN VDIR_PERSONA.COD_SEXO%TYPE,
                             p_telefono IN VDIR_PERSONA.TELEFONO%TYPE,
                             p_celular IN VDIR_PERSONA.CELULAR%TYPE,
                             p_email IN VDIR_PERSONA.EMAIL%TYPE,
                             p_usuario IN VDIR_USUARIO.LOGIN%TYPE,
                             p_clave IN VDIR_USUARIO.CLAVE%TYPE,
                             p_tipo_persona IN VDIR_TIPO_PERSONA.COD_TIPO_PERSONA%TYPE,
                             p_plan IN VDIR_PLAN.COD_PLAN%TYPE,
                             p_cod_estado IN VDIR_ESTADO.COD_ESTADO%TYPE,                             
                             p_respuesta OUT VARCHAR2                            
                             );  

 ------------------------------------------------ PROCEDIMIENTO PARA ACTUALIZAR EL CODIGO DE SEGURIDAD PARA CAMBIAR LA CLAVE

 PROCEDURE VDIR_SP_ACTUALIZAR_COD_SEG(p_identificacacion IN VDIR_PERSONA.numero_identificacion%TYPE,p_codigo_seguridad OUT VDIR_USUARIO.CODIGO_SEGURIDAD%TYPE);

 ------------------------------------------------ PROCEDIMIENTO PARA ACTUALIZAR LA CLAVE DEL USUARIO
 PROCEDURE VDIR_SP_CAMBIAR_CLAVE(p_identificacacion IN VDIR_PERSONA.numero_identificacion%TYPE,p_codigo_seguridad IN VDIR_USUARIO.CODIGO_SEGURIDAD%TYPE,p_clave IN VDIR_USUARIO.CLAVE%TYPE,p_respuesta OUT VARCHAR2);

  ------------------------------------------------FUNCION PARA TRAER LOS DAOS DE LA PERSONA,USUAIRO Y ROLES 
 FUNCTION VDIR_FN_GET_DATOS_USUARIO(p_login IN vdir_usuario.login%TYPE,p_clave IN vdir_usuario.clave%TYPE) RETURN sys_refcursor;

 -------------------------------------------------FUNCION PARA TRAER LOS ROLES QUE TIENE UNA PERSONA 
 FUNCTION VDIR_FN_GET_ROLES_PERSONA(p_cod_user IN vdir_usuario.cod_usuario%TYPE) RETURN VARCHAR2;


 ------------------------------------------------ PROCEDIMIENTO PARA INSERTAR EL LOG DE USUARIO
 PROCEDURE VDIR_SP_INSERT_LOG_USER(p_login IN VDIR_USUARIO.login%TYPE,p_ip IN VARCHAR2,p_navegador IN VARCHAR2);

 ------------------------------------------------ FUNCION PARA TRAER LAS IMAGENES DE LAS PROMOCIONES DE LOS PRODUCTOS 
 FUNCTION VDIR_FN_GET_DATOS_IMG_PROMO(p_codigo_plan IN vdir_plan.cod_plan%TYPE DEFAULT NULL) RETURN sys_refcursor;

 ------------------------------------------------ FUNCION PARA ENVIAR EMAILS 
 FUNCTION VDIR_FN_SEND_EMAIL(p_to IN VARCHAR2,p_asunto IN VARCHAR2, p_mensaje IN VARCHAR2,p_mensaje2 IN VARCHAR2 DEFAULT '')  RETURN VARCHAR2;

 /*---------------------------------------------------------------------
  fn_get_keyPagesNot: Traer el key calss de las paginas a las que el usuario no tiene acceso
  ---------------------------------------------------------------------- */
 FUNCTION fn_get_keyPagesNot
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN VARCHAR2;

END VDIR_PACK_INICIO_SESSION;

/

create or replace PACKAGE BODY           "VDIR_PACK_INICIO_SESSION" AS

  FUNCTION VDIR_FN_GET_TIPO_DOCUMENTO RETURN sys_refcursor AS
  vl_cursor  sys_refcursor;
  BEGIN

     OPEN vl_cursor
       FOR 
        SELECT
            cod_tipo_identificacion as codigo,
            des_tipo_identificacion as nombre,    
            des_abr as nombre_abr
        FROM
            vdir_tipo_identificacion
        WHERE
          cod_estado = 1
          ORDER BY 2;

    RETURN vl_cursor;
  END VDIR_FN_GET_TIPO_DOCUMENTO;

  -------------------------------------------------------FUNCION PARA TRAER DATOS DEL SEXO

  FUNCTION VDIR_FN_GET_SEXO RETURN sys_refcursor AS
  vl_cursor  sys_refcursor;
  BEGIN

     OPEN vl_cursor
       FOR 
        SELECT
            cod_sexo as codigo,
            des_sexo as nombre,    
            des_abr as nombre_abr
        FROM
            vdir_sexo
        WHERE
          cod_estado = 1
          ORDER BY 2;

    RETURN vl_cursor;
  END VDIR_FN_GET_SEXO;


   ------------------------------------------------ PROCEDIMIENTO PARA GUARDAR EL USUARIO  
  PROCEDURE VDIR_SP_GUARDAR_USUARIO(
                             p_tipo_identificacion IN VDIR_PERSONA.COD_TIPO_IDENTIFICACION%TYPE,                            
                             p_numero_identificacion IN VDIR_PERSONA.NUMERO_IDENTIFICACION%TYPE,
                             p_nombre_1 IN VDIR_PERSONA.NOMBRE_1%TYPE,
                             p_nombre_2 IN VDIR_PERSONA.NOMBRE_2%TYPE,
                             p_apellido_1 IN VDIR_PERSONA.APELLIDO_1%TYPE,
                             p_apellido_2 IN VDIR_PERSONA.APELLIDO_2%TYPE,
                             p_fecha_nacimiento IN DATE, 
                             p_cod_sexo IN VDIR_PERSONA.COD_SEXO%TYPE,
                             p_telefono IN VDIR_PERSONA.TELEFONO%TYPE,
                             p_celular IN VDIR_PERSONA.CELULAR%TYPE,
                             p_email IN VDIR_PERSONA.EMAIL%TYPE,
                             p_usuario IN VDIR_USUARIO.LOGIN%TYPE,
                             p_clave IN VDIR_USUARIO.CLAVE%TYPE,
                             p_tipo_persona IN VDIR_TIPO_PERSONA.COD_TIPO_PERSONA%TYPE,
                             p_plan IN VDIR_PLAN.COD_PLAN%TYPE,
                             p_cod_estado IN VDIR_ESTADO.COD_ESTADO%TYPE,                             
                             p_respuesta OUT VARCHAR2 
                             )
 IS

  vl_sec_persona vdir_persona.cod_persona%TYPE;
  vl_sec_usuario vdir_usuario.cod_usuario%TYPE;
  vl_tipo_pesona vdir_tipo_persona.cod_tipo_persona%TYPE;

 BEGIN
     vl_tipo_pesona := 2;
     p_respuesta := 'Operaci&oacute;n realizada correctamente.';
     --se valida si la persona existe con su numero de cedula y el tipo de identificacion 

	 vl_sec_persona := VDIR_PACK_CONSULTA_USUARIOS.fnGetExistePersona(p_tipo_identificacion,p_numero_identificacion);       


   -- si la paersona no existe se inserta  
   IF(vl_sec_persona IS NULL)THEN

           SELECT VDIR_SEQ_PERSONA.NEXTVAL INTO vl_sec_persona FROM DUAL ;

           INSERT INTO vdir_persona (
            cod_persona,
            cod_tipo_identificacion,
            numero_identificacion,
            nombre_1,
            nombre_2,
            apellido_1,
            apellido_2,
            fecha_nacimiento,
            telefono,
            celular,
            email,            
            cod_sexo,           
            cod_estado

        ) VALUES (
           vl_sec_persona,
           p_tipo_identificacion,
           p_numero_identificacion,
           p_nombre_1,
           p_nombre_2,
           p_apellido_1,
           p_apellido_2 ,
           p_fecha_nacimiento,                                     
           p_telefono,
           p_celular,
           p_email ,
           p_cod_sexo ,
           p_cod_estado            
        );
   ELSE
       UPDATE vdir_persona
        SET
            cod_tipo_identificacion = p_tipo_identificacion,
            numero_identificacion = p_numero_identificacion,
            nombre_1 = p_nombre_1,
            nombre_2 = p_nombre_2,
            apellido_1 = p_apellido_1,
            apellido_2 = p_apellido_2,
            fecha_nacimiento = p_fecha_nacimiento,
            telefono = p_telefono,
            celular = p_celular,
            email = p_email,            
            cod_sexo = p_cod_sexo,           
            cod_estado = p_cod_estado
        WHERE
            cod_persona = vl_sec_persona;

   END IF;

   -- se inserta el tipo de persona al que pertence el usuario   
   MERGE INTO vdir_persona_tipoper tipop
   USING (
           SELECT
            vl_sec_persona AS cod_persona,
            p_tipo_persona AS cod_tipo_persona
          FROM
             DUAL   
      ) tipop2
   ON (tipop.cod_persona = tipop2.cod_persona AND tipop.cod_tipo_persona = tipop2.cod_tipo_persona)   
   WHEN NOT MATCHED THEN   
    INSERT (tipop.cod_persona_tipoper, tipop.cod_persona,tipop.cod_tipo_persona)
     VALUES (VDIR_SEQ_PERSONA_TIPOPER.NEXTVAL,tipop2.cod_persona, tipop2.cod_tipo_persona);
    
   -- se inserta al usuario como tipo persona beneficiario  
   MERGE INTO vdir_persona_tipoper tipop
   USING (
           SELECT
            vl_sec_persona AS cod_persona,
            vl_tipo_pesona AS cod_tipo_persona
          FROM
             DUAL   
      ) tipop2
   ON (tipop.cod_persona = tipop2.cod_persona AND tipop.cod_tipo_persona = tipop2.cod_tipo_persona)   
   WHEN NOT MATCHED THEN   
    INSERT (tipop.cod_persona_tipoper, tipop.cod_persona,tipop.cod_tipo_persona)
     VALUES (VDIR_SEQ_PERSONA_TIPOPER.NEXTVAL,tipop2.cod_persona, tipop2.cod_tipo_persona);       


    --Se valida si el login de usuario existe
	vl_sec_usuario := VDIR_PACK_CONSULTA_USUARIOS.fnGetExisteLogin(p_usuario);


    IF(vl_sec_usuario IS NULL)THEN

        SELECT VDIR_SEQ_USUARIO.NEXTVAL INTO vl_sec_usuario FROM DUAL ; 

        INSERT INTO vdir_usuario (
            cod_usuario,
            login,
            clave,
            cod_persona,
            cod_estado,
            cod_plan
        ) VALUES (
           vl_sec_usuario,
           p_usuario,
           p_clave,
           vl_sec_persona,
           p_cod_estado,
           p_plan
        );
    ELSE

        UPDATE vdir_usuario
            SET
                login = p_usuario,
                clave = p_clave,
                cod_persona = vl_sec_persona,
                cod_estado = p_cod_estado,
                cod_plan = p_plan
        WHERE
            cod_usuario = vl_sec_usuario;

    END IF;

     -- se enlaza el rol con el usuario   
   MERGE INTO vdir_rol_usuario rolusu
   USING (
            SELECT
               vl_sec_usuario AS cod_usuario,
               1   AS cod_rol 
            FROM
                DUAL

      ) rolusu2
   ON (rolusu.cod_usuario = rolusu2.cod_usuario AND rolusu.cod_rol = rolusu2.cod_rol)   
   WHEN NOT MATCHED THEN INSERT (rolusu.cod_rol_usuario, rolusu.cod_usuario,rolusu.cod_rol)
     VALUES (VDIR_SEQ_ROL_USUARIO.NEXTVAL,rolusu2.cod_usuario,rolusu2.cod_rol);


  COMMIT;

  EXCEPTION 
   WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, 'error VDIR_SP_GUARDAR_USUARIO.');
     p_respuesta := 'Ocurrio un error en la base de datos.';
   ROLLBACK;

 END VDIR_SP_GUARDAR_USUARIO;

 ------------------------------------------------ PROCEDIMIENTO PARA ACTUALIZAR EL CODIGO DE SEGURIDAD PARA CAMBIAR LA CLAVE

 PROCEDURE VDIR_SP_ACTUALIZAR_COD_SEG(p_identificacacion IN VDIR_PERSONA.numero_identificacion%TYPE,p_codigo_seguridad OUT VDIR_USUARIO.CODIGO_SEGURIDAD%TYPE)

 IS
  vl_codigo_usuario NUMBER;
  vl_codigo_seguridad NUMBER;
 BEGIN  


    SELECT
       usu.cod_usuario INTO vl_codigo_usuario    
    FROM
        vdir_persona per

        INNER JOIN VDIR_USUARIO usu
         ON usu.cod_persona = per.cod_persona
    WHERE
      per.numero_identificacion = p_identificacacion; 

    SELECT 
       (1000+ABS(MOD(dbms_random.random,9999))) INTO vl_codigo_seguridad
    FROM   dual;  

    UPDATE vdir_usuario

    SET
        codigo_seguridad = vl_codigo_seguridad
    WHERE
       cod_usuario = vl_codigo_usuario;    

    p_codigo_seguridad := vl_codigo_seguridad;

    COMMIT; 
    
   EXCEPTION 
   WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000, 'error VDIR_SP_ACTUALIZAR_COD_SEG.');     
   ROLLBACK;

 END VDIR_SP_ACTUALIZAR_COD_SEG;

 ------------------------------------------------ PROCEDIMIENTO PARA ACTUALIZAR LA CLAVE DEL USUARIO
 PROCEDURE VDIR_SP_CAMBIAR_CLAVE(p_identificacacion IN VDIR_PERSONA.numero_identificacion%TYPE,p_codigo_seguridad IN VDIR_USUARIO.CODIGO_SEGURIDAD%TYPE, p_clave IN VDIR_USUARIO.CLAVE%TYPE,p_respuesta OUT VARCHAR2)

 IS

   vl_codigo_usuario NUMBER;   

 BEGIN

   p_respuesta := 'Operaci&oacute;n realizada correctamente.';

    BEGIN
    SELECT
       usu.cod_usuario INTO vl_codigo_usuario    
    FROM
        vdir_persona per

        INNER JOIN VDIR_USUARIO usu
         ON usu.cod_persona = per.cod_persona

    WHERE
      per.numero_identificacion = p_identificacacion
      AND usu.CODIGO_SEGURIDAD = p_codigo_seguridad;

    EXCEPTION WHEN OTHERS THEN    
     vl_codigo_usuario := NULL;
    END;  

    UPDATE vdir_usuario
        SET
            clave = p_clave
    WHERE
        cod_usuario = vl_codigo_usuario;

    IF vl_codigo_usuario IS NULL THEN
       p_respuesta := 'El c&oacute;digo de seguridad no corresponde con el n&uacute;mero de identificaci&oacute;n.';
    END IF;

    COMMIT;

     EXCEPTION 
       WHEN OTHERS THEN 
       
     RAISE_APPLICATION_ERROR(-20000, 'error VDIR_SP_CAMBIAR_CLAVE.');
     p_respuesta := 'Ocurrio un error en la base de datos.';
     ROLLBACK;  


 END VDIR_SP_CAMBIAR_CLAVE;

 ----------------------------------------------------------------------------  FUNCION PARA TRAER LOS DAOS DE LA PERSONA,USUAIRO Y ROLES 
 FUNCTION VDIR_FN_GET_DATOS_USUARIO(p_login IN vdir_usuario.login%TYPE,p_clave IN vdir_usuario.clave%TYPE) 

   RETURN sys_refcursor 
   AS

   vl_cursor sys_refcursor;   

    BEGIN

  OPEN vl_cursor
    FOR 
     SELECT
        persona.cod_persona ,
        persona.cod_tipo_identificacion,
        ti.DES_TIPO_IDENTIFICACION AS DES_TIP_IDENT_LONG,
        ti.DES_ABR AS DES_TIP_IDENT_SMALL,
        persona.numero_identificacion,
        persona.nombre_1,
        persona.nombre_2,
        persona.apellido_1,
        persona.apellido_2,
        COALESCE(persona.nombre_1,' ')||' '|| COALESCE(persona.nombre_2,' ')||' '|| COALESCE(persona.apellido_1,' ')||' '||COALESCE(persona.apellido_2,' ') AS NOMBRE_COMPLETO,
        persona.fecha_nacimiento,
        trunc(months_between(sysdate,persona.fecha_nacimiento)/12) as EDAD,
        persona.telefono,
        persona.email,
        persona.direccion,
        persona.cod_sexo,
        sexo.des_sexo as DESCRIPCION_LONG_SEXO,
        sexo.DES_ABR as DESCRIPCION_SMALL_SEXO,
        persona.cod_municipio,
        --persona.fecha_creacion,
        persona.cod_estado,
        persona.celular,
        usu.COD_USUARIO,
        usu.CLAVE,
        usu.LOGIN,
        VDIR_FN_GET_ROLES_PERSONA(usu.COD_USUARIO) as ROLESS,
        usu.COD_PLAN AS CODIGO_PLAN,
        VDIR_PACK_INICIO_SESSION.fn_get_keyPagesNot(usu.COD_USUARIO) AS PAGINAS_NO_APLICA
    FROM
        vdir_persona persona

        INNER JOIN vdir_usuario usu
         ON usu.cod_persona = persona.cod_persona

        LEFT JOIN VDIR_SEXO sexo
         ON sexo.cod_sexo = persona.cod_sexo

        INNER JOIN  VDIR_TIPO_IDENTIFICACION ti
         ON ti.COD_TIPO_IDENTIFICACION =persona.COD_TIPO_IDENTIFICACION

    WHERE
       TRIM(UPPER(usu.login)) = TRIM(UPPER(p_login))
       AND usu.COD_ESTADO = 1
       AND  usu.clave = p_clave; 

    RETURN vl_cursor;      

    END VDIR_FN_GET_DATOS_USUARIO; 

     ------------------------------------------------------------------------------FUNCION PARA TRAER LOS ROLES QUE TIENE UNA PERSONA 
    FUNCTION VDIR_FN_GET_ROLES_PERSONA(p_cod_user IN vdir_usuario.cod_usuario%TYPE) RETURN VARCHAR2

    IS
    json_datos VARCHAR2(4000);
    BEGIN
      JSON_DATOS := '[ ';
      FOR FILA IN (
                     SELECT 
                        ROL.COD_ROL ,
                        ROL.DES_ROL
                      FROM 
                        VDIR_ROL_USUARIO ROL_USER

                        INNER JOIN VDIR_ROL ROL 
                         ON ROL.COD_ROL = ROL_USER.COD_ROL
                      WHERE 
                        ROL_USER.COD_USUARIO = p_cod_user
                        ) LOOP

      JSON_DATOS := JSON_DATOS ||'{';      
      JSON_DATOS := JSON_DATOS ||'"CODIGO": "'||FILA.COD_ROL||'",';
      JSON_DATOS := JSON_DATOS ||'"NOMBRE": "'||FILA.DES_ROL||'"';
      JSON_DATOS := JSON_DATOS ||'},';

   END LOOP;
    JSON_DATOS := SUBSTR(JSON_DATOS, 1,LENGTH(JSON_DATOS)-1);
    JSON_DATOS := JSON_DATOS || ']'; 

    RETURN json_datos; 

    END VDIR_FN_GET_ROLES_PERSONA;

  ------------------------------------------------ PROCEDIMIENTO PARA INSERTAR EL LOG DE USUARIO
 PROCEDURE VDIR_SP_INSERT_LOG_USER(p_login IN VDIR_USUARIO.login%TYPE,p_ip IN VARCHAR2,p_navegador IN VARCHAR2)

 IS

 BEGIN 

     INSERT INTO vdir_log_usuarios_sistema (
        cod_log_usuarios_sistema,
        usuario,       
        ip,
        navegador
    ) VALUES (
       VDIR_SEQ_LOG_USUARIOS_SISTEMA.NEXTVAL,
       p_login,
       p_ip,
       p_navegador        
    );

 END VDIR_SP_INSERT_LOG_USER;

 ------------------------------------------------ FUNCION PARA TRAER LAS IMAGENES DE LAS PROMOCIONES DE LOS PRODUCTOS 
 FUNCTION VDIR_FN_GET_DATOS_IMG_PROMO(p_codigo_plan IN vdir_plan.cod_plan%TYPE DEFAULT NULL) 
  RETURN sys_refcursor 
   AS

   vl_cursor sys_refcursor;   

 BEGIN

         OPEN vl_cursor FOR 
	   SELECT ruta AS RUTA_FILE
         FROM VDIR_FILE
		WHERE COD_TIPO_FILE = 5;

    RETURN vl_cursor;   

 END VDIR_FN_GET_DATOS_IMG_PROMO;

 ------------------------------------------------ FUNCION PARA ENVIAR EMAILS 
 FUNCTION VDIR_FN_SEND_EMAIL(p_to IN VARCHAR2,p_asunto IN VARCHAR2, p_mensaje IN VARCHAR2,p_mensaje2 IN VARCHAR2 DEFAULT '')  RETURN VARCHAR2

 AS 

 vl_remite VARCHAR2(50);
 vl_puerto NUMBER(3);
 vl_servidor VARCHAR2(50);
 vl_smtp_usuario VARCHAR2(50);
 vl_smtp_clave VARCHAR2(50);
 vl_respuesta_email VARCHAR2(50); 

 BEGIN 

      vl_remite := 'ventaDirecta@coomeva.com.co';
      --vl_asunto := 'Codigo de verificacion'; 
      vl_puerto := 25;
      vl_servidor := 'appcorreo.intracoomeva.com.co';
      vl_smtp_usuario := '';
      vl_smtp_clave := ''; 

    SELECT VDIR_PACK_ENVIAR_EMAIL.send_email2(vl_remite,p_to,p_asunto,p_mensaje,vl_puerto,vl_servidor,vl_smtp_usuario,vl_smtp_clave,p_mensaje2) INTO vl_respuesta_email FROM DUAL;

    RETURN vl_respuesta_email;

 END VDIR_FN_SEND_EMAIL;

 /*---------------------------------------------------------------------
  fn_get_keyPagesNot: Traer el key calss de las paginas a las que el usuario no tiene acceso
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 01-03-2019
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_keyPagesNot
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN VARCHAR2 IS
    json_datos VARCHAR2(8000);
    key_datos VARCHAR2(4000);
    url_datos VARCHAR2(4000);
 BEGIN
    key_datos := '[ ';
    url_datos := '["#",';
    FOR FILA IN (SELECT 
                        key_pagina,
                        url_pagina
                    FROM
                        vdir_pagina
                    WHERE
                        cod_pagina NOT IN (SELECT
                                                pa.cod_pagina
                                            FROM
                                                vdir_usuario us
                                                INNER JOIN vdir_rol_usuario rul ON rul.cod_usuario = us.cod_usuario
                                                INNER JOIN vdir_pagina_rol par ON par.cod_rol = rul.cod_rol
                                                INNER JOIN vdir_pagina pa ON pa.cod_pagina = par.cod_pagina
                                            WHERE
                                               us.cod_usuario = pty_cod_usuario)) 
    LOOP
        key_datos := key_datos ||'"'||FILA.key_pagina||'",';
        IF FILA.url_pagina <> '#' THEN
            url_datos := url_datos ||'"'||FILA.url_pagina||'",';
        END IF;
    END LOOP;
    key_datos := SUBSTR(key_datos, 1,LENGTH(key_datos)-1);
    url_datos := SUBSTR(url_datos, 1,LENGTH(url_datos)-1);
    key_datos := key_datos || ']';
    url_datos := url_datos || ']';
    json_datos := '{"css":' || key_datos || ', "url":'|| url_datos ||'}'; 

    RETURN json_datos; 

 END fn_get_keyPagesNot;

END VDIR_PACK_INICIO_SESSION;
/

CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_CONTRATO AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_CONTRATO
 Caso de Uso : 
 Descripción : Procesos para el registro del contrato asociado al contratante - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 14-01-2018  
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
 
	-- ---------------------------------------------------------------------
	-- prGuardarContratoAdobe
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarContratoAdobe
	(
		inu_codPersona        IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE, 
		inu_codPrograma       IN VDIR_PERSONA_CONTRATO.COD_PROGRAMA%TYPE,
		inu_codAfiliacion     IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		ivc_nroContratoAdobe  IN VDIR_PERSONA_CONTRATO.NUMERO_CONTRATO_ADOBE%TYPE
    );
	
	-- ---------------------------------------------------------------------
	-- prActualizarAfiliacion
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarAfiliacion
	(		
		inu_codAfiliacion     IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    );
  
END VDIR_PACK_REGISTRO_CONTRATO;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_REGISTRO_CONTRATO AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_CONTRATO
 Caso de Uso : 
 Descripción : Procesos para el registro del contrato asociado al contratante - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 14-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */
 
 
	-- ---------------------------------------------------------------------
	-- prGuardarContratoAdobe
	-- ---------------------------------------------------------------------
	PROCEDURE prGuardarContratoAdobe
	(
		inu_codPersona        IN VDIR_PERSONA_CONTRATO.COD_PERSONA%TYPE, 
		inu_codPrograma       IN VDIR_PERSONA_CONTRATO.COD_PROGRAMA%TYPE,
		inu_codAfiliacion     IN VDIR_PERSONA_CONTRATO.COD_AFILIACION%TYPE,
		ivc_nroContratoAdobe  IN VDIR_PERSONA_CONTRATO.NUMERO_CONTRATO_ADOBE%TYPE
    ) 
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_CONTRATO
	 Caso de Uso : 
	 Descripción : Procedimiento que guarda el contrato de Adobe Sign 
	               asociado a la persona y al programa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 14-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codPersona        Código de la persona contratante
	   inu_codPrograma       Código del programa
	   inu_codAfiliacion     Código de la afiliación
	   ivc_nroContratoAdobe  Número del contrato proveniente de Adobe Sign
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
	    lnu_codPersonaContrato VDIR_PERSONA_CONTRATO.COD_PERSONA_CONTRATO%TYPE;
	
	BEGIN
		
	    -- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_PERSONACONTRATO.NEXTVAL INTO lnu_codPersonaContrato FROM DUAL;   
		
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se ingresa la persona asociada al contrato
			-- --------------------------------------------------------------------- 
			INSERT INTO VDIR_PERSONA_CONTRATO
			(
				COD_PERSONA_CONTRATO, 
				COD_PERSONA, 
				COD_PROGRAMA, 
				COD_AFILIACION,
				NUMERO_CONTRATO_ADOBE
			) 
			VALUES 
			(
				lnu_codPersonaContrato,
				inu_codPersona,
				inu_codPrograma,
				inu_codAfiliacion,
				ivc_nroContratoAdobe
			);
			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al guardar el contrato: '||SQLERRM); 
		
		END;		
	 
	END prGuardarContratoAdobe;	
	
	-- ---------------------------------------------------------------------
	-- prActualizarAfiliacion
	-- ---------------------------------------------------------------------
	PROCEDURE prActualizarAfiliacion
	(		
		inu_codAfiliacion     IN VDIR_AFILIACION.COD_AFILIACION%TYPE
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_CONTRATO
	 Caso de Uso : 
	 Descripción : Procedimiento que actualiza el estado de la afiliación
	               para enviarla a la bandeja de operaciones
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 21-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:	  
	   inu_codAfiliacion     Código de la afiliación	 
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
	 	
	BEGIN
		
	 	BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se actualiza el estado de la solicitud
			-- --------------------------------------------------------------------- 
			UPDATE VDIR_AFILIACION
			   SET cod_estado      = 7
		     WHERE cod_afiliacion  = inu_codAfiliacion;
			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al actualizar la afiliación para enviar a la bandeja: '||SQLERRM); 
		
		END;		
	 
	END prActualizarAfiliacion;
 
END VDIR_PACK_REGISTRO_CONTRATO;
/

CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_DATOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_DATOS
 Caso de Uso : 
 Descripción : Procesos para la ejecucion del requerimiento Registro datos basicos - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : diego.castillo@kalettre.com
 Fecha : 03-12-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */
 
 ----------------------------------------------------------------------------
 -- Declaracion de estructuras dinamicas
 ----------------------------------------------------------------------------
 TYPE type_cursor IS REF CURSOR;
 
 TYPE datasplit_record IS RECORD(
       idx NUMBER, 
       dato VARCHAR2(4000)
  );

 TYPE datasplit_table IS TABLE OF datasplit_record;

/*---------------------------------------------------------------------
  fn_get_contratante: Traer la informacion del usuario contratante
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_contratante
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN type_cursor;
 
/*---------------------------------------------------------------------
  fn_get_info_persona: Taer iformacion de la persona con el numero de y tipo de identificacion
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_info_persona
 (
    pty_num_indentificacion in vdir_persona.numero_identificacion%type,
    pty_tip_indentificacion in vdir_persona.cod_tipo_identificacion%type
 )RETURN type_cursor;
 
 /*---------------------------------------------------------------------
  sp_set_beneficiario: Agregar beneficiario
 ----------------------------------------------------------------------- */
 PROCEDURE sp_set_beneficiario
 (
    p_cod_contratante in vdir_persona.cod_persona%type,
    p_cod_tipo_doc in vdir_persona.cod_tipo_identificacion%type,
    p_num_doc in vdir_persona.numero_identificacion%type,
    p_nombre_1 in vdir_persona.nombre_1%type,
    p_nombre_2 in vdir_persona.nombre_2%type,
    p_apellido_1 in vdir_persona.apellido_1%type,
    p_apellido_2 in vdir_persona.apellido_2%type,
    p_fecha_nacimiento in vdir_persona.fecha_nacimiento%type,
    p_telefono in vdir_persona.telefono%type,
    p_email in vdir_persona.email%type,
    p_cod_sexo in vdir_persona.cod_sexo%type,
    p_cod_municipio in vdir_persona.cod_municipio%type,
    p_celular in vdir_persona.celular%type,
    p_eps in vdir_persona.cod_eps%type,
    p_estado_civil in vdir_persona.cod_estado_civil%type,
    p_ind_tiene_mascota in vdir_persona.ind_tiene_mascota%type,
    p_tipo_via_dir in vdir_tipo_via.cod_tipo_via%type,
    p_num_tipo_via_dir in varchar2,
    p_num_placa_dir in varchar2,
    p_complemento_dir in varchar2,
    p_parentesco in vdir_parentesco.cod_parentesco%type,
    p_estado in vdir_persona.cod_estado%type,
    p_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type,
    p_cod_afiliacion_out out vdir_afiliacion.cod_afiliacion%type
 );
 
  /*---------------------------------------------------------------------
  fn_get_afiliacion_pendiente: Trae afiliacion pendiente
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_afiliacion_pendiente
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN vdir_afiliacion.cod_afiliacion%type;

 /*---------------------------------------------------------------------
  fn_get_benficiarios_contra: Traer los beneficiarios que esta registrando un contratante
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_benficiarios_contra
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN type_cursor;
 
 /*---------------------------------------------------------------------
  sp_quitar_contra_benefi: Quitar la relacion entre el contratante y los beneficiarios de una afiliacion pendiente
  ----------------------------------------------------------------------- */
 PROCEDURE sp_quitar_contra_benefi
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type,
    pnu_result out numeric
 );
 
 /*---------------------------------------------------------------------
  sp_cambiar_estado_contra_benefi: Cambiar de estado la relacion entre el contratante y los beneficiarios de una afiliacion pendiente
  ---------------------------------------------------------------------- */
 PROCEDURE sp_set_estado_contra_benefi
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type,
    pty_cod_estado in vdir_estado.cod_estado%type
 );
 
 /* ------------------------------------------
  fn_splitData: funcion para retornar tabla con los datos de una cadena separados por un caracter
 -- ------------------------------------------  */
 FUNCTION fn_splitData
 (
    P_STRING_DATA IN VARCHAR2,
    P_SEPARATOR IN VARCHAR2
 )RETURN datasplit_table PIPELINED;
 
    -- ---------------------------------------------------------------------
    -- fnGetProgramasBeneficiario
    -- --------------------------------------------------------------------- 
	FUNCTION fnGetProgramasBeneficiario
	(
		inu_codBeneficiario  IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE,
        inu_codAfiliacion    IN VDIR_AFILIACION.COD_AFILIACION%TYPE
	)
	RETURN VARCHAR2;
    
 /*---------------------------------------------------------------------
  fn_get_habeasData: Traer el texto habeas datada para la compra de productos
  ---------------------------------------------------------------------- */
 FUNCTION fn_get_habeasData
 (
    p_tipo VARCHAR2
 )
 RETURN VARCHAR2;

END VDIR_PACK_REGISTRO_DATOS;
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_REGISTRO_DATOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_DATOS BODY
 Caso de Uso : 
 Descripción : Procesos para la ejecucion del requerimiento Registro datos basicos
 --------------------------------------------------------------------
 Autor : diego.castillo@kalettre.com
 Fecha : 03-12-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */
 
 /*---------------------------------------------------------------------
  fn_get_contratante: Traer la informacion del usuario contratante
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 03-12-2018
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_contratante
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN type_cursor IS
    ltc_datos type_cursor;
 BEGIN 
 
    OPEN ltc_datos FOR
    SELECT
        persona.cod_persona ,
        persona.cod_tipo_identificacion,
        ti.DES_TIPO_IDENTIFICACION AS DES_TIP_IDENT_LONG,
        ti.DES_ABR AS DES_TIP_IDENT_SMALL,
        persona.numero_identificacion,
        persona.nombre_1,
        persona.nombre_2,
        persona.apellido_1,
        persona.apellido_2,
        COALESCE(persona.nombre_1,' ')||' '|| COALESCE(persona.nombre_2,' ')||' '|| COALESCE(persona.apellido_1,' ')||' '||COALESCE(persona.apellido_2,' ') AS NOMBRE_COMPLETO,
        to_char(persona.fecha_nacimiento,'dd/mm/yyyy') AS fecha_nacimiento,
        trunc(months_between(sysdate, to_date(to_char(persona.fecha_nacimiento,'dd/mm/yyyy'),'dd/mm/yyyy'))/12) as EDAD,
        persona.telefono,
        persona.email,
        persona.direccion,
        persona.cod_sexo,
        sexo.des_sexo as DESCRIPCION_LONG_SEXO,
        sexo.DES_ABR as DESCRIPCION_SMALL_SEXO,
        persona.cod_municipio,
        persona.fecha_creacion,
        persona.cod_estado,
        persona.celular,
        usu.COD_USUARIO,
        usu.CLAVE,
        usu.LOGIN,
        dp.cod_pais,
        persona.dir_tipo_via,
        persona.dir_num_via,
        persona.dir_num_placa,
        persona.dir_complemento,
        persona.cod_estado_civil,
        persona.cod_eps,
        persona.ind_tiene_mascota,
        VDIR_PACK_REGISTRO_DATOS.fn_get_afiliacion_pendiente(pty_cod_usuario) AS cod_afiliacion,
		(SELECT pai.des_pais
		   FROM VDIR_PAIS pai
		WHERE pai.cod_pais = dp.cod_pais) nacionalidad,
		mu.des_municipio,
		(SELECT esc.des_estado_civil
		   FROM VDIR_ESTADO_CIVIL esc
		  WHERE esc.cod_estado_civil = persona.cod_estado_civil) des_estado_civil,
		(SELECT eps.des_eps
	 	   FROM VDIR_EPS eps
		  WHERE eps.cod_eps = persona.cod_eps) des_eps,
		usu.cod_plan
    FROM
        vdir_persona persona
        INNER JOIN vdir_usuario usu
            ON usu.cod_persona = persona.cod_persona        
        INNER JOIN VDIR_SEXO sexo
            ON sexo.cod_sexo = persona.cod_sexo        
        INNER JOIN VDIR_TIPO_IDENTIFICACION ti
            ON ti.COD_TIPO_IDENTIFICACION = persona.COD_TIPO_IDENTIFICACION         
        LEFT JOIN vdir_municipio mu
            ON mu.cod_municipio = persona.cod_municipio
        LEFT JOIN vdir_departamento dp
            ON dp.cod_departamento = mu.cod_departamento
         
    WHERE
       usu.cod_usuario = pty_cod_usuario;
       
       
    RETURN ltc_datos;
 
 END fn_get_contratante; 
 
 /*---------------------------------------------------------------------
  fn_get_info_persona: Taer iformacion de la persona con el numero de y tipo de identificacion
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 03-12-2018
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_info_persona
 (
    pty_num_indentificacion in vdir_persona.numero_identificacion%type,
    pty_tip_indentificacion in vdir_persona.cod_tipo_identificacion%type
 )RETURN type_cursor IS
    ltc_datos type_cursor;
 BEGIN 
 
    OPEN ltc_datos FOR
    SELECT
        persona.cod_persona ,
        persona.cod_tipo_identificacion,
        ti.DES_TIPO_IDENTIFICACION AS DES_TIP_IDENT_LONG,
        ti.DES_ABR AS DES_TIP_IDENT_SMALL,
        persona.numero_identificacion,
        persona.nombre_1,
        persona.nombre_2,
        persona.apellido_1,
        persona.apellido_2,
        COALESCE(persona.nombre_1,' ')||' '|| COALESCE(persona.nombre_2,' ')||' '|| COALESCE(persona.apellido_1,' ')||' '||COALESCE(persona.apellido_2,' ') AS NOMBRE_COMPLETO,
        to_char(persona.fecha_nacimiento,'dd/mm/yyyy') AS fecha_nacimiento,
        trunc(months_between(sysdate, to_date(to_char(persona.fecha_nacimiento,'dd/mm/yyyy'),'dd/mm/yyyy'))/12) as EDAD,
        persona.telefono,
        persona.email,
        persona.direccion,
        persona.cod_sexo,
        sexo.des_sexo as DESCRIPCION_LONG_SEXO,
        sexo.DES_ABR as DESCRIPCION_SMALL_SEXO,
        persona.cod_municipio,
        persona.fecha_creacion,
        persona.cod_estado,
        persona.celular,
        usu.COD_USUARIO,
        usu.CLAVE,
        usu.LOGIN,
        dp.cod_pais,
        persona.dir_tipo_via,
        persona.dir_num_via,
        persona.dir_num_placa,
        persona.dir_complemento,
        persona.cod_estado_civil,
        persona.cod_eps,
        persona.ind_tiene_mascota
    FROM
        vdir_persona persona
        LEFT JOIN vdir_usuario usu ON usu.cod_persona = persona.cod_persona
        INNER JOIN VDIR_SEXO sexo ON sexo.cod_sexo = persona.cod_sexo
        INNER JOIN  VDIR_TIPO_IDENTIFICACION ti ON ti.COD_TIPO_IDENTIFICACION = persona.COD_TIPO_IDENTIFICACION
        LEFT JOIN vdir_municipio mu ON mu.cod_municipio = persona.cod_municipio
        LEFT JOIN vdir_departamento dp ON dp.cod_departamento = mu.cod_departamento
    WHERE
       persona.numero_identificacion = pty_num_indentificacion
       AND persona.cod_tipo_identificacion = pty_tip_indentificacion;
       
       
    RETURN ltc_datos;
 
 END fn_get_info_persona;

 /*---------------------------------------------------------------------
  sp_set_beneficiario: Agregar beneficiario
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 26-12-2018
 ----------------------------------------------------------------------- */
 PROCEDURE sp_set_beneficiario
 (
    p_cod_contratante in vdir_persona.cod_persona%type,
    p_cod_tipo_doc in vdir_persona.cod_tipo_identificacion%type,
    p_num_doc in vdir_persona.numero_identificacion%type,
    p_nombre_1 in vdir_persona.nombre_1%type,
    p_nombre_2 in vdir_persona.nombre_2%type,
    p_apellido_1 in vdir_persona.apellido_1%type,
    p_apellido_2 in vdir_persona.apellido_2%type,
    p_fecha_nacimiento in vdir_persona.fecha_nacimiento%type,
    p_telefono in vdir_persona.telefono%type,
    p_email in vdir_persona.email%type,
    p_cod_sexo in vdir_persona.cod_sexo%type,
    p_cod_municipio in vdir_persona.cod_municipio%type,
    p_celular in vdir_persona.celular%type,
    p_eps in vdir_persona.cod_eps%type,
    p_estado_civil in vdir_persona.cod_estado_civil%type,
    p_ind_tiene_mascota in vdir_persona.ind_tiene_mascota%type,
    p_tipo_via_dir in vdir_tipo_via.cod_tipo_via%type,
    p_num_tipo_via_dir in varchar2,
    p_num_placa_dir in varchar2,
    p_complemento_dir in varchar2,
    p_parentesco in vdir_parentesco.cod_parentesco%type,
    p_estado in vdir_persona.cod_estado%type,
    p_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type,
    p_cod_afiliacion_out out vdir_afiliacion.cod_afiliacion%type
 ) IS
    lv_des_tipo_via varchar(4000);
    lv_existe_registro integer;
    lv_direccion vdir_persona.direccion%type;
    lv_cod_beneficiario vdir_persona.cod_persona%type;
    lv_cod_afiliacion vdir_afiliacion.cod_afiliacion%type;
    lv_cod_usuario vdir_usuario.cod_usuario%type;
    lv_cod_persona_tipoper vdir_persona_tipoper.cod_persona_tipoper%type;
 BEGIN
    lv_existe_registro := 0;
    --Consultar descripcion del tipo via
    SELECT des_tipo_via INTO lv_des_tipo_via FROM vdir_tipo_via WHERE cod_tipo_via = p_tipo_via_dir;
    --Consultar codigo usuario del contratante
    SELECT cod_usuario INTO lv_cod_usuario FROM vdir_usuario WHERE cod_persona = p_cod_contratante;
    
    lv_direccion := lv_des_tipo_via||' '||p_num_tipo_via_dir||' # '||p_num_placa_dir||' '||p_complemento_dir;
    lv_cod_afiliacion :=  VDIR_PACK_REGISTRO_DATOS.fn_get_afiliacion_pendiente(lv_cod_usuario);
    
    --Agregar afiliacion si no existe una pendiente
    IF lv_cod_afiliacion < 0 THEN
        SELECT VDIR_SEQ_AFILIACION.NEXTVAL INTO lv_cod_afiliacion FROM DUAL;
        INSERT INTO vdir_afiliacion (
                            cod_afiliacion,
                            fecha_creacion,
                            cod_estado
                        ) VALUES (
                            lv_cod_afiliacion,
                            SYSDATE,
                            3 --Temporal
                        );
    END IF;   
    
        
    --Validar si esxite la persona
    SELECT 
        COUNT(*) INTO lv_existe_registro 
    FROM 
        vdir_persona 
    WHERE 
        cod_tipo_identificacion = p_cod_tipo_doc 
        AND numero_identificacion = p_num_doc;
        
    IF lv_existe_registro > 0 THEN
        --Obtener codigo de persona
        SELECT 
            cod_persona INTO lv_cod_beneficiario 
        FROM 
            vdir_persona 
        WHERE 
            cod_tipo_identificacion = p_cod_tipo_doc 
            AND numero_identificacion = p_num_doc;
        --Actualizar persona    
        UPDATE vdir_persona
        SET
            nombre_1 = p_nombre_1,
            nombre_2 = p_nombre_2,
            apellido_1 = p_apellido_1,
            apellido_2 = p_apellido_2,
            fecha_nacimiento = p_fecha_nacimiento,
            telefono = p_telefono,
            email = p_email,
            direccion = lv_direccion,
            cod_sexo = p_cod_sexo,
            cod_municipio = p_cod_municipio,
            celular = p_celular,
            cod_eps = p_eps,
            cod_estado_civil = p_estado_civil,
            ind_tiene_mascota = p_ind_tiene_mascota,
            cod_estado = p_estado,
            dir_tipo_via = p_tipo_via_dir,
            dir_num_via = p_num_tipo_via_dir,
            dir_num_placa = p_num_placa_dir,
            dir_complemento = p_complemento_dir
        WHERE
            cod_persona = lv_cod_beneficiario;
    ELSE
        --Obtener secuencia persona
        SELECT VDIR_SEQ_PERSONA.NEXTVAL INTO lv_cod_beneficiario FROM DUAL;
        --Agregar persona 
        INSERT INTO vdir_persona (
                cod_persona,
                cod_tipo_identificacion,
                numero_identificacion,
                nombre_1,
                nombre_2,
                apellido_1,
                apellido_2,
                fecha_nacimiento,
                telefono,
                email,
                direccion,
                cod_sexo,
                cod_municipio,
                fecha_creacion,
                cod_estado,
                celular,
                cod_eps,
                cod_estado_civil,
                ind_tiene_mascota,
                dir_tipo_via,
                dir_num_via,
                dir_num_placa,
                dir_complemento
            ) VALUES (
                lv_cod_beneficiario,
                p_cod_tipo_doc,
                p_num_doc,
                p_nombre_1,
                p_nombre_2,
                p_apellido_1,
                p_apellido_2,
                p_fecha_nacimiento,
                p_telefono,
                p_email,
                lv_direccion,
                p_cod_sexo,
                p_cod_municipio,
                SYSDATE,
                p_estado,
                p_celular,
                p_eps,
                p_estado_civil,
                p_ind_tiene_mascota,
                p_tipo_via_dir,
                p_num_tipo_via_dir,
                p_num_placa_dir,
                p_complemento_dir
            );
            
            --Insertar tipo de persona            
            SELECT VDIR_SEQ_PERSONA_TIPOPER.NEXTVAL INTO lv_cod_persona_tipoper FROM DUAL;
            insert into vdir_persona_tipoper(
                cod_persona_tipoper,
                cod_persona,
                cod_tipo_persona
            ) VALUES (
                lv_cod_persona_tipoper,
                lv_cod_beneficiario,
                2
            );
    END IF;
    
    --Validar si existe la relacion entre el beneficiario y el contratante
    SELECT
        COUNT(*) INTO lv_existe_registro
    FROM
        vdir_contratante_beneficiario
    WHERE
        cod_contratante = p_cod_contratante
        AND cod_beneficiario = lv_cod_beneficiario
        AND cod_afiliacion = lv_cod_afiliacion;
        
    --Agregar o actualizar la relacion entre el beneficiario y el contratante
    IF lv_existe_registro > 0 THEN
        UPDATE vdir_contratante_beneficiario
        SET
            cod_parentesco = p_parentesco,
            cod_estado = 1
        WHERE
            cod_contratante = p_cod_contratante
            AND cod_beneficiario = lv_cod_beneficiario
            AND cod_afiliacion = lv_cod_afiliacion;
    ELSE
        INSERT INTO vdir_contratante_beneficiario (
                cod_contratante_beneficiario,
                cod_contratante,
                cod_beneficiario,
                cod_parentesco,
                cod_afiliacion,
                cod_tipo_solicitud,
                cod_estado
            ) VALUES (
                VDIR_SEQ_CONTRATANTE_BENEFI.NEXTVAL,
                p_cod_contratante,
                lv_cod_beneficiario,
                p_parentesco,
                lv_cod_afiliacion,
                null,
                1
            );
    END IF;
    
     p_cod_afiliacion_out := lv_cod_afiliacion;
	
	 EXCEPTION 
     WHEN OTHERS THEN
     p_cod_afiliacion_out := -1;
 
 END sp_set_beneficiario;
 
  /*---------------------------------------------------------------------
  fn_get_afiliacion_pendiente: Trae afiliacion pendiente
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 27-12-2018
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_afiliacion_pendiente
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN vdir_afiliacion.cod_afiliacion%type IS
    lv_cod_afiliacion vdir_afiliacion.cod_afiliacion%type;
 BEGIN
    
    BEGIN
      SELECT DISTINCT
          va.cod_afiliacion INTO lv_cod_afiliacion
      FROM
          vdir_usuario us
          INNER JOIN vdir_contratante_beneficiario cb ON cb.cod_contratante = us.cod_persona
          INNER JOIN vdir_afiliacion va ON va.cod_afiliacion = cb.cod_afiliacion          
      WHERE
          us.cod_usuario = pty_cod_usuario
          AND va.cod_estado = 3;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
      lv_cod_afiliacion := -1;
    END;
       
    RETURN lv_cod_afiliacion;
 
 END fn_get_afiliacion_pendiente;
 
 /*---------------------------------------------------------------------
  fn_get_benficiarios_contra: Traer los beneficiarios que esta registrando un contratante
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 31-12-2018
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_benficiarios_contra
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN type_cursor IS
    ltc_datos type_cursor;
 BEGIN 
     BEGIN
        OPEN ltc_datos FOR
        SELECT
            va.cod_afiliacion AS "cod_afiliacion",
            pr.cod_persona AS "cod_persona",
            pr.cod_tipo_identificacion AS "tipoDocumento",
            pr.numero_identificacion AS "numeroDocumento",
            pr.nombre_1 AS "nombre1",
            pr.nombre_2 AS "nombre2",
            pr.apellido_1 AS "apellido1",
            pr.apellido_2 AS "apellido2",
            TO_CHAR(pr.fecha_nacimiento, 'DD/MM/YYYY') AS "fechaNacimiento",
            pr.cod_sexo AS "tipoSexo",
            pr.telefono AS "telefono",
            pr.celular AS "celular",
            pr.email AS "correo",
            dp.cod_pais AS "pais",
            pr.cod_municipio AS "municipio",
            pr.direccion AS "direccion",
            pr.cod_estado_civil AS "estado_civil",
            pr.cod_eps AS "eps",
            pr.ind_tiene_mascota AS "mascota",
            pr.dir_tipo_via AS "tipoVia",
            pr.dir_num_via AS "numeroTipoVia",
            pr.dir_num_placa AS "numeroPlaca",
            pr.dir_complemento AS "complemento",
            ti.des_abr AS "tipoDocumento_abr",
            tv.abr_tipo_via AS "tipoVia_abr",
            --COALESCE(tv.abr_tipo_via, ' ')||' '||COALESCE(pr.dir_num_via, ' ')||' # '||COALESCE(pr.dir_num_placa, ' ')||' '||COALESCE(pr.dir_complemento, ' ')  AS "direccion",
            COALESCE(pr.nombre_1, ' ') || ' ' || COALESCE(pr.nombre_2, ' ') || ' ' || COALESCE(pr.apellido_1, ' ') || ' ' || COALESCE(pr.apellido_2, ' ') AS "nombre_completo",
            cb.cod_parentesco AS "parentesco",
            0 AS "tarifa",
            trunc(months_between(sysdate, to_date(to_char(pr.fecha_nacimiento,'dd/mm/yyyy'),'dd/mm/yyyy'))/12) AS "edad",
			des_parentesco AS "des_parentesco",
			VDIR_PACK_REGISTRO_DATOS.fnGetProgramasBeneficiario(pr.cod_persona, va.cod_afiliacion) "benefiProgramas",
			(SELECT SUM(tari.valor)
			   FROM VDIR_BENEFICIARIO_PROGRAMA bepo,
				    VDIR_TARIFA tari
		 	  WHERE bepo.cod_tarifa = tari.cod_tarifa
				AND bepo.cod_beneficiario = pr.cod_persona
				AND bepo.cod_estado = 1
				AND bepo.cod_afiliacion = va.cod_afiliacion) "tarifaBeneficiario"
        FROM
            vdir_usuario us
            INNER JOIN vdir_contratante_beneficiario cb ON cb.cod_contratante = us.cod_persona
            INNER JOIN vdir_afiliacion va ON va.cod_afiliacion = cb.cod_afiliacion
            INNER JOIN vdir_persona pr ON pr.cod_persona = cb.cod_beneficiario
            INNER JOIN vdir_tipo_identificacion ti ON ti.cod_tipo_identificacion = pr.cod_tipo_identificacion
			INNER JOIN vdir_parentesco pare ON pare.cod_parentesco = cb.cod_parentesco
		    LEFT JOIN vdir_municipio mu ON mu.cod_municipio = pr.cod_municipio
            LEFT JOIN vdir_departamento dp ON dp.cod_departamento = mu.cod_departamento
            LEFT JOIN vdir_tipo_via tv ON pr.dir_tipo_via = tv.cod_tipo_via
          WHERE
              us.cod_usuario = pty_cod_usuario
              AND va.cod_estado = 3;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            OPEN ltc_datos FOR
            SELECT -1 AS cod_afiliacion FROM DUAL;
    END;       

    RETURN ltc_datos;

 END fn_get_benficiarios_contra;
 
 /*---------------------------------------------------------------------
  sp_quitar_contra_benefi: Quitar la relacion entre el contratante y los beneficiarios de una afiliacion pendiente
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 03-01-2019
 ----------------------------------------------------------------------- */
 PROCEDURE sp_quitar_contra_benefi
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type,
    pnu_result out numeric
 ) IS
    ltc_datos type_cursor;
    lv_cod_afiliacion vdir_afiliacion.cod_afiliacion%type;
 BEGIN
    lv_cod_afiliacion := VDIR_PACK_REGISTRO_DATOS.fn_get_afiliacion_pendiente(pty_cod_usuario);
    BEGIN
        pnu_result := 1;
        --Inactivar registros de beneficiario a quitar en vdir_beneficiario_programa
        UPDATE vdir_beneficiario_programa
        SET 
            cod_estado = 2
        WHERE
            cod_afiliacion = lv_cod_afiliacion
            AND cod_beneficiario IN (SELECT
                                            cb.cod_beneficiario 
                                        FROM
                                            vdir_contratante_beneficiario cb
                                        WHERE
                                            cb.cod_afiliacion = lv_cod_afiliacion
                                            AND cb.cod_estado = 2);
                                        
        --Quitar registros inactivos de vdir_contratante_beneficiario
        DELETE FROM 
            vdir_contratante_beneficiario
        WHERE
            cod_afiliacion = lv_cod_afiliacion
            AND cod_estado = 2;
            
        --Quitar registros inactivos de vdir_beneficiario_programa
        VDIR_PACK_REGISTRO_PRODUCTOS.sp_quitar_benefi_programa(pty_cod_usuario);
        
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        pnu_result := 0;
    END;
    
 END sp_quitar_contra_benefi;
 
 /*---------------------------------------------------------------------
  sp_set_estado_contra_benefi: Asgnar estado a la relacion entre el contratante y los beneficiarios de una afiliacion pendiente
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 23-01-2019
 ----------------------------------------------------------------------- */
 PROCEDURE sp_set_estado_contra_benefi
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type,
    pty_cod_estado in vdir_estado.cod_estado%type
 ) IS
    ltc_datos type_cursor;
    lv_cod_afiliacion vdir_afiliacion.cod_afiliacion%type;
 BEGIN
    lv_cod_afiliacion := VDIR_PACK_REGISTRO_DATOS.fn_get_afiliacion_pendiente(pty_cod_usuario);
 
    UPDATE vdir_contratante_beneficiario
    SET
        cod_estado = pty_cod_estado
    WHERE
        cod_afiliacion = lv_cod_afiliacion;    
    
 END sp_set_estado_contra_benefi;
 
 /*---------------------------------------------------------------------
  fn_splitData: funcion para retornar tabla con los datos de una cadena separados por un caracter
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 02-01-2019
 ----------------------------------------------------------------------- */  
 FUNCTION fn_splitData
 (
    P_STRING_DATA IN VARCHAR2,
    P_SEPARATOR IN VARCHAR2
 )RETURN datasplit_table PIPELINED
 IS
     ltc_datos type_cursor;
     rec datasplit_record;
 BEGIN
    
    --OPEN ltc_datos FOR
    FOR registro IN  (SELECT level AS IDX, regexp_substr(P_STRING_DATA,'[^'|| P_SEPARATOR ||']+', 1, level) DATO from dual
                    connect by regexp_substr(P_STRING_DATA, '[^'|| P_SEPARATOR ||']+', 1, level) is not null)
    LOOP
        SELECT 
            registro.idx, 
            registro.dato
            INTO rec
        FROM DUAL;
        
        PIPE ROW(rec);
    
    END LOOP;
    
    --RETURN ltc_datos;
    RETURN;
    
 END fn_splitData;
 
    -- ---------------------------------------------------------------------
    -- fnGetProgramasBeneficiario
    -- --------------------------------------------------------------------- 
	FUNCTION fnGetProgramasBeneficiario
	(
		inu_codBeneficiario  IN VDIR_BENEFICIARIO_PROGRAMA.COD_BENEFICIARIO%TYPE,
        inu_codAfiliacion    IN VDIR_AFILIACION.COD_AFILIACION%TYPE
	)
	RETURN VARCHAR2 IS
 
    /* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_PRODUCTOS
	 Caso de Uso : 
	 Descripción : Retorna una cadena con los datos de los programas por 
	               beneficiario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 21-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :         Descripción:
	 inu_codBeneficiario   Código del beneficiario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
		lvc_codProgramas VARCHAR2(4000);
		
	BEGIN
	
		lvc_codProgramas := '';

		FOR fila IN (SELECT bepo.cod_programa
					   FROM VDIR_BENEFICIARIO_PROGRAMA bepo
		              WHERE bepo.cod_beneficiario = inu_codBeneficiario
                        AND bepo.cod_afiliacion = inu_codAfiliacion
					    AND bepo.cod_estado = 1)
		LOOP
		
			lvc_codProgramas := lvc_codProgramas || fila.cod_programa || ',';
			
		END LOOP;
				   
		RETURN lvc_codProgramas;

	END fnGetProgramasBeneficiario;

 /*---------------------------------------------------------------------
  fn_get_habeasData: Traer el texto habeas datada para la compra de productos
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 18-02-2019
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_habeasData
 (
    p_tipo IN VARCHAR2
 )
 RETURN VARCHAR2 IS
    lv_texto_habeasData VARCHAR2(32767);
 BEGIN
    
    BEGIN
        lv_texto_habeasData := '';
        IF p_tipo <> 'CEM' THEN
            lv_texto_habeasData := lv_texto_habeasData || VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(49);
            lv_texto_habeasData := lv_texto_habeasData || '<br>';
            lv_texto_habeasData := lv_texto_habeasData || VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(50);
        ELSE
            lv_texto_habeasData := lv_texto_habeasData || VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(51);
            lv_texto_habeasData := lv_texto_habeasData || '<br>';
            lv_texto_habeasData := lv_texto_habeasData || VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(52);            
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            lv_texto_habeasData := 'NO DATA';
    END;
       
    RETURN lv_texto_habeasData;
 
 END fn_get_habeasData;
 
END VDIR_PACK_REGISTRO_DATOS;
/

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

CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_LINEAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_LINEAS
 Caso de Uso : 
 Descripción : Procesos para el registro del los programas asociados al 
               plan - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 25-01-2018  
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
/

CREATE OR REPLACE PACKAGE BODY VDIR_PACK_REGISTRO_LINEAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_LINEAS
 Caso de Uso : 
 Descripción : Procesos para el registro del los programas asociados al 
               plan - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 25-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
 ----------------------------------------------------------------- */
 
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
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_LINEAS
	 Caso de Uso : 
	 Descripción : Procedimiento que guarda el plan programa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 25-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codPlan           Código del plan
	   inu_codPrograma       Código del programa
	   inu_codEstado         Código del estado
	   ivc_coberturaInicial  Cobertura inicial
	   ivc_coberturaFinal    Cobertura final
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	 
	    lnu_codPlanPrograma VDIR_PLAN_PROGRAMA.COD_PLAN_PROGRAMA%TYPE;
	
	BEGIN
		
	    -- ---------------------------------------------------------------------
		-- Se avanza la secuencia
		-- --------------------------------------------------------------------- 
	    SELECT VDIR_SEQ_PLANPROGRAMA.NEXTVAL INTO lnu_codPlanPrograma FROM DUAL;   
		
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se ingresa el programa asociado al plan
			-- --------------------------------------------------------------------- 
			INSERT INTO VDIR_PLAN_PROGRAMA
			(
				COD_PLAN_PROGRAMA, 
				COD_PLAN,
				COD_PROGRAMA, 
				COD_ESTADO, 
				COBERTURA_INICIAL,
				COBERTURA_FINAL,
                COD_PROGRAMA_HOMOLOGA
			) 
			VALUES 
			(
			    lnu_codPlanPrograma,
				inu_codPlan,
				inu_codPrograma,
				inu_codEstado,
				ivc_coberturaInicial,
				ivc_coberturaFinal,
                ivc_codProgramaHologa
			);
			
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al guardar el programa asociado al plan: '||SQLERRM); 
		
		END;
		
	END prGuardarPlanPrograma;
	
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
    )
	IS
	
	/* ---------------------------------------------------------------------
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_LINEAS
	 Caso de Uso : 
	 Descripción : Procedimiento que actualiza el plan programa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 25-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	   inu_codPlanPrograma   Código del plan asociado al programa
	   inu_codPlan           Código del plan
	   inu_codPrograma       Código del programa
	   inu_codEstado         Código del estado
	   ivc_coberturaInicial  Cobertura inicial
	   ivc_coberturaFinal    Cobertura final
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
	 ----------------------------------------------------------------- */
	
	BEGIN
			    	
		BEGIN
		
		    -- ---------------------------------------------------------------------
			-- Se actualiza el programa asociado al plan
			-- --------------------------------------------------------------------- 
			UPDATE VDIR_PLAN_PROGRAMA
			   SET COD_PLAN          = inu_codPlan,
				   COD_PROGRAMA      = inu_codPrograma, 
				   COD_ESTADO        = inu_codEstado, 
				   COBERTURA_INICIAL = ivc_coberturaInicial,
				   COBERTURA_FINAL   = ivc_coberturaFinal,
                   COD_PROGRAMA_HOMOLOGA = ivc_codProgramaHologa
		     WHERE COD_PLAN_PROGRAMA = inu_codPlanPrograma;
	
		EXCEPTION WHEN OTHERS THEN
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al guardar el programa asociado al plan: '||SQLERRM); 
		
		END;
		
	END prActualizarPlanPrograma;
 
END VDIR_PACK_REGISTRO_LINEAS;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_PRODUCTOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_PRODUCTOS
 Caso de Uso : 
 Descripci�n : Procesos para la ejecucion del requerimiento Registro de productos - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : diego.castillo@kalettre.com
 Fecha : 10-12-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 
 ----------------------------------------------------------------------------
 -- Declaracion de estructuras dinamicas
 ----------------------------------------------------------------------------
 TYPE type_cursor IS REF CURSOR;

    /*---------------------------------------------------------------------
      fn_get_producto: Traer los programas de cada producto en un string con estructura de objeto
     ----------------------------------------------------------------------- */
     FUNCTION fn_get_producto
     (
        pty_cod_producto in vdir_producto.cod_producto%type,
        inu_codPlan      IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
     )RETURN type_cursor;
     
     /*---------------------------------------------------------------------
      fn_get_programaxproducto_str: Traer los programas de cada producto en un string con estructura de objeto
     ----------------------------------------------------------------------- */
     FUNCTION fn_get_programaxproducto_str
     (
        pty_cod_producto in vdir_producto.cod_producto%type,
        inu_codPlan      IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
     )RETURN VARCHAR2;
     
     /*---------------------------------------------------------------------
      fn_get_promocion_producto: Trae la el valor de la promocion a la que aplica un producto
     ----------------------------------------------------------------------- */
     FUNCTION fn_get_promocion_producto
     (
        pty_cod_producto in vdir_producto.cod_producto%type
     )RETURN NUMBER;  
    	
	/*---------------------------------------------------------------------
    fn_get_tarifa: Traer tarifa beneficiario por programa
    ----------------------------------------------------------------------*/
    FUNCTION fn_get_tarifa
     (
        pty_cod_beneficiario in vdir_persona.cod_persona%type,
        pty_cod_programa in vdir_programa.cod_programa%type,
        pty_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type
     )RETURN vdir_tarifa.cod_tarifa%type;
     
     /*---------------------------------------------------------------------
      fn_get_valor_tarifa: Traer el valor de la tarifa
      ---------------------------------------------------------------------- */
     FUNCTION fn_get_valor_tarifa
     (
        pty_cod_tarifa in vdir_tarifa.cod_tarifa%type
     )RETURN vdir_tarifa.valor%type;
     
     /*---------------------------------------------------------------------
      sp_quitar_beneficiario_programa: Quitar registros diferentes a estado 1 en la tabla vdir_beneficiario_programa
      ----------------------------------------------------------------------- */
     PROCEDURE sp_quitar_benefi_programa
     (
        pty_cod_usuario in vdir_usuario.cod_usuario%type
     );
    
    /*---------------------------------------------------------------------
      sp_registra_benefi_programa: Agregar beneficiario programa 
      ----------------------------------------------------------------------*/
    
     PROCEDURE sp_registra_benefi_programa
     (
        p_cod_beneficiario in vdir_persona.cod_persona%type,
        p_cod_programa in vdir_programa.cod_programa%type,
        p_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type,
        p_cod_estado in vdir_estado.cod_estado%type,
        p_cod_tipoSolicitud in vdir_tipo_solicitud.cod_tipo_solicitud%type,
        p_val_tarifa out number,
        p_replica_val_tarifa out number
     );
     
    /*---------------------------------------------------------------------
    sp_registra_factura: Registrar factura de compra productos (linea, programa, beneficiario) 
    ----------------------------------------------------------------------*/
     PROCEDURE sp_registra_factura
     (
        pty_cod_usuario in vdir_usuario.cod_usuario%type,
        pty_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type,
        pty_cod_factura out vdir_factura.cod_factura%type
     );

     /*---------------------------------------------------------------------
      fn_get_benficiarios_programas: Traer los beneficiarios que estan registrados a un programa
      ---------------------------------------------------------------------- */
     FUNCTION fn_get_benficiarios_programas
     (
        pty_cod_usuario in vdir_usuario.cod_usuario%type
     )RETURN type_cursor;
     
      /*---------------------------------------------------------------------
      fn_get_codPrograma_homologa: Traer el codigo de hologacion del programa plan
      ----------------------------------------------------------------------- */
     FUNCTION fn_get_codPrograma_homologa
     (
        pty_cod_programa in vdir_programa.cod_programa%type,
        pty_cod_plan in vdir_plan.cod_plan%type
     )RETURN vdir_plan_programa.cod_programa_homologa%type;
    
     /*---------------------------------------------------------------------
     sp_set_estado_benefi_program: Actualizar estado alos pregamas agragados a un beneficiario temporalmente de una afiliacion pendiente
     ----------------------------------------------------------------------- */
     PROCEDURE sp_set_estado_benefi_program
     (
        pty_cod_usuario in vdir_usuario.cod_usuario%type,
        pty_cod_estado in vdir_estado.cod_estado%type
     );

END VDIR_PACK_REGISTRO_PRODUCTOS;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VDIR_PACK_REGISTRO_PRODUCTOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnolog�a Inform�tica Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_PRODUCTOS BODY
 Caso de Uso : 
 Descripci�n : Procesos para la ejecucion del requerimiento Registro de productos - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : diego.castillo@kalettre.com
 Fecha : 10-12-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificaci�n
 ----------------------------------------------------------------- */
 
 /*---------------------------------------------------------------------
  fn_get_producto: Traer la informacion del producto y sus programas
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 10-12-2018
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_producto
 (
    pty_cod_producto in vdir_producto.cod_producto%type,
	inu_codPlan      IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
 )RETURN type_cursor IS
    ltc_datos type_cursor;
 BEGIN 
 
    OPEN ltc_datos FOR
    SELECT
        vpro.cod_producto,
        COALESCE(vpro.des_producto, ' ') AS des_producto,
        COALESCE(vpro.descripcion, ' ') AS descripcion,
        VDIR_PACK_REGISTRO_PRODUCTOS.fn_get_programaxproducto_str(vpro.cod_producto, inu_codPlan) AS programas
    FROM
        vdir_producto vpro
    WHERE
        vpro.cod_producto = CASE WHEN pty_cod_producto = -1 THEN vpro.cod_producto ELSE pty_cod_producto END
		AND EXISTS (SELECT plpr.cod_programa
					  FROM VDIR_PROGRAMA      prog,
					       VDIR_PLAN_PROGRAMA plpr
					 WHERE prog.cod_programa = plpr.cod_programa 
					   AND prog.cod_producto = vpro.cod_producto
					   AND plpr.cod_estado   = 1
					   AND plpr.cod_plan     = inu_codPlan)
        AND cod_estado = 1
    ORDER BY cod_producto;
       
       
    RETURN ltc_datos;
 
 END fn_get_producto;
 
  /*---------------------------------------------------------------------
  fn_get_programaxproducto_str: Traer los programas de cada producto en un string con estructura de objeto
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 11-12-2018
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_programaxproducto_str
 (
    pty_cod_producto in vdir_producto.cod_producto%type,
	inu_codPlan      IN VDIR_PLAN_PROGRAMA.COD_PLAN%TYPE
 )RETURN VARCHAR2 IS
    ltc_datos type_cursor;
    lv_programas VARCHAR2(4000);
 BEGIN
    lv_programas := '[ ';
    
    FOR fila IN (SELECT prog.cod_programa,
					    prog.des_programa,
					    vfil.ruta,
	                    vfil.url,
						prog.descripcion
			 	   FROM vdir_programa prog,
					    vdir_programa_file prfi,
					    vdir_file vfil,
						vdir_plan_programa plpr
				  WHERE prog.cod_programa  = prfi.cod_programa
				    AND prog.cod_programa  = plpr.cod_programa
				    AND prfi.cod_file      = vfil.cod_file
				    AND vfil.cod_tipo_file = 3
					AND plpr.cod_estado    = 1
					AND plpr.cod_plan      = inu_codPlan 
				    AND prog.cod_producto  = CASE WHEN pty_cod_producto = -1 THEN prog.cod_producto ELSE pty_cod_producto END)
    LOOP
        lv_programas := lv_programas || '{"cod_programa":"' || fila.cod_programa || '",';
        lv_programas := lv_programas || '"des_programa":"'  || fila.des_programa || '",';
		lv_programas := lv_programas || '"link_url_firma":"'  || fila.url || '",';
		lv_programas := lv_programas || '"descripcion":"'  || fila.descripcion || '",';
		lv_programas := lv_programas || '"link_contrato":"' || fila.ruta || '"},';
    END LOOP;
    lv_programas := SUBSTR(lv_programas, 1,LENGTH(lv_programas)-1)  ||']';
       
    RETURN lv_programas;
 
 END fn_get_programaxproducto_str;
 
 /*---------------------------------------------------------------------
  fn_get_promocion_producto: Trae la el valor de la promocion a la que aplica un producto
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 17-12-2018
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_promocion_producto
 (
    pty_cod_producto in vdir_producto.cod_producto%type
 )RETURN NUMBER IS
    lv_valor_promo NUMBER;
 BEGIN
    
    IF pty_cod_producto = 2 THEN
        lv_valor_promo := 2000;
    ELSE
        lv_valor_promo := -1;
    END IF;
    
       
    RETURN lv_valor_promo;
 
 END fn_get_promocion_producto;  
	
	     
 /*---------------------------------------------------------------------
  fn_get_tarifa: Traer tarifa beneficiario por programa
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 20-01-2019
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_tarifa
 (
    pty_cod_beneficiario in vdir_persona.cod_persona%type,
    pty_cod_programa in vdir_programa.cod_programa%type,
    pty_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type
 )RETURN vdir_tarifa.cod_tarifa%type IS
    
    TYPE datos_benefi IS RECORD(
        cod_sexo vdir_sexo.cod_sexo%type,
        edad NUMBER
    );
    
    lv_cod_tarifa vdir_tarifa.cod_tarifa%type;
    lt_benefi datos_benefi;
    lv_cod_plan vdir_plan.cod_plan%type;
    lv_count_user NUMBER;
 BEGIN    
    --Consultar el plan al pertenese el usuario
    BEGIN
        SELECT 
            cod_plan INTO lv_cod_plan
        FROM
            vdir_contratante_beneficiario cb
            INNER JOIN vdir_usuario us ON us.cod_persona = cb.cod_contratante
        WHERE
            cb.cod_beneficiario = pty_cod_beneficiario
            AND cb.cod_afiliacion = pty_cod_afiliacion;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            lv_cod_plan := -1;    
    END;
    --Consultar sexo y edad del beneficiario
    BEGIN
        SELECT 
            cod_sexo,
            trunc(months_between(sysdate, fecha_nacimiento)/12)
            INTO
            lt_benefi
        FROM
            vdir_persona
        WHERE
            cod_persona = pty_cod_beneficiario;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            lt_benefi.cod_sexo := -1;    
            lt_benefi.edad := -1;
    END;
    --Consultar cuantos beneficiarios estas asociados al programa en la afiliacion
    BEGIN
        SELECT 
            COUNT(*) INTO lv_count_user
        FROM 
            vdir_beneficiario_programa
        WHERE 
            cod_programa = pty_cod_programa
            AND cod_afiliacion = pty_cod_afiliacion
            AND cod_estado = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            lv_count_user := 0;  
    END;
    
    --IF lv_count_user > 0 THEN
    --    lv_count_user := lv_count_user - 1;
    --END IF;
    --Consultar tarifa a la aplica el beneficiario al adquireir el programa
    SELECT
        COALESCE(MAX(tr.cod_tarifa), -1) INTO lv_cod_tarifa
    FROM
        vdir_tarifa tr
        INNER JOIN vdir_plan_programa pp ON pp.cod_plan_programa = tr.cod_plan_programa
    WHERE
        pp.cod_plan = lv_cod_plan
        AND pp.cod_programa = pty_cod_programa
        AND ((cod_sexo = lt_benefi.cod_sexo AND cod_condicion_tarifa = 2)
                OR (cod_sexo IS NULL AND cod_condicion_tarifa = 1))
        AND ((edad_inicial <= lt_benefi.edad AND cod_condicion_tarifa = 2)
                OR (edad_inicial IS NULL AND cod_condicion_tarifa = 1))
        AND ((edad_final >= lt_benefi.edad AND cod_condicion_tarifa = 2)
                OR (edad_final IS NULL AND cod_condicion_tarifa = 1))
        AND ((cod_num_usuarios_tarifa <= lv_count_user AND cod_condicion_tarifa = 1)
            OR (cod_num_usuarios_tarifa IS NULL AND cod_condicion_tarifa = 2))
        AND tr.cod_estado = 1;
       
    RETURN lv_cod_tarifa;
 
 END fn_get_tarifa;  
    
 /*---------------------------------------------------------------------
  fn_get_valor_tarifa: Traer el valor de la tarifa
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 22-01-2019
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_valor_tarifa
 (
    pty_cod_tarifa in vdir_tarifa.cod_tarifa%type
 )RETURN vdir_tarifa.valor%type IS
    lv_val_tarifa vdir_tarifa.valor%type;
 BEGIN
    
    BEGIN
      SELECT
            valor INTO lv_val_tarifa
        FROM
            vdir_tarifa
        WHERE
            cod_tarifa = pty_cod_tarifa;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            lv_val_tarifa := 0;
    END;
       
    RETURN lv_val_tarifa;
 
 END fn_get_valor_tarifa;      

 /*---------------------------------------------------------------------
  sp_registra_benefi_programa: Agregar beneficiario programa 
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 20-01-2019
 ----------------------------------------------------------------------- */
 PROCEDURE sp_registra_benefi_programa
 (
    p_cod_beneficiario in vdir_persona.cod_persona%type,
    p_cod_programa in vdir_programa.cod_programa%type,
    p_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type,
    p_cod_estado in vdir_estado.cod_estado%type,
    p_cod_tipoSolicitud in vdir_tipo_solicitud.cod_tipo_solicitud%type,
    p_val_tarifa out number,
    p_replica_val_tarifa out number
 ) IS
    lv_cod_tarifa vdir_tarifa.cod_tarifa%type;
    lv_sec_beneficiario_programa integer;
    lv_existe integer;
    
    
 BEGIN
    lv_cod_tarifa := -1;
    
    --Validar si beneficiario ya se encuentra relacionado al programa en la misma afiliacion
    SELECT 
        COUNT(*) INTO lv_existe
    FROM
        vdir_beneficiario_programa
    WHERE
        cod_programa = p_cod_programa
        AND cod_beneficiario = p_cod_beneficiario
        AND cod_afiliacion = p_cod_afiliacion;
       
    IF lv_existe < 1 THEN
        SELECT VDIR_SEQ_BENEFICIARIO_PROGRAMA.NEXTVAL INTO lv_sec_beneficiario_programa FROM DUAL;        
        INSERT INTO vdir_beneficiario_programa(
            cod_beneficiario_programa,
            cod_programa,
            cod_beneficiario,
            cod_tarifa,
            cod_afiliacion,
            cod_estado,
            cod_tipo_solicitud
        ) VALUES (
            lv_sec_beneficiario_programa,
            p_cod_programa,
            p_cod_beneficiario,
            lv_cod_tarifa,
            p_cod_afiliacion,
            p_cod_estado,
            p_cod_tipoSolicitud
        );    
    ELSE
        UPDATE vdir_beneficiario_programa
        SET
            cod_tarifa = lv_cod_tarifa,
            cod_estado = p_cod_estado,
            cod_tipo_solicitud = p_cod_tipoSolicitud
        WHERE
            cod_programa = p_cod_programa
            AND cod_beneficiario = p_cod_beneficiario
            AND cod_afiliacion = p_cod_afiliacion;
    END IF;
    
    --Consultar codigo de tarifa a la que aplica l beneficiario en el programa
    lv_cod_tarifa := VDIR_PACK_REGISTRO_PRODUCTOS.fn_get_tarifa(p_cod_beneficiario, p_cod_programa, p_cod_afiliacion);    
    --Consultar valor de la tarifa y a cuantos usurios se replica este valor
    BEGIN
        SELECT
            valor,
            (CASE WHEN cod_num_usuarios_tarifa IS NULL OR cod_tarifa = -1 THEN 0 ELSE cod_num_usuarios_tarifa END)
            INTO
            p_val_tarifa,
            p_replica_val_tarifa
        FROM
            vdir_tarifa
        WHERE
            cod_tarifa = lv_cod_tarifa;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_val_tarifa := -1;
            p_replica_val_tarifa := 0;
    END;
    
    --Actualizar tarifa a la que aplica el beneficiario por la compra del programa
    UPDATE vdir_beneficiario_programa
        SET
            cod_tarifa = lv_cod_tarifa,
            cod_estado = CASE WHEN lv_cod_tarifa = -1 THEN 2 ELSE cod_estado END --Si tarifa es default(-1), se inactiva el registro pasando el valor 2
    WHERE
        cod_programa = p_cod_programa
        AND cod_beneficiario = p_cod_beneficiario
        AND cod_afiliacion = p_cod_afiliacion;
    
    --Aplicar tarifa cuando esta se realice por nuero de usuarios
    IF p_replica_val_tarifa > 0 THEN
        UPDATE vdir_beneficiario_programa
        SET
            cod_tarifa = lv_cod_tarifa
        WHERE
            cod_programa = p_cod_programa
            AND cod_afiliacion = p_cod_afiliacion;    
    END IF;
     
 END sp_registra_benefi_programa;
 
  /*---------------------------------------------------------------------
  sp_quitar_beneficiario_programa: Quitar registros diferentes a estado 1 en la tabla vdir_beneficiario_programa
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 22-01-2019
 ----------------------------------------------------------------------- */
 PROCEDURE sp_quitar_benefi_programa
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 ) IS
    lv_cod_afiliacion_pendiente vdir_afiliacion.cod_afiliacion%type;
 BEGIN
    lv_cod_afiliacion_pendiente := VDIR_PACK_REGISTRO_DATOS.fn_get_afiliacion_pendiente(pty_cod_usuario);
    
    --Eliminar registros de vdir_factura_detalle donde el cod_beneficiario_programa se encuentre en estado diferente a 1=activo
    DELETE FROM vdir_factura_detalle
    WHERE
        cod_factura_detalle IN (SELECT 
                                        fd.cod_factura_detalle
                                    FROM
                                        vdir_beneficiario_programa bp
                                        INNER JOIN vdir_factura fa ON  fa.cod_afiliacion = bp.cod_afiliacion
                                        INNER JOIN vdir_factura_detalle fd ON fd.cod_factura = fa.cod_factura
                                                                            AND fd.cod_beneficiario_programa = bp.cod_beneficiario_programa
                                    WHERE
                                        bp.cod_afiliacion = lv_cod_afiliacion_pendiente
                                        AND bp.cod_estado <> 1);    
    
    --Eliminar registros de vdir_beneficiario_programa que con estado diferente a 1 (no se encuentran activos)
    DELETE vdir_beneficiario_programa
    WHERE
        cod_afiliacion = lv_cod_afiliacion_pendiente
        AND cod_estado <> 1;
     
 END sp_quitar_benefi_programa;
 
 
  /*---------------------------------------------------------------------
  sp_registra_factura: Registrar factura de compra productos (linea, programa, beneficiario) 
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 21-01-2019
 ----------------------------------------------------------------------- */
 PROCEDURE sp_registra_factura
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type,
    pty_cod_afiliacion in vdir_afiliacion.cod_afiliacion%type,
    pty_cod_factura out vdir_factura.cod_factura%type
 ) IS
    lv_cod_tarifa vdir_tarifa.cod_tarifa%type;
    lv_sec_factura integer;
    lv_sec_factura_detalle integer;
    lv_existe integer;
    lv_valor_tarifa number;
    lv_aux_valor_total number;
 BEGIN
    
    --Consultar valor total de la factura
    SELECT 
        COALESCE(SUM(tr.valor), 0) INTO lv_aux_valor_total
    FROM
        vdir_beneficiario_programa bp
        INNER JOIN vdir_tarifa tr ON tr.cod_tarifa = bp.cod_tarifa
    WHERE
        bp.cod_afiliacion = pty_cod_afiliacion
        AND bp.cod_estado = 1;
        
    BEGIN    
        --Consultar codigo factura
        SELECT 
            cod_factura INTO lv_sec_factura
        FROM
            vdir_factura
        WHERE
            cod_usuario = pty_cod_usuario
            AND cod_afiliacion = pty_cod_afiliacion;
            
        --Eliminar registros de vdir_beneficiario_programa que con estado diferente a 1 (no se encuentran selecionados)
        VDIR_PACK_REGISTRO_PRODUCTOS.sp_quitar_benefi_programa(pty_cod_usuario);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            lv_sec_factura := 0;
    END;
       
    IF lv_sec_factura < 1 THEN
        --Consultar secuencia factura
        SELECT VDIR_SEQ_FACTURA.NEXTVAL INTO lv_sec_factura FROM DUAL;        
        --Insertar datos factura
        INSERT INTO vdir_factura(
            cod_factura,
            total_pagar,
            valor_impuesto,
            fecha_creacion,
            sub_total,
            valor_promocion,
            cod_tipo_pago,
            cod_forma_pago,
            cod_estado,
            cod_usuario,
            cod_afiliacion            
        ) VALUES (
            lv_sec_factura,
            lv_aux_valor_total,
            NULL,
            SYSDATE,
            lv_aux_valor_total,
            NULL,
            NULL,
            NULL,
            1,
            pty_cod_usuario,
            pty_cod_afiliacion
        );    
    ELSE            
        --Actualizar datos factura
        UPDATE vdir_factura
        SET
            total_pagar = lv_aux_valor_total,
            sub_total = lv_aux_valor_total
        WHERE
            cod_factura = lv_sec_factura;
    END IF;
    
    --Registrar detalle factura
    FOR fila IN (SELECT 
                        COALESCE(tr.valor, 0) AS valor,
                        bp.cod_tarifa,
                        bp.cod_beneficiario_programa
                    FROM
                        vdir_beneficiario_programa bp
                        INNER JOIN vdir_tarifa tr ON tr.cod_tarifa = bp.cod_tarifa
                    WHERE
                        bp.cod_afiliacion = pty_cod_afiliacion
                        AND bp.cod_estado = 1)
    LOOP
        --Validar si existe el registro
        SELECT 
            COUNT(*) INTO lv_existe 
        FROM 
            vdir_factura_detalle 
        WHERE 
            cod_factura = lv_sec_factura 
            AND cod_beneficiario_programa = fila.cod_beneficiario_programa;
        --Consultar valor tarifa
        lv_valor_tarifa := fila.valor; --SELECT valor INTO lv_valor_tarifa FROM vdir_tarifa WHERE cod_tarifa = fila.cod_tarifa;
        
        IF lv_existe < 1 THEN
            --Consultar secuencia factura detalle
            SELECT VDIR_SEQ_FACTURA_DETALLE.NEXTVAL INTO lv_sec_factura_detalle FROM DUAL;
            
            INSERT INTO vdir_factura_detalle(
                cod_factura_detalle,
                valor_total,
                sub_total,
                cantidad,
                valor_impuesto,
                valor_promocion,
                valor_tarifa,
                porcentaje_impuesto,
                cod_beneficiario_programa,
                cod_factura
            )VALUES(
                lv_sec_factura_detalle,
                lv_valor_tarifa,
                lv_valor_tarifa,
                1,
                NULL,
                NULL,
                lv_valor_tarifa,
                NULL,
                fila.cod_beneficiario_programa,
                lv_sec_factura
            );
        ELSE
            UPDATE vdir_factura_detalle
            SET
                valor_total = lv_valor_tarifa,
                sub_total = lv_valor_tarifa,
                valor_tarifa = lv_valor_tarifa
            WHERE
                cod_beneficiario_programa = fila.cod_beneficiario_programa
                AND cod_factura = lv_sec_factura;
        END IF;
        
        pty_cod_factura := lv_sec_factura;
    
    END LOOP;
     
 END sp_registra_factura;
 
 /*---------------------------------------------------------------------
  fn_get_benficiarios_programas: Traer los beneficiarios que estan registrados a un programa
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 22-01-2019
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_benficiarios_programas
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type
 )RETURN type_cursor IS
    ltc_datos type_cursor;
    lv_cod_afiliacion_pendiente vdir_afiliacion.cod_afiliacion%type;
 BEGIN
    lv_cod_afiliacion_pendiente := VDIR_PACK_REGISTRO_DATOS.fn_get_afiliacion_pendiente(pty_cod_usuario);
    
    BEGIN
        OPEN ltc_datos FOR
        SELECT 
                bp.cod_programa,
                bp.cod_beneficiario,
                bp.cod_afiliacion,
                bp.cod_tarifa,
                tr.valor AS val_tarifa,
                pm.cod_producto,
                pe.cod_tipo_identificacion,
                pe.numero_identificacion,
                bp.cod_tipo_solicitud
            FROM
                vdir_beneficiario_programa bp
                INNER JOIN vdir_programa pm ON pm.cod_programa = bp.cod_programa
                INNER JOIN vdir_persona pe ON pe.cod_persona = bp.cod_beneficiario
                INNER JOIN vdir_tarifa tr ON tr.cod_tarifa = bp.cod_tarifa
            WHERE
                cod_afiliacion = lv_cod_afiliacion_pendiente
                AND bp.cod_estado = 1;
            
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            OPEN ltc_datos FOR
            SELECT -1 AS cod_beneficiario_programa FROM DUAL;
    END;       

    RETURN ltc_datos;

 END fn_get_benficiarios_programas;
 
 /*---------------------------------------------------------------------
  fn_get_codPrograma_homologa: Traer el codigo de hologacion del programa plan
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 14-02-2019
 ----------------------------------------------------------------------- */
 FUNCTION fn_get_codPrograma_homologa
 (
    pty_cod_programa in vdir_programa.cod_programa%type,
    pty_cod_plan in vdir_plan.cod_plan%type
 )RETURN vdir_plan_programa.cod_programa_homologa%type IS
    lv_codPrograma_homologa vdir_plan_programa.cod_programa_homologa%type;
 BEGIN
 
    BEGIN
        SELECT
            cod_programa_homologa INTO lv_codPrograma_homologa
        FROM
            vdir_plan_programa
        WHERE
            cod_programa = pty_cod_programa
            AND cod_plan = pty_cod_plan;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            lv_codPrograma_homologa := '-1';
    END;
       
    RETURN lv_codPrograma_homologa;
 
 END fn_get_codPrograma_homologa;
 
  /*---------------------------------------------------------------------
  sp_set_estado_benefi_program: Actualizar estado alos pregamas agragados a un beneficiario temporalmente de una afiliacion pendiente
  ----------------------------------------------------------------------
  Autor : diego.castillo@kalettre.com
  Fecha : 18-02-2019
 ----------------------------------------------------------------------- */
 PROCEDURE sp_set_estado_benefi_program
 (
    pty_cod_usuario in vdir_usuario.cod_usuario%type,
    pty_cod_estado in vdir_estado.cod_estado%type
 ) IS
    ltc_datos type_cursor;
    lv_cod_afiliacion vdir_afiliacion.cod_afiliacion%type;
 BEGIN
    lv_cod_afiliacion := VDIR_PACK_REGISTRO_DATOS.fn_get_afiliacion_pendiente(pty_cod_usuario);
 
    UPDATE vdir_beneficiario_programa
    SET
        cod_estado = pty_cod_estado
    WHERE
        cod_afiliacion = lv_cod_afiliacion
        AND cod_estado = 3;    
    
 END sp_set_estado_benefi_program;
 
END VDIR_PACK_REGISTRO_PRODUCTOS;
/

CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_TARIFAS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_TARIFAS
 Caso de Uso : 
 Descripción : Procesos para el registro del las tarifas - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 28-01-2018  
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
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_TARIFAS
 Caso de Uso : 
 Descripción : Procesos para el registro del las tarifas - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 28-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_TARIFAS
	 Caso de Uso : 
	 Descripción : Procedimiento que guarda la tarifa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	    inu_codPlanPrograma  Código del plan asociado al programa
        inu_codPlan          Código del plan
		inu_codEstado        Código del estado
		inu_codTipoTarifa    Código del tipo de tarifa
		inu_valorTarifa      Valor de la tarifa
		idt_fecVigenciaIni   Fecha inicio de vigencia
		idt_fecVigenciaFin   Fecha fin de vigencia
		inu_codCondicion     Código de la condición
		inu_codNumUsuarios   Código del número de usuarios
		inu_codSexo          Código del genero
		inu_edadInicial      Edad mínima
		inu_edadFinal        Edad máxima
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al guardar la tarifa: '||SQLERRM); 
		
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_TARIFAS
	 Caso de Uso : 
	 Descripción : Procedimiento que actualiza la tarifa
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 28-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	    inu_codTarifa        Código de la tarifa
	    inu_codPlanPrograma  Código del plan asociado al programa
        inu_codPlan          Código del plan
		inu_codEstado        Código del estado
		inu_codTipoTarifa    Código del tipo de tarifa
		inu_valorTarifa      Valor de la tarifa
		idt_fecVigenciaIni   Fecha inicio de vigencia
		idt_fecVigenciaFin   Fecha fin de vigencia
		inu_codCondicion     Código de la condición
		inu_codNumUsuarios   Código del número de usuarios
		inu_codSexo          Código del genero
		inu_edadInicial      Edad mínima
		inu_edadFinal        Edad máxima
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
		
		    RAISE_APPLICATION_ERROR(-20001,'Ocurrió un error al actualizar la tarifa: '||SQLERRM); 
		
		END;
		
	END prActualizarTarifa;
 
END VDIR_PACK_REGISTRO_TARIFAS;
/

CREATE OR REPLACE PACKAGE VDIR_PACK_REGISTRO_USUARIOS AS
/* ---------------------------------------------------------------------
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_USUARIOS
 Caso de Uso : 
 Descripción : Procesos para el registro del los usuarios - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 30-01-2018  
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
 Copyright  Tecnología Informática Coomeva - Colombia
 Package     : VDIR_PACK_REGISTRO_USUARIOS
 Caso de Uso : 
 Descripción : Procesos para el registro del los usuarios - VENTA DIRECTA
 --------------------------------------------------------------------
 Autor : katherine.latorre@kalettre.com
 Fecha : 30-01-2018  
 --------------------------------------------------------------------
 Procedimiento :     Descripcion:
 --------------------------------------------------------------------
 Historia de Modificaciones
 ---------------------------------------------------------------------
 Fecha Autor Modificación
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_USUARIOS
	 Caso de Uso : 
	 Descripción : Procedimiento que guarda el ingreso
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	    inu_codTipoId         Código del tipo de identificación
        inu_nroId             Número del tipo de identificación
		ivc_primerNombre      Primer nombre del usuario
		ivc_segundoNombre     Segundo nombre del usuario
		ivc_primerApellido    Primer apellido del usuario
		ivc_segundoApellido   Segundo apellido del usuario
		ivc_correoElectronico Correo electrónico del usuario
		ivc_telefono          Teléfono del usuario
		ivc_login             Login del usuario
		ivc_clave             Clave del usuario
		inu_codPerfil         Código del perfil
		inu_codEstado         Código del estado
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
			-- Si no ocurrió ningun error
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
					-- Si no ocurrió ningun error
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_USUARIOS
	 Caso de Uso : 
	 Descripción : Procedimiento que actualiza el usuario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 31-01-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	    inu_codPersona   Código de la persona
	    inu_codUsuario   Código del usuario
		inu_codPerfil    Código del perfil
		inu_codEstado    Código del estado
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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
		-- Si no ocurrió ningun error
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
	 Copyright   : Tecnología Informática Coomeva - Colombia
	 Package     : VDIR_PACK_REGISTRO_USUARIOS
	 Caso de Uso : 
	 Descripción : Procedimiento que actualiza la clave del usuario
	 ----------------------------------------------------------------------
	 Autor : katherine.latorre@kalettre.com
	 Fecha : 01-02-2019  
	 ----------------------------------------------------------------------
	 Parámetros :     Descripción:
	    inu_codUsuario   Código del usuario
		ivc_clave        Clave nueva ingresada por el usuario
	 ----------------------------------------------------------------------
	 Historia de Modificaciones
	 ----------------------------------------------------------------------
	 Fecha Autor Modificación
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

CREATE OR REPLACE 
PACKAGE VDIR_PACK_TARIFAS AS 

   -------------------FUNCION PARA TRAER LAS IMAGENES DE LAS PROMOCIONES
 FUNCTION VDIR_FN_GET_DATOS_PROMO_IMG RETURN sys_refcursor;
 
 -------------------- PROCEDIMIENTO PARA GUARDAR LAS IMAGNES DE LAS PROMOCIONES
 PROCEDURE VDIR_SP_SAVE_PROMO_IMG(p_name IN VARCHAR2,p_name_encript IN VARCHAR2,p_ruta IN VARCHAR2,p_respuesta OUT VARCHAR2);
 
 -------------------- PROCEDIMIENTO PARA ELIMINAR UNA IMAGEN
 PROCEDURE VDIR_SP_DELETE_PROMO_IMG(p_codigo_imagen IN NUMBER,p_respuesta OUT VARCHAR2);
 

END VDIR_PACK_TARIFAS;

/
CREATE OR REPLACE
PACKAGE BODY VDIR_PACK_TARIFAS AS

  FUNCTION VDIR_FN_GET_DATOS_PROMO_IMG RETURN sys_refcursor AS
  
    vl_cursor sys_refcursor;
    vl_parametro_url VARCHAR2(200);
  BEGIN    
  
    SELECT    
        valor_parametro INTO  vl_parametro_url       
    FROM
        vdir_parametro
    WHERE
     cod_parametro = 3
     AND cod_estado = 1;    
    
    OPEN vl_cursor
  FOR 
  
      SELECT 
        cod_file AS CODIGO_FILE,
        ruta AS RUTA_FILE,
        des_file
      FROM
        VDIR_FILE 
        
      WHERE
         COD_TIPO_FILE = 5;
         
    RETURN vl_cursor;  
    
  END VDIR_FN_GET_DATOS_PROMO_IMG;
  
  -------------------- PROCEDIMIENTO PARA GUARDAR LAS IMAGNES DE LAS PROMOCIONES
 PROCEDURE VDIR_SP_SAVE_PROMO_IMG(p_name IN VARCHAR2,p_name_encript IN VARCHAR2,p_ruta IN VARCHAR2,p_respuesta OUT VARCHAR2)
 AS
 
 BEGIN
 
  p_respuesta := 'Operación realizada correctamente.'; 
 
   INSERT INTO vdir_file (
    cod_file,
    des_file,   
    ruta,
    cod_tipo_file,    
    url
    
    ) VALUES (
       VDIR_SEQ_FILE.NEXTVAL,
       p_name,
       p_ruta,
       5,
       p_ruta
    );
    
    COMMIT;
  
  EXCEPTION 
    WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000, 'error.');
     p_respuesta := 'Ocurrio un error en la base de datos.';
     ROLLBACK;
 
 
 END VDIR_SP_SAVE_PROMO_IMG;
 
  -------------------- PROCEDIMIENTO PARA ELIMINAR UNA IMAGEN
 PROCEDURE VDIR_SP_DELETE_PROMO_IMG(p_codigo_imagen IN NUMBER,p_respuesta OUT VARCHAR2) 
 AS

 BEGIN
   p_respuesta := 'OK';
   
   
   DELETE FROM 
      vdir_file
   WHERE
    cod_file = p_codigo_imagen;
   
   
    EXCEPTION 
    WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000, 'error.');
     p_respuesta := 'Ocurrio un error en la base de datos.';
     ROLLBACK;
   
 END VDIR_SP_DELETE_PROMO_IMG; 
 

END VDIR_PACK_TARIFAS;

/






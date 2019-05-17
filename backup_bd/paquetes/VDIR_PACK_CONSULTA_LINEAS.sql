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
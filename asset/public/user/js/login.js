 var global_tipo_persona = 0;
 //var global_codigo_verificacion = 0;

 $(document).ready(function() {
 	 setTimeout(function(){ $("#usuario").val(""); $("#clave").val(""); }, 400);

 	 $("#btn-enviar").on("click",validarLogin);
 	 $("#btn-registrar").on("click",registrarse);
 	 $("#btn-restablecer").on("click",restablecerClave);
 	 $("#btn-cambioClave").on("click",cambioClave);	

 	 $("body").keypress(function(event){    
      var keycode = (event.keyCode ? event.keyCode : event.which);
      if(keycode == '13'){
        $("#btn-enviar").trigger('click');         
      }
    });
 	
    if(global_senal == 1){ 		
 	 	$("#btn-cambioClave").trigger("click");      
 	}

 });

 function restablecerClave(){

 	var idModal = 'modal_dialog_rest';
	var botonesModal = [{"id":"enviarMd","label":"Enviar","class":"btn-primary class_save  mr-2"},{"id":"canceMd","label":"Cancelar","class":"btn-primary "}];
	
    var formulario= $('<form id="form_rest_contrasena" autocomplete="off">'+
		                 '<div class="row">'+ 
			                 '<div class="col-lg-12 col-md-12 col-sm-12">'+
			                      '<label for="identificacion_rest" class="obligatorio">Identificaci&oacute;n</label>'+
								  '<input id="identificacion_rest" name="identificacion_rest" maxlength="12" type="text" class="form-control campo-vd input-sm">'+                        
			                 '</div>'+
			             '</div>'+
			          '</form>');		             

    crearModal(idModal,"Restablecer contrase&ntilde;a", formulario, botonesModal, true, '', '',true);	
		
	$('#canceMd').click(function(){
		$('#'+idModal).modal('hide');
	});	

	/* $("#identificacion_rest").on("keypress",function(event){
           return validar_solonumeros(event);
     }); */

	 // no permitir copiar letras
	 //validarCopyNumeric("identificacion_rest");	

	 $('#enviarMd').click(function(){
			var camposRequeridos = [  
                      {"id":"identificacion_rest", "texto":"Identificaci&oacute;n"}
                    ];

           if(validRequired(camposRequeridos)){

           	  	 runLoading(true);

				 var idModal = 'modalConfirmar';		 
		         var botonesModal = [{
		            	"id": "cerrarMd",
		            	"label": "Cerrar",
		            	"class": "btn-primary"
		         		}];   

				$.ajax({    
		          url: "Login/recordarContrasena", 
		          type: "POST",  
		          dataType: "json",
		          data:$("#form_rest_contrasena").serialize(), 	          	                             
		          success:function(data){
		            runLoading(false);	

		            //console.log("data ",data);	            	                                         
		               
		            global_codigo_verificacion = data["codigo_verificacion"] 

	                var mensaje = "";

	                if(data["respuesta"] == 'OK'){
	                    mensaje = "Se ha enviado un c&oacute;digo de seguridad al correo "+data["correo"]; 
	                }else if(data["respuesta"] == 'NO'){
	                	mensaje = "Se presentaron problemas al enviar el email";
	                }else{
	                	mensaje = data["respuesta"];
	                }

		             crearModal(idModal, 'Confirmaci&oacute;n',mensaje, botonesModal, false, '', '',true);
			            $('#cerrarMd').click(function() {
			                $('#'+idModal).modal('toggle');		                
			         });                      
		                                                                   
		          },		          
		          error: function(result) {

		          		  runLoading(false);		                      
		                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
		                  $('#cerrarMd').click(function() {
		                  	    $('#'+idModal).modal('toggle');	
		                  	    $('#modal_dialog_rest').modal('toggle');
		                  	    window.location.href = 'Login'; 
		                        
		                  });
		          }

		         });


           }
     });      
 }

 function cambioClave(){ 	

 	var idModal = 'modal_dialog_cambio';
	var botonesModal = [{"id":"enviarMd","label":"Enviar","class":"btn-primary class_save  mr-2 btn_clave"},{"id":"canceMd","label":"Cancelar","class":"btn-primary "}];
	
    var formulario= $('<form id="form_change_contrasena" autocomplete="off">'+
		                 '<div class="row">'+ 
			                 '<div class="col-lg-12 col-md-12 col-sm-12">'+
			                      '<label for="identificacion_rest" class="obligatorio">Identificaci&oacute;n</label>'+
								  '<input id="identificacion_rest" name="identificacion_rest" type="text" maxlength="12" class="form-control campo-vd input-sm">'+                        
			                 '</div>'+
			             '</div>'+
			             '<div class="row">'+ 
			                 '<div class="col-lg-12 col-md-12 col-sm-12">'+
			                      '<label for="codigo_rest" class="obligatorio">C&oacute;digo enviado a su correo</label>'+
								  '<input id="codigo_rest" name="codigo_rest" type="text" maxlength="4" class="form-control campo-vd input-sm">'+                        
			                 '</div>'+
			             '</div>'+
			              '<div class="row">'+ 
			                 '<div class="col-lg-8 col-md-8 col-sm-8">'+
			                      '<label for="clave1_rest" class="obligatorio">Contrase&ntilde;a</label>'+
								  '<input id="clave1_rest" name="clave1_rest" type="password" class="form-control campo-vd input-sm">'+                        
			                 '</div>'+
			                 '<div class="col-lg-4 col-md-4 col-sm-4">'+
			                      '<label for="recor_clave">Mostrar contrase&ntilde;a</label>'+
							 	'<div class="form-check">'+
								  '<label class="form-check-label">'+
			                          '<input class="form-check-input" onclick="showClave()" type="checkbox">'+
			                          '<span class="circle">'+
                   						 '<span class="check"></span>'+
                 					  '</span>'+
			                      '</label>'+			                      
		                      	'</div>'+                           
			                 '</div>'+
			             '</div>'+
			              '<div class="row">'+ 
			                 '<div class="col-lg-8 col-md-8 col-sm-8">'+
			                      '<label for="clave2_rest" class="obligatorio">Ingrese nuevamente la contrase&ntilde;a</label>'+
								  '<input id="clave2_rest" name="clave2_rest" type="password" class="form-control campo-vd input-sm">'+                        
			                 '</div>'+
			                 '<div class="col-lg-4 col-md-4 col-sm-4">'+
			                    '<label for="recor_clave">Mostrar contrase&ntilde;a</label>'+
							 	'<div class="form-check">'+
								  '<label class="form-check-label">'+
			                          '<input class="form-check-input" onclick="showClave2()" type="checkbox">'+
			                          '<span class="circle">'+
                   						 '<span class="check"></span>'+
                 					  '</span>'+
			                      '</label>'+			                      
		                      	'</div>'+                           
			                 '</div>'+
			             '</div>'+
		           '</form>');		            

    crearModal(idModal,"Cambio contrase&ntilde;a", formulario, botonesModal, true, '', '',true);

    $("#clave1_rest").PassRequirements();
    $("#clave2_rest").PassRequirements();   	
		
	$('#canceMd').click(function(){
		$('#'+idModal).modal('hide');
	});		


	/*$("#codigo_rest").on("keypress",function(event){
           return validar_solonumeros(event);
     }); */

	 $("#codigo_rest").on('input', function () { 
         this.value = this.value.replace(/[^0-9]/g,'');
     });

	 // no permitir copiar letras
	 validarCopyNumeric("codigo_rest");

	 $('#enviarMd').click(function(){
			var camposRequeridos = [  
                      {"id":"identificacion_rest", "texto":"Identificaci&oacute;n"},
                      {"id":"codigo_rest", "texto":"C&oacute;digo enviado a su correo"},
                      {"id":"clave1_rest", "texto":"Contrase&ntilde;a"},
                      {"id":"clave2_rest", "texto":"Ingrese nuevamente la contrase&ntilde;a"}
					];

			var validaClave1 = $("#clave1_rest").attr('validaPassword');
			var validaClave2 = $("#clave2_rest").attr('validaPassword');			

            if(validRequired(camposRequeridos)){

           	  var idModal = 'modalConfirmar';		 
	          var botonesModal = [{
					            	"id": "cerrarMd",
					            	"label": "Aceptar",
					            	"class": "btn-primary"
								  }];
				
				if (validaClave1 == 0){
				    $("#clave1_rest").focus(); 
				    return false;
				}

				if (validaClave2 == 0){
					$("#clave2_rest").focus();
				    return false; 
				}

           	  if ($("#clave1_rest").val() != $("#clave2_rest").val()) {

           	  	  crearModal(idModal, 'Advertencia','Las claves ingresadas no coinciden', botonesModal, false, '', '',true);
	              $('#cerrarMd').click(function() {
	              	$('#'+idModal).modal('toggle');		                
	          	  });
	             $("#clave1_rest").focus(); 
	             return false;           	  	 
			  } 

           	   if ($("#codigo_rest").val() != global_codigo_verificacion) {

           	   	    var idModal = 'modalConfirmar';		 
		         	var botonesModal = [{
		            	"id": "cerrarMd",
		            	"label": "Cerrar",
		            	"class": "btn-primary"
		         		}];  

           	 	    crearModal(idModal, 'Advertencia','El c&oacute;digo de verificaci&oacute;n debe ser el mismo que se le env&iacute;o al correo.', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		               $('#'+idModal).modal('toggle');		                
		          	});
		            $("#codigo_rest").focus();           	  	 
           	  	  	return false;
           	   } 

           	  runLoading(true);

				 var idModal = 'modalConfirmar';		 
		         var botonesModal = [{
		            	"id": "cerrarMd",
		            	"label": "Aceptar",
		            	"class": "btn-primary"
		         		}];   

				$.ajax({    
		          url: "Login/cambiarContrasena", 
		          type: "POST",  
		          dataType: "json",
		          data:$("#form_change_contrasena").serialize(), 	          	                             
		          success:function(data){
		            runLoading(false);		            	                                         
		              
		            crearModal(idModal, 'Confirmaci\u00f3n', data.respuesta, botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		                $('#'+idModal).modal('toggle');
		                $('#modal_dialog_cambio').modal('toggle');
		            });                       
		                                                                   
		          },		          
		          error: function(result) {
		          		  runLoading(false);		                      
		                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '');
		                  $('#cerrarMd').click(function() {
		                  	    $('#'+idModal).modal('toggle');	
		                  	    $('#modal_dialog_cambio').modal('toggle');
		                  	    window.location.href = 'Login'; 
		                        
		                  });
		          }

		         });     	  


           }
     }); 


 }

 function showClave(){ 	

 	var type = $("#clave1_rest").attr("type");
    if (type === "password") {
        $("#clave1_rest").attr("type","text");
    } else {
        $("#clave1_rest").attr("type","password");
    }
 }
 function showClave2(){

 	//console.log("type",$("#clave1_rest").attr("type"));

 	var type = $("#clave2_rest").attr("type");
    if (type === "password") {
        $("#clave2_rest").attr("type","text");
    } else {
        $("#clave2_rest").attr("type","password");
    }
 }

 function registrarse(){

 	 var idModal = 'modal_dialog_cambio';
	 var botonesModal = [{"id":"saveMd","label":"Registrar","class":"btn-primary class_save  mr-2 btn_clave"},{"id":"cancelarMd","label":"Cancelar","class":"btn-primary "}];
	
	 var formulario= $('<form id="form_usuario" name="form_usuario" autocomplete="off">'+
	                 '<div class="row">'+
	                    '<div class=" col-lg-6 col-md-6 col-sm-6">'+
	                     '<label for="tipo_identificacion" class="obligatorio">Tipo identificaci&oacute;n</label>'+	                      
						  g_listaTipoIdentificacion+
	                    '</div>'+
	                    '<div class="col-lg-6 col-md-6 col-sm-6" id="div_identificacion">'+
	                      '<label for="identificacion" class="obligatorio">Identificaci&oacute;n</label>'+
						  '<input id="identificacion" name="identificacion" maxlength="12" type="text" disabled class="form-control campo-vd input-sm">'+                        
	                    '</div>'+	                     	                    
	                 '</div>'+
	                 '<div class="row">'+
	                     '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="nombre1" class="obligatorio">Primer Nombre</label>'+
						  '<input id="nombre1" name="nombre1" type="text" maxlength="50" class="form-control campo-vd input-sm">'+                        
	                     '</div>'+
	                     '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="nombre2">Segundo Nombre</label>'+
						  '<input id="nombre2" name="nombre2" type="text" maxlength="50" class="form-control campo-vd input-sm">'+                        
	                    '</div>'+               
	                 '</div>'+	 
	                 '<div class="row">'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="apellido1" class="obligatorio">Primer Apellido</label>'+
						  '<input id="apellido1" name="apellido1" type="text" maxlength="50" class="form-control campo-vd input-sm">'+                        
	                    '</div>'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="apellido2">Segundo Apellido</label>'+
						  '<input id="apellido2" name="apellido2" type="text" maxlength="50" class="form-control campo-vd input-sm">'+                        
	                    '</div>'+	                     
	                 '</div>'+
	                 '<div class="row">'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="fecha_nacimiento" class="obligatorio">Fecha nacimiento</label>'+
						  '<input id="fecha_nacimiento" name="fecha_nacimiento" type="text" maxlength="12" class="form-control campo-vd" onkeypress="return false;" style="height: 37px;">'+                        
	                    '</div>'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label class="obligatorio" for="lit_sexo">Sexo</label>'+
						   g_listaSexo+
	                    '</div>'+	                     
	                 '</div>'+
	                 '<div class="row">'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="telefono">Tel&eacute;fono</label>'+
						  '<input id="telefono" name="telefono" type="text" maxlength="10" class="form-control campo-vd input-sm">'+
	                    '</div>'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="celular" class="obligatorio">Celular</label>'+
						  '<input id="celular" name="celular" type="text" maxlength="10" class="form-control campo-vd input-sm">'+
	                    '</div>'+	                    
	                 '</div>'+	                	                                 
	                 '<div class="row">'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="correo" class="obligatorio">Email</label>'+
						  '<input id="correo" name="correo" maxlength="100" type="test" class="form-control campo-vd input-sm">'+                        
	                    '</div>'+	
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="usu" class="obligatorio">Usuario</label>'+
						  '<input id="usu" name="usu" type="text" maxlength="50" class="form-control campo-vd input-sm">'+                        
	                    '</div>'+	                     	                                      
	                 '</div>'+
	                 '<div class="row">'+
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="contrasena" class="obligatorio">Contrase&ntilde;a</label>'+
						  '<input id="contrasena" name="contrasena" maxlength="50" type="password" class="form-control campo-vd input-sm">'+                        
	                    '</div>'+         
	                    '<div class="col-md-6 col-sm-6  col-lg-6">'+
	                      '<label for="contrasena" class="obligatorio">Repetir contrase&ntilde;a</label>'+
						  '<input id="contrasena_re" name="contrasena_re" maxlength="20" type="password" class="form-control campo-vd input-sm">'+                        
	                    '</div>'+		                 
	                 '</div>'+
	                 '<div class="row">'+
		                 '<div class="col-md-6 col-sm-6  col-lg-6">'+
		                      '<label for="usu" class="obligatorio">C&oacute;digo de confirmaci&oacute;n</label>'+
							  '<div class="input-group">'+
								  '<input id="cod_confirma" name="cod_confirma" type="text" disabled class="form-control campo-vd input-sm">'+                        
			                      '<div class="input-group-append">'+
								      '<button id="btn_enviar_email" onclick="enviarEmailCodSeg()" class="btn btn-primary" disabled type="button" style="border-radius: 5px;">'+
								        '<i class="fa fa-envelope"  style="margin-top: -8px;" title="Enviar c&oacute;digo de seguridad"></i>'+
								      '</button>'+
							      '</div>'+ 
							  '</div>'+
		                 '</div>'+
                         '<div class="col-md-6 col-sm-6  col-lg-6 mt-4">'+ 
		                 	'<label class="obligatorio">Debe seleccionar esta opci&oacute;n para enviar el c&oacute;digo de verificaci&oacute;n</label>'+
	                     '</div>'+
	                 '</div>'+ 	 	                                 
	                 '<br>'+
	                  '<div class="row">'+
	                 	'<div class="col-md-12 col-sm-12 col-xs-12 col-lg-12">'+
	                 		'<label>los campos con * son obligatorios.</label>'+
	                 	'</div>'+	
	                 '</div>'+		                     
	           '</form>');

        

        crearModal(idModal,"Registro", formulario, botonesModal, true, 'modal-lg', '',true);

         /*$("#telefono,#celular,#cod_confirma").on("keypress",function(event){
           return validar_solonumeros(event);
         });*/ 

         $("#telefono,#celular,#cod_confirma").on('input', function () { 
         	this.value = this.value.replace(/[^0-9]/g,'');
         });       

         $("#tipo_identificacion").on("change",function(){					 		
    		disabledIndentificacion(this);
    	});

		 // no permitir copiar letras
		 validarCopyNumeric("identificacion,telefono,celular,cod_confirma");	
		
		$('#cancelarMd').click(function(){
			$('#'+idModal).modal('hide');
		});

		/*$('#fecha_nacimiento').datepicker({
	        locale: 'es-es',
	        format: 'yyyy/mm/dd',
	        //maxDate : getFechaActual(0),        
	        keyboardNavigation: false, 
	        modal: false, 
	        header: false, 
	        footer: false	        
    	});*/

    	//$('#fecha_nacimiento').datepicker();

    	$('#fecha_nacimiento').datepicker({ 
    		// uiLibrary: 'bootstrap4', 
    		 size: 'small',
    		 locale: 'es-es',
	         format: 'dd/mm/yyyy',
	         maxDate : getFechaActual(1)});

		$("#identificacion").on("blur",function(){
		   if ($("#identificacion").val() != "" && $("#tipo_identificacion").val() != -1) {	
				getDatosAsociados();				
		   }
		});

		$("#correo").on("keyup",function(){
			  disabledSendEmail(this.value);
		});				

		$("#contrasena").PassRequirements();
		$("#contrasena_re").PassRequirements();   

		setTimeout(function(){
			$("#contrasena").val("");
			$("#usu").val("");
			$("#clave").val("");
			$("#usuario").val("");
		}, 500);

		$('#fecha_nacimiento').bind("cut copy paste",function(e) {
      		 e.preventDefault();
    	});		

		$('#saveMd').click(function(){

			var camposRequeridos = [  
			          {"id":"tipo_identificacion", "texto":"Tipo identificaci&oacute;n"},
                      {"id":"identificacion", "texto":"Identificaci&oacute;n"},
                      {"id":"nombre1", "texto":"Primer nombre"},
                      {"id":"apellido1", "texto":"Primer apellido"},
                      {"id":"fecha_nacimiento", "texto":"Fecha de nacimiento"},
                      {"id":"lit_sexo", "texto":"Sexo"},                      
                      {"id":"celular", "texto":"Celular"},
                      {"id":"correo", "texto":"Email"},
                      {"id":"usu", "texto":"Usuario"}, 
                      {"id":"contrasena", "texto":"Contrase\u00f1a"},                      
                      {"id":"contrasena_re", "texto":"Repetir contrase\u00f1a"},
                      {"id":"cod_confirma", "texto":"C&oacute;digo de confirmaci&oacute;n"}
					];

				

           if(validRequired(camposRequeridos)){

           	  var idModal = 'modalConfirmar';		 
	          var botonesModal = [{
					            	"id": "cerrarMd",
					            	"label": "Aceptar",
					            	"class": "btn-primary"
					         	 }];

			 var validaClave1 = $("#contrasena").attr('validaPassword');
			 var validaClave2 = $("#contrasena_re").attr('validaPassword');

			if (validaClave1 == 0){
				$("#contrasena").focus(); 
			    return false;
			}

			if (validaClave2 == 0){
			   $("#contrasena_re").focus(); 
			   return false;
			}

	         if ($("#correo").val() != "") {  
		         if (validarEmail($("#correo").val()) == -1) {		         	 
		         	crearModal(idModal, 'Advertencia','Email incorrecto', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		                $('#'+idModal).modal('toggle');		                
		          	});
		            $("#correo").focus(); 
		            return false;
		         }
			 }

			if ($("#contrasena").val() != $("#contrasena_re").val()) {

				    crearModal(idModal, 'Advertencia','Las claves ingresadas no coinciden', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		               $('#'+idModal).modal('toggle');		                
		          	});
		            $("#contrasena").focus(); 
		            return false;
           	}

           	if (global_codigo_verificacion == 0) {

           		crearModal(idModal, 'Advertencia','Debe solicitar el c&oacute;digo de confirmaci&oacute;n', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		               $('#'+idModal).modal('toggle');		                
		          	});
		            $("#cod_confirma").focus();           	  	 
           	  	  	return false;
           	}

           	 if ($("#cod_confirma").val() != global_codigo_verificacion) {

           	 	    crearModal(idModal, 'Advertencia','El c&oacute;digo de verificaci&oacute;n debe ser el mismo que se le env&iacute;o al correo.', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		               $('#'+idModal).modal('toggle');		                
		          	});
		            $("#cod_confirma").focus();           	  	 
           	  	  	return false;
           	 } 

           	 if (validaEdad($("#fecha_nacimiento").val()) < 18 ) {

           	 	    crearModal(idModal, 'Advertencia','Edad no permitida para realizar la solicitud, por favor comun&iacute;quese con un asesor', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		               $('#'+idModal).modal('toggle');		                
		          	});
								$("#fecha_nacimiento").focus(); 
								         	  	 
           	  	  	return false;
           	 }           	 
							
		     global_tipo_persona = global_tipo_persona == 0 ? 2	: global_tipo_persona;

	         	 var formData = $('#form_usuario').serializeArray();	
	             formData.push({ name: "codigo_usuario", value: 0});
	             formData.push({ name: "codigo_plan", value: global_tipo_persona});
	             formData.push({ name: "codigo_tipo_persona", value: 1});             

	           runLoading(true);

	           $.ajax({    
		              url: "Login/guardarUsuario",
		              type: "POST",  
		              dataType: "json",
		              data:formData,                    
		              success:function(data){
		                runLoading(false);

		                crearModal(idModal, 'Confirmaci\u00f3n', data.respuesta, botonesModal, false, '', '',true);
				            $('#cerrarMd').click(function() {
				                $('.modal').modal('hide');
				                window.location.href = 'Login';
				            });                                                    
		              },
		              error: function(result) {
		              	  runLoading(false);		                      
		                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
		                  $('#cerrarMd').click(function() {
		                  	    window.location.href = 'Login'; 
		                        $('.modal').modal('hide');
		                  });		                     
		              }

		        });
           }
			
		});		

 }

 function validarLogin(){

  var camposRequeridos = [  
                      {"id":"usuario", "texto":"Usuario"},
                      {"id":"clave", "texto":"Clave"}                      
                    ];

  var idModal = 'modalConfirmar';		 
  var botonesModal = [{
				    	"id": "cerrarMd",
				    	"label": "Aceptar",
				    	"class": "btn-primary"
				 	 }];                     

  if(validRequired(camposRequeridos)){ 

         runLoading(true);         
          
            $.ajax({    
              url: "Login/loguear", 
              type: "POST",  
              dataType: "json",
              data:$("#form_login").serialize(),
              encode:true,                
              success:function(data){
                runLoading(false);
                if (data.respuesta == 'OK') {                 
									 //document.location.href = 'Home'; 
									 validMora();
                }else if(data.respuesta == 'NO'){
                    crearModal(idModal, 'Confirmaci\u00f3n','Usuario o contraseña incorrectos', botonesModal, false, '', '',true);
										$('#cerrarMd').click(function() {
												$('.modal').modal('hide');
												//window.location.href = 'Login';
										});                          
                                    
                }else{                 
                    crearModal(idModal, 'Confirmaci\u00f3n',data.respuesta, botonesModal, false, '', '',true);
										$('#cerrarMd').click(function() {
												$('.modal').modal('hide');
												window.location.href = 'Login';
										});                  
                }                
                                                                       
              },
              error: function(result) {
                    runLoading(false);
                    crearModal(idModal, 'Confirmaci\u00f3n','La operaci\u00f3n no se pudo completar por que ocurri&oacute; un error en la base de datos', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		                $('.modal').modal('hide');
		                window.location.href = 'Login';
		            });                   
                 
              }

             });		
	} 
}

function validMora(){

	runLoading(true);

	 var idModal = 'modalConfirmar';		 
     var botonesModal = [{
			            	"id": "cerrarMd",
			            	"label": "Cerrar",
			            	"class": "btn-primary boton-vd"
			         	 }];

	$.ajax({    
            url: "WebService/callWsEstadoUsuario", 
            type: "POST",  
            dataType: "json", 
            success:function(data){
              	runLoading(false);
              	console.log("respuesta",data);
              	if (data['RESPUESTA'] == undefined && data['DATOS'] != undefined) {
                        if(data['DATOS'][0]['fecha_mora'] != null){
                              crearModal(idModal, 'Advertencia', 'Usted est\u00e1 en cartera, por favor comun\u00edquese con un asesor', botonesModal, false, '', '',true);
                              $('#cerrarMd').click(function() {	                  	   
															$('.modal').modal('hide');
															document.location.href = 'Home'; 
                              });
                        }else{
                              document.location.href = 'Gestion_compra';
                        }                       	
              	}else{
              	      document.location.href = 'Gestion_compra';	
              	}              		             	                                                                   
            },
            error: function(result) {
                  runLoading(false);		                      
                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
                  $('#cerrarMd').click(function() {	                  	   
                        $('.modal').modal('hide');
                  });	
            }

        });

}

function getDatosAsociados(){

         global_tipo_persona = 0; 
 
         var idModal = 'modalConfirmar';		 
  		 var botonesModal = [{
				    	"id": "cerrarMd",
				    	"label": "Aceptar",
				    	"class": "btn-primary"
				 	 }];				 	                

         runLoading(true);         
          
            $.ajax({    
              url: "Login/getDataCurl", 
              type: "POST",  
              dataType: "json",
              data:{tipo_identificacion:$("#tipo_identificacion [value='"+$('#tipo_identificacion').val()+"']").attr("data_abr"),identificacion:$('#identificacion').val(),cod_tipo_ident:$('#tipo_identificacion').val()},
              encode:true,                
              success:function(data){
                runLoading(false);  

                console.log("data",data);              

              if (data['tipo'] != 0){

              	if (data['tipo'] == 1) {

	                $("#nombre1").val(data['datos']['cabeceraUsuario']['primer_nombre']);
	                $("#nombre2").val(data['datos']['cabeceraUsuario']['segundo_nombre']);
	                $("#apellido1").val(data['datos']['cabeceraUsuario']['primer_apellido']);
	                $("#apellido2").val(data['datos']['cabeceraUsuario']['segundo_apellido']); 
	                $("#telefono").val(data['datos']['cabeceraUsuario']['telefono_fijo']);
	                $("#celular").val(data['datos']['cabeceraUsuario']['telefono_celular']);
	                $("#correo").val(data['datos']['cabeceraUsuario']['email']); 
	                $("#fecha_nacimiento").val(formatFecha(data['datos']['cabeceraUsuario']['fecha_nacimiento'])); 
	                $("#lit_sexo").val($("#lit_sexo [data_abr='"+data['datos']['cabeceraUsuario']['genero']+"']").val());
	                if (data['datos']['cabeceraUsuario']['asociado'] == 'S') {
	                	global_tipo_persona = 1;
	                }else{
	                	global_tipo_persona = 2; 
	                }

	                disabledSendEmail(data['datos']['cabeceraUsuario']['email']);
               }

               if (data['tipo'] == 2) {

               	    data['datos'] = data['datos'][0];  

	                $("#nombre1").val(data['datos']['NOMBRE_1']);
	                $("#nombre2").val(data['datos']['NOMBRE_2']);
	                $("#apellido1").val(data['datos']['APELLIDO_1']);
	                $("#apellido2").val(data['datos']['APELLIDO_2']); 
	                $("#telefono").val(data['datos']['TELEFONO']);
	                $("#celular").val(data['datos']['CELULAR']);
	                $("#correo").val(data['datos']['EMAIL']); 
	                $("#fecha_nacimiento").val(data['datos']['FECHA_NACIMIENTO']); 
	                $("#lit_sexo").val(data['datos']['COD_SEXO']);               
	               
	                global_tipo_persona = data['datos']['COD_PLAN'];

	                disabledSendEmail(data['datos']['EMAIL']);
	                
               }else if(data['tipo'] == 3){
								global_tipo_persona = 1;
							 }

              }                                                       
              },
              error: function(result) {
										runLoading(false);										 
                    crearModal(idModal, 'Confirmaci\u00f3n','La operaci\u00f3n no se pudo completar por que ocurri&oacute; un error en la base de datos', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		                $('.modal').modal('hide');
		                window.location.href = 'Login';
		            });                   
                 
              }
           });	
}

function disabledIndentificacion(_this){

    var valor = _this.value;
    var abrValor = $(_this).find("option[value='"+valor+"']").attr("data_abr");	

    if (abrValor == 'CE' || abrValor == 'PA') {
		$("#div_identificacion").html('<label for="identificacion" class="obligatorio">Identificaci&oacute;n</label><input id="identificacion" name="identificacion" maxlength="12" type="text" disabled class="form-control input-sm campo-vd">');

		$("#identificacion").on("blur",function(){
		   if ($("#identificacion").val() != "" && $("#tipo_identificacion").val() != -1) {	
				getDatosAsociados();
		   }
		});
	}else{
		$("#identificacion").val("");

		/*$("#identificacion").on("keypress",function(event){
           return validar_solonumeros(event);
        });*/

         $('#identificacion').on('input', function () { 
            this.value = this.value.replace(/[^0-9]/g,'');
         });

		 // no permitir copiar letras
		 validarCopyNumeric("identificacion");
	}

	if (valor != -1) {
		$("#identificacion").removeAttr("disabled");
	}else{
		$("#identificacion").attr("disabled","disabled");
	}
	
}

function formatFecha(fecha){

	var anio = fecha.substring(0,4);
	var mes = fecha.substring(4,6);
	var dia = fecha.substring(6,8);
	//var newFecha = anio+'/'+mes+'/'+dia;
	 var newFecha = dia+'/'+mes+'/'+anio;

	return newFecha;
}

function enviarEmailCodSeg(){

	     var idModal = 'modalConfirmar';		 
  		 var botonesModal = [{
						    	"id": "cerrarMd",
						    	"label": "Cerrar",
						    	"class": "btn-primary"
				 	 	    }];          

	    if ($("#correo").val() != "") {  
	         if (validarEmail($("#correo").val()) == -1) {
	         	 $("#correo").focus();
	         	 crearModal(idModal, 'Advertencia','Email incorrecto', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		                $('#'+idModal).modal('toggle');		                
		          	});
	             
	            return false;
	         }
		}

		runLoading(true);

		$.ajax({    
              url: "Login/sendEmailCodSeg", 
              type: "POST",  
              dataType: "json",
              data:{correo:$("#correo").val()},
              encode:true,                
              success:function(data){
                runLoading(false);

                global_codigo_verificacion = data["codigo_verificacion"] 

                var mensaje = "";

                if(data["respuesta"] == 'OK'){
                    mensaje = "Se ha enviado un c&oacute;digo de seguridad al correo "+data["correo"]; 
                }else{
                	mensaje = "Se presentaron problemas al enviar el email";
                }

	             crearModal(idModal, 'Confirmaci&oacute;n',mensaje, botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		                $('#'+idModal).modal('toggle');		                
		         });                                        
                                                                       
              },
              error: function(result) {
                    runLoading(false);
                    crearModal(idModal, 'Confirmaci\u00f3n','La operaci\u00f3n no se pudo completar por que ocurri&oacute; un error en la base de datos', botonesModal, false, '', '',true);
		            $('#cerrarMd').click(function() {
		                $('.modal').modal('hide');
		                window.location.href = 'Login';
		            });                   
                 
              }

             });

}

function disabledSendEmail(valor){	

	if (valor != "" && valor != undefined && valor != null) {
		$("#cod_confirma").removeAttr("disabled");
		$("#btn_enviar_email").removeAttr("disabled"); 
	}else{
		$("#cod_confirma").attr("disabled","disabled");
        $("#btn_enviar_email").attr("disabled","disabled");
		
	}	
}


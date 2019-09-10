/*$(document).ready(function(){  

	 $("#btn_consultar").on("click",getEncuestaSarlafDatos);
     $("#btn_encuesta").on("click",getEncuestaSarlaf);

});*/

function saveEncuesta(){

	var camposRequeridos = [  
                      		{"id":"radio_respuesta_n_1", "texto":"Ingresos mensuales actividad principal"},
                      		{"id":"radio_respuesta_n_2", "texto":"Egresos mensuales actividad principal"},
                      		{"id":"radio_respuesta_n_3", "texto":"Otros ingresos diferentes a la actividad principal"}
                    	  ];

   if ($("input[name='radio_respuesta_n_3']:checked").val() != 11) {
        camposRequeridos.push({"id":"concept", "texto":"Detalle el concepto de otros Ingresos diferentes a la Actiividad Principal"});
   } 

   camposRequeridos.push({"id":"valor_activo", "texto":"Valor activos o posesiones"});
   camposRequeridos.push({"id":"valor_pasivo", "texto":"Valor pasivos o deudas"});
   camposRequeridos.push({"id":"radio_respuesta_n_6", "texto":"Usted realiza transacciones en moneda extranjera"});
   //camposRequeridos.push({"id":"radio_respuesta_n_7", "texto":"Seleccione el tipo de transacciones que realiza"});
   
   camposRequeridos.push({"id":"radio_respuesta_n_34", "texto":"¿Posee cuentas corrientes en moneda extranjera?"});

   if ($("input[name='radio_respuesta_n_34']:checked").val() == 28) {
        camposRequeridos.push({"id":"nom_banco", "texto":"Nombre del banco"});
        camposRequeridos.push({"id":"ciudad", "texto":"Ciudad"});
        camposRequeridos.push({"id":"pais", "texto":"Pa&iacute;s"});
        camposRequeridos.push({"id":"moneda", "texto":"Moneda"});
   }

   camposRequeridos.push({"id":"radio_respuesta_n_35", "texto":"¿Es una persona expuesta pol&iacute;ticamente de acuerdo al decreto 1674 de 2016?(&)"});

   if ($("input[name='radio_respuesta_n_35']:checked").val() == 34) {
        camposRequeridos.push({"id":"cargo", "texto":"Cargo"});
        camposRequeridos.push({"id":"fecha_ini", "texto":"Fecha de Inicio"});
        camposRequeridos.push({"id":"fecha_fin", "texto":"Fecha Fin"});       
   }

   camposRequeridos.push({"id":"radio_respuesta_n_36", "texto":"¿Representa legalmente alguna organizaci&oacute;n internacional (ONG - OIG)?"});

   if ($("input[name='radio_respuesta_n_36']:checked").val() == 39) {
        camposRequeridos.push({"id":"organizacion", "texto":"Organizaci&oacute;n"});
        camposRequeridos.push({"id":"fecha_ini_1", "texto":"Fecha de Inicio"});
        camposRequeridos.push({"id":"fecha_fin_1", "texto":"Fecha Fin"});       
   }

   camposRequeridos.push({"id":"radio_respuesta_n_37", "texto":"¿Existe algún vínculo entre usted y alguna persona expuesta políticamente?(&&)"});

   if ($("input[name='radio_respuesta_n_37']:checked").val() == 44) {
        camposRequeridos.push({"id":"nombre_1", "texto":"Nombre"});
        camposRequeridos.push({"id":"cargo_1", "texto":"Cargo"});
        camposRequeridos.push({"id":"parentesco", "texto":"Parentesco"});       
   }

   camposRequeridos.push({"id":"declaro","texto":"Debe diligenciar el  campo"});

   if($("#pregunta_6").find("input").is(":checked") && !$("#pregunta_7").find("input").is(":checked") && $("#pregunta_7").find("input").is(":visible")){
            var posicion = $("#pregunta_7").offset();
            var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
            $('body').append(divRequired);
            $("#pregunta_7").focus();
            alertify.notify('Por favor selecionar alguna opci&oacute;n para el campo <b>Seleccione el tipo de transacciones que realiza</b>', 'error', 3, null);
           
            return false;
   }

   if(validRequired(camposRequeridos)){

     	var datosJson         = {};
  		var codigo_afiliacion = global_datos_contratante['COD_AFILIACION'];
          var codigo_persona    = global_datos_contratante['COD_PERSONA'];
  		var codigo_encuesta   = 1; 
  		var arrayData         = [];
  		var datosJson         = {};  
  		$("#form_div").find("input[type!='radio'],input[type='radio']:checked,input[type='checkbox']:checked,select").each(function(){
  				 
  			  var name = this.name; 
  			  var valor_respuesta = "";
  			  var codigo_pregunta = "";
  	      var codigo_respuesta = "";
  	      datosJson = {};  

  			   if(this.type == "radio" || this.type == "checkbox"){
  			      if($(this).is(":checked") && $(this).is(":visible")){
  				       valor_respuesta = $("input[name='"+name+"']:checked").val();
  				       codigo_respuesta = $(this).closest(".div_container_respuesta").attr("data-respuesta"); 
  				       codigo_pregunta = $(this).closest(".div_container_pregunta").attr("data-pregunta"); 
  	             datosJson =  {"codigo_encuesta":codigo_encuesta,"codigo_pregunta":codigo_pregunta,"codigo_respuesta":codigo_respuesta,"valor_respuesta":valor_respuesta,"codigo_afiliacion":codigo_afiliacion,"codigo_persona":codigo_persona}; 
  	             arrayData.push(datosJson); 
  			      }
  			   }else if(this.type != "button" && $(this).is(":visible") && $(this).is(":enabled")){  				  
    					   valor_respuesta = this.value.toString().replace(/\./g,'');
    	           codigo_respuesta = $(this).closest(".div_container_respuesta").attr("data-respuesta");
    					   codigo_pregunta = $(this).closest(".div_container_pregunta").attr("data-pregunta");
    	           datosJson =  {"codigo_encuesta":codigo_encuesta,"codigo_pregunta":codigo_pregunta,"codigo_respuesta":codigo_respuesta,"valor_respuesta":valor_respuesta,"codigo_afiliacion":codigo_afiliacion,"codigo_persona":codigo_persona}; 
    	           arrayData.push(datosJson);  
  			   }				    
  		                      		    
  		  });

  	 	      var idModal = 'modalConfirmarSarlaf';		 
            var botonesModal = [{
  				            	"id": "cerrarMdSarlaf",
  				            	"label": "Cerrar",
  				            	"class": "btn-primary"
  				         	 }];
          runLoading(true); 

    	    $.ajax({    
                url: "Encuesta_sarlaf/save_encuesta_sarlaf", 
                type: "POST",  
                dataType: "json",
                data:{datos:arrayData},  
                success:function(data){
                  	runLoading(false);
  	             	crearModal(idModal, 'Confirmaci\u00f3n', data.respuesta, botonesModal, false, '', '',true);
  		            $('#cerrarMdSarlaf').click(function() {
  		                //$('#'+idModal).modal('toggle');
                      $('.modal').modal('hide');		               
  		            });                                                                     
                },
                error: function(result) {
                        runLoading(false);		                      
  	                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
  	                  $('#cerrarMdSarlaf').click(function() {	                  	   
  	                        $('.modal').modal('hide');
  	                  });	
                }

          });

   }

}

function complementoEncuesta(){

	 /*$("#valor_activo,#valor_pasivo").on("keypress",function(event){
           return validar_solonumeros(event);
   });*/

    $("valor_activo,#valor_pasivo").on('input', function () { 
          this.value = this.value.replace(/[^0-9]/g,'');
    }); 

	// no permitir copiar letras
	  validarCopyNumeric("valor_activo,valor_pasivo");

	  $("#valor_activo,#valor_pasivo").on("keyup",function(event){
           validFieldMiles(this);
      });	

      $("input[name='radio_respuesta_n_3']").change(function(){

		   if(this.value == 11){		   	   
		       $("#concept").attr("disabled","disabled");
		   }else{
		  	  $("#concept").removeAttr("disabled");
		   }

      });

       $("input[name='radio_respuesta_n_6']").change(function(){

		   if(this.value == 17){		   	   
		       $("#pregunta_7").attr("style","display:block");
		   }else{
		  	  $("#pregunta_7").attr("style","display:none");
		   }

      });

       $("input[name='radio_respuesta_n_34']").change(function(){

		   if(this.value == 28){		   	   
		        $("#nom_banco").removeAttr("disabled");
		        $("#ciudad").removeAttr("disabled");
		        $("#pais").removeAttr("disabled");
		        $("#moneda").removeAttr("disabled");
		   }else{		  	  
		  	   $("#nom_banco").attr("disabled","disabled");
		  	   $("#ciudad").attr("disabled","disabled");
		  	   $("#pais").attr("disabled","disabled");
		  	   $("#moneda").attr("disabled","disabled");
		   }
      });

      $("input[name='radio_respuesta_n_35']").change(function(){

		   if(this.value == 34){		   	   
		        $("#cargo").prop("disabled",false);
		        $("#fecha_ini").prop("disabled",false);
		        $("#fecha_fin").prop("disabled",false);
		        $("#fecha_ini").next().show();
		        $("#fecha_fin").next().show();	        
		   }else{		  	  
		  	   $("#cargo").prop("disabled",true);
		  	   $("#fecha_ini").prop("disabled",true);
		       $("#fecha_fin").prop("disabled",true);
		  	   $("#fecha_ini").next().hide();
		       $("#fecha_fin").next().hide();	  	   
		   }
      });

      $("input[name='radio_respuesta_n_36']").change(function(){

		   if(this.value == 39){
		        $("#organizacion").prop("disabled",false);
		        $("#fecha_ini_1").prop("disabled",false);
		        $("#fecha_fin_1").prop("disabled",false);
		        $("#fecha_ini_1").next().show();
		        $("#fecha_fin_1").next().show();	        
		   }else{
		  	   $("#organizacion").prop("disabled",true);
		  	   $("#fecha_ini_1").prop("disabled",true);
		       $("#fecha_fin_1").prop("disabled",true);
		  	   $("#fecha_ini_1").next().hide();
		       $("#fecha_fin_1").next().hide();		  	   
		   }
      });

       $("input[name='radio_respuesta_n_37']").change(function(){

		   if(this.value == 44){		   	   
		        $("#nombre_1").removeAttr("disabled");
		        $("#cargo_1").removeAttr("disabled");
		        $("#parentesco").removeAttr("disabled");		        
		   }else{		  	  
		  	   $("#nombre_1").attr("disabled","disabled");
		  	   $("#cargo_1").attr("disabled","disabled");
		  	   $("#parentesco").attr("disabled","disabled");		  	   
		   }
      });  

      formatDate("fecha_ini", "fecha_fin");
      formatDate("fecha_ini_1", "fecha_fin_1");       

    $("#fecha_ini").next().addClass('col-sm-6');
    $("#fecha_fin").next().addClass('col-sm-6');
    $("#fecha_ini_1").next().addClass('col-sm-6');
    $("#fecha_fin_1").next().addClass('col-sm-6');  

    $("#fecha_ini").next().hide();
	  $("#fecha_fin").next().hide();
	  $("#fecha_ini_1").next().hide();
	  $("#fecha_fin_1").next().hide();         

    $("#btn_guardar").on("click",saveEncuesta);

}

function getEncuestaSarlaf(codigo_afiliacion,codigo_contratante){

   //Se valida que la encuesta Sarlaft esta diligenciada
    var validaEncuestaSarlaft = validaEncuesta(codigo_contratante,codigo_afiliacion,1);
   
	  var idModal = 'modalEncuestaSarlaf';
    if (validaEncuestaSarlaft) {
          getEncuestaSarlafDatos(codigo_afiliacion,codigo_contratante);
    }else{

      var botonesModal = [
                         {
                "id":"btn_guardar",
                   "label":"Guardar",
                   "class":"btn-primary class_save mr-2 btn_clave"
                  },
                        {
                  "id": "cerrarSarlaf",
                  "label": "Cerrar",
                  "class": "btn-primary"
               }
              
               ];   
    		         	 

	runLoading(true);

  	    $.ajax({    
              url: "Encuesta_sarlaf/getEncuestaSarlaf", 
              type: "POST",  
              dataType: "json", 
              data: {codigo_afiliacion:codigo_afiliacion,codigo_contratante:codigo_contratante},             
              success:function(data){
                runLoading(false);
                if (data.encuestaSarlaf != '[]') {
  	             	crearModal(idModal, 'Encuesta Sarlaf', data.encuestaSarlaf, botonesModal, false, 'modal-xl', '',true);
  		            $('#cerrarSarlaf').click(function() {
  		                $('#'+idModal).modal('toggle');		               
  		            });
  		            complementoEncuesta();
                }                                                                     
              },
              error: function(result) {
                    runLoading(false);		                      
	                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
	                  $('#cerrarSarlaf').click(function() {	                  	   
	                        $('#'+idModal).modal('hide');
	                  });	
              }

        });

    }     

}

function getEncuestaSarlafDatos(codigo_afiliacion,codigo_contratante){

  var idModal = 'modalEncuestaSarlafDatos';		 
 var botonesModal = [{
		            	"id": "cerrarSarlafD",
		            	"label": "Cerrar",
		            	"class": "btn-primary"
		         	 }]; 
  
	runLoading(true);

  	    $.ajax({    
              url: "Encuesta_sarlaf/getEncuestaSarlafDilig", 
              type: "POST",  
              dataType: "json",
              data: {codigo_afiliacion:codigo_afiliacion,codigo_contratante:codigo_contratante},  
              success:function(data){
                	runLoading(false);
	             	crearModal(idModal, 'Encuesta Sarlaf', data.encuestaSarlafDilig+'<button data-html2canvas-ignore id="sarlaftExportarPdf" class="btn btn-default">Descargar PDF</button>', botonesModal, false, 'modal-xl', '',true);
		            $('#cerrarSarlafD').click(function() {
		                $('#'+idModal).modal('toggle');		               
		            });	

		            $("#form_div").find("input[type='text'],select").each(function(){
			
    						   var valor_respuesta = "";			   	  
    						   valor_respuesta = $(this).closest(".div_container_respuesta").attr("data-val_respuesta");
    						   $(this).val(valor_respuesta);
    						   $(this).attr("disabled","disabled");		   			    
		                      		    
		            });

                $("#form_div").find("input[type='radio']:checked").each(function(){
      
                   if(this.value == 18){           
                      $("#pregunta_7").attr("style","display:none");
                   }           
                                  
                }); 

                $("#fecha_ini_1,#fecha_fin_1").on("keypress",function(){
                       return false;

                });                 

              },
              error: function(result) {
                      runLoading(false);		                      
	                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
	                  $('#cerrarSarlafD').click(function() {	                  	   
	                        $('#'+idModal).modal('hide');
	                  });	
              }

        });

}
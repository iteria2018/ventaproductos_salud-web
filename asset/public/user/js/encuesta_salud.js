$(document).ready(function(){  

	 //$("#btn_consultar").on("click",getEncuestaSarlafDatos);
   //$("#btn_encuesta_salud").on("click",function(){
      //getEncuestaSalud(4,2,12,2); // para probar ever
   //});

   $(document.body).on('click', '.encuestaSalud', function(e) {
    
        var codPersona    = $(this).attr('codigoPersona');
        var codAfiliacion = $(this).attr('codigoAfiliacion');
        var codSexo       = $(this).attr('codigoSexo');
        var edad          = $(this).attr('edad');
        
        getEncuestaSalud(edad,codSexo,codPersona,codAfiliacion);
    });

});

function saveEncuestaSalud(cod_persona,cod_afiliacion){

	var camposRequeridos = [  
                      		{"id":"radio_respuesta_n_8", "texto":"¿Ha tenido embarazos normales, quir&uacute;rgicos o abortos, trastornos de los senos, matriz u ovarios?"},
                      		{"id":"radio_respuesta_n_9", "texto":"¿Est&aacute; actualmente embarazada?"},
                          {"id":"radio_respuesta_n_10", "texto":"¿Cu&aacute;ntos meses?"},                          
                      		{"id":"radio_respuesta_n_11", "texto":"¿Convulsiones, ataques, p&eacute;rdida de conocimiento, desmayos, trombosis cerebral, hemorragia, epilepsia o cualquier afecci&oacute;n neurol&oacute;gica?"},
                          {"id":"radio_respuesta_n_12", "texto":"¿Fracturas, artritis, reumatismo, trastornos articulares, enfermedades de la columna, de piel o alergias?"},                          
                          {"id":"radio_respuesta_n_13", "texto":"¿Diabetes, trastornos de la gl&aacute;ndula tiroides, az&uacute;car en la sangre o en la orina?"},
                          {"id":"radio_respuesta_n_14", "texto":"¿Ulcera g&aacute;strica o duodenal, gastritis, agrieras (reflujo gastroesof&aacute;gico), colitis, hemorroides, c&oacute;licos biliares, enfermedades del h&iacute;gado?"},
                          {"id":"radio_respuesta_n_15", "texto":"¿Asma, tuberculosis, dificultad para respirar, enfermedades del pulm&oacute;n?"},
                          {"id":"radio_respuesta_n_16", "texto":"¿Tensi&oacute;n arterial alta, enfermedades del coraz&oacute;n, angina de pecho, enfermedades de arterias o venas?"},
                          {"id":"radio_respuesta_n_17", "texto":"¿Anemia, linfomas, ganglios inflamados, enfermedades renales, de la pr&oacute;stata, de la vejiga, o venereas?"},
                          {"id":"radio_respuesta_n_18", "texto":"¿Malformaciones, deformaciones, imperfecciones o anomal&iacute;as cong&eacute;nitas o adquiridas?"},
                          {"id":"radio_respuesta_n_19", "texto":"¿V&aacute;rices, hinchaz&oacute;n o ulceras en las piernas?"},
                          {"id":"radio_respuesta_n_20", "texto":"¿Enfermedades psiqui&aacute;tricas o trastornos psicol&oacute;gicos?"},
                          {"id":"radio_respuesta_n_21", "texto":"¿Accidentes, traumatismos, infecciones o riesgos de padecer enfermedades transmisibles?"},                          
                          {"id":"radio_respuesta_n_22", "texto":"¿Ha estado alguna vez hospitalizado(a) o le han practicado cirug&iacute;as o transfusiones?"},
                          {"id":"radio_respuesta_n_23", "texto":"¿Ha consultado alg&uacute;n m&eacute;dico en el &uacute;ltimo año?"},
                          {"id":"radio_respuesta_n_24", "texto":"¿Le han practicado alg&uacute;n examen de laboratorio cl&iacute;nico, radiol&oacute;gico o alg&uacute;n otro examen de diagn&oacute;stico en los &uacute;ltimos seis (6) meses?"},
                          {"id":"radio_respuesta_n_25", "texto":"¿Piensa someterse o tiene pendiente alg&uacute;n tratamiento m&eacute;dico o quir&uacute;rgico?"},
                          {"id":"radio_respuesta_n_26", "texto":"¿Le han diagnosticado en alguna &eacute;poca de su vida tumores benignos o c&aacute;ncer, ha tenido masas palpables?"},
                          {"id":"radio_respuesta_n_27", "texto":"¿Practica deporte de alto riesgo?"},
                          {"id":"radio_respuesta_n_28", "texto":"¿Padece o ha padecido alguna enfermedad que no aparezca registrada en el presente cuestionario?"},
                          {"id":"radio_respuesta_n_29", "texto":"¿Lo han vacunado de acuerdo al esquema de vacunaci&oacute;n del PAI?"},
                          {"id":"radio_respuesta_n_30", "texto":"¿Al nacer su hijo requiri&oacute; de oxigeno e incubadora?"},
                          {"id":"inp_118", "texto":"¿Cu&aacute;l es su talla?"},
                          {"id":"inp_119", "texto":"¿Cu&aacute;l es su peso?"},
                          {"id":"radio_respuesta_n_33", "texto":"¿Enfermedades de los ojos, pterigios, estrabismo, defectos de refracci&oacute;n visual, cataratas, enfermedades del o&iacute;do, v&eacute;rtigo, enfermedades de la garganta?"}
                       
                    	  ];                        

   
   if(validRequired(camposRequeridos)){

     	var datosJson = {};

  		var codigo_afiliacion = cod_afiliacion;
      var codigo_persona    = cod_persona;
  		var codigo_encuesta   = 2; 
  		var arrayData         = [];
  		var datosJson         = {};  
  		$("#form_div_salud").find("input[type!='radio'],input[type='radio']:checked").each(function(){
  				 
  			  var name = this.name; 
  			  var valor_respuesta = "";
  			  var codigo_pregunta = "";
  	      var codigo_respuesta = "";
  	      datosJson = {};  

  			   if(this.type == "radio"){
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

	 	      var idModal = 'modalConfirmarSave';		 
          var botonesModal = [{
        				            	"id": "cerrarMdSave",
        				            	"label": "Cerrar",
        				            	"class": "btn-primary"
				         	           }];

        console.log("arrayData encuesta salud ",arrayData);
                   
        runLoading(true);

  	    $.ajax({    
              url: "Encuesta_sarlaf/save_encuesta_salud", 
              type: "POST",  
              dataType: "json",
              data:{datos:arrayData},  
              success:function(data){
                runLoading(false);                
	             	crearModal(idModal, 'Confirmaci\u00f3n', data.respuesta, botonesModal, false, '', '',true);
		            $('#cerrarMdSave').click(function() {
		                $('.modal').modal('hide');	               
		            });                                                                     
              },
              error: function(result) {
                    runLoading(false);		                      
	                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
	                  $('#cerrarMdSave').click(function() {	                  	   
	                        $('.modal').modal('hide');
	                  });	
              }

        });

   }

}

function complementoEncuestaSalud(codigo_persona,codigo_afiliacion){

  	/*$("#inp_119").on("keypress",function(event){
         return validar_solonumeros(event);
    });*/

    $("#inp_119").on('input', function () { 
          this.value = this.value.replace(/[^0-9]/g,'');
    });   

	// no permitir copiar letras
	  validarCopyNumeric("inp_119");

      $('#form_div_salud').find('input[type="radio"]').change(function(){
          var nameCh = $(this).attr('name');  
          var value = $('input[name="'+nameCh+'"]:checked').val();        
          if($('input[name="'+nameCh+'"]:checked').attr("data-value") == 1){
             $(this).closest("div").next().next().removeClass('d-none');
          }else{
             $(this).closest("div").next().addClass('d-none');
          }
          if(value == 55){
              $("#pregunta_10").attr('style',"display:inline");
              $("#pregunta_10 > div").attr('style',"display:inline");

          }else if(value == 56){
              $("#pregunta_10").attr('style',"display:none");
              $("#pregunta_10 > div").attr('style',"display:none");
          }

      });              

     $("#btn_guardar").on("click",function(){
        saveEncuestaSalud(codigo_persona,codigo_afiliacion);
     });

}

function getEncuestaSalud(edad,codigo_sexo,codigo_persona,codigo_afiliacion){
   alertify.dismissAll();
   
  var validaEncuestaSalud = validaEncuesta(codigo_persona,codigo_afiliacion,2);
   
  console.log("validaEncuestaSalud ", validaEncuestaSalud);
	var idModal = 'modalConfirmar';  
   if (validaEncuestaSalud) {
       console.log("entrro encuesta datos"); 
       getEncuestaSaludDatos(edad,codigo_sexo,codigo_persona,codigo_afiliacion);           	 
   }else{

      var botonesModal = [
                         {
                "id":"btn_guardar",
                   "label":"Guardar",
                   "class":"btn-primary class_save mr-2 btn_clave"
                  },
                        {
                  "id": "cerrarMd",
                  "label": "Cerrar",
                  "class": "btn-primary"
               }
              
               ];   

   
	runLoading(true);

  	    $.ajax({    
              url: "Encuesta_sarlaf/getEncuestaSalud", 
              type: "POST",  
              dataType: "json",
              data: {edad:edad,codigo_sexo:codigo_sexo,codigo_afiliacion:codigo_afiliacion,codigo_beneficiario:codigo_persona},              
              success:function(data){
                	runLoading(false);
               if (data.encuestaSalud != '[]') {  
  	             	crearModal(idModal, 'Estado Salud', data.encuestaSalud, botonesModal, false, 'modal-xl', '',true);
  		            $('#cerrarMd').click(function() {
  		                $('#'+idModal).modal('toggle');		               
  		            });
  		            complementoEncuestaSalud(codigo_persona,codigo_afiliacion);
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
}

function getEncuestaSaludDatos(edad,codigo_sexo,codigo_beneficiario,codigo_afiliacion){

  var idModal = 'modalConfirmarEncSalud';		 
  var botonesModal = [{
    		            	"id": "cerrarMdEncSal",
    		            	"label": "Cerrar",
    		            	"class": "btn-primary"
		         	      }]; 
  
	      runLoading(true);
  	    $.ajax({    
              url: "Encuesta_sarlaf/getEncuestaSaludDilig", 
              type: "POST",  
              dataType: "json",
              data: {edad:edad,codigo_sexo:codigo_sexo,codigo_beneficiario:codigo_beneficiario,codigo_afiliacion:codigo_afiliacion},  
              success:function(data){
                runLoading(false);
	             	crearModal(idModal, 'Estado salud', data.encuestaSaludDilig, botonesModal, false, 'modal-xl', '',true);
		            $('#cerrarMdEncSal').click(function() {
		                $('#'+idModal).modal('toggle');		               
		            });	

		            $("#form_div_salud").find("input[type='radio']:checked,input[type='text']").each(function(){
                    
                    $(this).prop("disabled",true);
                    var nameCh = $(this).attr('name');  
                    var value = this.value;//$('input[name="'+nameCh+'"]').val();        
                    if($('input[name="'+nameCh+'"]').attr("data-value") == 1){                     
                       $(this).closest("div").next().next().removeClass('d-none');
                    }else{                       
                       $(this).closest("div").next().addClass('d-none');
                    }
                    console.log(" value ", value);
                    if(value == 56){
                        $("#pregunta_10").attr('style',"display:none");
                        $("#pregunta_10 > div").attr('style',"display:none");
                    }   
		                      		    
		            });

              },
              error: function(result) {
                      runLoading(false);		                      
	                  crearModal(idModal, 'Confirmaci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '',true);
	                  $('#cerrarMdEncSal').click(function() {	                  	   
	                        $('.modal').modal('hide');
	                  });	
              }

        });

}






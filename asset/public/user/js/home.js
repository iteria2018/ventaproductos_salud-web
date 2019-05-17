
$( document ).ready(function() {  

      /* if (g_codigo_rol != 1 && g_codigo_rol != 3) {
            $("#a_gestionar_pedido,#a_mensajes,#a_promopuntos,#a_admin").remove();           
      }*/

      //$("#btn_comprar").on("click",validMora);
      calcSizeScreen();
      $( window ).resize(function() {
            calcSizeScreen();
      });
});

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
            data:{tipoIdentificacion:global_tipo_identificacion_abr,nroIdentificacion:global_Identificacion},  
            success:function(data){
              	runLoading(false);
              	console.log("respuesta",data);
              	if (data['RESPUESTA'] == undefined && data['DATOS'] != undefined) {
                        if(data['DATOS'][0]['fecha_mora'] != null){
                              crearModal(idModal, 'Advertencia', 'Usted est\u00e1 en cartera, por favor comun\u00edquese con un asesor', botonesModal, false, '', '',true);
                              $('#cerrarMd').click(function() {	                  	   
                              $('.modal').modal('hide');
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

function calcSizeScreen(){
      $('.carousel-inner').attr('style','height:10px;');
      var altoPantalla = $(document).height();
      var ajusteImg = altoPantalla - 130;
      $('.carousel-inner').attr('style','height:'+ajusteImg+'px;');
      $('.carousel-item img').attr('style','height:'+ajusteImg+'px;');
}

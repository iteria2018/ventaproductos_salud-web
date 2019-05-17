
$(document).ready(function(){	
 
   $("#agregar").on("click",guardarImagen);
   aplicarDatatable("tabla_imagen"); 

});


function aplicarDatatable(idTabla){
		$('#'+idTabla).DataTable({
				responsive: true,
				"colReorder": true,
						"language": {
								"processing":     "Procesando...",
								"search":         "B&uacute;squeda General:",
								"lengthMenu": "Mostrar _MENU_ por p&aacute;gina",
								"zeroRecords": "No hay resultados",
								"info": "Mostrando p&aacute;gina _PAGE_ de _PAGES_",
								"infoEmpty": "Sin registros",
								"infoFiltered": "(Filtrar de _MAX_ total registros)",
								"paginate": {
											"first": "Primero",
											"previous": "Anterior",
											"next": "Siguiente",
											"last": "Ultimo"
									}
						},
						"aoColumns": [
						{ "sWidth": "40%" , "sClass": "left", "bSortable": true  },
						{ "sWidth": "30%" , "sClass": "center", "bSortable": false  },
						{ "sWidth": "15%" , "sClass": "center", "bSortable": false  },
						{ "sWidth": "15%" , "sClass": "center", "bSortable": false }
					],	
						//dom: 'Bfrtip',
						buttons: [  ]
		});
}

function guardarImagen(){
		var idModal = 'modal_dialog_editar';
		var botonesModal = [{"id":"guardarMd","label":"Guardar","class":"btn-primary mr-3"},{"id":"cancelarMd","label":"Cancelar","class":"btn-primary"}];

		var formulario = $('<form id="form_imagen" name="form_imagen" enctype="multipart/form-data">'+				                     	                    
															'<div class="row">'+
																	'<div class="col-12">'+
																			'<label for="archivo" class="obligatorio">Descripci&oacute;n</label>'+
																			'<input type="text" id="desArchivo" name="desArchivo" class="form-control campo-vd" maxlength="50">'+               
																	'</div>'+                                   
																	'<div class="col-12">'+
																			'<label for="archivo" class="obligatorio">Archivo</label>'+
																			'<input type="file" id="archivo" name="archivo" class="file" accept="image/*">'+               
																	'</div>'+
															'</div>'+			                      		                    
													'</form>');

			crearModal(idModal, 'Guardar imagen', formulario, botonesModal, true, '', '',true);			

			$('#cancelarMd').click(function(){
				$('#'+idModal).modal('hide');
			});

			var aux_array_ext = ['jpg', 'png', 'gif', 'jpeg', 'bmp','ico'];				
			aplicInputFile(true,'archivo','Imagen',aux_array_ext,'','','seleccionar imagen');				 				

				$("#archivo").on("change",function(){			   	 
								validarExtFile(this.id,'jpg,png,gif,jpeg,bmp,ico');			   	    
				}); 

			$('#guardarMd').click(function(){

					var requeridos = [															
												{"id":"desArchivo", "texto":"Descripci&oacute;n"},	
												{"id":"archivo", "texto":"Archivo"}
											];			

					if(validRequired(requeridos)){

									idModal = 'modalConfirmar';
									botonesModal = [{
														"id": "cerrarMd",
														"label": "Aceptar",
														"class": "btn-primary"
											}];

									runLoading(true);			        

									var formData = new FormData(document.getElementById("form_imagen"));
									var dascriocionArchivo = $('#desArchivo').val();
									formData.append('desArchivo', dascriocionArchivo);

									$.ajax({    
											url: "PromocionesImg/guardarImagen", 
											type: "POST",  
											dataType: "json",
											data:formData,             
											cache: false,
											contentType: false,
											processData: false,                
											success:function(data){
												runLoading(false); 
												crearModal(idModal, 'Confirmaci\u00f3n', data.respuesta, botonesModal, false, '', '',true);
													$('#cerrarMd').click(function() {
															$('.modal').modal('hide');
													});         
													
													$("#contenedor_table").html(data.tablaImagen);	
													aplicarDatatable("tabla_imagen");  
																																	
											},
											error: function(result) {
												runLoading(false);
								crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al guardar el registro', botonesModal, false, '', '');
								$('#cerrarMd').click(function(){
									$('#'+idModal).modal('hide');
								});		                     
											}

										});			   
					}
			});
}



function descargarDocumento(ruta){
	
	if(ruta != undefined){
		window.open(ruta,'_blank');
	}else{
		alertify.error("No hay archivo para descargar");
	} 

}

function eliminarReigistro(codigo_file,ruta_file_ant){
	var idModal = 'modal_dialog_eliminar';
	var botonesModal = [{"id":"eliminarMd","label":"Eliminar","class":"btn-primary mr-3"},{"id":"cancelarMd","label":"Cancelar","class":"btn-primary"}];
	var formulario = '¿Esta seguro de eliminar esta imagen?';
	
	crearModal(idModal, 'Eliminar imagen', formulario, botonesModal, true, '', '',true);
		
	$('#cancelarMd').click(function(){
		$('#'+idModal).modal('hide');
	});
	
	$('#eliminarMd').click(function(){
		quitarRegistro(codigo_file,ruta_file_ant);
	});
}

function quitarRegistro(codigo_file,ruta_file_ant){	

	runLoading(true); 

	 var idModal = 'modalConfirmar';
	 var botonesModal = [{
	        "id": "cerrarMd",
	        "label": "Aceptar",
	        "class": "btn-primary"
	     }];

	$.ajax({    
          url: "PromocionesImg/eliminarImagen", 
          type: "POST",  
          dataType: "json",
          data:{codigo_file:codigo_file,ruta_file_ant:ruta_file_ant},   
          success:function(data){
            runLoading(false);
             
	        crearModal(idModal, 'Confirmaci\u00f3n', data.respuesta, botonesModal, false, '', '',true);
            $('#cerrarMd').click(function() {
                $('.modal').modal('hide');
            });  

            $("#contenedor_table").html(data.tablaImagen);
            aplicarDatatable("tabla_imagen");            
                                                                   
          },
          error: function(result) {

          	    runLoading(false);
				crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al guardar el registro', botonesModal, false, '', '');
				$('#cerrarMd').click(function(){
					$('#'+idModal).modal('hide');
				});
                  
          }

         }); 

}














	
	


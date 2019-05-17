var arrayNombres = [];

$(document).ready(function(){	
 
    $('#parametrizarProductoAg').click(function() {
        cargarFormulario(1,'');
    });

    $(document.body).on('click', '.parametrizarProductoEd', function(e) {
        cargarFormulario(2,$(this).attr('codPlanPrograma'));
    });

   
    $(document.body).on('change', '.adjuntarDocumentos', function(e) {
      
        var idDocumento  = $(this).attr('id');
        var filename     = $(this).val();
        var mensaje      = $(this).attr('msj'); 

        if ($(this).get(0).files.length == 0) {
            $("#btnVerFile"+idDocumento).addClass("disabled");
            $("#showFile"+idDocumento).val('');
            $("#showFile"+idDocumento).attr("placeholder", mensaje);
        
        } else {

            if (typeof arrayNombres !== 'undefined' && arrayNombres.length > 0) {

                //Se valida si el nombre ya existe
                if(!arrayNombres.includes(filename)){
                    //Se agrega el nombre actual al array
                    arrayNombres.push(filename);
                    $("#showFile"+idDocumento).val(filename);
                    $("#btnVerFile"+idDocumento).removeClass("disabled");

                } else {
                    $(this).val('');
                    mensaje         = 'No se puede ingresar el mismo archivo adjunto';
                    posicion        = $('#'+idDocumento).offset();
                    
                    var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
                    $('body').append(divRequired);
                    alertify.notify(mensaje, 'error', 3, function(){ $('#div_required_nexos').remove(); });
                }
            } else {
                //Se agrega el nombre actual al array
                arrayNombres.push(filename);
                $("#showFile"+idDocumento).val(filename);
                $("#btnVerFile"+idDocumento).removeClass("disabled");
            }
            
        }

    });

    $(document.body).on('change', '#cmbLinea', function(e) {

        var paramsObj            = {};
        paramsObj['codProducto'] = $(this).val();

        $.ajax({
            url: "Linea/cargarProgramas",  
            type: "POST",  
            dataType: "json",
            data: paramsObj,   
            success: function(resp){
                $('#cmbPrograma').html(resp.vista);            
            },
            error: function(resp) {
                runLoading(false);
                crearModal('verError', 'Confirmaci\u00f3n', 'No se pueden cargar los programas', botonesModal, false, '', '');
                $('#cerrarMd').click(function(){
                    $('#verError').modal('hide');
                });
            }
        });
    });

    $(document.body).on('click', '.verArchivo', function(e) {
   
        var idDocumento = $(this).attr('upload');
        if ($(this).hasClass('disabled') === false) {

            var file   = $("#"+idDocumento)[0].files[0];
            var reader = new FileReader();
            reader.readAsDataURL(file);

            reader.onload = function (e) {

                var idModal      = 'verUpload';
                var botonesModal = [{"id":"cerrarModal","label":"Aceptar","class":"btn-primary"}];
                crearModal(idModal, 'Archivo seleccionado', '<iframe class="embed-responsive-item" id="verUploadZoom" src="'+e.target.result+'" width="100%" height="100%" frameborder="0" style="border: 0; overflow: hidden; min-height: 450px;"></iframe>',  botonesModal, false, 'modal-lg', '',true);
                $('#cerrarModal').click(function() {	                  	   
                    $('#'+idModal).modal('toggle');
                });

                $('iframe#verUploadZoom').on('load', function () {
                    $(this).contents().find("img").addClass('img-fluid');
                    $(this).contents().find("img").css({
                        'width' : '100%'
                    });
                });
            }
        }
       
   });
 
    aplicarDataTable("tablaParametrizacionlineas"); 
 
});


function cargarFormulario(tipoAccion, codPlanPrograma){

    runLoading(true);
    var desAccion    = tipoAccion == 1 ? 'Agregar' : 'Editar';
    var idModal      = 'verParametrizacionProductos';
    var botonesModal = [{"id":"guardarMd","label":"Guardar","class":"btn-primary mr-3"},{"id":"cerrarMd","label":"Cancelar","class":"btn-primary"}];
    var paramsObj    = {};
    arrayNombres     = [];

    paramsObj['tipoAccion']      = tipoAccion;
    paramsObj['codPlanPrograma'] = codPlanPrograma;
  
    $.ajax({
        url: "Linea/formulario",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
           
            crearModal(idModal, desAccion + ' producto', resp.vista, botonesModal, false, 'modal-lg', '',true);
            $('#cerrarMd').click(function() {	                  	   
                $('#'+idModal).modal('hide');
            });
            $('#guardarMd').click(function() {	                  	   
                guardarProductos();
            });
        },
        error: function(resp) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'No se pueden visualizar el formulario', botonesModal, false, '', '');
            $('#cerrarMd').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
}

function guardarProductos(){

    var camposRequeridos = [];
    camposRequeridos.push({"id":"cmbLinea",         "texto":"Linea"});
    camposRequeridos.push({"id":"cmbPrograma",      "texto":"Programa"});
    camposRequeridos.push({"id":"cmbPlan",          "texto":"Plan"});
    camposRequeridos.push({"id":"cmbEstado",        "texto":"Estado"});
    camposRequeridos.push({"id":"programaHomologa",   "texto":"Codigo de homolaci&oacute;n programa"});

    if ($('#txtTipoAccion').val() == 2){

        if($('#txtRutaCoberturaIni').val() == ''){
            camposRequeridos.push({"id":"CoberturaInicial", "texto":"Cobertura Inicial"});
        }

        if($('#txtRutaCoberturaFin').val() == ''){
            camposRequeridos.push({"id":"CoberturaFinal",   "texto":"Cobertura Final"});
        }

    } else {
        camposRequeridos.push({"id":"CoberturaInicial", "texto":"Cobertura Inicial"});
        camposRequeridos.push({"id":"CoberturaFinal",   "texto":"Cobertura Final"});
    }
    
 
    if(validRequired(camposRequeridos)){

        var idModal       = 'verMsgGuardarProductos';
        var botonesModal  = [{"id":"cerrarMsgProductos","label":"Aceptar","class":"btn-primary"}];
        var formData      = new FormData($("#formProductos")[0]);
        
        $.ajax({
            url: "Linea/guardarProductos",  
            type: "POST",  
            dataType: "json",
            data:formData,            
            cache: false,
            contentType: false,
            processData: false,        
            success: function(resp){
                runLoading(false);

                if (resp.ret){
                    mensajeRespuesta =  'Se guardo con &eacute;xito la parametrizaci&oacute;n del producto'; 
                } else {
                    mensajeRespuesta = resp.errors;
                }

                crearModal(idModal, 'Confirmaci\u00f3n', mensajeRespuesta, botonesModal, false, '', '');
                $('#cerrarMsgProductos').click(function(){
                    $('#'+idModal).modal('hide');
                    $('#verParametrizacionProductos').modal('hide');
                    location.reload();
                });
            },
            error: function(resp) {
                runLoading(false);
                crearModal(idModal, 'Confirmaci\u00f3n', 'No se puede guardar la parametrizaci&oacute;n del producto', botonesModal, false, '', '');
                $('#cerrarMsgProductos').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });

    }

    
}
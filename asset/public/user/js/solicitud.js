
$(document).ready(function(){	
 
    if ($('#txtcodSolicitudGestion').val() != '' && $('#txtcodSolicitudGestion').val() !== undefined){
        //Se muestra en pantalla la solicitud que actualmente tiene el usuario en gesti&oacute;n
        formularioGestionarSolicitud(5,$('#txtcodSolicitudGestion').val());
    }

    $('#consultarSolicitudes').click(function() {
        consultarSolicitud();
    });

    $('#buscarSolicitudes').click(function() {
        buscarSolicitud();
    });

    $(document.body).on('click', '.tomarSolicitud', function(e) {
        tomarSolicitud($(this).attr('codSolicitud'));
    });

    $(document.body).on('click', '.retomarSolicitud', function(e) {
        formularioGestionarSolicitud(2,$(this).attr('codSolicitud'));
    });

    $(document.body).on('click', '.validado', function(e) {
        //Se muestra la solicitud a modo de consulta
        formularioGestionarSolicitud(4,$(this).attr('codSolicitud'));
    });

    $(document.body).on('click', '#btnEncuestaSarlaf', function(e) {
        getEncuestaSarlaf($(this).attr('codAfiliacion'),$(this).attr('codPersona'));
    });

    $(document.body).on('click', '.enGestion', function(e) {
        solicitudGestion($(this).attr('codSolicitud'));        
    });


    $(document.body).on('click', '.verArchivo', function(e) {   
        
        var codPersona         = $(this).attr('codPersona');
        var nombreBeneficiario = $(this).attr('nombreBeneficiario');
        var codAfiliacion      = $(this).attr('codAfiliacion');
        var url                = './Gc_paso_3/verAdjuntarArchivos/'+codPersona+'/'+codAfiliacion; 
        var botonesModal       = [{"id":"cerrarAr","label":"Cerrar","class":"btn-primary"}];
        var idModal            = 'verAdjuntarArchivos';
        
        crearModal(idModal, 'Soportes ' + nombreBeneficiario, '<iframe class="embed-responsive-item" id="verAdjuntar" src="'+url+'" width="100%" height="100%" frameborder="0" style="border: 0; overflow: hidden; min-height: 220px;"></iframe>' ,  botonesModal, false, 'modal-lg', '');
        
        $('#cerrarAr').click(function() {	                  	   
            $('#'+idModal).modal('hide');
        });

        $('iframe#verAdjuntar').on('load', function () {

            $(this).contents().find('.verAdjunto').on('click', function() {    
    
                var url          = $(this).attr('ruta');
                var idModal      = 'verUploadBd';
                var botonesModal = [{"id":"cerrarModalBd","label":"Aceptar","class":"btn-primary"}];
                crearModal(idModal, 'Archivo seleccionado',  '<iframe class="embed-responsive-item" id="verUploadZoomBd" src="'+url+'" width="100%" height="100%" frameborder="0" style="border: 0; overflow: hidden; min-height: 450px;"></iframe>',  botonesModal, false, 'modal-lg', '',true);
                $('#cerrarModalBd').click(function() {	                  	   
                    $('#'+idModal).modal('toggle');
                });
    
                $('iframe#verUploadZoomBd').on('load', function () {
    
                    $(this).contents().find("img").addClass('img-fluid');
    
                    $(this).contents().find("img").css({
                        'width' : '100%'
                    });
                });
                
            });
    
        });    
        
    });
   
    formatDate('txtFechaInicial','txtFechaFinal');
    formatDate('txtFecRadicaIni','txtFecRadicaFin');
    formatDate('txtFecGestionIni','txtFecGestionFin');    
    aplicarDataTable("solicitudesConsulta");
    
    $('#solGestiona TABLE').attr('id','solGestiona_table');
    aplicarDataTable('solGestiona_table');

});

function consultarSolicitud(){

    $('#txtFechaInicial').prop('disabled', false);
    $('#txtFechaFinal').prop('disabled', false);

    var botonesModal  = [{"id":"cerrarMsgSolicitud","label":"Aceptar","class":"btn-primary"}];
    var formData      = new FormData($("#formBusqueda")[0]);

     var requeridos = [];

      if ($("#txtFechaInicial").val() != "") {
         requeridos.push({"id":"txtFechaFinal","texto":"Fecha final"});
      } 
      if ($("#txtFechaFinal").val() != "") {
         requeridos.push({"id":"txtFechaInicial","texto":"Fecha inicial"});
      } 

  if(validRequired(requeridos)){

    runLoading(true);
    $.ajax({
        url: "Solicitud/buscarSolicitudes",  
        type: "POST",  
        dataType: "json",
        data: formData,   
        cache: false,
        contentType: false,
        processData: false,
        success: function(resp){
            runLoading(false);
            $('#solGestiona').html(resp.vista);
            $('#solGestiona TABLE').attr('id','solGestiona_table');
            aplicarDataTable('solGestiona_table');
            /*$('#txtFechaInicial').prop('disabled', true);
            $('#txtFechaFinal').prop('disabled', true);
            $('#txtFechaInicial').val('');
            $('#txtFechaFinal').val('');*/

                      
        },
        error: function(resp) {
            runLoading(false);
            crearModal('verError', 'Confirmaci\u00f3n', 'No se pueden cargar las solicitudes por gestionar', botonesModal, false, '', '');
            $('#cerrarMsgSolicitud').click(function(){
                $('#verError').modal('hide');
            });
        }
    });

 }
  
}

function buscarSolicitud(){

    $('#txtFecRadicaIni').prop('disabled', false);
    $('#txtFecRadicaFin').prop('disabled', false);
    $('#txtFecGestionIni').prop('disabled', false);
    $('#txtFecGestionFin').prop('disabled', false);

    var botonesModal  = [{"id":"cerrarMsgSolicitud","label":"Aceptar","class":"btn-primary"}];
    var formData      = new FormData($("#formBusqueda")[0]);

     var requeridos = [];

      if ($("#txtFecRadicaIni").val() != "") {
         requeridos.push({"id":"txtFecRadicaFin","texto":"Fecha final"});
      } 
      if ($("#txtFecRadicaFin").val() != "") {
         requeridos.push({"id":"txtFecRadicaIni","texto":"Fecha inicial"});
      } 

      if ($("#txtFecGestionIni").val() != "") {
         requeridos.push({"id":"txtFecGestionFin","texto":"Fecha final"});
      } 
      if ($("#txtFecGestionFin").val() != "") {
         requeridos.push({"id":"txtFecGestionIni","texto":"Fecha inicial"});
      } 

    runLoading(true);
    $.ajax({
        url: "Consulta/consultarSolicitudes",  
        type: "POST",  
        dataType: "json",
        data: formData,   
        cache: false,
        contentType: false,
        processData: false,
        success: function(resp){
            runLoading(false);
            $('#solGestiona').html(resp.vista);
            aplicarDataTable("solicitudesConsulta");        
        },
        error: function(resp) {
            runLoading(false);
            crearModal('verError', 'Confirmaci\u00f3n', 'No se pueden cargar las solicitudes', botonesModal, false, '', '');
            $('#cerrarMsgSolicitud').click(function(){
                $('#verError').modal('hide');
            });
        }
    });
  
}

function tomarSolicitud(codSolicitud){

    runLoading(true); 

    var paramsObj             = {};
    paramsObj['codSolicitud'] = codSolicitud;
    
    $.ajax({
        url: "Solicitud/tomarSolicitud",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        async: false, 
        success: function(resp){
            runLoading(false);

            //Aun no existe el registro en la cola
            if (resp.validaCola == 0){

                formularioGestionarSolicitud(1,codSolicitud);

            //El usuario va a retomar la solicitud    
            } else if (resp.validaCola == 1) {

                formularioGestionarSolicitud(2,codSolicitud);

            //El usuario va tomar la solicitud de otra persona
            } else {
                var idModal      = 'verSolicitudPendiente';
                var botonesModal = [{"id":"siMd","label":"SI","class":"btn-primary mr-3"},{"id":"noMd","label":"NO","class":"btn-primary"}];
            
                crearModal(idModal, 'Confirmaci\u00f3n', 'La solicitud se encuentra en la bandeja de pendientes del usuario <b>' + resp.nombreUsuario +'</b>, ¿Desea tomarla?', botonesModal, false, '', '');
                $('#siMd').click(function(){
                    formularioGestionarSolicitud(3,codSolicitud); 
                    $('#'+idModal).modal('hide');
                });

                $('#noMd').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }           
          
        },
        error: function(resp) {
            runLoading(false);
            var botonModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary mr-3"}];
            crearModal(idModal, 'Confirmaci\u00f3n', 'No se pueden visualizar el formulario', botonModal, false, '', '');
            $('#cerrarMd').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
}

function formularioGestionarSolicitud(tipoAccion,codSolicitud){

    runLoading(true);     

    if (tipoAccion == 4){
        var botonesModal = [{"id":"cerrarMd","label":"Cerrar","class":"btn-primary mr-3"}];
    } else {
        var botonesModal = [{"id":"pendienteMd","label":"Dejar Pendiente","class":"btn-primary mr-3"},{"id":"validaMd","label":"Validado","class":"btn-primary"}];
    }
  
    var paramsObj  = {};
    var idModal    = 'verSolicitud';

    paramsObj['codSolicitud'] = codSolicitud;
    paramsObj['tipoAccion']   = tipoAccion;
  
    $.ajax({
        url: "Solicitud/formularioGestionSolicitud",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
                       
            crearModal(idModal, 'Gestionar solicitud No ' + codSolicitud , resp.vista, botonesModal, false, 'modal-xl', '',true);
            $('#pendienteMd').click(function() {	
                solicitudPendiente();             	   
            });
            $('#validaMd').click(function() {	 
                
                var idModal      = 'verValidaSolicitud';
                var botonesModal = [{"id":"siMd","label":"SI","class":"btn-primary mr-3"},{"id":"noMd","label":"NO","class":"btn-primary"}];
            
                crearModal(idModal, 'Confirmaci\u00f3n', '¿Está seguro de que la solicitud ya se encuentra registrada en AFILMED?', botonesModal, false, '', '');
                $('#siMd').click(function(){
                    validaSolicitud();
                });

                $('#noMd').click(function(){
                    $('#'+idModal).modal('hide');
                });
                
            }); 

            $('#cerrarMd').click(function() {	
                $('#'+idModal).modal('hide');           	   
            });           
          
        },
        error: function(resp) {
            runLoading(false);
            var botonModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary mr-3"}];
            crearModal(idModal, 'Confirmaci\u00f3n', 'No se pueden visualizar el formulario', botonModal, false, '', '');
            $('#cerrarMd').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });

}

function validaEncuesta(codPersona,codAfiliacion,codEncuesta){

    var parametrosObj    = {};
    var valida           = false;
    parametrosObj['codPersona']     = codPersona;
    parametrosObj['codAfiliacion']  = codAfiliacion;
    parametrosObj['codEncuesta']    = codEncuesta;

    runLoading(true);

    $.ajax({
        url: "Encuesta_sarlaf/getValidaEncuesta",  
        type: "POST",  
        dataType: "json",
        data: parametrosObj, 
        async: false,   
        success: function(resp){
            runLoading(false);
            if (resp.validaEncuesta != '0'){
                valida = true;
            }  else {
                valida = false;
            }
        },
        error: function(resp) {
            runLoading(false);
            valida = false;
        }
    });

    return valida;

}

function solicitudPendiente(){

    var paramsObj             = {};
    var idModal               = 'verMsgPendiente';
    var botonesModal          = [{"id":"cerrarMsgPendiente","label":"Aceptar","class":"btn-primary"}];
    paramsObj['codSolicitud'] = $('#txtcodAfiliacion').val();
    
    runLoading(true);
    $.ajax({
        url: "Solicitud/dejarPendienteSolicitud",  
        type: "POST",  
        dataType: "json",
        data:paramsObj,       
        success: function(resp){
            runLoading(false);

            if (resp.ret){
                mensajeRespuesta =  'La solicitud se dejo pendiente con &eacute;xito!'; 
            } else {
                mensajeRespuesta = resp.errors;
            }

            crearModal(idModal, 'Confirmaci\u00f3n', mensajeRespuesta, botonesModal, false, '', '');
            $('#cerrarMsgPendiente').click(function(){
                $('#'+idModal).modal('hide');
                if (resp.ret){
                    $('#verSolicitud').modal('hide');
                    location.reload();
                }
                
            });
        },
        error: function(resp) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'No se puede dejar pendiente la solicitud', botonesModal, false, '', '');
            $('#cerrarMsgPendiente').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
    
}

function validaSolicitud(){

    var paramsObj             = {};
    var idModal               = 'verMsgValida';
    var botonesModal          = [{"id":"cerrarMsgValida","label":"Aceptar","class":"btn-primary"}];
    paramsObj['codSolicitud'] = $('#txtcodAfiliacion').val();
    
    runLoading(true);
    $.ajax({
        url: "Solicitud/validarSolicitud",  
        type: "POST",  
        dataType: "json",
        data:paramsObj,       
        success: function(resp){
            runLoading(false);

            if (resp.ret){
                mensajeRespuesta =  'La solicitud se valido con &eacute;xito!'; 
            } else {
                mensajeRespuesta = resp.errors;
            }

            crearModal(idModal, 'Confirmaci\u00f3n', mensajeRespuesta, botonesModal, false, '', '');
            $('#cerrarMsgValida').click(function(){
                $('#'+idModal).modal('hide');
                if (resp.ret){
                    $('#verSolicitud').modal('hide');
                    $('#verValidaSolicitud').modal('hide');
                    location.reload();
                }
                
            });
        },
        error: function(resp) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'No se puede validar la solicitud', botonesModal, false, '', '');
            $('#cerrarMsgValida').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
    
}


function solicitudGestion(codSolicitud){

    runLoading(true); 

    var paramsObj             = {};
    paramsObj['codSolicitud'] = codSolicitud;
    
    $.ajax({
        url: "Solicitud/solicitudEnGestion",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        async: false, 
        success: function(resp){
            runLoading(false);

            var idModal      = 'verSolicitudGestion';
            var botonesModal = [{"id":"cerrarMd","label":"Cerrar","class":"btn-primary mr-3"}];
        
            crearModal(idModal, 'Confirmaci\u00f3n', 'La solicitud actualmente la tiene en gesti&oacute;n el usuario <b>' + resp.nombreUsuario +'</b>, y NO puede ser tomada para gesti&oacute;n', botonesModal, false, '', '');
            $('#cerrarMd').click(function(){
                $('#'+idModal).modal('hide');
            });
        },
        error: function(resp) {
            runLoading(false);
            var botonModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary mr-3"}];
            crearModal(idModal, 'Confirmaci\u00f3n', 'No se pueden visualizar el formulario', botonModal, false, '', '');
            $('#cerrarMd').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
}
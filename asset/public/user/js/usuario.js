
$(document).ready(function(){	
 
    $('#parametrizarUsuarioAg').click(function() {
        cargarFormulario(1,'','','')
    });

    $(document.body).on('click', '.parametrizarUsuarioEd', function(e) {
        cargarFormulario(2,$(this).attr('codUsuario'),$(this).attr('codPersona'),$(this).attr('codRol'));
    });     
       
      aplicarDataTable("tablaParametrizacionUsuarios");      

});


function cargarFormulario(tipoAccion, codUsuario,codPersona,codPerfil){

    runLoading(true);
    var desAccion    = tipoAccion == 1 ? 'Agregar' : 'Editar';
    var idModal      = 'verParametrizacionUsuarios';
    var botonesModal = [{"id":"guardarMd","label":"Guardar","class":"btn-primary mr-3"},{"id":"cerrarMd","label":"Cancelar","class":"btn-primary"}];
    var paramsObj    = {};

    paramsObj['tipoAccion']  = tipoAccion;
    paramsObj['codUsuario']  = codUsuario;
    paramsObj['codPersona']  = codPersona;
    paramsObj['codPerfil']   = codPerfil;
  
    $.ajax({
        url: "Usuario/formulario",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
           
            crearModal(idModal, desAccion + ' Usuarios', resp.vista, botonesModal, false, 'modal-lg', '',true);
            $('#cerrarMd').click(function() {	                  	   
                $('#'+idModal).modal('hide');
            });
            $('#guardarMd').click(function() {

                if (tipoAccion == 1){
                    guardarUsuarios();
                } else {
                    var estado       = $("#cmbEstado").val() == 1 ? 'Activar' : 'Inactivar'; 
                    var nombre       = $("#txtPrimerNombre").val() +' '+$("#txtSegundoNombre").val() +' '+$("#txtPrimerApellido").val()+' '+$("#txtSegundoApellido").val();
                    var perfilActual = $("#cmbPerfil option:selected").text();
                    var mensaje      = '¿Esta seguro que desea '+estado+' al usuario '+ nombre + ' con perfil '+ perfilActual +'?';
                    var botonesModalUsuario = [{"id":"siMd","label":"SI","class":"btn-primary mr-3"},{"id":"noMd","label":"NO","class":"btn-primary"}];
                    crearModal('verModificaUsuario', 'Modificar la informaci&oacute;n del Usuario', mensaje, botonesModalUsuario, false, 'modal-lg', '',true);
                    $('#noMd').click(function() {	                  	   
                        $('#verModificaUsuario').modal('hide');
                    });
                    $('#siMd').click(function() {	                  	   
                        guardarUsuarios();
                    });
                }	                  	   
                
            });
            $("#txtContrasena").PassRequirements();
            $('#cmbTipoIdentificacion').change(function(){
                validaTipoDoc('cmbTipoIdentificacion', 'txtNroIdentificacion');
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

function guardarUsuarios(){

    var camposRequeridos = [];
    camposRequeridos.push({"id":"cmbTipoIdentificacion", "texto":"Debe ingresar el tipo de identificaci&oacute;n"});
    camposRequeridos.push({"id":"txtNroIdentificacion",  "texto":"Debe ingresar el número de identificaci&oacute;n"});
    camposRequeridos.push({"id":"txtPrimerNombre",       "texto":"Debe ingresar el primer nombre"});
    camposRequeridos.push({"id":"txtPrimerApellido",     "texto":"Debe ingresar el primer apellido"});
    camposRequeridos.push({"id":"txtCorreoElectronico",  "texto":"Debe ingresar el correo electr&oacute;nico"});
    camposRequeridos.push({"id":"txtUsuario",            "texto":"Debe ingresar el usuario"});
    camposRequeridos.push({"id":"txtContrasena",         "texto":"Debe ingresar la contraseña"});
    camposRequeridos.push({"id":"cmbPerfil",             "texto":"Debe ingresar el perfil"});
    camposRequeridos.push({"id":"cmbEstado",             "texto":"Debe ingresar el estado"});

    if(validRequired(camposRequeridos)){

        var validaContrasena = $("#txtContrasena").attr('validaPassword');

        if (validaContrasena == 0){
            $("#txtContrasena").focus();
            return false; 
        }

        if (validarEmail($("#txtCorreoElectronico").val()) == -1) {	

            $("#txtCorreoElectronico").focus();
            var mensaje  = 'Debe ingresar un formato de <b>correo electr&oacute;nico</b> valido';
            var posicion = $("#txtCorreoElectronico").offset();
            
            var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
            $('body').append(divRequired);
            alertify.notify(mensaje, 'error', 3, function(){ $('#div_required_nexos').remove(); });
            return false;
        }

        $("#txtNombrePerfil").val($("#cmbPerfil option:selected").text());
        var idModal       = 'verMsgGuardarUsuarios';
        var botonesModal  = [{"id":"cerrarMsgUsuarios","label":"Aceptar","class":"btn-primary"}];
        var formData      = new FormData($("#formUsuarios")[0]);

        runLoading(true);
    
        $.ajax({
            url: "Usuario/guardarUsuarios",  
            type: "POST",  
            dataType: "json",
            data:formData,            
            cache: false,
            contentType: false,
            processData: false,        
            success: function(resp){
                runLoading(false);

                if (resp.ret){
                    mensajeRespuesta =  'Se guardo con &eacute;xito el usuario'; 
                } else {
                    mensajeRespuesta = resp.errors;
                }

                crearModal(idModal, 'Confirmaci\u00f3n', mensajeRespuesta, botonesModal, false, '', '');
                $('#cerrarMsgUsuarios').click(function(){
                    $('#'+idModal).modal('hide');
                    $('#verModificaUsuario').modal('hide');
                    if (resp.ret){
                        $('#verParametrizacionUsuarios').modal('hide');
                        location.reload();
                    }
                });
            },
            error: function(resp) {
                runLoading(false);
                crearModal(idModal, 'Confirmaci\u00f3n', 'No se puede guardar el usuario', botonesModal, false, '', '');
                $('#cerrarMsgUsuarios').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });

    }
}
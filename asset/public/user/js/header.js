var timeOutSesion = 0;
var userSesion;
$(document).ready(function() {  

    var min_x_segundo = 60;
    var mils_x_segundo = 1000;

    var seg_a_minuto_inact = global_tiempoMaxInact*min_x_segundo; 
    timeOutSesion = seg_a_minuto_inact*mils_x_segundo; 

    iniciarConteoSesion('inicio');    
    
    $(document).on( 'scroll',function(){
      pararConteoSesion('scroll');
    });
    
    $('body').on( 'keypress',function(){
      pararConteoSesion('keypress');
    });
    
    $('body').on( 'click',function(){
      pararConteoSesion('click');
    });
    
    $('body').on( 'mousemove',function(){
      pararConteoSesion('mousemove');
    }); 
});

function pararConteoSesion(evento) {
  clearTimeout(userSesion);
  iniciarConteoSesion(evento);
}

function iniciarConteoSesion(evento){ 
  userSesion = setTimeout(function(){
      console.log("Su session a expirado");  
      window.location.href = 'Login/logout';
  
  },timeOutSesion); 
}


function gestionarImgPromo(){
    window.open('PromocionesImg', '_blank');
}

function redHome(){
	var url = pointToUrl()+"Gestion_compra";
    location.href = url;  
}

$("#parametrizarUsuarioEditar").on('click', function(e) {
      cargarFormularioUsuario(2,global_codigo_usuario,global_codigo_persona,JSON.parse(global_roles)[0]["CODIGO"]);
});   

function cargarFormularioUsuario(tipoAccion, codUsuario,codPersona,codPerfil){

    runLoading(true);
    var desAccion    = tipoAccion == 1 ? 'Agregar' : 'Actualizar';
    var idModal      = 'verParametrizacionUsuarios';
    var botonesModal = [{"id":"guardarMd","label":"Actualizar","class":"btn-primary mr-3"},{"id":"cerrarMd","label":"Cancelar","class":"btn-primary"}];
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
           
            crearModal(idModal,'Actualizar datos', resp.vista, botonesModal, false, 'modal-lg', '',true);
            $('#cerrarMd').click(function() {	                  	   
                $('#'+idModal).modal('hide');
            });

            $("#div_contrasena").hide();
            $("#div_perfil").hide();
            $("#div_estado").hide();  

            $("#divUsuario").find("input").removeAttr("disabled");
            $("#cmbPerfil").append('<option value="1" selected>Cliente</option>'); 
            $("#txtNroIdentificacion").attr("readOnly",true);                    
            
            $('#guardarMd').click(function() {                                	                  	   
                 guardarUsuariosForm();                
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

function guardarUsuariosForm(){

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

        $("#cmbTipoIdentificacion").removeAttr("disabled");
        $("#txtNombrePerfil").val($("#cmbPerfil option:selected").text());
        var idModal       = 'verMsgGuardarUsuarios';
        var botonesModal  = [{"id":"cerrarMsgUsuarios","label":"Aceptar","class":"btn-primary"}];
        var formData      = new FormData($("#formUsuarios")[0]);

        runLoading(true);
    
        $.ajax({
            url: "Usuario/guardarusuariosHeader",  
            type: "POST",  
            dataType: "json",
            data:formData,            
            cache: false,
            contentType: false,
            processData: false,        
            success: function(resp){
                runLoading(false);

                if (resp.ret == 1){
                    mensajeRespuesta =  'Se guardo con &eacute;xito el usuario'; 
                } else {
                    mensajeRespuesta = resp.errors;
                }

                crearModal(idModal, 'Confirmaci\u00f3n', mensajeRespuesta, botonesModal, false, '', '',true);
                $('#cerrarMsgUsuarios').click(function(){
                    $('#'+idModal).modal('hide');
                    $('#verModificaUsuario').modal('hide');
                    if (resp.ret == 1){
                        $('#verParametrizacionUsuarios').modal('hide');
                        location.reload();
                    }
                });
            },
            error: function(resp) {
                runLoading(false);
                crearModal(idModal, 'Confirmaci\u00f3n', 'No se puede guardar el usuario', botonesModal, false, '', '',true);
                $('#cerrarMsgUsuarios').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });

    }
}

function verificarSession(){
    $.ajax({    
      url: "Cron/verificarSesion", 
      type: "POST",  
      dataType: "html",
      encode:true,
      success:function(result){
        
       if (result == 0) {
         window.location.href = "Login"; 
       } 
        
      },
      error: function(result) {
        runLoading(false);
        console.log('ERROR_AJAX: La operaci\u00f3n no se pudo completar por que ocurrio un error en la base de datos');
      }
    });
      
}



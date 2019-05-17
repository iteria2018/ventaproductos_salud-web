
$(document).ready(function(){	
 

    /*$(document.body).on('blur', '#txtValorTarifa', function(e) {
        $('#txtValorTarifa').val(formatMiles($('#txtValorTarifa').val()));
    });*/
     
   
    $('#parametrizarTarifaAg').click(function() {
        cargarFormulario(1,'')
    });

    $(document.body).on('click', '.parametrizarTarifaEd', function(e) {
        cargarFormulario(2,$(this).attr('codTarifa'));
    });

    $(document.body).on('change', '#cmbPlan', function(e) {

        var paramsObj        = {};
        paramsObj['codPlan'] = $(this).val();

        $.ajax({
            url: "Tarifa/cargarProgramasPlan",  
            type: "POST",  
            dataType: "json",
            data: paramsObj,   
            success: function(resp){
                $('#cmbProductos').html(resp.vista);            
            },
            error: function(resp) {
                runLoading(false);
                crearModal('verError', 'Confirmaci\u00f3n', 'No se pueden cargar los productos', botonesModal, false, '', '');
                $('#cerrarMd').click(function(){
                    $('#verError').modal('hide');
                });
            }
        });
    });

    $(document.body).on('change', '#cmbTipoTarifa', function(e) {

        //Se setea la fecha de vigencia inicial
        var d     = new Date();
        var month = d.getMonth()+1;
        var day   = d.getDate();
        var fechaVigenciaIni = (day < 10 ? '0' : '') + day  + '/' + (month < 10 ? '0' : '') + month + '/' + d.getFullYear();
        
        //Si es normal o estandar
        if ($(this).val() == 2){

            d.setFullYear(d.getFullYear()+1);
            var fechaVigenciaFin = (day < 10 ? '0' : '') + day  + '/' + (month < 10 ? '0' : '') + month + '/' + d.getFullYear();
           
            limpiarDatePicker();

            //formatDate('txtVigenciaInicial','txtVigenciaFinal',1);
            $('#txtVigenciaInicial').val(fechaVigenciaIni);
            $('#txtVigenciaFinal').val(fechaVigenciaFin);
           

        //Si es una promoci&oacute;n    
        } else if($(this).val() == 1){

            $('#txtVigenciaFinal').val('');
            formatDate('txtVigenciaInicial','txtVigenciaFinal',1);
            $('#txtVigenciaInicial').val(fechaVigenciaIni);

        } else {
            limpiarDatePicker();
            $('#txtVigenciaFinal').val('');
            $('#txtVigenciaInicial').val('');
        }
     
    });
 
    $(document.body).on('change', '#cmbTipoCondicion', function(e) {

         //Si es número de usuarios
         if ($(this).val() == 1){
            $('#cmbNumUsuarios').prop('disabled', false);
            $('#cmbGenero').prop('disabled', true);
            $('#txtEdadMinima').prop('disabled', true);
            $('#txtEdadMaxima').prop('disabled', true);
            $('#cmbGenero').val('');
            $('#txtEdadMinima').val('');
            $('#txtEdadMaxima').val('');
            
            $('#cmbNumUsuarios').prev().addClass('obligatorio');
            $('#cmbGenero, #txtEdadMinima, #txtEdadMaxima').prev().removeClass('obligatorio');

         //Si es quinquenio   
         } else if($(this).val() == 2){
            $('#cmbNumUsuarios').prop('disabled', true);
            $('#cmbNumUsuarios').val('');
            $('#cmbGenero').prop('disabled', false);
            $('#txtEdadMinima').prop('disabled', false);
            $('#txtEdadMaxima').prop('disabled', false);

            $('#cmbNumUsuarios').prev().removeClass('obligatorio');
            $('#cmbGenero, #txtEdadMinima, #txtEdadMaxima').prev().addClass('obligatorio');

         } else {
            $('#cmbNumUsuarios').prop('disabled', false);
            $('#cmbGenero').prop('disabled', false);
            $('#txtEdadMinima').prop('disabled', false);
            $('#txtEdadMaxima').prop('disabled', false);
            $('#cmbGenero').val('');
            $('#txtEdadMinima').val('');
            $('#txtEdadMaxima').val('');
            $('#cmbNumUsuarios').val('');
            
            $('#cmbNumUsuarios, #cmbGenero, #txtEdadMinima, #txtEdadMaxima').prev().removeClass('obligatorio');
         }

    });

    $(document.body).on('blur', '#txtEdadMaxima', function(e) {
        validaEdadMaxima();
    });
    
    aplicarDataTable("tablaParametrizaciontarifas");

});


function cargarFormulario(tipoAccion, codTarifa){

    runLoading(true);
    var desAccion    = tipoAccion == 1 ? 'Agregar' : 'Editar';
    var idModal      = 'verParametrizacionTarifas';
    var botonesModal = [{"id":"guardarMd","label":"Guardar","class":"btn-primary mr-3"},{"id":"cerrarMd","label":"Cancelar","class":"btn-primary"}];
    var paramsObj    = {};

    paramsObj['tipoAccion']  = tipoAccion;
    paramsObj['codTarifa']   = codTarifa;
  
    $.ajax({
        url: "Tarifa/formulario",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
           
            crearModal(idModal, desAccion + ' tarifas y promociones', resp.vista, botonesModal, false, 'modal-lg', '',true);
            $('#cerrarMd').click(function() {	                  	   
                $('#'+idModal).modal('hide');
            });
            $('#guardarMd').click(function() {	                  	   
                guardarTarifas();
            }); 

            $("#txtValorTarifa").on("keyup",function(){
                validFieldMiles(this);          
            }); 

            if ($('#txtValorTarifa').val() != ''){
                $('#txtValorTarifa').val(formatMiles($('#txtValorTarifa').val()));  
            }
            
            formatDate('txtVigenciaInicial','txtVigenciaFinal',1);
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

function guardarTarifas(){

    var camposRequeridos = [];
    var tipoCondicion = $('#cmbTipoCondicion').val();
    camposRequeridos.push({"id":"txtCodTarifaMP",     "texto":"Debe ingresar el c&oacute;digo de la tarifa"});
    camposRequeridos.push({"id":"txtValorTarifa",     "texto":"Debe ingresar el valor de la tarifa"});
    camposRequeridos.push({"id":"cmbTipoTarifa",      "texto":"Debe seleccionar un tipo de tarifa"});
    camposRequeridos.push({"id":"cmbPlan",            "texto":"Debe seleccionar un plan"});
    camposRequeridos.push({"id":"cmbProductos",       "texto":"Debe seleccionar un producto"});
    camposRequeridos.push({"id":"cmbTipoCondicion",   "texto":"Debe seleccionar un tipo"});  
    camposRequeridos.push({"id":"txtVigenciaInicial", "texto":"Debe ingresar la fecha de la vigencia inicial"});
    camposRequeridos.push({"id":"txtVigenciaFinal",   "texto":"Debe ingresar la fecha de vigencia final"});
    camposRequeridos.push({"id":"cmbEstado",          "texto":"Debe seleccionar un estado"});
    
    if(tipoCondicion == 1){
        camposRequeridos.push({"id":"cmbNumUsuarios",     "texto":"Debe seleccionar un n&uacute;mero de usuarios"});
    }else{
        if(tipoCondicion == 2){
            camposRequeridos.push({"id":"cmbGenero",     "texto":"Debe seleccionar un sexo"});
            camposRequeridos.push({"id":"txtEdadMinima",     "texto":"Debe ingresar la edad m&iacute;nima"});
            camposRequeridos.push({"id":"txtEdadMaxima",     "texto":"Debe ingresar la edad m&aacute;xima"});
        }
    }    
    
    if(validRequired(camposRequeridos)){
        if(validaEdadMaxima()){
            $('#txtVigenciaInicial').prop('disabled', false);
            $('#txtVigenciaFinal').prop('disabled', false);
            $('#txtCodTarifaMP').prop('disabled', false);
            $('#cmbTipoTarifa').prop('disabled', false);
            $('#cmbPlan').prop('disabled', false);
            $('#cmbProductos').prop('disabled', false);
            $('#cmbTipoCondicion').prop('disabled', false);
            $('#cmbNumUsuarios').prop('disabled', false);
            $('#cmbGenero').prop('disabled', false);
    
            $('#txtValorTarifa').val($('#txtValorTarifa').val().toString().replace(/\./g,''));
    
            var idModal       = 'verMsgGuardarTarifas';
            var botonesModal  = [{"id":"cerrarMsgTarifas","label":"Aceptar","class":"btn-primary"}];
            var formData      = new FormData($("#formTarifas")[0]);
        
            $.ajax({
                url: "Tarifa/guardarTarifas",  
                type: "POST",  
                dataType: "json",
                data:formData,            
                cache: false,
                contentType: false,
                processData: false,        
                success: function(resp){
                    runLoading(false);
    
                    if (resp.ret){
                        mensajeRespuesta =  'Se guardo con &eacute;xito la parametrizaci&oacute;n de la tarifa y promoci&oacute;n'; 
                    } else {
                        mensajeRespuesta = resp.errors;
                    }
    
                    crearModal(idModal, 'Confirmaci\u00f3n', mensajeRespuesta, botonesModal, false, '', '');
                    $('#cerrarMsgTarifas').click(function(){
                        $('#'+idModal).modal('hide');
                        if (resp.ret){
                            $('#verParametrizacionTarifas').modal('hide');
                            location.reload();
                        }
                        
                    });
                },
                error: function(resp) {
                    runLoading(false);
                    crearModal(idModal, 'Confirmaci\u00f3n', 'No se puede guardar la parametrizaci&oacute;n de la tarifa y la promoci&oacute;n', botonesModal, false, '', '');
                    $('#cerrarMsgTarifas').click(function(){
                        $('#'+idModal).modal('hide');
                    });
                }
            });
    
        }
    }
    
}

function limpiarDatePicker(){
    $('#txtVigenciaInicial').datepicker().destroy();
    $('#txtVigenciaInicial').addClass("form-control");
    $('#txtVigenciaInicial').addClass("campo-vd");

    $('#txtVigenciaFinal').datepicker().destroy();
    $('#txtVigenciaFinal').addClass("form-control");
    $('#txtVigenciaFinal').addClass("campo-vd");
}

function validaEdadMaxima(){
    var pasaValidacion = true;
    var edadMinima = !isNaN(parseInt($('#txtEdadMinima').val())) ? parseInt($('#txtEdadMinima').val()) : -1;
    var edadMaxima = !isNaN(parseInt($('#txtEdadMaxima').val())) ? parseInt($('#txtEdadMaxima').val()) : -1;
    
    if (edadMinima > edadMaxima){
        var mensaje   = 'La <b>edad mínima</b> no puede ser mayor a la <b>edad máxima</b>';
        var posicion  = $('#txtEdadMaxima').offset();
        $('#txtEdadMaxima').val('');
        
        var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
        $('body').append(divRequired);
        alertify.notify(mensaje, 'error', 3, function(){ $('#div_required_nexos').remove(); });
        pasaValidacion = false;
    }

    return pasaValidacion;
}
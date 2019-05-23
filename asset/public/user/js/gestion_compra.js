var global_aux_campos            = '';
var global_registro_basico       = {};
var global_prod_benefi           = {};
var global_aux_prodbenefi       = {};
var global_producto_seleccionado = {};
var global_programa_selecionado  = [];
var global_beneficiario_programa = {};
var global_accion_evento         = {};

$(document).ready(function() {

   if(g_senal == 0){
        if(global_datos_contratante['COD_AFILIACION'] == '-1'){
            traerHabeasData(function(data){
                validarHabeasData(data);        
            });
        }else{
            fn_inicio();
        }  
        //se establece nacionalidad por defecto - colombiano/a
        $('#pais_ctr option[value="36"]').attr("selected",true);
        
    }else{
        global_registro_basico = actualizaGlobalRegistro(global_benefis_pend);
        traerBenefisPrograms(function(data){
            pintarTablasBenefiProd('_pro');
            cargarBenefisPrograms(data);  
            cambiarEstadoAfiliacion();                 
            fn_pintarContrato(); 
            fn_verDetallePrograma();
            fn_pintarCoberturas();
            fn_pintarProgramas();
            fn_pintarCotizacion();
            cambioTabs('5','<b>Paso 5</b>','Generar','<b>Contrato</b>');
            $("#a_admin").hide();

            $('#btnFinalizarVenta').click(function(){
                finalizarVenta();
            });

            if(window.addEventListener){
                window.addEventListener('message', eventHandler,false);  
            }            
        }); 
        //fn_inicio();          
    }     
    
});

function fn_pintarContrato(){

    $(document.body).on("click", ".verContrato", function() {
       
        var urlAdobeSign     = $(this).attr('urlAdobeSign');
        var idWidget         = $(this).attr('idWidget');
        var codProgramaFirma = $(this).attr('codPrograma');
        var tipoMostrarPDF   = $(this).attr('tipoMostrarPDF');
      
        var idModal = 'verContrato';
        var botonesModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary"}];
        var paramsObj = {};

        paramsObj['nombrePdf']   = urlAdobeSign;
        paramsObj['codPrograma'] = codProgramaFirma;
        paramsObj['codPersona']  = global_datos_contratante['COD_PERSONA'];
        paramsObj['codAfiliacion']  = global_datos_contratante['COD_AFILIACION'];

      if (tipoMostrarPDF == 0) {
        crearModal(idModal, 'Informaci\u00f3n del Contrato', '<iframe id="verContrato" src="'+urlAdobeSign+'" width="100%" height="100%" style="border: 0; overflow: hidden; min-height: 500px;"></iframe>', botonesModal, false, 'modal-xl', '',true);
                $('#cerrarMd').click(function() {                          
                    $('.modal').modal('hide');
                });
       }else{

        runLoading(true);

        $.ajax({
            url: pointToUrl()+"Gc_paso_5/getUrlFirmaContrato",  
            type: "POST",  
            dataType: "json",
            data: paramsObj,   
            success: function(resp){
                runLoading(false);
                $('#txtMsgInicioServicio').val(resp.msgInicioServicio);                             
                $('#txtIdWidget').val(resp.widgetId);
                $('#txtCodProgramaFirma').val(codProgramaFirma);
                crearModal(idModal, 'Informaci\u00f3n del Contrato', '<iframe id="verContrato" src="'+resp.url+'" width="100%" height="100%" style="border: 0; overflow: hidden; min-height: 500px;"></iframe>', botonesModal, false, 'modal-xl', '',true);
                $('#cerrarMd').click(function() {                          
                    $('.modal').modal('hide');
                });
            },
            error: function(result) {
                runLoading(false);
                crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
                $('#cerrarMd').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });
     }

    });

}

function fn_verDetallePrograma(){

    $(document.body).on("click", ".verDetallePrograma", function() {
       
        var detalle      = $(this).attr('detalle');
        var desPrograma  = $(this).attr('desPrograma');
        var idModal      = 'verDetallePrograma';
        var botonesModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary"}];
        crearModal(idModal, desPrograma, '<p class="text-justify font-weight-normal">'+detalle+'</p>', botonesModal, false, '', '');
        $('#cerrarMd').click(function() {                          
            $('.modal').modal('hide');
        });

    });
}

function fn_pintarCoberturas(){
    $(document.body).on("click", ".verCoberturaPrograma", function() {
       
        var codPrograma   = $(this).attr('codPrograma');
        var desPrograma   = $(this).attr('desPrograma');
        var tipoCobertura = $(this).attr('tipoCobertura');
        var desCobertura  = tipoCobertura == '1' ? 'Iniciales' : 'Finales';
        var codPlan       = global_datos_contratante['COD_PLAN'];

        runLoading(true);

        var idModal      = 'verCoberturas';
        var botonesModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary"}];
        var paramsObj    = {};

        paramsObj['codPrograma']   = codPrograma;
        paramsObj['codPlan']       = codPlan;
        paramsObj['tipoCobertura'] = tipoCobertura;
      
        $.ajax({
            url: pointToUrl()+"Gestion_compra/getImgCoberturas",  
            type: "POST",  
            dataType: "json",
            data: paramsObj,   
            success: function(resp){
                runLoading(false);
               
                crearModal(idModal, 'Coberturas ' +desCobertura+' '+ desPrograma, resp.vista, botonesModal, false, 'modal-xl', '',true);
                $('#cerrarMd').click(function() {                          
                    $('.modal').modal('hide');
                });
            },
            error: function(result) {
                runLoading(false);
                crearModal(idModal, 'Confirmaci\u00f3n', 'No se pueden visualizar las coberturas', botonesModal, false, '', '');
                $('#cerrarMd').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });

    });
}

function fn_pintarProgramas(){
    $(document.body).on("click", ".seleccionarPrograma", function() {
        tabProductos(event, $(this).attr('href'));
        $(".seleccionarPrograma").css("background", ""); 
        $(".seleccionarPrograma").css("color", "#000"); 
        $(this).css("background","#2196f3");
        $(this).css("color","#fff");
    });
}

function fn_pintarCotizacion(){
    $(document.body).on("click", "#btn_cotizacion", function() {
       
        var url          = global_base_url + 'Gc_paso_3/verCotizacionPDF'; 
        var idModal      = 'verCotizacion';
        var botonesModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary"}];
        crearModal(idModal, 'Cotizaci&oacute;n', '<object class="embed-responsive-item" id="verCotizacionPDF" data="'+url+'" type="application/pdf" width="100%" height="100%" frameborder="0" style="border: 0; overflow: hidden; min-height: 500px; "><p> Su navegador web no tiene un complemento de PDF.En su lugar, puede <a href="'+url+'"> hacer clic aqu&iacute; para Descarga el archivo PDF. </a> </p></object>' , botonesModal, false, 'modal-xl', '',true);
        $('#cerrarMd').click(function() {                          
            $('.modal').modal('hide');
        });

    });
}

function validarHabeasData(data){
    var idModal = 'modalHabeasData';
    var botonesModal = [{"id":"aceptarHd","label":"Aceptar","class":"btn-primary mr-2"},{"id":"cerrarHd","label":"Cancelar","class":"btn-primary"}];
    var divHd = $('<div id="divHd" class="content-habeasData"></div>');
    var labelHd = $('<label></label>');
    var checkHd = $('<input type="checkbox" id="chAcepta">');
    
    labelHd.html(checkHd);
    labelHd.append(' Acepto los t&eacute;rminos y condiciones');
    divHd.html(data['habeasData']);
    divHd.append('<br><br>');
    divHd.append(labelHd);

    crearModal(idModal, 'Autorizaci&oacute;n para el tratamiento de los datos personales', divHd, botonesModal, false, 'modal-xl', '',true);
    
    $('#cerrarHd').click(function() {
        $('#'+idModal).modal('hide');
        location.href = 'Home';
    });

    $('#aceptarHd').click(function() {
        $('#'+idModal).modal('hide');
        fn_inicio();
    });

    $('#aceptarHd').attr('disabled','disabled');

    checkHd.change(function(){
        if($(this).is(':checked')){
            $('#aceptarHd').removeAttr('disabled');
        }else{
            $('#aceptarHd').attr('disabled','disabled');
        }
    });
}

function fn_inicio(){

    if(window.addEventListener){
        window.addEventListener('message', eventHandler,false);  
    }

    var tabsCompra = $('#tabs_compra').children('li');
    var cadena_excluidos = 'nombre2_ctr,apellido2_ctr,telefono_ctr,complemento_ctr,inBeneficiario';
    global_aux_campos = $('#divContratante').html();
    formatDate('fechaNacimiento_ctr');
    $('#fechaNacimiento_ctr').attr('autocomplete','off');

    $('#btnAddBenefi').click(function(){
        var datoBenefi = !isNaN(parseInt($(this).attr('data-numBenefi'))) ? parseInt($(this).attr('data-numBenefi')) : 1;
        agregarBeneficiario(datoBenefi);
    });

    //Aplicar evento al incluir o no el contratante como beneficiario 
    $('INPUT[name="inBeneficiario"]').change(function(){
        var valorIn = $('INPUT[name="inBeneficiario"]:checked').val();
        if(valorIn == '1'){
            cadena_excluidos += 'mascota_ctr';
            if(validRequired(getObjRequerid('divContratante', cadena_excluidos))){
                getDataCamps('ctr', 0);
                $('#div_tieneMascota_ctr').removeClass('hideComponent');
            }else{
                $('INPUT[name="inBeneficiario"][value="0"]').prop('checked',true);
                $('INPUT[name="inBeneficiario"]').trigger('change');
            }
            //getDataCamps('ctr', 0);
            //$('#div_tieneMascota_ctr').removeClass('hideComponent');
        }else{
            quitarBeneficiario(0);
            $('#div_tieneMascota_ctr').addClass('hideComponent');
            $('INPUT[name="mascota_ctr"]').prop('checked',false);
        }

        pintarTablaBeneficiarios();
    });

    cargarDatos('ctr', global_datos_contratante);
    aplicaValidacionCampos('ctr');
    pintarTabsProductos('_pro');

    //Aplicar evento click a la pesta 1 - Registro datos basicos
    tabsCompra.eq(0).children('a').click(function(){
        cambioTabs('1','<b>Paso 1</b>','Solicitar','<b>Compra</b>');
    });

    //Aplicar evento click a la pesta 2 - Agregar producto
    tabsCompra.eq(1).children('a').click(function(){        
        traerBenefisPrograms(function(data){
            cambioTabs('2','<b>Paso 2</b>','Agregar','<b>Productos</b>');
            pintarTablasBenefiProd('_pro');
            cargarBenefisPrograms(data);            
        });                
    });

     //Aplicar evento click a la pesta 3 - Cotizaci&oacute;n
    tabsCompra.eq(2).children('a').click(function(){ 
        cambioTabs('3','<b>Paso 3</b>','','<b>Cotizaci&oacute;n</b>');       
        llenarDatosTab('_cot');        
    });

    //Aplicar evento click a la pesta 4 - Registro pago
    tabsCompra.eq(3).children('a').click(function(){
        cambioTabs('4','<b>Paso 4</b>','Registrar','<b>Pago</b>');
    });

    //Aplicar evento click a la pesta 5 - Contrato
     tabsCompra.eq(4).children('a').click(function(){
        cambioTabs('5','<b>Paso 5</b>','Generar','<b>Contrato</b>');
        llenarDatosTab('_con');
        $('#ulProductos_con').find('a.nav-link:first-child').trigger('click');
    });

    $("#btn_consultar").on("click",getEncuestaSarlafDatos);
    $("#btn_encuesta").on("click",function(){
        alertify.dismissAll();
        getEncuestaSarlaf(global_datos_contratante["COD_AFILIACION"],global_datos_contratante["COD_PERSONA"]);
    });    

    $(document.body).on('click', '.adjuntarArchivo', function(e) {
        alertify.dismissAll();
        var codPersona         = $(this).attr('codPersona');
        var nombreBeneficiario = $(this).attr('nombreBeneficiario');
        var codAfiliacion      = global_datos_contratante['COD_AFILIACION'];//global_registro_basico[0]['cod_afiliacion'];
        var url                = global_base_url + 'Gc_paso_3/verAdjuntarArchivos/'+codPersona+'/'+codAfiliacion; 
        var validaAdjuntos     = false;
        var botonesModal       = '';
       
        validaAdjuntos         = validaDocumentos(codPersona,codAfiliacion);
        
        if (validaAdjuntos){
            botonesModal  = [{"id":"cerrarMd","label":"Cerrar","class":"btn-primary"}];
        } else {
            botonesModal  = [{"id":"guardarMd","label":"Guardar","class":"btn-primary mr-3"},{"id":"cerrarMd","label":"Cerrar","class":"btn-primary"}];
        }
        var idModal       = 'verAdjuntarArchivos';
        
        crearModal(idModal, 'Soportes ' + nombreBeneficiario, '<iframe class="embed-responsive-item" id="verAdjuntar" src="'+url+'" width="100%" height="100%" frameborder="0" style="border: 0; overflow: hidden; min-height: 220px;"></iframe>' ,  botonesModal, false, 'modal-lg', '');
        
        $('#cerrarMd').click(function() {	                  	   
            $('#'+idModal).modal('hide');
        });
        $('#guardarMd').click(function() {	     
                  
            var mensaje      = '';
            $('iframe#verAdjuntar').contents().find(".adjuntarDocumentos").each(function(){  
               
                var idDocumento   = $(this).attr('id');
                              
                if($(this).val() == '' || $(this).val() == ' ') {
                    mensaje         = 'Debe adjuntar todos los soportes';
                    posicion        = $('iframe#verAdjuntar').contents().find('#'+idDocumento).offset();
                } 
               
            });
        
            if (mensaje != ''){
                var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
                $('iframe#verAdjuntar').contents().find('body').append(divRequired);
                alertify.notify(mensaje, 'error', 3, function(){ $('iframe#verAdjuntar').contents().find('#div_required_nexos').remove(); });
            } else {
                mensaje = 'Se agregaron correctamente los soportes';
                $('iframe#verAdjuntar').contents().find('#formAdjuntos').submit();
                $('#guardarMd').prop('disabled');
                //Cerrar el modal
                //$('#'+idModal).modal('hide');
                //alertify.notify(mensaje, 'success', 3, null);        
            }

                

        });
    
        $('iframe#verAdjuntar').on('load', function () {
           
            $('iframe#verAdjuntar').contents().find("#codAfiliacion").val(codAfiliacion);
            $('iframe#verAdjuntar').contents().find("#codBeneficiario").val(codPersona);

            var arrayNombres = [];
            
            $(this).contents().find('.adjuntarDocumentos').on('change', function() {
               
                var idDocumento = $(this).attr('id');
                var filename    = $(this).val();
                var mensaje     = $(this).attr('msj'); 

                if ($(this).get(0).files.length == 0) {
                    $('iframe#verAdjuntar').contents().find("#btnVerFile"+idDocumento).addClass("disabled");
                    $('iframe#verAdjuntar').contents().find("#mostrarfile"+idDocumento).val('');
                    $('iframe#verAdjuntar').contents().find("#mostrarfile"+idDocumento).attr("placeholder", mensaje);
              
                } else {

                    if (typeof arrayNombres !== 'undefined' && arrayNombres.length > 0) {

                        //Se valida si el nombre ya existe
                        if(!arrayNombres.includes(filename)){
                            //Se agrega el nombre actual al array
                            arrayNombres.push(filename);
                            $('iframe#verAdjuntar').contents().find("#mostrarfile"+idDocumento).val(filename);
                            $('iframe#verAdjuntar').contents().find("#btnVerFile"+idDocumento).removeClass("disabled");

                        } else {
                            $(this).val('');
                            mensaje         = 'No se puede ingresar el mismo archivo adjunto';
                            posicion        = $('iframe#verAdjuntar').contents().find('#'+idDocumento).offset();
                            
                            var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
                            $('iframe#verAdjuntar').contents().find('body').append(divRequired);
                            alertify.notify(mensaje, 'error', 3, function(){ $('iframe#verAdjuntar').contents().find('#div_required_nexos').remove(); });
                        }
                    } else {
                        //Se agrega el nombre actual al array
                        arrayNombres.push(filename);
                        $('iframe#verAdjuntar').contents().find("#mostrarfile"+idDocumento).val(filename);
                        $('iframe#verAdjuntar').contents().find("#btnVerFile"+idDocumento).removeClass("disabled");
                    }

                   
                }
            });

            $(this).contents().find('.verArchivo').on('click', function() {

                var idDocumento = $(this).attr('upload');
                if ($(this).hasClass('disabled') === false) {

                    var file   = $('iframe#verAdjuntar').contents().find("#"+idDocumento)[0].files[0];
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


           $(this).contents().find('.verAdjunto').on('click', function() {

                var url = $(this).attr('ruta');
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

    
    $(document.body).on("click", ".paginaAnterior", function() {
        var idBotonAtras = $(this).attr('id');
        $('#tabs_compra').find('a[href="#paso' + idBotonAtras + '"]').trigger('click');
    });

    fn_pintarProgramas();   
    fn_pintarContrato();
    fn_verDetallePrograma();
    fn_pintarCoberturas();    
    fn_pintarCotizacion();

    $("#guardaCotizacion").on("click",function(){
        runLoading(true);
        setTimeout(function(){
           saveCotizacion();
           runLoading(false);
        },1000);

    });
    
    //Aplicar evento al pasar de la tab1 a la tab2
    $('#siguiente_paso1').click(function(){
        var valorInBenefi = $('INPUT[name="inBeneficiario"]:checked').val();
        var cadena_excluidos_aux = valorInBenefi == 1 ? cadena_excluidos : cadena_excluidos + ',mascota_ctr';
        
        if(validRequired(getObjRequerid('divContratante', cadena_excluidos_aux))){ 
            if(Object.keys(global_registro_basico).length > 0){
                var codigoContratante = global_datos_contratante['COD_PERSONA'];
                if(global_registro_basico[0] != undefined){
                    getDataCamps('ctr', 0);
                }
                guardarDatosBasicos(codigoContratante, global_registro_basico, 3, function(data){
                    var dataBenefi = actualizaGlobalRegistro(data['beneficiarios']);
                    global_registro_basico = dataBenefi;
                    if(global_registro_basico[0] != undefined){
                        getDataCamps('ctr', 0);
                    }
                    tabsCompra.eq(1).children('a').trigger('click');
                });
            }else{
                crearModal('modalConfirm', 'Confirmaci&oacute;n', 'Para avanzar debe agregar por lo menos un beneficiario.', {}, true, '', '');
            }
        }
    });

    //Aplicar evento al pasar de la tab2 a la tab3
    $('#siguiente_paso2').click(function(){
        if(validaBenefiCompra()){
            registrarFactura(function(){
                //Actualizar variable aux con lo que posee la variable principal
                global_aux_prodbenefi = pasar_obj_global(global_prod_benefi);
                tabsCompra.eq(2).children('a').trigger('click');
            });
        }                
    });
    
    //Aplicar evento para setear dato al obj global_registro_basico, cuando se cambia la el check mascota
    $('INPUT[name="mascota_ctr"]').change(function(){
        var valorMascota = $('INPUT[name="mascota_ctr"]:checked').val();
        if(global_registro_basico[0] != undefined){
            global_registro_basico[0]['mascota'] = valorMascota;
        }        
    });
    
    $('#mostrarFirmaContrato').click(function(){
        firmaContrato();
    });

    $('#btnFinalizarVenta').click(function(){
        finalizarVenta();
    });

    //Aumentar contador beneficiarios
    $('#btnAddBenefi').attr('data-numBenefi', global_benefis_pend.length + 1);

    //Pintar detalle de mi carrito
    $('.micar-vd').click(function(){
        detalleMiCarrito();
    });

    global_registro_basico = actualizaGlobalRegistro(global_benefis_pend);
    pintarTablaBeneficiarios();
}

function agregarBeneficiario(p_idx){
    var idx_aux = p_idx + 1;
    var idx = 'bnf';//p_idx;
    var vDiv = $('<div id="divBenefi_'+idx+'" class="content"></div>');
    var vCampos = global_aux_campos.replace(/_ctr/g, '_'+idx);
    var idModal = 'modalAddBenefi';
    var botonesModal = [{"id":"aceptarMd","label":"Adicionar","class":"btn-primary mr-2"}, {"id":"cerrarMd","label":"Cerrar","class":"btn-primary"}];
    var div_parentesco = ('<div class="col-sm-12 col-md-6 col-lg-3">'+
                                '<label class="obligatorio">Parentesco</label>'+
                                '<select id="parentesco_'+idx+'" class="form-control lista-vd obligatorio">'+
                                    global_op_parentesco +
                                '</select>'+
                            '</div>');
    
    vDiv.html(vCampos);
    
    crearModal(idModal, 'Adicionar beneficiario', vDiv, botonesModal, false, 'modal-xl', '');

    //Aplicar accion remove para el beneficiario
    $('#quitBenefi_'+idx).click(function(){
        var datoBenefi = $(this).attr('data-benefi');
        quitarBeneficiarioConfirm(datoBenefi);
    });

    $('#aceptarMd').click(function(){
        var cadena_excluidos = 'nombre2_bnf,apellido2_bnf,telefono_bnf,complemento_bnf';
        if(validRequired(getObjRequerid('divBenefi_'+idx, cadena_excluidos))){
            getDataCamps(idx, p_idx);
            pintarTablaBeneficiarios();

            //Aumentar contador beneficiarios
            $('#btnAddBenefi').attr('data-numBenefi', idx_aux);
            $('#'+idModal).modal('toggle');
        }
    });

    $('#cerrarMd').click(function(){
        $('#'+idModal).modal('toggle');
    });

    //Ajustar campos para el benficiario
    $('#div_inBeneficiario_'+idx).remove();
    $('#div_row_add_'+idx).append(div_parentesco);
    $('#div_tieneMascota_'+idx).removeClass('hideComponent');
    //$('#div_row_add_'+idx).append(div_mascota);
    
    //Aplicar data picker (calendario)
    formatDate('fechaNacimiento_'+idx);
    $('#fechaNacimiento_'+idx).attr('autocomplete','off');
    
    //Aplicar validacion por edad del beneficiario
    $('#fechaNacimiento_'+idx).change(function(){
        var fechaSel = $(this).val();
        var idModalFch = 'modalValidFecha';
        var botonesFch = [{"id":"aceptarFch","label":"Aceptar","class":"btn-primary"}];
        var vEdadAdulto = 45;
        var vMayoriaEdad = 18;
        var vEdadMenor = 1;
        if(fechaSel != ''){
            var edadPersona = validaEdad(fechaSel);
            if(edadPersona > vEdadAdulto || edadPersona < vEdadMenor){
                crearModal(idModalFch, 'Confirmaci&oacute;n', 'Edad no permitida para realizar la solicitud, por favor comun&iacute;quese con un asesor.', botonesFch, false, '', '');
                $(this).val('');
                $('#aceptarFch').click(function(){
                    $('#'+idModalFch).modal('toggle');
                });
            }

            if(edadPersona < vMayoriaEdad){
                $('#telefono_'+idx).val($('#telefono_ctr').val());
                $('#celular_'+idx).val($('#celular_ctr').val());
                $('#correo_'+idx).val($('#correo_ctr').val());
            }
        }
    });

    //Aplicar validacion por parentesco del beneficiario
    $('#parentesco_'+idx).change(function(){
        var parentescoSel = $(this).val();
        var parentescoRegla = ['2','4'];
        if(parentescoRegla.indexOf(parentescoSel) > -1){
            $('#tipoVia_'+idx).find('option[value="'+$('#tipoVia_ctr').val()+'"]').prop('selected',true).attr('selected','selected');
            $('#numeroTipoVia_'+idx).val($('#numeroTipoVia_ctr').val());
            $('#numeroPlaca_'+idx).val($('#numeroPlaca_ctr').val());
            $('#complemento_'+idx).val($('#complemento_ctr').val());
        }
    });

    //Aplicar validacion por beneficiario ya registrado
    $('#numeroDocumento_'+idx).focusout(function(){
        var tipoIdenti = $('#tipoDocumento_'+idx).val();
        var numIdenti = $('#numeroDocumento_'+idx).val();
        var tipoIdentiAbr = $('#tipoDocumento_'+idx+' OPTION[value="'+tipoIdenti+'"]').attr('data-abr');
        if(tipoIdenti != '-1'  && tipoIdenti != null && numIdenti != ''){
            traerInfoBeneficiario(tipoIdenti, numIdenti, tipoIdentiAbr);
        }
    });

    //Aplicar validacion por beneficiario ya registrado
    $('#tipoDocumento_'+idx).change(function(){          
        validaTipoDoc('tipoDocumento_'+idx, 'numeroDocumento_'+idx);
        var tipoIdentifi = $('#tipoDocumento_'+idx).val();
        var numIdentifi = $('#numeroDocumento_'+idx).val();
        var tipoIdentiAbr = $('#tipoDocumento_'+idx+' OPTION[value="'+tipoIdentifi+'"]').attr('data-abr');
        if(tipoIdentifi != '-1'){
            $('#numeroDocumento_'+idx).removeAttr("disabled");
        }   
        if(tipoIdentifi != '-1'  && tipoIdentifi != null && numIdentifi != ''){                        
            traerInfoBeneficiario(tipoIdentifi, numIdentifi, tipoIdentiAbr);
        }
    });
    $('#numeroDocumento_'+idx).attr("disabled","disabled");
}

function quitarBeneficiarioConfirm(idxBenefi){
    var idModal = 'modalAddBenefi';
    var botonesModal = [{"id":"aceptarCm","label":"Aceptar","class":"btn-primary mr-2"}, {"id":"cerrarCm","label":"Cancelar","class":"btn-primary"}];
    var nomBenefi = global_registro_basico[idxBenefi]['nombre_completo'] != undefined ? global_registro_basico[idxBenefi]['nombre_completo'] : '';
    var msj = '¿Esta seguro de quitar el beneficiario '+ nomBenefi +'?';
    
    crearModal(idModal, 'Adicionar beneficiario', msj, botonesModal, false, '', '');

    $('#aceptarCm').click(function(){
        quitarBeneficiario(idxBenefi);
        $('#'+idModal).modal('toggle');
    });

    $('#cerrarCm').click(function(){
        $('#'+idModal).modal('toggle');
    });
}

function quitarBeneficiario(idxBenefi){
    if(global_registro_basico[idxBenefi] != undefined){
        var llaveProdBenefi = global_registro_basico[idxBenefi]['tipoDocumento']+'_'+global_registro_basico[idxBenefi]['numeroDocumento'];
        var prodBenefi = global_aux_prodbenefi;
        delete global_registro_basico[idxBenefi];
        pintarTablaBeneficiarios();
    
        //Remover beneficiario de la seleccion de programas
        for(p in prodBenefi){
            var cod_producto = p;
            var producto = prodBenefi[cod_producto];
            var programas = Object.keys(producto);
            for(a=0; a<programas.length; a++){
                var cod_programa = programas[a];
                var programa = producto[cod_programa];
                console.log('producto['+cod_producto+']', producto);
                console.log('programa['+cod_programa+']', programa);
                if(programa[llaveProdBenefi] != undefined){
                    delete global_aux_prodbenefi[p][programas[a]][llaveProdBenefi];
                    delete global_prod_benefi[p][programas[a]][llaveProdBenefi];
                }            
            }
        }
    }
}


function getDataCamps(complemento, idx, actualizaGlobal){
    var complent = '_'+complemento;
    var objDatos = global_registro_basico[idx] != undefined ? global_registro_basico[idx] : {};
    objDatos['tipoDocumento'] = $('#tipoDocumento'+complent).val();
    objDatos['tipoDocumento_abr'] = $('#tipoDocumento'+complent+' OPTION[value="'+objDatos['tipoDocumento']+'"]').attr('data-abr');
    objDatos['numeroDocumento'] = $('#numeroDocumento'+complent).val();
    objDatos['nombre1'] = $('#nombre1'+complent).val();
    objDatos['nombre2'] = $('#nombre2'+complent).val();
    objDatos['apellido1'] = $('#apellido1'+complent).val();
    objDatos['apellido2'] = $('#apellido2'+complent).val();
    objDatos['fechaNacimiento'] = $('#fechaNacimiento'+complent).val();
    objDatos['tipoSexo'] = $('#tipoSexo'+complent).val();
    objDatos['telefono'] = $('#telefono'+complent).val();
    objDatos['celular'] = $('#celular'+complent).val();
    objDatos['correo'] = $('#correo'+complent).val();
    objDatos['pais'] = $('#pais'+complent).val();
    objDatos['tipoVia'] = $('#tipoVia'+complent).val();
    objDatos['numeroTipoVia'] = $('#numeroTipoVia'+complent).val();
    objDatos['numeroPlaca'] = $('#numeroPlaca'+complent).val();
    objDatos['complemento'] = $('#complemento'+complent).val();
    objDatos['municipio'] = $('#municipio'+complent).val();
    objDatos['estado_civil'] = $('#estado_civil'+complent).val();
    objDatos['eps'] = $('#eps'+complent).val();
    objDatos['parentesco'] = idx > 0 ? $('#parentesco'+complent).val() : 10;
    objDatos['mascota'] = $('#mascota'+complent+':checked').val();
    objDatos['tarifa'] = 0;
    objDatos['nombre_completo'] = objDatos['nombre1']+' '+objDatos['nombre2']+' '+objDatos['apellido1']+' '+objDatos['apellido2'];
    objDatos['tipoVia_abr'] = $('#tipoVia'+complent+' OPTION[value="'+objDatos['tipoVia']+'"]').attr('data-abr');
    objDatos['direccion'] = objDatos['tipoVia_abr']+' '+objDatos['numeroTipoVia']+' # '+objDatos['numeroPlaca']+' '+objDatos['complemento'];

    if(idx > 0){
        objDatos['accion'] = '<img src="'+global_base_url+'asset/public/images/delete.png" class="quit-benefi" id="quitBenefi_'+complent+'" data-benefi="'+complent+'" onclick="quitarBeneficiarioConfirm('+idx+');">'+
                                '<img src="'+global_base_url+'asset/public/images/edit.png" class="edit-benefi" id="editBenefi_'+complent+'" data-benefi="'+complent+'" onclick="editarBeneficiario('+idx+');">';
    }else{
        objDatos['accion'] = '';
    }   

    if(actualizaGlobal != false){
        global_registro_basico[idx] = objDatos;
    }
    
    return objDatos;
}

function pintarTablaBeneficiarios(){
    var auxDatos = [];
    var columnas = getColumnTable('beneficiarios');
    var tabla = '';

    for(b in global_registro_basico){
        var beneficiario = global_registro_basico[b];
        auxDatos.push(beneficiario);
    }

    tabla = createTable('tablaBenefi', columnas, auxDatos);
    $('#divTablaBenefi').html(tabla);
    aplicarDataTable('tablaBenefi');

}

function cargarDatos(complement, datos){
   
    var data = datos;
    var complemento = '_'+complement;

    $('#tipoDocumento'+complemento).find('option[value="'+data['COD_TIPO_IDENTIFICACION']+'"]').prop('selected',true).attr('selected','selected');
    $('#numeroDocumento'+complemento).val(data['NUMERO_IDENTIFICACION']);
    $('#nombre1'+complemento).val(data['NOMBRE_1']);
    $('#nombre2'+complemento).val(data['NOMBRE_2']);
    $('#apellido1'+complemento).val(data['APELLIDO_1']);
    $('#apellido2'+complemento).val(data['APELLIDO_2']);
    $('#fechaNacimiento'+complemento).val(data['FECHA_NACIMIENTO']);
    $('#tipoSexo'+complemento).find('option[value="'+data['COD_SEXO']+'"]').prop('selected',true).attr('selected','selected');
    $('#telefono'+complemento).val(data['TELEFONO']);
    $('#celular'+complemento).val(data['CELULAR']);
    $('#correo'+complemento).val(data['EMAIL']);
    $('#pais'+complemento).find('option[value="'+data['COD_PAIS']+'"]').prop('selected',true).attr('selected','selected');
    $('#tipoVia'+complemento).find('option[value="'+data['DIR_TIPO_VIA']+'"]').prop('selected',true).attr('selected','selected');
    $('#numeroTipoVia'+complemento).val(data['DIR_NUM_VIA']);
    $('#numeroPlaca'+complemento).val(data['DIR_NUM_PLACA']);
    $('#complemento'+complemento).val(data['DIR_COMPLEMENTO']);
    $('#estado_civil'+complemento).find('option[value="'+data['COD_ESTADO_CIVIL']+'"]').prop('selected',true).attr('selected','selected');
    $('#eps'+complemento).find('option[value="'+data['COD_EPS']+'"]').prop('selected',true).attr('selected','selected');
    $('INPUT[name="mascota'+complemento+'"][value="'+data['IND_TIENE_MASCOTA']+'"]').prop('checked', true);
    $('#municipio'+complemento).find('option[value="'+data['COD_MUNICIPIO']+'"]').prop('selected',true).attr('selected','selected');
    
}

function aplicaValidacionCampos(complemento){
    //Aplicar disabled a los campos que se requiere
    //$('#tipoDocumento_'+complemento+', #numeroDocumento_'+complemento+', #nombre1_'+complemento+', #nombre2_'+complemento+', #apellido1_'+complemento+', #apellido2_'+complemento).attr('disabled','disabled');
    $('#tipoDocumento_'+complemento+', #numeroDocumento_'+complemento).attr('disabled','disabled');
}

function traerInfoBeneficiario(tipoIdentificacion, numIdentificacion, tipoIdentificacionAbr){
    runLoading(true);
    var idModal = 'modalInfoBeneficiario';
    var botonesModal = [{"id":"cerrarMr","label":"Aceptar","class":"btn-primary"}];
    var paramsObj = {};
    paramsObj['tipo_identificacion'] = tipoIdentificacion;
    paramsObj['num_identificacion'] = numIdentificacion;
    paramsObj['tipo_identificacion_abr'] = tipoIdentificacionAbr;

    $.ajax({
        url: "Gestion_compra/getInfoPersona",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            var data = resp;
            if(Object.keys(data['benefi']).length > 0){ 
                cargarDatos('bnf', data['benefi']);
                aplicaValidacionCampos('bnf');
            }

            //if(data['mora']['fecha_mora'] != undefined){
                if(data['mora']['fecha_mora'] == null){
                    if(data['mora']['fecha_retiro'] == null){
                        if(data['benefi'].length > 0){ 
                            cargarDatos('bnf', data['benefi']);
                            aplicaValidacionCampos('bnf');
                        }
                        $('#aceptarMd').removeAttr('disabled');
                    }else{
                        //Validar si lleva mas de un año retirado
                        //MSJ: "Debido al tiempo que lleva retirado, la compra que solicite quedara como una venta nueva y no conservara su antigüedad"
                        if(validaEdad(data['mora']['fecha_retiro']) < 1){ //No mora y retirado menos de un año
                            crearModal(idModal,"Confirmaci&oacute;n", 'El beneficiario '+ data['mora']['nombre_completo'] +' se encuentra en cartera, por favor comun&iacute;quese con un asesor', botonesModal, false, '', '',true);
                            $('#aceptarMd').attr('disabled','disabled');
                        }else{ //No mora y retirado mas de un año
                            crearModal(idModal,"Confirmaci&oacute;n", 'Debido al tiempo que lleva retirado, la compra que solicite quedara como una venta nueva y no conservara su antigüedad', botonesModal, false, '', '',true);
                            $('#aceptarMd').removeAttr('disabled');
                        }
                        $('#cerrarMr').click(function(){
                            $('#'+idModal).modal('toggle');
                        });
                    }
                }else{
                    if(data['mora']['fecha_retiro'] == null){ //En mora y activo
                        crearModal(idModal,"Confirmaci&oacute;n", 'El beneficiario '+ data['mora']['nombre_completo'] +' se encuentra en cartera, por favor comun&iacute;quese con un asesor', botonesModal, false, '', '',true);                        
                        $('#aceptarMd').attr('disabled','disabled');
                    }else{
                        if(validaEdad(data['mora']['fecha_retiro']) < 1){ //En mora y retirado menos de un año
                            crearModal(idModal,"Confirmaci&oacute;n", 'El beneficiario '+ data['mora']['nombre_completo'] +' se encuentra en cartera, por favor comun&iacute;quese con un asesor', botonesModal, false, '', '',true);
                            $('#aceptarMd').attr('disabled','disabled');
                        }else{ //En mora y retirado mas de un año
                            crearModal(idModal,"Confirmaci&oacute;n", 'Debido a la mora que presenta el beneficiario, la compra que solicite quedara como una venta nueva y no conservara su antigüedad', botonesModal, false, '', '',true);
                            $('#aceptarMd').removeAttr('disabled');
                        }
                    }
                    $('#cerrarMr').click(function(){
                        $('#'+idModal).modal('toggle');
                    });
                }
            //}else{
            //    $('#aceptarMd').removeAttr('disabled');
            //}          
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
            $('#cerrarMr').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    }); 
}

function pintarTabsProductos(abr_tab){

    var productos = abr_tab == '_pro' ? global_productos : global_producto_seleccionado;
    
    $('#ulProductos'+abr_tab).html('');
    $('#divProductos'+abr_tab).html('');
    
    for(p=0; p<productos.length; p++){
        
        var producto = productos[p];
        var codProd = producto['COD_PRODUCTO'];
        var liProduct = $('<li class="nav-item tabs-producto" id="liProducto_'+codProd+'">');
        var aProduct = $('<a class="nav-link" href="#divProducto'+abr_tab+'_'+codProd+'" role="tab" data-toggle="tab"></a>');
        var imageProduct = $('<img class="imgmenu-vd" src="'+global_base_url+'asset/public/images/vd/producto_'+codProd+'.png">');
        var divProduct = $('<div class="tab-pane text-center gallery" id="divProducto'+abr_tab+'_'+codProd+'">');

        aProduct.html(imageProduct);
        liProduct.html(aProduct);
        liProduct.append('<div><span>'+producto['DES_PRODUCTO']+'</span></div>');
        divProduct.html('<fielset><legend>'+producto['DES_PRODUCTO']+'</legend><br> <div id="desProducto_'+codProd+'"><p class="text-justify font-weight-normal">'+producto['DESCRIPCION']+'</p></div></fielset>');
       

        $('#ulProductos'+abr_tab).append(liProduct);
        $('#divProductos'+abr_tab).append(divProduct);
        pintarTabsProgramas(codProd, producto['PROGRAMAS'], abr_tab);
       
    }

    //Calcular datos mi carrito
    $('.add-prodcar').click(function(){
        calcularMiCarrito(true);
    });
    //Aplicar validacion Habeas data CEM
    $('#liProducto_3 a').click(function(){        
        setTimeout(function(){
            if ($('#tabs_compra').find('A[aria-selected="true"]').attr('href') != "#paso_5") {       
                validarHabeasDataCem();
            }
        },1000);         
    });
}

function pintarTabsProgramas(codProducto, objProgramas, abr_tab){

     var verBeneficiarios = abr_tab == '_con' ? '' : 'seleccionarPrograma';
    //var productos = objProgramas;
    var htmlTabsPrograma = '<div class="container">'+
                                '<div class="card-deck justify-content-center text-center" id="programas'+abr_tab+'_'+codProducto+'"></div>'+
                                '<div class="tab-content tab-space" id="divProgramas'+abr_tab+'_'+codProducto+'"></div>'+
                            '</div>';
    var btnAddCar = '<div class="container">'+
                        '<div class="row">'+
                            '<div class="col-sm-12 col-md-3 col-lg-3 offset-md-9 offset-lg-9 text-rigth">'+
                                '<button type="button" class="btn btn-primary btn-block boton-vd add-prodcar disabled-add-prodcar">'+
                                    '<i class="fa fa-shopping-cart" aria-hidden="true"></i> &nbsp; A&ntilde;adir'+
                                '</button>'+
                            '</div>'+
                        '</div>'+
                    '</div>';

    $('#divProducto'+abr_tab+'_'+codProducto).append(htmlTabsPrograma);
    for(z=0; z<objProgramas.length; z++){
       

        var activeTab     = '';//z == 0 ? 'active' : '';
        var programa      = objProgramas[z];
        var codPrograma   = programa['cod_programa'];        
        var urlAdobeSign  = '';
        var desContrato   = '';
        var tipoMostrarPDF = 0;

        if (programa['tipo_venta'] !== undefined && abr_tab == '_con'){

            //Si el tipo de venta es inclusi&oacute;n
            if (programa['tipo_venta']  == 1){

                urlAdobeSign  =  global_base_url+programa['link_contrato'];
                desContrato   =  'Ver Contrato';
                tipoMostrarPDF = 0;

            }  else {

                urlAdobeSign  = programa['link_url_firma'];
                desContrato   = 'Firmar Contrato';
                tipoMostrarPDF = 1;
            }
        } else {
            urlAdobeSign  = abr_tab == '_pro' ? global_base_url+programa['link_contrato'] : programa['link_url_firma'];
            desContrato   = abr_tab == '_pro' ? 'Ver Contrato' : 'Firmar Contrato';
            tipoMostrarPDF   = abr_tab == '_pro' ? 0 : 1;
        }

        var aux_tittle  = abr_tab == '_pro' ? 'Ver beneficiarios' : '';

        var tipoCobertura = abr_tab == '_pro' ? '1' : '2';
        var cardPrograma  = $('<div class="card col-md-3 shadow-sm" id="cardPrograma'+abr_tab+'_'+codPrograma+'"> </div>');
        var cardHeader    = $('<div class="card-header '+verBeneficiarios+'"  href="divPrograma'+abr_tab+'_'+codPrograma+'" style="cursor:pointer;" title="'+aux_tittle+'"><i class="fa fa-shopping-cart" aria-hidden="true"></i> &nbsp;<strong><b>'+ programa['des_programa'] +'</b></strong></div>');
        var cardBody      = $('<div class="card-body"></div>');
        var ulPrograma    = $('<ul class="list-unstyled"></ul>');
        var divPrograma   = $('<div class="tab-pane tabcontent text-center gallery '+activeTab+'" id="divPrograma'+abr_tab+'_'+codPrograma+'">');

        cardPrograma.append(cardHeader);
        cardPrograma.append(cardBody);
        cardBody.append(ulPrograma);
        if(abr_tab != '_con'){
            ulPrograma.append('<li style="cursor:pointer;" class="verDetallePrograma" detalle="'+programa['descripcion']+'" desPrograma="'+programa['des_programa']+'"><h6 class="card-title pricing-card-title">Ver Detalle</h6></li>');
            ulPrograma.append('<li style="cursor:pointer;" class="verCoberturaPrograma" codPrograma="'+codPrograma+'" desPrograma="'+programa['des_programa']+'" tipoCobertura="'+tipoCobertura+'"><h6 class="card-title pricing-card-title">Coberturas</h6></li>');
        }       
       
        cardBody.append('<button type="button" class="verContrato btn btn-sm btn-block btn-primary" urlAdobeSign="'+urlAdobeSign+'" codPrograma="'+codPrograma+'" desPrograma="'+programa['des_programa']+'" tipoMostrarPDF="'+tipoMostrarPDF+'"> <i class="fa fa-file-pdf-o" aria-hidden="true" style="font-size: 0.8rem;"></i> &nbsp;'+desContrato+'</button>');
        divPrograma.html('<fielset><legend>Seleccionar Beneficiarios</legend><br> Por favor seleccione los beneficiarios a los que desea comprar el programa<div class="container"><div id="benefiProducto'+abr_tab+'_'+codProducto+'_'+codPrograma+'" class="table table-responsive"></div></div><fielset>');

        if(abr_tab == '_pro'){
            divPrograma.append(btnAddCar);
        }
        

        $('#programas'+abr_tab+'_'+codProducto).append(cardPrograma);
        $('#divProgramas'+abr_tab+'_'+codProducto).append(divPrograma);
    }
}

function pintarTablasBenefiProd(abr_tab){
    var productos = global_productos;
    var beneficiarios = global_registro_basico;
    var columnas = getColumnTable('beneficiarios_prod');    
    
    for(p=0; p<productos.length; p++){
        var producto = productos[p];
        var programas = producto['PROGRAMAS'];
        for(a=0; a<programas.length; a++){
            var programa = programas[a];
            var auxDatos = [];
            var tablaBenefi = '';
            var idTablaBenefi = 'tablaBenefiProd_'+producto['COD_PRODUCTO']+'_'+programa['cod_programa'];
            for(b in beneficiarios){
                var beneficiariox = beneficiarios[b];
                var llaveBenefi = beneficiariox['tipoDocumento']+'_'+beneficiariox['numeroDocumento'];
                var checkedBenefi = '';
                var objBenfi = {};
                
                objBenfi[llaveBenefi] = {};
                objBenfi[llaveBenefi]['tarifa'] = beneficiariox['tarifa'];
                objBenfi[llaveBenefi]['marcaAplica'] = 0;
                objBenfi[llaveBenefi]['nombre_completo'] = beneficiariox['nombre_completo'];
                objBenfi[llaveBenefi]['tipo_solicitud'] = 0;
                if(global_aux_prodbenefi[producto['COD_PRODUCTO']] != undefined){
                    if(global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']] != undefined){
                        if(global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']][llaveBenefi] != undefined){
                            var dataBenefi = global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']][llaveBenefi];
                            objBenfi[llaveBenefi]['tarifa'] = dataBenefi['tarifa'];
                            objBenfi[llaveBenefi]['marcaAplica'] = dataBenefi['marcaAplica'];
                            if(dataBenefi['marcaAplica'] == 1){
                                checkedBenefi = 'checked';
                            }
                        }else{
                            global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']][llaveBenefi] = objBenfi[llaveBenefi];
                        }
                    }else{
                        global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']] = {};
                        global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']][llaveBenefi] = objBenfi[llaveBenefi];
                    }                    
                }else{
                    global_aux_prodbenefi[producto['COD_PRODUCTO']] = {};
                    global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']] = {};
                    global_aux_prodbenefi[producto['COD_PRODUCTO']][programa['cod_programa']][llaveBenefi] = objBenfi[llaveBenefi];
                }
    
                beneficiariox['tarifa'] = objBenfi[llaveBenefi]['tarifa'];
                beneficiariox['aplica'] = '<input type="checkbox" id="ch_'+producto['COD_PRODUCTO']+'_'+programa['cod_programa']+'_'+beneficiariox['cod_persona']+'" data-producto="'+producto['COD_PRODUCTO']+'" data-programa="'+programa['cod_programa']+'" data-tipodoc="'+beneficiariox['tipoDocumento']+'" data-numdoc="'+beneficiariox['numeroDocumento']+'" '+checkedBenefi+' onChange="validBenefiProd(this);">';
                auxDatos.push(beneficiariox);
            }

            //Agregar tabla a la pestana producto
            tablaBenefi = createTable(idTablaBenefi, columnas, auxDatos);
            $('#benefiProducto'+abr_tab+'_'+producto['COD_PRODUCTO']+'_'+programa['cod_programa']).html(tablaBenefi);
            aplicarDataTable(idTablaBenefi);
        }
        
    }

}

function validBenefiProd(campo){
    var idCampo = campo.id;
    var producto = $('#'+idCampo).attr('data-producto');
    var programa = $('#'+idCampo).attr('data-programa');
    var tipoDoc = $('#'+idCampo).attr('data-tipodoc');
    var numDoc = $('#'+idCampo).attr('data-numdoc');
    var llaveBenefi = tipoDoc+'_'+numDoc;
    var chMarcado = 0;
    var idModal = 'modalValidBenefi';
    var botonesModal = [{"id":"cerrarMr","label":"Aceptar","class":"btn-primary"}];

    if($('#'+idCampo).is(':checked')){
        chMarcado = 1;
    }
    
    if(chMarcado == 0){
        if(global_aux_prodbenefi[producto] != undefined){
            if(global_aux_prodbenefi[producto][programa] != undefined){
                if(global_aux_prodbenefi[producto][programa][llaveBenefi] != undefined){
                    global_aux_prodbenefi[producto][programa][llaveBenefi]['marcaAplica'] = z;
                    global_prod_benefi[producto][programa][llaveBenefi]['marcaAplica'] = chMarcado;
                    registrarBenefiPrograma(producto, programa, tipoDoc, numDoc, chMarcado, idCampo, function(nadaTarifa){
                        calcularMiCarrito(false);
                        if(validaMarcaAplica_prodbenefi()){
                            $('.add-prodcar').addClass('disabled-add-prodcar');
                        }
                    });
                }
            }            
        }
    }else{
        aplicaBenefiValid(producto, programa, tipoDoc, numDoc, function(objAplica){
           
            var msj = '';    
            if(objAplica['disponibleVd'] != -1 || objAplica['disponibleAfilmed'] != -1){
                msj = 'El beneficiario '+ global_aux_prodbenefi[producto][programa][llaveBenefi]['nombre_completo'] +', ya se encuentra afiliado a este u otro producto.';
            }else{
                if(objAplica['disponibleUbicacion'] != -1){
                    if(objAplica['disponibleUbicacion']['aprobado'] != 'S'){
                        //msj = 'El producto seleccionado no cuenta con cobertura en la ubicaci&oacute;n ingresada';
                        msj = objAplica['disponibleUbicacion']['mensaje'];
                    }
                }
            }

            if(msj != ''){
                $('#'+idCampo).prop('checked', false);                    
                crearModal(idModal, 'Confirmaci\u00f3n', msj, botonesModal, false, '', '');
                $('#cerrarMr').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }else{
                if(global_aux_prodbenefi[producto] != undefined){
                    if(global_aux_prodbenefi[producto][programa] != undefined){
                        if(global_aux_prodbenefi[producto][programa][llaveBenefi] != undefined){
                            global_aux_prodbenefi[producto][programa][llaveBenefi]['marcaAplica'] = chMarcado;
                            registrarBenefiPrograma(producto, programa, tipoDoc, numDoc, chMarcado, idCampo, function(nadaTarifa){
                                if(nadaTarifa){
                                    $('.add-prodcar').removeClass('disabled-add-prodcar');
                                }else{ //Se quita la seleccion del programa
                                    $('#'+idCampo).prop('checked', false);
                                    global_aux_prodbenefi[producto][programa][llaveBenefi]['marcaAplica'] = 0;      
                                }                                
                            });                            
                        }
                    }                    
                }
            }
        });
    }
}

function validBenefiDisponible(keyBenefi, codProducto){
    var prodBenefi = global_aux_prodbenefi[codProducto];
    var prodContiene = -1;
    for(b in prodBenefi){
        var prod = prodBenefi[b];
        if(prod[keyBenefi]['marcaAplica'] == 1){
            prodContiene = b;
            break; 
        }
    }

    return prodContiene;
}

function traerTarifaBenefi(codProducto, codPrograma, tipoDocBenefi, numDocBenefi, calckback){
    runLoading(true);
    var idModal = 'modalTarifaBenefi';
    var botonesModal = [{"id":"cerrarMr","label":"Aceptar","class":"btn-primary"}];
    var paramsObj = {};
    paramsObj['producto'] = codProducto;
    paramsObj['programa'] = codPrograma;
    paramsObj['tipDocumento'] = tipoDocBenefi;
    paramsObj['numDocumento'] = numDocBenefi;

    $.ajax({
        url: "Gestion_compra/getInfoPersona",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            var data = resp;
            calckback(data);
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
            $('#cerrarMr').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    }); 
}

function datosBenefi(tipooc, numDoc){
    var beneficiario = {};
    var dataBenefis = global_registro_basico;

    for(d in dataBenefis){
        var benefi = dataBenefis[d];
        if(benefi['tipoDocumento'] == tipooc && benefi['numeroDocumento'] == numDoc){
            beneficiario = benefi;
            break;
        }        
    }

    return beneficiario;
}

function aplicaBenefiValid(codProducto, codPrograma, tipoDocBenefi, numDocBenefi, calbackAplica){
    runLoading(true);
    // Validar que el beneficiario no se encuentre ya afiliado al producto en diferente programa
    var llaveBenefi = tipoDocBenefi+'_'+numDocBenefi;
    var productCotiene = validBenefiDisponible(llaveBenefi, codProducto);

    if(productCotiene == -1){
        // Validar que el beneficiario no se encuentre ya afiliado al producto en diferente programa - afilmed y oravle venta directa
        // Validar la cobertura del producto, frente a la direccion del beneficiario
        var idModal = 'modalTarifaBenefi';
        var botonesModal = [{"id":"cerrarMr","label":"Aceptar","class":"btn-primary"}];
        var paramsObj = {};
        paramsObj['codProducto'] = codProducto;
        paramsObj['codPrograma'] = codPrograma;
        paramsObj['objBeneficiario'] = datosBenefi(tipoDocBenefi, numDocBenefi);
        $.ajax({
            url: "Gestion_compra/validarAplicaBenefi",  
            type: "POST",  
            dataType: "json",
            data: paramsObj,   
            success: function(resp){
                runLoading(false);
                var data = resp;
                calbackAplica(resp);           
            },
            error: function(result) {
                runLoading(false);
                crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al validar el usuario', botonesModal, false, '', '');
                $('#cerrarMr').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });
    }else{
        runLoading(false);
        var objData = {};
        objData['disponibleVd'] = productCotiene;
		objData['disponibleAfilmed'] = -1;
        objData['disponibleUbicacion'] = -1;
        calbackAplica(objData);
    }
}

function calcularMiCarrito(verMsj){
    var idModal = 'modalCar';
    var botonesModal = [{"id":"cerrarCar","label":"Aceptar","class":"btn-primary"}];
    var prodBenefi = pasar_obj_global(global_aux_prodbenefi);
    var countProd = 0;
    var countVal = 0;

    //Si verMsj es falso, tabajar con la seleccion de producto actual(global_prod_benefi) y no la temporal(global_aux_prodbenefi)
    if(!verMsj){
        prodBenefi = pasar_obj_global(global_prod_benefi);
    }
    
    for(p in prodBenefi){
        var producto = prodBenefi[p];
        var programas = Object.keys(producto);
        var cantidadBenefi = 0;
        for(a=0; a<programas.length; a++){
            var programa = producto[programas[a]];
            for(b in programa){
                var beneficiario = programa[b];
                if(beneficiario['marcaAplica'] == 1){
                    countVal += typeof beneficiario['tarifa'] != 'number' ? parseInt(beneficiario['tarifa']) : beneficiario['tarifa'];
                    cantidadBenefi++;
                }
            }               
        }
        
        if(cantidadBenefi > 0){
            countProd++;
        }        
    }

    $('#lbCantidadProd').html('('+countProd+') Productos');
    $('#lbValProd').html('Total $ '+formatMiles(countVal));
    
    if(verMsj){
        crearModal(idModal, 'Confirmaci\u00f3n', '¡Se adicionaron correctamente a mi carrito!', botonesModal, false, '', '');
        $('#cerrarCar').click(function(){
            $('#'+idModal).modal('hide');
        });

        //Actualizar variable global, con los productos seleccionados por beneficiario
        global_prod_benefi = prodBenefi;
        //Inactivar boton para agregar(calcular) al carrito 
        $('.add-prodcar').addClass('disabled-add-prodcar');
    }

    
    
    actualizarMiCarrito(function(data){ console.log('Se actualizo correctamente mi carrito..') });

    return countVal;
}

function detalleMiCarrito(){
    var idModal = 'modalTarifaBenefi';
    var botonesModal = [{"id":"cerrarMr","label":"Aceptar","class":"btn-primary"}];
    var prodBenefi = global_prod_benefi;
    var benefis = global_registro_basico;
    var productos = global_productos;
    var divTable = $('<div class="table table-responsive"></div>');
    var vtabla = $('<table width="100%" class="table table-striped table-bordered table-hover detalle-micar-vd" id="tablaDetallaCar" cellspacing="0"></tale>');
    var vthead = $('<thead></thead>');
    var vtbody = $('<tbody></tbody>');
    var vtrH1 = $('<tr></tr>');
    var vtrH2 = $('<tr></tr>');
    var vtrH3 = $('<tr></tr>');
    var vtd = '';
    var contadorColumn = 0;
    var valorTotalTarifa = 0;
    var divTotalTarifa = $('<div class="total-tarifa"></div>');

    //Crear thead - INICIO
    for(p=0; p<productos.length; p++){
        var producto = productos[p];
        var programas = producto['PROGRAMAS'];
        var numProgramas = programas.length;
        contadorColumn ++;
        vtd = '';
        
        for(i=0; i<numProgramas; i++){
            var programa = programas[i];
            if(i != 0){
                contadorColumn ++;
            }
            vtd += '<th>'+programa['des_programa']+'</th>';
        }
        vtrH3.append(vtd);

        if(numProgramas > 0){
            vtd = '<th colspan="'+numProgramas+'" rowspan="1">'+producto['DES_PRODUCTO']+'</th>';
        }else{
            vtd = '<th colspan="1" rowspan="2">'+producto['DES_PRODUCTO']+'</th>';
        }
        vtrH2.append(vtd);
    }
      
    vtd = '<th rowspan="3"> Beneficiarios </th>';
    vtd += '<th rowspan="1" colspan="'+contadorColumn+'"> Productos </th>';
    vtd += '<th rowspan="3"> Tarifas </th>';
    vtrH1.append(vtd);

    vtabla.append(vthead);
    vtabla.append(vtbody);
    vthead.append(vtrH1);
    vthead.append(vtrH2);
    vthead.append(vtrH3);
    //Crear thead - FIN

    var auxArrProd = [];
    var auxCbzArr = [{"column":"beneficiario", "label":""}];
    var counBenefi = 0;

    for(x in benefis){
        var benef = benefis[x];
        var auxObjProd = {};
        var countAuxKey = 0;
        auxObjProd['beneficiario'] = benef['nombre_completo'];
        auxObjProd['tarifa'] = 0;//benef['tarifa'];
        
        vtd = '';

        for(y=0; y<productos.length; y++){
            var product = productos[y];
            var programas = product['PROGRAMAS'];            
            for(z=0; z<programas.length; z++){
                var programa = programas[z];
                var keyBenefi = benef['tipoDocumento']+'_'+benef['numeroDocumento'];
                var prBenefi = prodBenefi[product['COD_PRODUCTO']][programa['cod_programa']][keyBenefi];
                var auxKeyColumn = 'pr'+countAuxKey;
                var keyQuit = product['COD_PRODUCTO']+'_'+programa['cod_programa']+'_'+benef['cod_persona'];
                var datoTarifa = prBenefi['marcaAplica'] == 1 ? prBenefi['tarifa'] : 0;
                vtd += '';
                countAuxKey++;
                auxObjProd[auxKeyColumn] = prBenefi['marcaAplica'] == 1 ? '<div id="div_'+keyQuit+'" style="text-align:center;"> <img src="'+global_base_url+'asset/public/images/aplica.png"> <img src="'+global_base_url+'asset/public/images/quitar.png" id="quit_'+keyQuit+'" onClick="quitarBeneficiarioPrograma(this);" style="cursor:pointer;" data-valor="'+datoTarifa+'">  </div>' : '';
                auxObjProd['tarifa'] += datoTarifa;
                valorTotalTarifa += datoTarifa;
                if(counBenefi == 0){
                    auxCbzArr.push({"column": auxKeyColumn, "label":""});
                }
                
            }
        }
        
        auxArrProd.push(auxObjProd);
        counBenefi++;
    }
    
    auxCbzArr.push({"column": "tarifa", "label":"", "format":"miles"});    
    var auxTabla = createTable('tablaBenefiProd_aux', auxCbzArr, auxArrProd);    
    vtbody.html(auxTabla.find('tbody').html());
    divTotalTarifa.html('Total: <span class="class-pesos">'+ formatMiles(valorTotalTarifa)+'</span><span class="iva-incluido"> IVA incluido </span>');
    divTable.append(vtabla);
    divTable.append(divTotalTarifa); 

    crearModal(idModal, 'Productos seleccionados', divTable, botonesModal, false, 'modal-xl', '');
    $('#cerrarMr').click(function(){
        $('#'+idModal).modal('hide');
    });

    aplicarDataTable('tablaDetallaCar');    
}

function llenarDatosTab(abr_tab){

    var abr_comple = '_ctr';
    $('#tipoDocumento'+abr_tab).val($('#tipoDocumento'+abr_comple).val());
    $('#numeroDocumento'+abr_tab).val($('#numeroDocumento'+abr_comple).val());
    $('#nombre1'+abr_tab).val($('#nombre1'+abr_comple).val());
    $('#nombre2'+abr_tab).val($('#nombre2'+abr_comple).val());
    $('#apellido1'+abr_tab).val($('#apellido1'+abr_comple).val());
    $('#apellido2'+abr_tab).val($('#apellido2'+abr_comple).val());
    $('#fechaNacimiento'+abr_tab).val($('#fechaNacimiento'+abr_comple).val());
    $('#tipoSexo'+abr_tab).val($('#tipoSexo'+abr_comple).val());
    $('#telefono'+abr_tab).val($('#telefono'+abr_comple).val());
    $('#celular'+abr_tab).val($('#celular'+abr_comple).val());
    $('#correo'+abr_tab).val($('#correo'+abr_comple).val());
    $('#pais'+abr_tab).val($('#pais'+abr_comple).val());
    $('#tipoVia'+abr_tab).val($('#tipoVia'+abr_comple).val());
    $('#numeroTipoVia'+abr_tab).val($('#numeroTipoVia'+abr_comple).val());
    $('#numeroPlaca'+abr_tab).val($('#numeroPlaca'+abr_comple).val());
    $('#complemento'+abr_tab).val($('#complemento'+abr_comple).val());
    $('#estado_civil'+abr_tab).val($('#estado_civil'+abr_comple).val());
    $('#eps'+abr_tab).val($('#eps'+abr_comple).val());
    $('#parentesco'+abr_tab).val($('#parentesco'+abr_comple).val());
    $('#municipio'+abr_tab).find('option[value="'+$('#municipio'+abr_comple).val()+'"]').prop('selected',true).attr('selected','selected');
  
    global_producto_seleccionado = [];
    var arrayProgramas           = [];
    var auxDatos                 = [];
    var arrayProgramasAux        = [];
    var arrayProductosAux        = {};
    var arrayProductoAuxiliar    = {};
    var contadorProgramaAux      = 0;
    var contadorPrograma         = 0;
    var contadorproducto         = 0;
    var contadorProductoAux      = 0;
    var totalCotizado            = 0;
    var productoAux              = 0;
    var mostrarEncuesta          = 0;
    var productos                = global_productos;
    var codigoAfiliacion         = global_datos_contratante['COD_AFILIACION'];
    var productoAnterior         = '';
    var productoPrevio           = '';
    var columnas                 = '';
    var tabla                    = '';
    var acolums                  = '';
    var botonEncuesta            = '';
    var botonAdjuntos            = '';
    var llaveBenefi              = '';
    var llaveProducto            = '';
    var llavePrograma            = '';
    var tarifa                   = '';
    var nombreProducto           = '';
    var nombreIcon               = '';
    var producto                 = '';
    var programas                = '';
    var programa                 = '';
      
    if (abr_tab == '_cot'){
        columnas =  getColumnTable('beneficiarios_cotiza');
        acolums  = [{"width": "90px"},null,null,null,null,null,{"width": "246px"}];
    }

    //Se recorren los beneficiarios
    for(b in global_registro_basico){

        botonAdjuntos += '<a style="margin-left: 30px;" title="Adjuntar archivos" id="adjuntar'+b+'" codPersona="'+global_registro_basico[b].cod_persona+'" nombreBeneficiario="'+global_registro_basico[b].nombre_completo+'" class="adjuntarArchivo btn-floating btn-lg blue lighten-1 mt-0 float-left"><i class="fa fa-paperclip" aria-hidden="true"></i></a>'; 
        
        llaveBenefi   = global_registro_basico[b].tipoDocumento+'_'+global_registro_basico[b].numeroDocumento;
        global_registro_basico[b].telefono = global_registro_basico[b].telefono === null ? '' : global_registro_basico[b].telefono;
        global_registro_basico[b].tipoNroId = global_registro_basico[b].tipoDocumento_abr+'-'+global_registro_basico[b].numeroDocumento;

        //Se recorren los productos por beneficiarios
        for(p=0; p<productos.length; p++){

            producto      = productos[p];
            programas     = producto['PROGRAMAS'];
            llaveProducto = producto['COD_PRODUCTO'];
                     
            //Se recorren los programas por producto y beneficiarios
            for(a=0; a<programas.length; a++){

                programa      = programas[a];
                llavePrograma = programa['cod_programa'];
              
                if (global_prod_benefi[llaveProducto][llavePrograma][llaveBenefi].marcaAplica == 1){

                    tarifa          = global_prod_benefi[llaveProducto][llavePrograma][llaveBenefi]['tarifa'];
                   
                    if (producto['COD_PRODUCTO'] == 1){
                        nombreIcon = 'fa-heartbeat';
                    } else if (producto['COD_PRODUCTO'] == 2){
                        nombreIcon = 'fa-stethoscope';
                    } else {
                        nombreIcon = 'fa-ambulance';
                    }

                    nombreProducto  += '<div class="tarjeta tarjeta-stats">';
                    nombreProducto  += '<div class="tarjeta-header tarjeta-header-info tarjeta-header-icon">';
                    nombreProducto  += '<div class="tarjeta-icon" style="font-size: 20px;">';
                    nombreProducto  += '<i class="fa '+nombreIcon+'"></i>';
                    nombreProducto  += '</div>';
                    nombreProducto  += '<strong class="tarjeta-category" style="font-size: 12px;"><b>'+producto['DES_PRODUCTO']+'</b></strong>';
                    nombreProducto  += '<p class="tarjeta-title">'+ programa['des_programa']+': $'+ formatMiles(tarifa)+'</p>';
                    nombreProducto  += '</div>';
                    nombreProducto  += '<div class="tarjeta-footer">';
                    nombreProducto  += '<div class="stats verCoberturaPrograma" style="cursor:pointer;" codPrograma="'+programa['cod_programa']+'" desPrograma="'+programa['des_programa']+'">';
                    nombreProducto  += '<i class="material-icons">hdr_strong</i> Coberturas';
                    nombreProducto  += '</div>';
                    nombreProducto  += '</div>';
                    nombreProducto  += '</div>';
                    totalCotizado  += tarifa;
                    productoAux     = 1;            
                   
                    //Si el array ya se encuentra definido y si tiene datos
                    if (typeof arrayProgramasAux !== 'undefined' && arrayProgramasAux.length > 0) {

                        //Se valida si el programa ya existe en el array Auxiliar
                        if(!arrayProgramasAux.includes(llavePrograma)){

                            //Se agrega el programa actual al array de programas Auxiliar
                            arrayProgramasAux.push(llavePrograma);
                           
                            //Si el producto anterior y el actual son iguales
                            if (productoAnterior == llaveProducto){

                                //Se incrementa el contador
                                contadorPrograma++;
                                
                                //Se guarda el contador actual y el producto actual
                                arrayProductosAux[llaveProducto] = contadorPrograma;
                                productoAnterior = llaveProducto;
                               
                            //Si el producto anterior y el actual son diferentes    
                            } else {
                                
                                //Si el producto actual NO existe en el array Auxiliar
                                if (arrayProductosAux[llaveProducto] == undefined){
                                    
                                    //Se inicializa el contador de nuevo
                                    contadorPrograma = 0;

                                    //Se guarda el contador actual y el producto actual
                                    arrayProductosAux[llaveProducto] = contadorPrograma;
                                    productoAnterior = llaveProducto;
                                
                                    //Se inicializa el array de programas nuevamente
                                    arrayProgramas[llaveProducto] = [];
                                    
                                //Si el producto actual SI existe        
                                } else {

                                    //Se haya el valor del contador por producto
                                    contadorProgramaAux = arrayProductosAux[llaveProducto];   
                                    contadorPrograma = contadorProgramaAux + 1;

                                    //Se guarda el contador actual y el producto actual
                                    arrayProductosAux[llaveProducto] = contadorPrograma;
                                    productoAnterior = llaveProducto;
                                  
                                }

                            }
                            
                            //console.log('Primera llave ', llaveProducto, 'Segunda llave ',contadorPrograma);
                            //Se agregan los datos del programa actual al array de programas
                            arrayProgramas[llaveProducto][contadorPrograma] = {};
                            arrayProgramas[llaveProducto][contadorPrograma]['cod_programa']   = programa['cod_programa'];
                            arrayProgramas[llaveProducto][contadorPrograma]['des_programa']   = programa['des_programa'];
                            arrayProgramas[llaveProducto][contadorPrograma]['link_contrato']  = programa['link_contrato'];
                            arrayProgramas[llaveProducto][contadorPrograma]['link_url_firma'] = programa['link_url_firma'];
                            arrayProgramas[llaveProducto][contadorPrograma]['tipo_venta']     = global_prod_benefi[llaveProducto][llavePrograma][llaveBenefi]['tipo_solicitud'];
                            arrayProgramas[llaveProducto][contadorPrograma]['descripcion']    = programa['descripcion'];

                        }
                    //Si es la primera vez que entra en la iteraci&oacute;n    
                    } else {

                        //Se agrega el programa actual al array de programas Auxiliar
                        arrayProgramasAux.push(llavePrograma);
                       
                        //Se guarda el contador actual y el producto actual
                        arrayProductosAux[llaveProducto] = contadorPrograma;
                        productoAnterior = llaveProducto;
                        //console.log('Primera llave ', llaveProducto, 'Segunda llave ',contadorPrograma);
                        //Se agregan los datos del programa actual al array de programas
                        arrayProgramas[llaveProducto] = [];
                        arrayProgramas[llaveProducto][contadorPrograma] = {};
                        arrayProgramas[llaveProducto][contadorPrograma]['cod_programa']   = programa['cod_programa'];
                        arrayProgramas[llaveProducto][contadorPrograma]['des_programa']   = programa['des_programa'];
                        arrayProgramas[llaveProducto][contadorPrograma]['link_contrato']  = programa['link_contrato'];
                        arrayProgramas[llaveProducto][contadorPrograma]['link_url_firma'] = programa['link_url_firma'];
                        arrayProgramas[llaveProducto][contadorPrograma]['tipo_venta']     = global_prod_benefi[llaveProducto][llavePrograma][llaveBenefi]['tipo_solicitud'];
                        arrayProgramas[llaveProducto][contadorPrograma]['descripcion']    = programa['descripcion'];

                    }

                }
                
                global_registro_basico[b].nombreProducto = nombreProducto;
               

                if (productoAux == 1){

                    //Si es diferente de la primera vez
                    if (productoPrevio != ''){

                        //Si el producto actual NO existe en el array Auxiliar
                        if (arrayProductoAuxiliar[llaveProducto] == undefined){

                            contadorProductoAux++;
                            contadorproducto = contadorProductoAux;
                                                
                        //Si el producto actual SI existe        
                        } else {

                            contadorproducto = arrayProductoAuxiliar[llaveProducto];
                                                      
                        }
                    }

                    //Se agregan los productos al array de productos seleccionados
                    global_producto_seleccionado[contadorproducto] = {};
                    global_producto_seleccionado[contadorproducto]['COD_PRODUCTO'] = producto['COD_PRODUCTO'];
                    global_producto_seleccionado[contadorproducto]['DES_PRODUCTO'] = producto['DES_PRODUCTO'];
                    global_producto_seleccionado[contadorproducto]['DESCRIPCION']  = producto['DESCRIPCION'];
                    global_producto_seleccionado[contadorproducto]['PROGRAMAS']    = arrayProgramas[producto['COD_PRODUCTO']];

                    arrayProductoAuxiliar[llaveProducto] = contadorproducto;
                    productoPrevio = producto['COD_PRODUCTO'];

                    //Si el producto es igual a MI
                    if (llaveProducto == 1){
                        mostrarEncuesta = 1;
                    }

                } 

                productoAux = 0;
               
            }
        }

        if (mostrarEncuesta == 1){
            botonEncuesta   += '<a style="margin-left: 60px;" title="Encuesta Salud" id="encuesta'+b+'" nombreBeneficiario="'+global_registro_basico[b].nombre_completo+'" codigoPersona="'+global_registro_basico[b].cod_persona+'" codigoAfiliacion="'+codigoAfiliacion+'" codigoSexo="'+global_registro_basico[b].tipoSexo+'" edad="'+global_registro_basico[b].edad+'" class="encuestaSalud btn-floating btn-lg blue lighten-1 mt-0 float-left"><i class="fa fa-check-square-o" aria-hidden="true"></i></a>';
            global_registro_basico[b].salud =  botonEncuesta;    
        }
        
        global_registro_basico[b].soporte_eps = botonAdjuntos;          

        tarifaProducto   = '';
        nombreProducto   = '';
        caberaInputFile  = '';
        cuerpoInputFile  = '';
        footerInputFile  = '';
        botonEncuesta    = '';
        botonAdjuntos    = '';
        contadorproducto = 0;
        mostrarEncuesta  = 0;
        
        var beneficiario = global_registro_basico[b];
        auxDatos.push(beneficiario);
        $('.totalCotiza').html('$ '+ formatMiles(totalCotizado));
    }
    
    //Se llama la funci&oacute;n para pintar los productos
    pintarTabsProductos(abr_tab);

    if (abr_tab == '_con'){
        pintarBeneficiariosCotizacion(abr_tab);
    } else {
        tabla = createTable('tablaBenefi'+abr_tab, columnas, auxDatos);
        $('#divTablaBenefi'+abr_tab).html(tabla);
        aplicarDataTable('tablaBenefi'+abr_tab,acolums);
    }
}

function saveCotizacion(){
   
    var codigoAfiliacion      = global_datos_contratante['COD_AFILIACION'];//global_registro_basico[0]['cod_afiliacion'];
    var validaOK              = true;
    var validaEncuestaSarlaft = false;
    var validaEncuestaSalud   = false;
    var validaAdjuntos        = false;
    var mensaje               = '';
    var posicion              = '';
    var idEncuesta            = '';
    var idDocumento           = '';
    var resultEncuesta        = '';
  
    $(".adjuntarArchivo").each(function(){  

        idDocumento    = $(this).attr("id");
        validaAdjuntos = validaDocumentos($(this).attr('codPersona'),codigoAfiliacion);
        
        if (!validaAdjuntos){

            mensaje  = 'Debe adjuntar los soportes de EPS requeridos, para el beneficiario <b>' +$(this).attr("nombreBeneficiario") + '</b><br>';
            posicion = $('#'+idDocumento).offset();
            validaOK = false;
            return false;
        }
        
    });

 
    //Se valida que la encuesta Sarlaft esta diligenciada
    validaEncuestaSarlaft = validaEncuesta(global_datos_contratante['COD_PERSONA'],global_datos_contratante['COD_AFILIACION'],1);
   
    if (!validaEncuestaSarlaft && validaOK){

        mensaje  = 'Debe diligenciar la encuesta <b>SARLAF</b>';
        posicion = $('#btn_encuesta').offset();
        validaOK = false;
    }

   
    if (validaOK){
        
        //Se valida que la encuesta de salud este diligenciada
        $(".encuestaSalud").each(function(){  
           
            idEncuesta          = $(this).attr("id");
            validaEncuestaSalud = validaEncuesta($(this).attr('codigoPersona'),$(this).attr('codigoAfiliacion'),2);
           
            if (!validaEncuestaSalud){

                mensaje  = 'Debe diligenciar la encuesta de salud, para el beneficiario <b>' + $(this).attr("nombreBeneficiario") + '</b><br>';
                posicion = $('#'+idEncuesta).offset();
                return false;
            }            
        });

         // se valida los resultados de la encuesta de salud por beneficiario 
         resultEncuesta = validaEncuestaSaludDatos(global_datos_contratante["COD_AFILIACION"]);

         if (resultEncuesta != '') {          
            validaOK = false;
            var idModal = 'modalTarifaBenefi';
            var botonesModal = [{"id":"cerrarMr","label":"Cerrar","class":"btn-primary"}];

            crearModal(idModal, 'Advertencia',resultEncuesta, botonesModal, false, 'modal-lg', '',true);
            $('#cerrarMr').click(function(){
                $('#'+idModal).modal('toggle');                
            });
            return false;            
         }
    }
    
    if (mensaje != ''){
        var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
        $('body').append(divRequired);
        alertify.notify(mensaje, 'error', 30, function(){ $('#div_required_nexos').remove(); });
    } else {
        if (validaOK){
            $('#tabs_compra').find('a[href="#paso_4"]').trigger('click');
        }
    }

}

function validaEncuestaSaludDatos(codAfiliacion){    
    
    var resultado = "";
    runLoading(true);

    $.ajax({
        url: "Encuesta_sarlaf/validaEncuestaSaludDatos",  
        type: "POST",  
        dataType: "json",
        data: {codigo_afiliacion:codAfiliacion}, 
        async: false, // este parametro hace que el ajax deje ser asincronico,   
        success: function(resp){
            runLoading(false);
            resultado = resp; 
        },
        error: function(resp) {
            runLoading(false);
            resultado = "Se presentaron problemas al consultar el registro";
        }
    });

    return resultado;

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

function validaDocumentos(codPersona,codAfiliacion){

    var parametrosObj    = {};
    var valida           = false;
    parametrosObj['codPersona']     = codPersona;
    parametrosObj['codAfiliacion']  = codAfiliacion;

    runLoading(true);

    $.ajax({
        url: "Gc_paso_3/getValidaAdjuntos",  
        type: "POST",  
        dataType: "json",
        data: parametrosObj,   
        async: false, 
        success: function(resp){
            runLoading(false);
            var cantidadDocs = !isNaN(parseInt(resp.validaDocumento)) ? parseInt(resp.validaDocumento) : 0;
            if (cantidadDocs > 0){
                valida = true;
            } else {
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

function guardarDatosBasicos(codContratante, objBeneficiarios, codEstado, calbackRegistro){
    runLoading(true);
    var idModal = 'modalTarifaBenefi';
    var botonesModal = [{"id":"cerrarMr","label":"Aceptar","class":"btn-primary"}];
    var paramsObj = {};
    paramsObj['codContratante'] = codContratante;
    paramsObj['objBeneficiarios'] = pasar_obj_global(objBeneficiarios);
    paramsObj['codEstado'] = codEstado;
    paramsObj['incluyente'] = 1;

    
    if(paramsObj['objBeneficiarios'][0] == undefined){
        paramsObj['objBeneficiarios'][0] = getDataCamps('ctr', 0, false);
        paramsObj['incluyente'] = 0;
    }

    $.ajax({
        url: "Gestion_compra/guardarDatosBasicos",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            var data = resp;
            //console.log("data ",data);
            if(data['codAfiliacion'] != undefined){
                if(data['codAfiliacion'] != '-1'){
                    global_datos_contratante['COD_AFILIACION'] = data['codAfiliacion'];
                }                
            }
            calbackRegistro(resp);           
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
            $('#cerrarMr').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
}

function actualizaGlobalRegistro(arrBenefi){
    var objBenefi = {};
    var complent = 'bnf';
    $('#div_tieneMascota_ctr').addClass('hideComponent');

    if(arrBenefi.length > 0){
        $('INPUT[name="inBeneficiario"][value="0"] ').prop('checked',true);
    }    

    for(x=0; x<arrBenefi.length; x++){
        var benefi = arrBenefi[x];
        var auxKey = x;
        
        if(benefi['cod_persona'] == global_datos_contratante['COD_PERSONA']){
            auxKey = 0;
            benefi['accion'] = '';
            $('INPUT[name="inBeneficiario"][value="1"] ').prop('checked',true);
            $('#div_tieneMascota_ctr').removeClass('hideComponent');
            //$('INPUT[name="inBeneficiario"]').trigger('change');
        }else{
            auxKey = x + 1;
            benefi['accion'] = '<img src="'+global_base_url+'asset/public/images/delete.png" class="quit-benefi" id="quitBenefi_'+complent+'" data-benefi="'+complent+'" onclick="quitarBeneficiarioConfirm('+auxKey+');">'+
                                '<img src="'+global_base_url+'asset/public/images/edit.png" class="quit-benefi" id="editBenefi_'+complent+'" data-benefi="'+complent+'" onclick="editarBeneficiario('+auxKey+');">';
        }
        
        benefi['aplica'] = '';
        benefi['tarifa'] = typeof benefi['tarifa'] != 'number' ? parseInt(benefi['tarifa']) : benefi['tarifa'];
        objBenefi[auxKey] = benefi;
    }

    return objBenefi;
}


function traerHabeasData(calback){
    runLoading(true);
    var paramsObj = {};
    //paramsObj['codContratante'] = codContratante;
    
    $.ajax({
        url: "Gestion_compra/getHabeasData",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            calback(resp);           
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
            $('#cerrarMr').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
}

function eventHandler(e){

    //console.log("origen",e.origin);
    
    if(e.origin == urlOrigenWidget){
          
        //Se capturan los eventos
        var content = JSON.parse(e.data);

        //console.log("content",content);

        //Si el evento es cuando se firma el documento
        if (content.type == 'ESIGN'){

            //console.log("LLega al ajax ",content);
            var msgInicioServicio = $('#txtMsgInicioServicio').val();
            var idModal           = 'verMsgContrato';
            var botonesModal      = [{"id":"cerrarMsgContrato","label":"Aceptar","class":"btn-primary"}];
            var paramsObj         = {};
            var mensajeRespuesta  = '';

            paramsObj['codWidget']         = $('#txtIdWidget').val();   
            paramsObj['codPrograma']       = $('#txtCodProgramaFirma').val();   
            paramsObj['codPersona']        = global_datos_contratante['COD_PERSONA'];
            paramsObj['codAfiliacion']     = global_datos_contratante['COD_AFILIACION'];
            paramsObj['nroIdenfificacion'] = global_datos_contratante['NUMERO_IDENTIFICACION'];
           
            $.ajax({
                url: pointToUrl()+"Gc_paso_5/guardarContratoAdobeSign",  
                type: "POST",  
                dataType: "json",
                data: paramsObj,   
                success: function(resp){
                    runLoading(false);
                   
                    if (resp.ret){
                        mensajeRespuesta =  msgInicioServicio; 
                    } else {
                        mensajeRespuesta = resp.errors;
                    }

                    crearModal(idModal, 'Confirmaci\u00f3n', '<p class="text-justify">'+mensajeRespuesta+'</p>', botonesModal, false, '', '');
                    $('#cerrarMsgContrato').click(function(){
                        $('#'+idModal).modal('hide');
                    });
                    
                },
                error: function(result) {
                    runLoading(false);
                    crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al guardar el registro', botonesModal, false, '', '');
                    $('#cerrarMsgContrato').click(function(){
                        $('#'+idModal).modal('hide');
                    });
                }
            });
          
        }
             
    }
}

function pintarBeneficiariosCotizacion(abr_tab){
    var productos            = global_producto_seleccionado;
    var beneficiarios        = global_registro_basico;
    var columnas             = getColumnTable('beneficiarios_contrato');
    var arrayBeneficiarioAux = [];
    var llaveBenefi          = '';
    var llaveProducto        = '';
    var llavePrograma        = '';
    var idTablaBenefi        = '';
    var tablaBeneficiario    = '';         
    
    //Se recorren los productos
    for(p=0; p<productos.length; p++){

        var producto  = productos[p];
        var programas = producto['PROGRAMAS'];
        llaveProducto = producto['COD_PRODUCTO']; 

        //Se recorren los programas
        for(a=0; a<programas.length; a++){

            var programa  = programas[a];  
            llavePrograma = programa['cod_programa'];
            idTablaBenefi = 'tablaBenefiCon_'+llaveProducto+'_'+llavePrograma;
               
            //Se recorren los beneficiarios
            for(b in beneficiarios){
                
                llaveBenefi   = beneficiarios[b].tipoDocumento+'_'+beneficiarios[b].numeroDocumento;               
            
                if (global_prod_benefi[llaveProducto][llavePrograma][llaveBenefi]["marcaAplica"] == 1) {
                    beneficiarios[b].tarifaProducto = '$ '+ formatMiles(global_prod_benefi[llaveProducto][llavePrograma][llaveBenefi]['tarifa']);
                    arrayBeneficiarioAux.push(beneficiarios[b]);                              
                }               
                    
            }

            //Se valida si existen los beneficiarios por programas
            if (typeof arrayBeneficiarioAux !== 'undefined' && arrayBeneficiarioAux.length > 0) {
           
                //Agregar tabla a la pestaña contrato
                tablaBeneficiario = createTable(idTablaBenefi, columnas, arrayBeneficiarioAux);
                $('#benefiProducto'+abr_tab+'_'+llaveProducto+'_'+llavePrograma).html(tablaBeneficiario);
                aplicarDataTable(idTablaBenefi);
                arrayBeneficiarioAux = [];
            }
        }        
    }

}

function tabProductos(evt, nameTab) {
    // Declare all variables
    var i, tabcontent, tablinks;
  
    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
  
    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(nameTab).style.display = "block";
}

function cargarMunicipio(codPais, idMunicipio){
    runLoading(true);
    var idModal = 'modalCargaMunicipio';
    var botonesModal = [{"id":"cerrarMn","label":"Cerrar","class":"btn-primary"}];
    var paramsObj = {};
    paramsObj['codPais'] = codPais;
    
    $.ajax({
        url: pointToUrl()+"Gestion_compra/getOpMunicipio",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            $('#'+idMunicipio).html(resp['opMunicipio']);
            execute_event_state('cargarMunicipio', 1, true);
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
            $('#cerrarMn').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    });
}

function registrarBenefiPrograma(codProducto, codPrograma, tipoDocBenefi, numDocBenefi, chMarca, idCampoCh, callback){
    runLoading(true);
    var idModal = 'modalBenefiProgram';
    var botonesModal = [{"id":"cerrarBp","label":"Cerrar","class":"btn-primary"}];
    var llaveBenefi = tipoDocBenefi+'_'+numDocBenefi;
    var dataBenefi = datosBenefi(tipoDocBenefi, numDocBenefi);
    var paramsObj = {};
    paramsObj['producto'] = codProducto;
    paramsObj['programa'] = codPrograma;
    paramsObj['beneficiario'] = dataBenefi['cod_persona'];
    paramsObj['estado'] = chMarca == 1 ? 3 : 2;
    paramsObj['afiliacion'] = global_datos_contratante['COD_AFILIACION'];
    $.ajax({
        url: "Gestion_compra/setBenefiPrograma",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            var data = resp;
            var tarifaAuxVal = chMarca == 1 ? parseInt(data['valorTarifa']) : 0;
            var replicaTarifa = chMarca == 1 ? parseInt(data['replicaTarifa']) : 0;            
            var noTarifa = true;
            var tarifaAux = tarifaAuxVal != -1 ? tarifaAuxVal : 0;

            if(replicaTarifa > 0){
                $('#'+idCampoCh).parent().parent().parent().find('input[type=checkbox]:checked').each(function(index, elemento){
                    var idElemt = elemento.id;
                    var productoElement = $('#'+idElemt).attr('data-producto');
                    var programaElement = $('#'+idElemt).attr('data-programa');
                    var tipodocElement = $('#'+idElemt).attr('data-tipodoc');
                    var numdocElement = $('#'+idElemt).attr('data-numdoc');
                    var llaveElement = tipodocElement+'_'+numdocElement;

                    //Actualizar propiedad tarifa            
                    global_aux_prodbenefi[productoElement][programaElement][llaveElement]['tarifa'] = tarifaAux;
                    //Actualizar columna tarifa
                    $('#'+idElemt).parent().parent().find('.class-pesos').html(formatMiles(tarifaAux));

                });
            }else{
                //Actualizar propiedad tarifa            
                global_aux_prodbenefi[codProducto][codPrograma][llaveBenefi]['tarifa'] = tarifaAux;
                //Actualizar columna tarifa
                $('#'+idCampoCh).parent().parent().find('.class-pesos').html(formatMiles(tarifaAux));
            }

            //Actualizar tipo solicitud (inclusion/venta nueva)           
            global_aux_prodbenefi[codProducto][codPrograma][llaveBenefi]['tipo_solicitud'] = parseInt(data['tipoSolicitud']);

            if(chMarca == 1 && tarifaAuxVal == -1){
                noTarifa = false;
                //Dialog para informar que hace falta paraetrizar tarifas que cumplan con la condicion
                crearModal(idModal, 'Advertencia', global_msj_noAplicaTarifa, botonesModal, false, '', '');
                $('#cerrarBp').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }

            callback(noTarifa);
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al guardar el registro', botonesModal, false, '', '');
            $('#cerrarBp').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    }); 
}

function registrarFactura(calback){
    runLoading(true);
    var idModal = 'modalFt';
    var botonesModal = [{"id":"cerrarFt","label":"Aceptar","class":"btn-primary"}];
    var paramsObj = {};
    paramsObj['afiliacion'] = global_datos_contratante['COD_AFILIACION'];
    $.ajax({
        url: "Gestion_compra/setFactura",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            var data = resp;
            calback(data);
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al guardar el registro', botonesModal, false, '', '');
            $('#cerrarFt').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    }); 
}


function validaBenefiCompra(){
    var idModal = 'validaCompraBenf';
    var botonesModal = [{"id":"cerrarCB","label":"Aceptar","class":"btn-primary"}];
    var beneficiarios = global_registro_basico;
    var benefiFaltante =  [];
    var valido = true;
    var nombresBenefis = '';

    for(b in  beneficiarios){
        var benefi = beneficiarios[b];
        var aplicaCompra = false;
        for(p in global_prod_benefi){
            var producto = global_prod_benefi[p];
            for(x in producto){
                var programa = producto[x];
                var llaveBenefi = benefi['tipoDocumento']+'_'+benefi['numeroDocumento'];
                if(programa[llaveBenefi]['marcaAplica'] == 1){
                    aplicaCompra = true;
                }

                if(aplicaCompra){
                    break;
                }
            }
            if(aplicaCompra){
                break;
            }
        }
        
        if(!aplicaCompra){
            benefiFaltante.push(benefi['nombre_completo']);
        }
    }

    if(benefiFaltante.length > 0){
        valido = false;
        nombresBenefis = benefiFaltante.join('<br>-');        
        crearModal(idModal, 'Confirmaci\u00f3n', 'Por favor garantizar que los siguientes usuarios pertenezcan al menos a un programa.<br><br>-'+nombresBenefis, botonesModal, false, '', '');
        $('#cerrarCB').click(function() {	                  	   
            $('#'+idModal).modal('hide');
        });
    }
    
    return valido;
}

function traerBenefisPrograms(calback){
    runLoading(true);
    var idModal = 'modalBnp';
    var botonesModal = [{"id":"cerrarBnp","label":"Aceptar","class":"btn-primary"}];
    var paramsObj = {};
    
    $.ajax({
        url: pointToUrl()+"Gestion_compra/getBenefisProgramasPend",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            var data = resp;
            calback(data);
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
            $('#cerrarBnp').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    }); 
}

function cargarBenefisPrograms(benefisProgramas){
    for(y=0; y<benefisProgramas.length; y++){
        var benPro = benefisProgramas[y];
        var codProducto = benPro['COD_PRODUCTO'];
        var codPrograma = benPro['COD_PROGRAMA'];
        var tipoDoc = benPro['COD_TIPO_IDENTIFICACION'];
        var numeroDoc = benPro['NUMERO_IDENTIFICACION'];
        var codPersona = benPro['COD_BENEFICIARIO'];
        var llaveBenefi = tipoDoc+'_'+numeroDoc;
        var idCheckbox = 'ch_'+codProducto+'_'+codPrograma+'_'+codPersona;
        if(global_aux_prodbenefi[codProducto] != undefined){
            if(global_aux_prodbenefi[codProducto][codPrograma] != undefined){
                if(global_aux_prodbenefi[codProducto][codPrograma][llaveBenefi] != undefined){
                    global_aux_prodbenefi[codProducto][codPrograma][llaveBenefi]['marcaAplica'] = 1;
                    global_aux_prodbenefi[codProducto][codPrograma][llaveBenefi]['tarifa'] = parseInt(benPro['VAL_TARIFA']);
                    global_aux_prodbenefi[codProducto][codPrograma][llaveBenefi]['tipo_solicitud'] = parseInt(benPro['COD_TIPO_SOLICITUD']);
                    
                    //Seleccionar el checkbox del beneficiario en el programa y aplicar tarifa
                    $('#'+idCheckbox).prop('checked',true);
                    $('#'+idCheckbox).parent().parent().find('.class-pesos').html(formatMiles(benPro['VAL_TARIFA']));
                }
            }
        }
        
    }
    
    //Llenar global_prod_benefi si esta se encuentra vacia
    if(Object.keys(global_prod_benefi).length == 0){
        global_prod_benefi = pasar_obj_global(global_aux_prodbenefi);
    }

    calcularMiCarrito(false);
}

function cambiarEstadoAfiliacion(){

    var tabsCompra = $('#tabs_compra').children('li');
    tabsCompra.eq(4).children('a').click(function(){
        llenarDatosTab('_con');
        $('#ulProductos_con').find('a.nav-link:first-child').trigger('click');
    });

    $("#tabs_compra > li").eq(4).find("a").trigger("click");

}

function quitarBeneficiarioPrograma(elemento){
    var idElement = elemento.id;
    var keyBenefi = idElement.replace('quit_','');
    var valorTotal = $('#'+idElement).parent().parent().parent().find('.class-pesos').html().replace(/\./g,'');
    var valorQuit = $('#'+idElement).attr('data-valor');
    var valor = parseInt(valorTotal) - parseInt(valorQuit);
    var valorMiCarrito_aux = 0;
    
    $('#'+idElement).parent().parent().parent().find('.class-pesos').html(formatMiles(valor));
    $('#div_'+keyBenefi).remove();
    $('#ch_'+keyBenefi).prop('checked', false);
    $('#ch_'+keyBenefi).trigger('change');
    valorMiCarrito_aux = calcularMiCarrito(false);
    $('.total-tarifa>.class-pesos').html(formatMiles(valorMiCarrito_aux));    
}

function editarBeneficiario(p_idx){
    var complement = 'bnf';
    agregarBeneficiario(p_idx);
    cargarDatosEdit(complement, global_registro_basico[p_idx]);
    $('#aceptarMd').html('Modificar');
    aplicaValidacionCampos(complement);
}

function cargarDatosEdit(complement, datos){
   
    var data = datos;
    var complemento = '_'+complement;

    $('#tipoDocumento'+complemento).find('option[value="'+data['tipoDocumento']+'"]').prop('selected',true).attr('selected','selected');
    $('#numeroDocumento'+complemento).val(data['numeroDocumento']);
    $('#nombre1'+complemento).val(data['nombre1']);
    $('#nombre2'+complemento).val(data['nombre2']);
    $('#apellido1'+complemento).val(data['apellido1']);
    $('#apellido2'+complemento).val(data['apellido2']);
    $('#fechaNacimiento'+complemento).val(data['fechaNacimiento']);
    $('#tipoSexo'+complemento).find('option[value="'+data['tipoSexo']+'"]').prop('selected',true).attr('selected','selected');
    $('#telefono'+complemento).val(data['telefono']);
    $('#celular'+complemento).val(data['celular']);
    $('#correo'+complemento).val(data['correo']);
    $('#pais'+complemento).find('option[value="'+data['pais']+'"]').prop('selected',true).attr('selected','selected');
    $('#tipoVia'+complemento).find('option[value="'+data['tipoVia']+'"]').prop('selected',true).attr('selected','selected');
    $('#numeroTipoVia'+complemento).val(data['numeroTipoVia']);
    $('#numeroPlaca'+complemento).val(data['numeroPlaca']);
    $('#complemento'+complemento).val(data['complemento']);
    $('#estado_civil'+complemento).find('option[value="'+data['estado_civil']+'"]').prop('selected',true).attr('selected','selected');
    $('#eps'+complemento).find('option[value="'+data['eps']+'"]').prop('selected',true).attr('selected','selected');
    $('INPUT[name="mascota'+complemento+'"][value="'+data['mascota']+'"]').prop('checked', true);
    $('#parentesco'+complemento).find('option[value="'+data['parentesco']+'"]').prop('selected',true).attr('selected','selected');
    $('#municipio'+complemento).find('option[value="'+data['municipio']+'"]').prop('selected',true).attr('selected','selected');
    
}


function actualizarMiCarrito(calback){
    runLoading(true);
    var idModal = 'modalUp';
    var botonesModal = [{"id":"cerrarUp","label":"Aceptar","class":"btn-primary"}];
    var paramsObj = {};
    
    $.ajax({
        url: pointToUrl()+"Gestion_compra/actualizarMicarrito",  
        type: "POST",  
        dataType: "json",
        data: paramsObj,   
        success: function(resp){
            runLoading(false);
            var data = resp;
            calback(data);
        },
        error: function(result) {
            runLoading(false);
            crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al realizar la operaci&oacute;n', botonesModal, false, '', '');
            $('#cerrarUp').click(function(){
                $('#'+idModal).modal('hide');
            });
        }
    }); 
}

function pasar_obj_global(dataObj){
    var objString = JSON.stringify(dataObj);
    var objReturn = JSON.parse(objString);
    
    return objReturn;
}

function validaContratos(codAfiliacion,codPersona,codPrograma){

    var parametrosObj    = {};
    var valida           = false;
    parametrosObj['codPersona']    = codPersona;
    parametrosObj['codAfiliacion'] = codAfiliacion;
    parametrosObj['codPrograma']   = codPrograma;

    runLoading(true);

    $.ajax({
        url: pointToUrl()+"Gc_paso_5/getValidaContratos",  
        type: "POST",  
        dataType: "json",
        data: parametrosObj,   
        async: false, 
        success: function(resp){
            runLoading(false);
            if (resp.validaContrato != '0'){
                valida = true;
            } else {
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

function finalizarVenta(){
        
    var codigoAfiliacion      = global_datos_contratante["COD_AFILIACION"];
    var codigoPersona         = global_datos_contratante['COD_PERSONA'];
    var validaOK              = true;  
    var validaContrato        = false;
    var mensaje               = '';
    var posicion              = '';
    var codPrograma           = '';
    var desPrograma           = '';
    var idModal               = 'verMsgContrato';
    var botonesModal          = [{"id":"cerrarMsgContrato","label":"Aceptar","class":"btn-primary"}];

    $(".verContrato").each(function(){  

        codPrograma    = $(this).attr("codprograma");
        desPrograma    = $(this).attr("desPrograma");
        validaContrato = validaContratos(codigoAfiliacion,codigoPersona,codPrograma);
        
        if (!validaContrato){

            mensaje  = 'No ha firmado el contrato para el programa <b>'+desPrograma+'</b>. Recuerde firmar todos los contratos y despu&eacute;s presionar el bot&oacute;n "Finalizar"<br>';
            posicion = $('#divPrograma_con_'+codPrograma).offset();
            validaOK = false;
            return false;
        }
        
    });

    if (mensaje != ''){
        var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
        $('body').append(divRequired);
        alertify.notify(mensaje, 'error', 3, function(){ $('#div_required_nexos').remove(); });
    } else {
        if (validaOK){
           
            var paramsObj    = {};
            paramsObj['codAfiliacion'] = codigoAfiliacion;
            runLoading(true);
      
            $.ajax({
                url: pointToUrl()+"Gc_paso_5/actualizarAfiliacion",  
                type: "POST",  
                dataType: "json",
                data: paramsObj,   
                success: function(resp){
                    runLoading(false);
                   
                    if (resp.ret){
                        mensajeRespuesta =  msgFinalizarVenta; 
                    } else {
                        mensajeRespuesta = resp.errors;
                    }

                    crearModal(idModal, 'Confirmaci\u00f3n', '<p class="text-justify">'+mensajeRespuesta+'</p>', botonesModal, false, '', '');
                    $('#cerrarMsgContrato').click(function(){
                        $('#'+idModal).modal('hide');
                        window.location.href = pointToUrl()+'Home';                        
                    });
                    
                },
                error: function(result) {
                    runLoading(false);
                    crearModal(idModal, 'Confirmaci\u00f3n', 'Se presentaron problemas al guardar el registro', botonesModal, false, '', '');
                    $('#cerrarMsgContrato').click(function(){
                        $('#'+idModal).modal('hide');
                    });
                }
            });            
        }
    }

}

function validarHabeasDataCem(){
    var idModal = 'modalHabeasDataCem';
    var botonesModal = [{"id":"aceptarHdCem","label":"Aceptar","class":"btn-primary mr-2"},{"id":"cerrarHdCem","label":"Cancelar","class":"btn-primary"}];
    var divHd = $('<div id="divHdCem" class="content-habeasData"></div>');
    var labelHd = $('<label></label>');
    var checkHd = $('<input type="checkbox" id="chAceptaCem">');
    var dataHabeasData = global_habeasDataCem;

    labelHd.html(checkHd);
    labelHd.append(' Comprendo y acepto los t&eacute;rminos, condiciones y restricciones alusivas al &Aacute;rea de Cobertura y manifiesto mi deseo de contratar el Programa ofrecido.');
    divHd.html(dataHabeasData);
    divHd.append('<br><br>');
    divHd.append(labelHd);

    crearModal(idModal, 'Declaraci&oacute;n de Conocimiento del &Aacute;rea de Cobertura', divHd, botonesModal, false, 'modal-xl', '',true);
    
    $('#cerrarHdCem').click(function() {
        $('#'+idModal).modal('hide');
        $('LI[id*="liProducto_"').eq(0).find('a').trigger('click');
    });

    $('#aceptarHdCem').click(function() {
        $('#'+idModal).modal('hide');
    });

    $('#aceptarHdCem').attr('disabled','disabled');

    checkHd.change(function(){
        if($(this).is(':checked')){
            $('#aceptarHdCem').removeAttr('disabled');
        }else{
            $('#aceptarHdCem').attr('disabled','disabled');
        }
    });
}

function validaMarcaAplica_prodbenefi(){
    var marcaAplicaIgual = true;
    var prodBenefi_aux = global_aux_prodbenefi;
    var prodBenefi = global_prod_benefi;
    
    for(p in prodBenefi_aux){
        var producto = prodBenefi_aux[p];
        var programas = Object.keys(producto);
        for(a=0; a<programas.length; a++){
            var programa = producto[programas[a]];
            for(b in programa){
                var prod = p;
                var prog = programas[a];
                var benf = b;
                
                if(prodBenefi[prod][prog][benf] != undefined){
                    if(prodBenefi_aux[prod][prog][benf]['marcaAplica'] != prodBenefi[prod][prog][benf]['marcaAplica']){
                        marcaAplicaIgual = false;
                        break;
                    }
                }else{
                    marcaAplicaIgual = false;
                    break;
                }
            }               
        }    
    }

    return marcaAplicaIgual;

}

function resultSubmitFileBenefi(idModal, success, msj){    
    if(success == '1'){
        alertify.notify('Operaci&oacute;n realizada correctamente', 'success', 3, null);
        $('#'+idModal).modal('hide');
    }else{
        alertify.notify('Fallo la operaci&oacute;n', 'error', 3, null);
    }   
}
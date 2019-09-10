<!-- DATOS BENEFICIARIOS -->
<br>
<fieldset> 
	<legend> Domicilio De Facturación </legend>
	<br>
    

    <?php $conteo = 1; foreach ($beneficiarios as $item): $beneficiario = $item['BENEFICIARIOS']?>
        <fieldset> 
	        <legend><strong>Producto #<?php echo $conteo?> </strong>               
                <button class="btn btn-primary btn_sm verContrato" data-url = "<?php echo base_url()?>Solicitud/getContrato/<?php echo $item['COD_PROGRAMA'].'/'.$contratante[0]['COD_AFILIACION']; ?>" >Ver contrato</button>
            </legend>
	        <br>  
            <div style="margin-left: 30px">      
            <h5><strong>  Grupo</strong></h5>
            <div class="row">
			<div class="col-sm-3">
				<label >Cuenta</label>
				<div>
					<input class="form-control campo-vd" id="cuenta" name="cuenta" type="text" max-length="100" value="<?php echo $item['CUENTA']; ?>" disabled>				
				</div>
			</div>	
			<div class="col-sm-3">
				<label >Sub-cuenta</label>
				<div>
					<input class="form-control campo-vd" id="sub_cuenta" name="sub_cuenta" type="text" max-length="100" value="<?php echo $item['SUB_CUENTA']; ?>" disabled>				
				</div>
			</div>
			<div class="col-sm-3">
				<label >Programa</label>
				<div>
					<input class="form-control campo-vd" id="programa" name="programa" type="text" max-length="100" value="<?php echo $item['PROGRAMA']; ?>" disabled>				
				</div>
			</div>	
			<div class="col-sm-3">
				<label >Tarifa</label>
				<div>
					<input class="form-control campo-vd" id="tarifa" name="tarifa" type="text" max-length="100" value="<?php echo $item['TARIFA']; ?>" disabled>				
				</div>
			</div>
		</div> <br>               
        <?php for ($i = 0; $i < count($beneficiario); $i++): ?>
            <div class="accordion acordeonPrincipal" id="accordionBeneficiarios<?php echo '_'.$conteo.'_'.$i?>">
            <div class="acordeonHeader">
                <div class="acordeonTitulo" id="heading<?php echo '_'.$conteo.'_'.$i?>">                
                    <button class="btn btn-link btn-sm" type="button" data-toggle="collapse" data-target="#collapse<?php echo '_'.$conteo.'_'.$i?>" aria-expanded="true" aria-controls="collapse<?php echo $i; ?>">
                        <span class="text-dark"><b><?php echo $beneficiario[$i]['NOMBRE_1'].' '.$beneficiario[$i]['APELLIDO_1']; ?></b></span>
                    </button>                
                </div>

                <div id="collapse<?php echo '_'.$conteo.'_'.$i?>" class="collapse show" aria-labelledby="heading<?php echo '_'.$conteo.'_'.$i?>" data-parent="#accordionBeneficiarios<?php echo '_'.$conteo.'_'.$i?>">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Parentesco</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['PARENTESCO'] ?>" disabled>
                            </div> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Tipo Documento</label>
                                <input type="text"  class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['TIPO_IDENTIFICACION'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Número Documento</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['NUMERO_IDENTIFICACION'] ?>" disabled>
                            </div> 
                        </div>   
                        <div class="row">                            
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Primer Apellido</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['APELLIDO_1'] ?>" disabled>
                            </div> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Segundo Apellido</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['APELLIDO_2'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Primer Nombre</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['NOMBRE_1'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Segundo Nombre</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['NOMBRE_2'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Género</label>
                                <input type="text"  class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['GENERO'] ?>" disabled>
                            </div> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Fecha Nacimiento</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['FECHA_NACIMIENTO'] ?>" disabled>
                            </div>
                        </div>
                        <div class="row">  
                        <?php if($item['COD_PROGRAMA'] == 1): ?>                             
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Cod Cobertura</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['COD_DIRECCION'] ?>" disabled>
                            </div>
                        <?php endif;?>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Nacionalidad</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['NACIONALIDAD'] ?>" disabled>
                            </div> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Estado Civil</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['ABR_ESTADO_CIVIL'] ?>" disabled>
                            </div> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>EPS</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['DES_EPS'] ?>" disabled>
                            </div> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Tipo de compra</label>
                                <?php $tiposVenta = explode(",", $beneficiario[$i]['TIPO_VENTA']); $totalTiposVenta = count($tiposVenta); ?>
                                
                                <?php if($totalTiposVenta > 1): ?>
                                    <input type="text" class="form-control form-control-sm campo-vd-sm" value="<?php echo $tiposVenta[0];?>" disabled>
                                <?php else: ?>
                                    <input type="text" class="form-control form-control-sm campo-vd-sm" value="<?php echo $beneficiario[$i]['TIPO_VENTA'] ?>" disabled>
                                <?php endif;?>
                            </div> 
                        </div>    
                        <div class="row"> 
                            <div class="col-sm-12 col-md-6 col-lg-2 text-center">
                                <label></label><br>
                                <button data-html2canvas-ignore codPersona="<?php echo $beneficiario[$i]['COD_PERSONA'] ?>" codAfiliacion="<?php echo $beneficiario[$i]['COD_AFILIACION'] ?>" nombreBeneficiario="<?php echo $beneficiario[$i]['NOMBRE_1'].' '.$beneficiario[$i]['APELLIDO_1']; ?>" class="verArchivo btn btn-primary btn-sm" type="button" title="Ver Adjunto" style="padding: 0.40625rem 0.6rem;">
                                    <i class="fa fa-file-image-o" aria-hidden="true"></i>&nbsp; Archivos Adjuntos
                                </button>
                            </div>                            
                            <div class="col-sm-12 col-md-6 col-lg-2 text-center">
                                <?php if ($beneficiario[$i]['IND_ENCUESTA_SALUD'] == 1): ?>                           
                                    <label></label><br>
                                    <button data-html2canvas-ignore codigoPersona="<?php echo $beneficiario[$i]['COD_PERSONA'] ?>" codigoAfiliacion="<?php echo $beneficiario[$i]['COD_AFILIACION'] ?>" codigoSexo="<?php echo $beneficiario[$i]['COD_SEXO'] ?>" edad="<?php echo $beneficiario[$i]['EDAD'] ?>" class="encuestaSalud btn btn-primary boton-vd btn-sm" type="button" >
                                        <i class="fa fa-check-square-o" aria-hidden="true"></i> &nbsp; Encuesta Salud
                                    </button>
                                <?php endif;?>
                            </div>   
                        </div>                                                              
                        <!--    <div class="col-sm-12 col-md-6 col-lg-2 $beneficiario[$i]['COD_PROGRAMAS'])">-->
                              
                    </div>
                </div>
            </div> 
        </div> 
          
    <?php endfor;?>	            
    </fieldset><br>
<?php $conteo++; endforeach;?> 
    
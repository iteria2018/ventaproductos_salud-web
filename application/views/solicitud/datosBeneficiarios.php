<!-- DATOS BENEFICIARIOS -->
<br>
<fieldset> 
	<legend> Informaci&oacute;n Beneficiarios </legend>
	<br>
    <div class="accordion acordeonPrincipal" id="accordionBeneficiarios">
        <?php for ($i = 0; $i < count($beneficiario); $i++): ?>
            <div class="acordeonHeader">
                <div class="acordeonTitulo" id="heading<?php echo $i; ?>">                
                    <button class="btn btn-link btn-sm" type="button" data-toggle="collapse" data-target="#collapse<?php echo $i; ?>" aria-expanded="true" aria-controls="collapse<?php echo $i; ?>">
                        <span class="text-dark"><b><?php echo $beneficiario[$i]['NOMBRE_1'].' '.$beneficiario[$i]['APELLIDO_1']; ?></b></span>
                    </button>                
                </div>

                <div id="collapse<?php echo $i; ?>" class="collapse <?php echo $show = ($i == 0) ? "show" : ""; ?>" aria-labelledby="heading<?php echo $i; ?>" data-parent="#accordionBeneficiarios">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Parentesco</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['PARENTESCO'] ?>" disabled>
                            </div> 
                        </div>   
                        <div class="row">
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Tipo Documento</label>
                                <input type="text"  class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['TIPO_IDENTIFICACION'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Número Documento</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['NUMERO_IDENTIFICACION'] ?>" disabled>
                            </div> 
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
                        </div>
                        <div class="row">                                
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Género</label>
                                <input type="text"  class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['GENERO'] ?>" disabled>
                            </div> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Fecha Nacimiento</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['FECHA_NACIMIENTO'] ?>" disabled>
                            </div>
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
                                    <select multiple class="form-control form-control-sm campo-vd-sm" readonly style="height: 68px;">
                                        <?php for ($j = 0; $j < $totalTiposVenta; $j++): ?>
                                            <option><?php echo ($j + 1).'. '.$tiposVenta[$j];?></option>                                        
                                        <?php endfor;?>                                                             
                                    </select>
                                <?php else: ?>
                                    <input type="text" class="form-control form-control-sm campo-vd-sm" value="<?php echo $beneficiario[$i]['TIPO_VENTA'] ?>" disabled>
                                <?php endif;?>
                            </div> 
                        </div>    
                        <div class="row"> 
                            <div class="col-sm-12 col-md-6 col-lg-2 text-center">
                                <label></label><br>
                                <button codPersona="<?php echo $beneficiario[$i]['COD_PERSONA'] ?>" codAfiliacion="<?php echo $beneficiario[$i]['COD_AFILIACION'] ?>" nombreBeneficiario="<?php echo $beneficiario[$i]['NOMBRE_1'].' '.$beneficiario[$i]['APELLIDO_1']; ?>" class="verArchivo btn btn-primary btn-sm" type="button" title="Ver Adjunto" style="padding: 0.40625rem 0.6rem;">
                                    <i class="fa fa-file-image-o" aria-hidden="true"></i>&nbsp; Archivos Adjuntos
                                </button>
                            </div>                            
                            <div class="col-sm-12 col-md-6 col-lg-2 text-center">
                                <?php if ($beneficiario[$i]['IND_ENCUESTA_SALUD'] == 1): ?>                           
                                    <label></label><br>
                                    <button codigoPersona="<?php echo $beneficiario[$i]['COD_PERSONA'] ?>" codigoAfiliacion="<?php echo $beneficiario[$i]['COD_AFILIACION'] ?>" codigoSexo="<?php echo $beneficiario[$i]['COD_SEXO'] ?>" edad="<?php echo $beneficiario[$i]['EDAD'] ?>" class="encuestaSalud btn btn-primary boton-vd btn-sm" type="button" >
                                        <i class="fa fa-check-square-o" aria-hidden="true"></i> &nbsp; Encuesta Salud
                                    </button>
                                <?php endif;?>
                            </div>   
                        </div>                                                              
                        <!--    <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Fecha inicio servicio</label>
                                <?php $fechasServicio = explode(",", $beneficiario[$i]['FECHA_INICIO_SERVICIO']); $totalFechasServicio = count($fechasServicio); ?>
                                <?php if($totalFechasServicio > 1): ?>
                                    <select multiple class="form-control form-control-sm campo-vd-sm" readonly style="height: 68px;">
                                        <?php for ($j = 0; $j < $totalFechasServicio; $j++): ?>
                                            <option><?php echo ($j + 1).'. '.$fechasServicio[$j];?></option>                                        
                                        <?php endfor;?>                                                             
                                    </select>
                                <?php else: ?>
                                    <input type="text" class="form-control form-control-sm campo-vd-sm" value="<?php echo $beneficiario[$i]['FECHA_INICIO_SERVICIO'] ?>" disabled>
                                <?php endif;?>                                
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Código programa</label>
                                <?php $programas = explode(",", $beneficiario[$i]['COD_PROGRAMAS']); $totalProgramas = count($programas); ?>
                                <?php if($totalProgramas > 1): ?>
                                    <select multiple class="form-control form-control-sm campo-vd-sm" readonly style="height: 68px;">
                                        <?php for ($j = 0; $j < $totalProgramas; $j++): ?>
                                            <option><?php echo ($j + 1).'. '.$programas[$j];?></option>                                        
                                        <?php endfor;?>                                                             
                                    </select>
                                <?php else: ?>
                                    <input type="text" class="form-control form-control-sm campo-vd-sm" value="<?php echo $beneficiario[$i]['COD_PROGRAMAS'] ?>" disabled>
                                <?php endif;?>                                
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">                                
                                <label>Código tarifa</label>
                                <?php $tarifas = explode(",", $beneficiario[$i]['COD_TARIFAS']); $totalTarifas = count($tarifas); ?>
                                <?php if($totalTarifas > 1): ?>
                                    <select multiple class="form-control form-control-sm campo-vd-sm" readonly style="height: 68px;">
                                        <?php for ($j = 0; $j < $totalTarifas; $j++): ?>
                                            <option><?php echo ($j + 1).'. '.$tarifas[$j];?></option>                                        
                                        <?php endfor;?>                                                             
                                    </select>
                                <?php else: ?>
                                    <input type="text" class="form-control form-control-sm campo-vd-sm" value="<?php echo $beneficiario[$i]['COD_TARIFAS'] ?>" disabled>
                                <?php endif;?>                                
                            </div>                                                                                                                     
                        </div>                    
                        <div class="row">                                    
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Tipo vía</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['ABR_TIPO_VIA'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Número</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['DIR_NUM_VIA'] ?>" disabled>
                            </div>                                                     
                        </div>
                        <div class="row"> 
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Número de Placa</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['DIR_NUM_PLACA'] ?>" disabled>
                            </div>   
                           <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Complemento</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['DIR_COMPLEMENTO'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>País</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['PAIS'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Municipio</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['COD_MUNICIPIO'] ?>" disabled>
                            </div>                    
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Barrio</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['BARRIO'] ?>" disabled>
                            </div>
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Código DANE</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['CODIGO_DANE'] ?>" disabled>
                            </div>                                                    
                        </div>  
                        <div class="row">
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Tel&eacute;fono Fijo</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['TELEFONO'] ?>" disabled>
                            </div>    
                            <div class="col-sm-12 col-md-6 col-lg-2">
                                <label>Email</label>
                                <input type="text" class="form-control campo-vd-sm" value="<?php echo $beneficiario[$i]['EMAIL'] ?>" disabled>
                            </div>
                                                                              
                        </div>  -->           	
                    </div>
                </div>
            </div> 
        <?php endfor;?>	 
    </div>
</fieldset>
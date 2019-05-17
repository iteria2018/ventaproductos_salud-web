<style> 

.fieldset{
    padding: 0;
    margin: 0;
    border: 0;
}

.legend{

    margin-bottom: 20px;
    font-weight: 300;
    border: 0;display: block;
    padding: 0;
    font-size:26px;
    line-height: inherit; 
    color: #3C4858;
    white-space: normal;
}

.table th, .table td {
    padding: 15px 20px;
    vertical-align: top;
    border-top: 1px solid #dee2e6;
    color: #3C4858;

}

.table-bordered th, .table-bordered td {
    padding: 10px 11px 2px;
    border: 1px solid #dee2e6;
    white-space: normal;
    text-align:center;
    vertical-align: middle;
}

table { page-break-inside:auto }
tr    { page-break-inside:avoid; page-break-after:auto }
thead { display:table-header-group }

.iva-incluido-pdf{
    font-size: 10px;
    color: #AAAAAA;
    display: block;      
}

</style>

<page backtop="36mm" backbottom="15mm" backleft="5mm" backright="3mm">

    <page_header>
        <div style="border-bottom: 1px solid #dee2e6 !important;">            
            <img src="./asset/public/images/logoC.jpg" > 
        </div>
    </page_header>

<fieldset class="fieldset"> 
	<legend class="legend"> Informaci&oacute;n contratante </legend>
   
    <table cellspacing="0" class="table" style="font-size:14px;" width="100%" align="center">
     <tr>
        <th>Tipo de identificación</th>
        <td><?php echo $datosContratante['DES_TIP_IDENT_LONG']; ?></td>
        <th>Número de identificación</th>
        <td><?php echo $datosContratante['NUMERO_IDENTIFICACION']; ?></td>
        <th>Nombre del cotizante</th>
        <td><?php echo ucwords(strtolower($datosContratante['NOMBRE_COMPLETO'])); ?></td>
     </tr>
     <tr>
        <th>Fecha de nacimiento</th>
        <td><?php echo $datosContratante['FECHA_NACIMIENTO']; ?></td>
        <th>Estado civil</th>
        <td><?php echo ucwords(strtolower($datosContratante['DES_ESTADO_CIVIL'])); ?></td>
        <th>Sexo</th>
        <td><?php echo ucwords(strtolower($datosContratante['DESCRIPCION_LONG_SEXO'])); ?></td>
     </tr>
     <tr>
        <th>Télefono fijo</th>
        <td><?php echo $datosContratante['TELEFONO']; ?></td>
        <th>Celular</th>
        <td><?php echo $datosContratante['CELULAR']; ?></td>
        <th>Correo electrónico</th>
        <td><?php echo $datosContratante['EMAIL']; ?></td>
     </tr>
     <tr>
        <th>Nacionalidad</th>
        <td><?php echo ucwords(strtolower($datosContratante['NACIONALIDAD'])); ?></td>
        <th>Municipio</th>
        <td><?php echo $datosContratante['DES_MUNICIPIO']; ?></td>
        <th>Dirección</th>
        <td><?php echo $datosContratante['DIRECCION']; ?></td>
     </tr>
     
     <tr>
        <th>Eps</th>
        <td colspan="5"><?php echo ucwords(strtolower($datosContratante['DES_EPS'])); ?></td>
     </tr>
</table>

</fieldset> 

<br>
<br>
<br>
<?php
    $totalProgramas = 0;
    for ($i = 0; $i < count($productos); $i++): 

        $programas         = json_decode($productos[$i]['PROGRAMAS'], true);
        $cantidadProgramas = count($programas);
        $totalProgramas   +=  $cantidadProgramas;

    endfor;   
?>
            
<fieldset class="fieldset"> 
	<legend class="legend"> Informaci&oacute;n beneficiarios </legend>
    <br>
<table cellspacing="0" width="100%" class="table table-bordered" style="font-size:11.3px;" align="center">
<thead>
    <tr role="row">
        <th rowspan="3">Número <br> Documento </th>
        <th rowspan="3">Nombre <br> beneficiario </th>
        <th rowspan="3">Parentesco </th>
        <th rowspan="3">Teléfono </th>
        <th rowspan="3">Correo electrónico</th>
        <th colspan="<?php echo $totalProgramas ; ?>">Productos </th>
        <th rowspan="3">Tarifa </th>
    </tr>
    <tr role="row">
    <?php
        for ($i = 0; $i < count($productos); $i++): 

            $programas         = json_decode($productos[$i]['PROGRAMAS'], true);
            $cantidadProgramas = count($programas);
    ?>
            <th colspan="<?php echo $cantidadProgramas; ?>">
                <?php  echo str_replace (' ' , '<br>' , $productos[$i]['DES_PRODUCTO']); ?>
            </th>
            
        <?php endfor;?>
    </tr>
    <tr>
    <?php
        for ($i = 0; $i < count($productos); $i++): 

            $programas         = json_decode($productos[$i]['PROGRAMAS'], true);
            $cantidadProgramas = count($programas);

            for($j = 0; $j < count($programas); $j++):
    ?>
            <th>
                <?php  echo str_replace (' ' , '<br>' , $programas[$j]['des_programa']); ?>
            </th>
           
      <?php endfor;
        endfor;?>
    </tr>
   </thead>
    
    <tbody> 
           
        <?php 
        
            $totalCotizacion = 0;
            for ($i = 0; $i < count($beneficiarios); $i++): 
            
        ?>

            <tr style="page-break-before: always;<?php echo $mod = ($i % 2 == 0) ? "background-color:#F2F2F2" : ""; ?>">
                <td style="text-align:left;">
                    <?php echo $beneficiarios[$i]['tipoDocumento_abr']; ?>-<?php echo $beneficiarios[$i]['numeroDocumento']; ?>
                </td>
                <td style="text-align:left;">
                    <?php echo $beneficiarios[$i]['nombre1']; ?> 
                    <?php echo $beneficiarios[$i]['nombre2']; ?><br> 
                    <?php echo $beneficiarios[$i]['apellido1']; ?> 
                    <?php echo $beneficiarios[$i]['apellido2']; ?>
                </td>
                <td>
                    <?php echo str_replace (' ' , '<br>' , $beneficiarios[$i]['des_parentesco']); ?>
                </td>
                <td>
                    <?php echo $beneficiarios[$i]['telefono']; ?>
                </td>
                <td>
                    <?php echo $beneficiarios[$i]['correo']; ?>
                </td>

                <?php
                    for ($k = 0; $k < count($productos); $k++): 

                        $programas         = json_decode($productos[$k]['PROGRAMAS'], true);
                        $cantidadProgramas = count($programas);

                        for($j = 0; $j < count($programas); $j++):

                            $validaPrograma = strrpos($beneficiarios[$i]['benefiProgramas'], $programas[$j]['cod_programa']);

                            if ($validaPrograma === false):

                ?>              <td></td>

                            <?php else: ?>
                                <td>
                                    <img src="./asset/public/images/check.png" width="20px;"> 
                                </td>
                    
                <?php 
                            endif;
                        endfor;
                    endfor;
                
                ?>
               
                
                <td>$ 
                    <?php 
                        $totalCotizacion += $beneficiarios[$i]['tarifaBeneficiario'];
                        echo number_format($beneficiarios[$i]['tarifaBeneficiario'],0,',','.'); 
                    ?>
                </td>
            </tr>
        <?php endfor;?>
    </tbody>
    </table>
</fieldset>
<br><br>
<div style="border-top: 1px solid #dee2e6 !important;text-align:right;padding:10px;">            
    <span style="color: #3C4858;">Total Cotizado</span> <br> <span style="color: #3C4858;">
     <b>$ <?php echo number_format($totalCotizacion,0,',','.');?> </b></span>
     <br><span class="iva-incluido-pdf"> IVA incluido </span>
</div>

    <page_footer>    
        <table width="100%" align="center">
            <tr class="fila">
                <td>
                    <span>Copyright © <?php echo date('Y'); ?> Venta Directa, Todos los derechos reservados.</span>
                </td>
            </tr>
        </table>   
    </page_footer>

</page>
<!DOCTYPE html>
<html>
	<head> 
		
		<link href="<?php echo base_url()?>asset/public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>  
		<link href="<?php echo base_url()?>asset/public/css/material-kit.css?v=2.0.4" rel="stylesheet" type="text/css"/>
		<link href="<?php echo base_url()?>asset/public/user/css/styles_general.css" rel="stylesheet" type="text/css"/> 
       
	</head>
	<body class="">
		
		<div class="container">
			
            <p class="text-secondary">
                El formato de los documentos aceptado es: <b><?php echo $arrayExtensiones; ?></b><br>
                El tamaño maximo por documento adjunto es: <b><?php echo $tamanoAdjunto; ?>
            </p>
            <br>
            <form id="formAdjuntos" name="formAdjuntos" action="<?php echo base_url(); ?>/Gc_paso_3/guardarDocumentos" method="post" enctype="multipart/form-data">    
                <input id="codAfiliacion" name="codAfiliacion" type="hidden" value="" readonly>
                <input id="codBeneficiario" name="codBeneficiario" type="hidden" value="" readonly>
                <div class="row">
                    <div class="file-field">
                        <a class="btn-floating btn-lg blue lighten-1 mt-0 float-left">
                            <i class="fa fa-paperclip" aria-hidden="true"></i>
                            <input class="adjuntarDocumentos" id="Cedula" name="archivo[]" msj="Copia de documento de Identidad" type="file" accept="<?php echo $arrayExtensiones; ?>">
                        </a>
                        <div class="file-path-wrapper">
                            <input name="tipoArchivo[]" type="hidden" value="6" readonly>
                            <input name="desArchivo[]" type="hidden" value="Copia de documento de Identidad" readonly>
                            <input id="mostrarfileCedula"  class="form-control file-path" type="text" placeholder="Copia de documento de Identidad" readonly>
                        </div>
                        <button id="btnVerFileCedula" class="verArchivo btn btn-primary disabled btn-sm" upload="Cedula" type="button" title="Ver Adjunto" style="padding: 0.40625rem 0.6rem;">
                            <i class="fa fa-file-image-o" aria-hidden="true"></i>
                        </button>
                    </div>
                                    
                    <div class="file-field">
                        <a class="btn-floating btn-lg blue lighten-1 mt-0 float-left">
                            <i class="fa fa-paperclip" aria-hidden="true"></i>
                            <input class="adjuntarDocumentos" id="Eps" name="archivo[]" msj="Copia de afiliación a la EPS" type="file" accept="<?php echo $arrayExtensiones; ?>">
                        </a>
                        <div class="file-path-wrapper">
                            <input name="tipoArchivo[]" type="hidden" value="7" readonly>
                            <input name="desArchivo[]" type="hidden" value="Copia de afiliación a la EPS" readonly>
                            <input id="mostrarfileEps" class="form-control file-path validate" type="text" placeholder="Copia de afiliación a la EPS" readonly> 
                        </div>
                        <button id="btnVerFileEps" class="verArchivo btn btn-primary disabled btn-sm" upload="Eps" type="button" title="Ver Adjunto" style="padding: 0.40625rem 0.6rem;">
                            <i class="fa fa-file-image-o" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>
            </form>
            <span class="text-danger small"><?php if (isset($errores)): echo $errores; endif; ?>  </span>
		</div>
	</body>
</html>
<!DOCTYPE html>
<html>
	<head> 
		
		<link href="<?php echo base_url()?>asset/public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>  
		<link href="<?php echo base_url()?>asset/public/css/material-kit.css?v=2.0.4" rel="stylesheet" type="text/css"/>
		<link href="<?php echo base_url()?>asset/public/user/css/styles_general.css" rel="stylesheet" type="text/css"/> 
       
	</head>
	<body class="">
		
		<div class="container">
            <div class="row justify-content-center text-center">
                <?php for ($i = 0; $i < count($datosArchivos); $i++): ?>

                <?php $extension = explode(".", $datosArchivos[$i]['RUTA']); ?>
               
                <div class="col-sm-6">
                    <img src="<?php echo $ruta = ($extension[1] == 'pdf') ?  base_url().'asset/public/fileUpload/miniaturaPdf.png' : base_url().'asset/public/fileUpload/miniaturaImg.png'; ?>" alt="<?php echo $datosArchivos[$i]['DES_FILE']; ?>" class="img-thumbnail" style="width: 142px;"><br>
                    <p class="text-secondary"><?php echo $datosArchivos[$i]['DES_FILE']; ?></p>
                    <button class="verAdjunto btn btn-primary btn-sm" type="button" ruta="<?php echo $datosArchivos[$i]['RUTA']; ?>" title="Ver Adjunto" style="padding: 0.40625rem 0.6rem;">
                        <i class="fa fa-file-image-o" aria-hidden="true"></i>
                    </button>
                </div>
           
              <?php endfor;?>
            </div>
       </div>
	</body>
</html>
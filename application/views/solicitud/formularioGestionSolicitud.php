<nav>
  <div class="nav nav-tabs" id="nav-tab" role="tablist" style="margin-bottom: 1rem;border-bottom: 2px solid #2196f3;padding:1px;">
    <a  style="width:15%" class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true">Datos de la Solicitud</a>
    <a style="width:15%"  class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false">Bitácora de cambios</a>

  </div>
</nav>
<div class="tab-content" id="nav-tabContent">
    <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
        <!-- DATOS CONTRATANTE -->
        <?php $this->load->view('solicitud/datosContratante');?>

        <!-- DATOS BENEFICIARIOS -->
        <?php $this->load->view('solicitud/datosBeneficiarios');?>
    </div>
    <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
         <?php $this->load->view('solicitud/tablaBitacora'); ?> 
    </div>
    
<!-- <form action="<?php echo base_url(); ?>Solicitud/exportarPdf" target="_blank">
  <button type="submit" class="btn btn_primary" id="exportarpdf" onclick="exportarPdf()">Descargar PDF</button>
</form> -->

<button data-html2canvas-ignore class="btn btn-default" id="clienteExportarPdf">Descargar PDF</button>
    
  
</div>
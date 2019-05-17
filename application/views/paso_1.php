<!-- DATOS CONTRATANTE -->
<?php $this->load->view('datos_contratante', array('abr_tab' => '_ctr', 'bloquea' => 'NO'));?>

<!-- DATOS BENEFICIARIOS -->
<br>
<fieldset> 
        <legend> Adicionar beneficiarios <img src="<?php echo base_url()?>asset/public/images/add-person.png" data-numBenefi="1" id="btnAddBenefi" class="add-benefi"></legend>
        <br>
    <div class="container" id="divBeneficiarios">
        <div id="divTablaBenefi" class="table table-responsive"> </div>
    </div>
    <!-- Botones navegacion -->
    <div class="container" div="botones_paso1">
        <div class="row"> 
            <div class="col-sm-4 col-md-12 col-lg-12 text-center">
                <button type="button" class="btn btn-primary boton-vd" id="siguiente_paso1">
                    Siguiente  &nbsp; <i class="fa fa-angle-right" aria-hidden="true"></i> 
                </button>
            </div>
        </div>
    </div>
</fieldset>
<option value="">Seleccione producto</option>
<?php for ($i = 0; $i < count($programasPlan); $i++): ?>
    <option value="<?php echo $programasPlan[$i]['COD_PLAN_PROGRAMA']; ?>">
        <?php echo $programasPlan[$i]['DES_PLAN_PROGRAMA']; ?>
    </option>
<?php endfor;?>	
 <?php if (!empty($solicitudesPendientes)): ?>
 <table width="100%" class="table table-striped table-bordered table-hover" >
    <thead>
        <tr>
            <th>No Solicitud</th>
            <th>Primer Nombre</th>
            <th>Primer Apellido</th>
            <th>Fecha de radicaci&oacute;n</th>
            <th>Plan</th>
            <th>Estado</th>
            <th>Gesti&oacute;n</th>
        </tr>
    </thead>	
    <tbody>
        <?php for ($i = 0; $i < count($solicitudesPendientes); $i++): ?>
            <tr>
                <td><?php echo $solicitudesPendientes[$i]['COD_AFILIACION']; ?></td>
                <td><?php echo $solicitudesPendientes[$i]['NOMBRE_1']; ?></td>
                <td><?php echo $solicitudesPendientes[$i]['APELLIDO_1']; ?></td>
                <td><?php echo $solicitudesPendientes[$i]['FECHA_RADICACION']; ?></td>
                <td><?php echo $solicitudesPendientes[$i]['DES_PLAN']; ?></td>
                <td><?php echo $solicitudesPendientes[$i]['DES_ESTADO']; ?></td>
                <td style="text-align:center">
                    <i title="Pendiente por gestión" class="retomarSolicitud text-warning fa fa-check-circle" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudesPendientes[$i]['COD_AFILIACION']; ?>"></i>
                </td>
            </tr>
        <?php endfor;?>		
    </tbody>
</table>
<?php else: ?>
    <div class="alert alert-dismissible fade show" role="alert" style="color: #004085;background-color: #cce5ff;border-color: #b8daff;">
        No tiene solicitudes pendientes por gestionar!
       <!-- <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true" style="color: #004085;">&times;</span>
        </button>-->
    </div>
<?php endif; ?>
<?php if (!empty($solicitudesGestionar)): ?>
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
        <?php for ($i = 0; $i < count($solicitudesGestionar); $i++): ?>
            <tr>
                <td><?php echo $solicitudesGestionar[$i]['COD_AFILIACION']; ?></td>
                <td><?php echo $solicitudesGestionar[$i]['NOMBRE_1']; ?></td>
                <td><?php echo $solicitudesGestionar[$i]['APELLIDO_1']; ?></td>
                <td><?php echo $solicitudesGestionar[$i]['FECHA_RADICACION']; ?></td>
                <td><?php echo $solicitudesGestionar[$i]['DES_PLAN']; ?></td>
                <td><?php echo $solicitudesGestionar[$i]['DES_ESTADO']; ?></td>
                <td style="text-align:center">
                    <?php if ($solicitudesGestionar[$i]['COD_ESTADO'] == 7): ?>
                        <i title="Sin gestión" class="text-danger fa fa-check-circle tomarSolicitud" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudesGestionar[$i]['COD_AFILIACION']; ?>"></i>
                    <?php elseif ($solicitudesGestionar[$i]['COD_ESTADO'] == 4): ?> 
                        <i title="Pendiente por gestión" class="tomarSolicitud text-warning fa fa-check-circle" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudesGestionar[$i]['COD_AFILIACION']; ?>"></i>
                    <?php elseif ($solicitudesGestionar[$i]['COD_ESTADO'] == 5): ?> 
                        <i title="En gestión" class="enGestion text-primary fa fa-check-circle" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudesGestionar[$i]['COD_AFILIACION']; ?>"></i>
                    <?php elseif ($solicitudesGestionar[$i]['COD_ESTADO'] == 6): ?>  
                        <i title="Validado" class="validado text-success fa fa-check-circle" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudesGestionar[$i]['COD_AFILIACION']; ?>"></i>
                    <?php endif; ?>
                </td>
            </tr>
        <?php endfor;?>		
    </tbody>
</table>
<?php else: ?> 
    <br><br><br><br>
    <div class="alert alert-dismissible fade show" role="alert" style="color: #856404;background-color: #fff3cd;border-color: #ffeeba;">
        No se encontraron solicitudes pendientes por gestionar. <strong>Intente con un filtro de búsqueda diferente!</strong>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true" style="color: #856404;">&times;</span>
        </button>
    </div>      
<?php endif; ?>
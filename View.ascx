<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="FAMTEAMEditar_IMP_EXP.View" %>

<link rel="stylesheet" type="text/css" href="/DesktopModules/Editar_IMP_EXP/vendor/DataTables/datatables.min.css" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/jqc-1.12.4/moment-2.18.1/dt-1.13.4/b-2.3.6/date-1.4.0/sl-1.6.2/datatables.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.4.0/css/responsive.dataTables.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/2.2.3/css/buttons.bootstrap.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<div class="container" id="containerinputCONSIGNEE">
            <label for="inputCONSIGNEE">Consignee:</label>
            <input type="text" id="inputCONSIGNEE" placeholder="No. consignee">
            <label for="inputBOOKING">Booking:</label>
            <input type="text" id="inputBOOKING" placeholder="Booking">
            <label for="inputPUERTO">Puerto:</label>
            <input type="text" id="inputPUERTO" placeholder="Puerto">
            <label for="inputVIAJE">Viaje:</label>
            <input type="text" id="inputVIAJE" placeholder="Viaje">
             <button type="button" class="btn btn-primary" id="btnConsultarVje">Consultar</button>
    </div>
    


<div class="modal fade" id="modalEditar" tabindex="-1" aria-labelledby="modalEditarLabel" aria-hidden="false">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalEditarLabel">Editar Registro</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="formEditar">
                     <div class="form-group">
                         <label for="editBREF">Booking Reference</label>
                         <input type="text" class="form-control" id="editBREF" disabled>
                     </div>
                    <div class="form-group">
                        <label for="editCONSIGNEE">No. Consignee</label>
                        <input type="text" class="form-control" id="editCONSIGNEE">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="btnGuardarCambios">Guardar Cambios</button>
            </div>
        </div>
    </div>
</div>

<table id="TablaContenedor" class="display">
   <thead>
    </thead>
</table>


<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="/DesktopModules/Editar_IMP_EXP/vendor/DataTables/datatables.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/2.2.3/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/2.2.3/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<!-- Necesario para Excel -->
<script type="text/javascript" src="https://cdn.datatables.net/buttons/2.2.3/js/buttons.bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>

<script>
        const DEBUG = false;

        <%--const Pais = "<%=Pais%>";--%>
        const userID = <%=UserId%>;
        const portalID =<%=PortalId%>;
        const moduleId = <%=ModuleId%>;

        const sf = $.ServicesFramework(moduleId);
        const lang = {
            "sProcessing": "Procesando...",
            "sLengthMenu": "Mostrar _MENU_ registros",
            "sZeroRecords": "No se encontraron resultados",
            "sEmptyTable": "No hay contenido disponible para este usuario.",
            "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
            "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
            "sInfoPostFix": "",
            "sSearch": "Filtrar:",
            "sUrl": "",
            "sInfoThousands": ",",
            "sLoadingRecords": "Cargando...",
            "oPaginate": {
                "sFirst": "Primero",
                "sLast": "Último",
                "sNext": "Siguiente",
                "sPrevious": "Anterior"
            },
            "oAria": {
                "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                "sSortDescending": ": Activar para ordenar la columna de manera descendente"
            },
            "buttons": {
                "copy": "Copiar",
                "colvis": "Visibilidad"
            }
        };

        var urlApi = "";
        var url = "";
        var tableEmision = {};

        function var_dump(val) {
            if (DEBUG) {
                console.log(val);
            }
        }

        $(document).ready(function () {

            llenarTablaBls("","","","");

            $('#btnConsultarVje').on('click', function () {
                var wBOOKING = $('#inputBOOKING').val().trim();
                var wPUERTO = $('#inputPUERTO').val().trim();
                var wCONSIGNEE = $('#inputCONSIGNEE').val().trim();
                var wVIAJE = $('#inputVIAJE').val().trim();
                console.log("Booking ingresado: ", wBOOKING);
                console.log("Booking ingresado: ", wPUERTO);
                console.log("Booking ingresado: ", wCONSIGNEE);
                console.log("Booking ingresado: ", wVIAJE);
                if (wBOOKING !== null & wBOOKING !== "") {
                    console.log("Cargando DataTable con BLs");
                    llenarTablaBls(wBOOKING,"","",""); // Llama a la función de cargar el DataTable pasando el #viaje
                }
                if (wPUERTO !== null & wPUERTO !== "") {
                    console.log("Cargando DataTable con BLs");
                    llenarTablaBls("", wPUERTO, "",""); // Llama a la función de cargar el DataTable pasando el #viaje
                }
                if (wCONSIGNEE !== null & wCONSIGNEE !== "") {
                    console.log("Cargando DataTable con BLs");
                    llenarTablaBls("", "", "", wCONSIGNEE); // Llama a la función de cargar el DataTable pasando el #viaje
                }
                if (wVIAJE !== null & wVIAJE !== "") {
                    console.log("Cargando DataTable con BLs");
                    llenarTablaBls("", "", wVIAJE,""); // Llama a la función de cargar el DataTable pasando el #viaje
                }
            });
        });

    function llenarTablaBls(BOOKING,PUERTO, VIAJE, CONSIGNEE) {
        const sf = $.ServicesFramework(moduleId);
        urlApi = sf.getServiceRoot('Editar_IMP_EXP');
        console.log(urlApi);
        $.ajax({
            url: urlApi + 'Registro/Traer_Imp?BOOKING=' + BOOKING + '&PUERTO=' + PUERTO + '&VIAJE=' + VIAJE + '&CONSIGNEE=' + CONSIGNEE, 
            type: 'POST',
            beforeSend: sf.setModuleHeaders,
            contentType: 'application/json',

            success: function (data) {

                if (data.error) {
                    console.error(data.message);
                    return;
                }

                if ($.fn.DataTable.isDataTable('#TablaContenedor')) {
                    $('#TablaContenedor').DataTable().clear().destroy();
                }
                $('#TablaContenedor').DataTable({
                    data: data,
                    responsive: true,
                    destroy: true,
                    columns: [
                        {
                            title: "Booking Ref",
                            data: 'BKH_Booking_Ref',
                            render: function (data) {
                                return data !== null ? data : '-';
                            }
                        },
                        {
                            title: "BL PLace",
                            data: 'BL_Place_of_BL_Issue',
                            render: function (data) {
                                return data !== null ? data : '-';
                            }
                        },
                        {
                            title: "Loading Port",
                            data: 'BKH_Loading_Port',
                            render: function (data) {
                                return data !== null ? data : '-';
                            }
                        },
                        {
                            title: "Discharge",
                            data: 'BKH_Discharge',
                            render: function (data) {
                                return data !== null ? data : '-';
                            }
                        },
                        {
                            title: "ETA Date",
                            data: 'BKH_ETA_Date',
                            render: function (data, type, row) {
                                const formattedDate = moment(data).format('YYYY-MM-DD');
                                return `<input type="date" class="form-control fecha-creacion" value="${formattedDate}" />`;
                            }
                        },
                        {
                            title: "Full Name",
                            data: 'PARC_FullName',
                            render: function (data) {
                                return data !== null ? data : '-';
                            }
                        },
                        {
                            title: "No Consignee",
                            data: 'No_Consignee',
                            render: function (data) {
                                return data !== null ? data : '-';
                            }
                        },
                        {
                            title: "Voyage POD",
                            data: 'BJS_Voyage_POD',
                            render: function (data) {
                                return data !== null ? data : '-';
                            }
                        },
                        {
                            title: "Editar",
                            data: null,
                            render: function () {
                                return `<button class="btn btn-primary btnEditar">Editar</button>`;
                            }
                        },
                        {
                            title: "Eliminar",
                            data: null,
                            render: function () {
                                return `<button class="btn btn-danger btnDelete">Eliminar</button>`;
                            }
                        },
                    ],
                    language: lang
                });
            },

            error: function (xhr, status, error) {
                console.error("Error en la solicitud:", error);
            }
        });
    };

        $(document).on('click', '.btnEditar', function () {
            event.preventDefault();
            let row = $(this).closest('tr');
            let BREF = row.find('td:eq(0)').text();
            let CONSIGNEE = row.find('td:eq(6)').text();

            // Llenar el modal con los valores actuales
            $('#editBREF').val(BREF);
            $('#editCONSIGNEE').val(CONSIGNEE);

            console.log("Abriendo modal para consignee: " + BREF);

            // Mostrar el modal
            $('#modalEditar').modal('show');
        });


    $('#btnGuardarCambios').on('click', function () {
            
            let BREF = $('#editBREF').val();
            let CONSIGNEE = $('#editCONSIGNEE').val();

            const sf = $.ServicesFramework(moduleId);

            let data = JSON.stringify({
                BKH_Booking_Ref: BREF,
                No_Consignee: CONSIGNEE,
            });

            $.ajax({
                url: urlApi + 'Registro/UpdateImp',
                type: 'POST',
                beforeSend: sf.setModuleHeaders,
                contentType: 'application/json',

                data: data,
                success: function (data) {
                    alert("Registro actualizado con éxito");

                    // Cerrar el modal
                    $('#modalEditar').modal('hide');

                    // Recargar la tabla después de la actualización
                    let BOOKING = $('#inputBOOKING').val().trim();
                    llenarTablaBls(BOOKING,"","","");
                    event.preventDefault();
                },
                error: function (xhr, status, error) {
                    console.error("Error AJAX:", xhr);
                    console.error("Estado:", status);
                    console.error("Mensaje de error:", error);
                    alert("Error al actualizar: " + xhr.responseText);
                }

            });
        });

        $(document).on('click', '.btnDelete', function () {
            event.preventDefault(); // Elimina el autopostback ---- solo controles html
            let row = $(this).closest('tr');
            let BREF = row.find('td:eq(0)').text();
            let CONSIGNEE = row.find('td:eq(6)').text();

            const sf = $.ServicesFramework(moduleId);

            let data = JSON.stringify({
                BKH_Booking_Ref: BREF,
                No_Consignee: CONSIGNEE,
            });

            $.ajax({
                url: urlApi + 'Registro/DeleteImp',
                type: 'POST',
                beforeSend: sf.setModuleHeaders,
                contentType: 'application/json',

                data: data,
                success: function (data) {
                    alert("Registro eliminado con éxito");

                    // Recargar la tabla después de la actualización
                    let BOOKING = $('#inputBOOKING').val().trim();
                    llenarTablaBls(BOOKING,"","","");
                },
                error: function (xhr, status, error) {
                    console.error("Error AJAX:", xhr);
                    console.error("Estado:", status);
                    console.error("Mensaje de error:", error);
                    alert("Error al eliminar: " + xhr.responseText);
                }
            });
        });
</script>


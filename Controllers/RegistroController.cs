using DotNetNuke.Entities.Modules;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using FAMTEAMEditar_IMP_EXP.Models;

namespace FAMTEAMEditar_IMP_EXP.Controllers
{
    public class RegistroController : MasterController
    {
        [HttpPost]
        //public List<DTOBlCXC> Traer_BlsCosco(string codviaje)
        public HttpResponseMessage Traer_Imp(string BOOKING, string PUERTO, string VIAJE, string CONSIGNEE)
        {
            List<EditarModel> BlsEdita = new List<EditarModel>();

            if (BOOKING == null)
            {
                BOOKING = "";
            }

            if (PUERTO == null)
            {
                PUERTO = "";
            }


            if (VIAJE == null)
            {
                VIAJE = "";
            }


            if (CONSIGNEE == null)
            {
                CONSIGNEE = "";
            }

            string connectionString = ConnectionString;  // Coloca tu cadena de conexión
            string PAIS = GetModuleSetting("SetPAIS");
            string sql = "EXEC SP_TRAER_DATOS_IMPO_BL @BOOKING,@PUERTO, @VIAJE, @CONSIGNEE, @PAIS";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        command.Parameters.AddWithValue("@BOOKING", BOOKING);
                        command.Parameters.AddWithValue("@PUERTO", PUERTO);
                        command.Parameters.AddWithValue("@VIAJE", VIAJE);
                        command.Parameters.AddWithValue("@CONSIGNEE", CONSIGNEE);
                        command.Parameters.AddWithValue("@PAIS", PAIS);
                        //command.CommandType = CommandType.StoredProcedure;

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                BlsEdita.Add(new EditarModel
                                {
                                    BKH_Booking_Ref = reader["BKH_Booking_Ref"].ToString(),
                                    BL_Place_of_BL_Issue = reader["BL_Place_of_BL_Issue"].ToString(),
                                    BKH_Loading_Port = reader["BKH_Loading_Port"].ToString(),
                                    BKH_Discharge = reader["BKH_Discharge"].ToString(),
                                    BKH_ETA_Date = Convert.ToDateTime(reader["BKH_ETA_Date"]),
                                    PARC_FullName = reader["PARC_FullName"].ToString(),
                                    No_Consignee = reader["No_Consignee"].ToString(),
                                    BJS_Voyage_POD = reader["BJS_Voyage_POD"].ToString()

                                });

                            }
                        }
                    }

                    connection.Close();
                    //return BlsEdita;

                    //var json = Json(BlsEdita);
                    //return json;

                    return Request.CreateResponse(System.Net.HttpStatusCode.OK, BlsEdita);
                }

                catch (Exception ex)
                {
                    connection.Close();
                    //return Json(new { error = true, message = ex.Message });
                    return Request.CreateErrorResponse(System.Net.HttpStatusCode.InternalServerError, "Error al ejecutar obtener datos: " + ex.Message);
                }
            }
        }

        public class UpdateImpRequest
        {
            public string No_Consignee { get; set; }
            public string BKH_Booking_Ref { get; set; }
            public string Country { get; set; }


        }

        [HttpPost]
        public IHttpActionResult UpdateImp([FromBody] UpdateImpRequest request)
        {

            if (request == null)
            {
                return BadRequest("Datos de entrada inválidos.");
            }

            string PAIS = GetModuleSetting("SetPAIS");
            string connectionString = ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {

                    using (SqlCommand cmd = new SqlCommand("SP_ACTUALIZAR_EMISION_IMP", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@CONSIGNEE", request.No_Consignee);
                        cmd.Parameters.AddWithValue("@BREF", request.BKH_Booking_Ref);
                        cmd.Parameters.AddWithValue("@PAIS", PAIS);

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        conn.Close();
                        return Ok(new { message = "Registro actualizado con éxito" });
                    }
                }

                catch (Exception ex)
                {
                    conn.Close();
                    return InternalServerError(new Exception("Error al actualizar: " + ex.Message));
                }
            }

        }

        public class DeleteImpRequest
        {
            public string No_Consignee { get; set; }
            public string BKH_Booking_Ref { get; set; }

        }

        [HttpPost]
        public IHttpActionResult DeleteImp([FromBody] DeleteImpRequest request)
        {

            if (request == null)
            {
                return BadRequest("Datos de entrada inválidos.");
            }

            string PAIS = GetModuleSetting("SetPAIS");
            string connectionString = ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand("SP_ELIMINAR_EMISION_IMP", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@CONSIGNEE", request.No_Consignee);
                        cmd.Parameters.AddWithValue("@BREF", request.BKH_Booking_Ref);
                        cmd.Parameters.AddWithValue("@PAIS", PAIS);

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        conn.Close();
                        return Ok(new { message = "Registro eliminado con éxito" });
                    }
                }

                catch (Exception ex)
                {
                    conn.Close();
                    return InternalServerError(new Exception("Error al eliminar: " + ex.Message));
                }
            }

        }

        private string GetModuleSetting(string key)
        {
            try
            {
                int moduleId = ActiveModule.ModuleID;
                int tabId = ActiveModule.TabID;
                var module = ModuleController.Instance.GetModule(moduleId, tabId, false);

                if (module != null && module.ModuleSettings.ContainsKey(key))
                {
                    string value = module.ModuleSettings[key].ToString();
                    return value;
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

    }
}
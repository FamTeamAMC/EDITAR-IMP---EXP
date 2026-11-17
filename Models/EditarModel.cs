using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FAMTEAMEditar_IMP_EXP.Models
{
    public class EditarModel
    {
        public string BKH_Booking_Ref { get; set; }
        public string BL_Place_of_BL_Issue { get; set; }
        public string BKH_Loading_Port { get; set; }
        public string BKH_Discharge { get; set; }
        public DateTime BKH_ETA_Date { get; set; }
        public string PARC_FullName { get; set; }
        public string No_Consignee { get; set; }
        public string BJS_Voyage_POD { get; set; }
    }
}
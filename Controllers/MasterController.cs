using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Security;
using DotNetNuke.Web.Api;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FAMTEAMEditar_IMP_EXP.Controllers
{
    [ValidateAntiForgeryToken]
    [DnnAuthorize]
    [DnnModuleAuthorize(AccessLevel = SecurityAccessLevel.View)]
    [SupportedModules("Editar_IMP_EXP")]
    public class MasterController: DnnApiController
    {
        private readonly string _connectionString;
        private string _dbType;
        public string DbType
        {
            get
            {
                if (string.IsNullOrEmpty(_dbType))
                {
                    _dbType = "sqlserver";
                }
                return _dbType;
            }
            set { _dbType = value; }
        }

        public string ConnectionString
        {
            get { return Config.GetConnectionString("BD_CMA_CGM"); }  // Prod
        }
        private PortalSettings PortalSettings => PortalController.Instance.GetCurrentPortalSettings();
        public int PortalId => this.PortalSettings.PortalId;
    }
}
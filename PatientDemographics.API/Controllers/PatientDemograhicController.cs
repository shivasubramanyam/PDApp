using PatientDemograhics.DataAccess.Patient;
using PatientDemographics.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace PatientDemographics.API.Controllers
{
    [EnableCors(origins:"*", headers: "*", methods:"GET,POST")]
    public class PatientDemograhicController : ApiController
    {
        //Creating object to access dataaccess
        private IPatientDemographics _patientDemographics;

        //Data access object is injected
        public PatientDemograhicController(IPatientDemographics patientDemographics)
        {
            _patientDemographics = patientDemographics;
        }

        // GET: api/PatientDemographics
        public string Get()
        {
            return _patientDemographics.GetPatientDemographicsList(GetSqlConnection());
        }

        // POST: api/PatientDemographics
        public void Post([FromBody]PatientData patientData)
        {
            patientData.createdBy = 0;
            patientData.createdDateTime = DateTime.Now;
            patientData.status = "Active";
            _patientDemographics.SavePatientDemographics(patientData, GetSqlConnection());
        }

        private SqlConnection GetSqlConnection()
        {
            SqlConnection connection = new SqlConnection();
            try
            {
                connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PatientDB"].ConnectionString);
            }
            catch(Exception ex)
            {
                //log the here
            }
            return connection;
        }
    }
}
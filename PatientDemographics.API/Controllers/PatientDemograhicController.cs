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
    [EnableCors(origins: "*", headers: "*", methods: "GET,POST")]
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
        [HttpGet]
        public string GetAllPatients()
        {
            return _patientDemographics.GetPatientDemographicsList(GetSqlConnection());
        }

        // POST: api/PatientDemographics
        [HttpPost]
        public bool AddPatientDemographic([FromBody]PatientData patientData)
        {
            try
            {
                patientData.createdDateTime = DateTime.Now;
                _patientDemographics.SavePatientDemographics(patientData, GetSqlConnection());
                return true;
            }
            catch (Exception ex)
            {

            }
            return false;
        }

        private SqlConnection GetSqlConnection()
        {
            SqlConnection connection = new SqlConnection();
            try
            {
                connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PatientDB"].ConnectionString);
            }
            catch (Exception ex)
            {
                //log the here
            }
            return connection;
        }
    }
}
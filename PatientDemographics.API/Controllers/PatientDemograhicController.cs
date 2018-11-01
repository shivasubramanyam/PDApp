using PatientDemograhics.DataAccess.Patient;
using PatientDemographics.Models;
using System;
using System.Configuration;
using System.Data.SqlClient;
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

        /// <summary>
        /// Get all the patients
        /// </summary>
        /// <returns>xml</returns>
        [HttpGet]
        public string GetAllPatients()
        {
            return _patientDemographics.GetPatientDemographicsList(GetSqlConnection());
        }

        /// <summary>
        /// Save  patient demographics
        /// </summary>
        /// <param name="patientData">patientData: holds/binds patient demographics data</param>
        /// <returns>true/false</returns>
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

        /// <summary>
        /// Fetches the connection string
        /// </summary>
        /// <returns>SqlConnection</returns>
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
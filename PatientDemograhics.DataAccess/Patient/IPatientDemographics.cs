using System;
using System.Data.SqlClient;
using PatientDemographics.Models;

namespace PatientDemograhics.DataAccess.Patient
{
    public interface IPatientDemographics
    {
        string GetPatientDemographicsList(SqlConnection connection);
        Boolean SavePatientDemographics(PatientData patientData, SqlConnection connection);
    }
}

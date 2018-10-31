using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PatientDemographics.Models;

namespace PatientDemograhics.DataAccess.Patient
{
    public interface IPatientDemographics
    {
        string GetPatientDemographicsList(SqlConnection connection);
        Boolean SavePatientDemographics(PatientData patientData, SqlConnection connection);
    }
}

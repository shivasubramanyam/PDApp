﻿using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using PatientDemographics.Models;

namespace PatientDemograhics.DataAccess.Patient
{
    public class PatientDemographics : IPatientDemographics
    {
        /// <summary>
        /// Gets the list of patients
        /// </summary>
        /// <returns>patient list in the form of XML</returns>
        public string GetPatientDemographicsList(SqlConnection connection)
        {
            //List<PatientDemographics> patientDemographics = new List<PatientDemographics>();
            string patientDemographics = string.Empty;
            try
            {
                using (SqlCommand cmd = new SqlCommand("GetPatientList", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    using (XmlReader reader = cmd.ExecuteXmlReader())
                    {
                        while (reader.Read())
                        {
                            patientDemographics += reader.ReadOuterXml();
                        }
                    }
                    connection.Close();
                }
            }
            catch (Exception ex)
            {

            }
            return patientDemographics;
        }

        /// <summary>
        /// Patient data is saved to the database
        /// </summary>
        /// <param name="patientData"></param>
        /// <returns>True/False</returns>
        public bool SavePatientDemographics(PatientData patientData, SqlConnection connection)
        {
            Boolean patientAdded = false;
            try
            {
                using (SqlCommand sqlCommand = new SqlCommand("SavePatientDemographics", connection))
                {
                    sqlCommand.Parameters.AddWithValue("@ForeName",patientData.foreName);
                    sqlCommand.Parameters.AddWithValue("@SurName", patientData.surName);
                    sqlCommand.Parameters.AddWithValue("@Gender", patientData.gender);
                    sqlCommand.Parameters.AddWithValue("@DOB", patientData.DOB);
                    sqlCommand.Parameters.AddWithValue("@HomeNo", "");
                    sqlCommand.Parameters.AddWithValue("@WorkNo", "");
                    sqlCommand.Parameters.AddWithValue("@MobileNo", "");
                    sqlCommand.Parameters.AddWithValue("@Status", "Active");
                    sqlCommand.Parameters.AddWithValue("@CreatedBy", 0);
                    sqlCommand.Parameters.AddWithValue("@CreatedDateTime", DateTime.Now);
                    connection.Open();
                    sqlCommand.ExecuteNonQuery();
                    connection.Close();
                    patientAdded = true;
                }
            }
            catch (Exception ex)
            {
                //log exception
            }
            return patientAdded;
        }
    }
}
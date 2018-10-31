using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatientDemographics.Models
{
    public class PatientData
    {
        public int patientId { get; set; }
        public string foreName { get; set; }
        public string surName { get; set; }
        public DateTime DOB { get; set; }
        public string gender { get; set; }
        public ICollection<PatientData> contactNumbers { get; set; }
        //public string patientDetails { get; set; }
        public int createdBy { get; set; }
        public DateTime createdDateTime { get; set; }
        public int? lastUpdateddBy { get; set; }
        public DateTime? lastUpdatedDateTime { get; set; }
        public string status { get; set; }
    }
}

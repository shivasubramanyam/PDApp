<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PatientList.aspx.cs" Inherits="PatientDemographics.UI.Patient.PatientList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Patient List</title>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.1.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>

    <script type="text/javascript">
        //On document ready fetch the patient data
        $(document).ready(function () {
            $.ajax({
                url: "http://localhost:59455/api/PatientDemograhic/GetAllPatients",
                type: "GET",
                success: function (response) {
                    //Process the xml data and bind it to the UI
                    ProcessData(response);
                },
                error: function (err) {
                    alert("Failed to fetch the patient list! Please try again.");
                }
            });
        });

        //Processes the XML data and binds it to the UI
        function ProcessData(data) {
            //iterate through the XML data and assign it to the table row
            if (data.length > 0) {

                //Parsing XML data
                var patientDemographic = $($.parseXML(data)).find('patient').map(function (index, element) {
                    var contactNos = '';
                    var cNodes = $(element).find('telephone').map(function (ind, ele) {
                        if ($(ele).attr('number') !== '')
                            contactNos += $(ele).attr('type') + " - " + $(ele).attr('number') + "<br />";
                    });
                    return {
                        foreName: $(element).attr('forename'),
                        surName: $(element).attr('surname'),
                        gender: $(element).attr('gender'),
                        dob: $(element).attr('dob'),
                        contactNumbers: contactNos
                    };
                }).toArray();

                //If there is patient data then bind it to the table 
                if (patientDemographic.length > 0) {
                    for (var i = 0; i < patientDemographic.length; i++) {
                        var row = "<tr><td>" + patientDemographic[i].foreName + "</td><td>" + patientDemographic[i].surName + "</td><td>"
                            + patientDemographic[i].gender + "</td><td>" + patientDemographic[i].dob + "</td><td>"
                            + (patientDemographic[i].contactNumbers === '' ? 'Not Available' : patientDemographic[i].contactNumbers)
                            + "</td></tr>";

                        $('#patientlist tbody').append(row);
                    }
                }
                else {
                    $('#patientlist tbody').append("<tr><td><h3>There are no patient demographic to display!</h3></td></tr>");
                }
            }
        }
    </script>
</head>
<body>
    <form id="patientListform" runat="server">
        <div class="container" style="margin-top: 50px">
            <div class="panel panel-primary">
                <div class="col-sm-4 pull-right" style="margin-top: 10px">
                    <a runat="server" class="btn btn-warning btn-xs" href="PatientRegistration.aspx" title="click here to go to patient registration form">Patient Registration</a>
                </div>
                <div class="panel-heading">
                    Demographic Details                    
                </div>
                <div class="clearfix"></div>
                <div class="panel-body">
                    <table class="table table-hover" id="patientlist">
                        <thead>
                            <tr>
                                <th>ForeName</th>
                                <th>Surname</th>
                                <th>Gender</th>
                                <th>D.O.B</th>
                                <th>Contact No</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

$(document).ready(function () {
    $("#btnReset").click(function () {
        ResetForm();
    });
});

//Saves the form data
function SavePatientDemographic() {
    debugger;
    //Fetching values from controls
    var foreName = $("#txtFirstName").val();
    var surName = $("#txtSurname").val();
    var dob = $("#txtDOB").val();
    var mobileNo = $("#txtMobile").val();
    var homeNo = $("#txtHomeNo").val();
    var workNo = $("#txtWorkNo").val();
    var gender = $("input[name='Gender']:checked").val() === "rbMale" ? "Male" : "Female";

    var patientData = {
        foreName: foreName,
        surName: surName,
        gender: gender,
        dob: dob,
        "contactNumbers": {
            home: homeNo,
            work: workNo,
            mobile: mobileNo
        },
        status: 'Active'
    };

    ////Building patient data in the xml form
    //var patientData = "=<patient forename='" + foreName + "' surname='" + surName + "' gender='" + gender + "' dob='" + dob + "'><contactdetails>";

    //if (mobileNo !== '')
    //    patientData += "<telephone type='Mobile' number= '" + mobileNo + "' />";

    //if (homeNo !== '')
    //    patientData += "<telephone type='Home' number= '" + homeNo + "' />";

    //if (workNo !== '')
    //    patientData += "<telephone type='Work' number= '" + workNo + "' />";

    //patientData += "</contactdetails></patient>";

    //Ajax call to post the data
    $.ajax({
        url: "http://localhost:59455/api/PatientDemographics",
        type: "Post",
        dataType: "html",
        contentType: "application/json; charset=UTF-8",
        data: JSON.stringify(patientData),
        success: function (response) {
            //Showing the alert message to the user on successfully storing the data
            alert("Patient demographic saved successfully!");
        },
        error: function (err) {
            //Showing the alert message to the user on failure of save operation
            alert("Failed to save patient demographic! ");
        }
    });
}

//Reset patient registration form to the original state
function ResetForm() {
    if (confirm("Are you sure you want to reset the form ?")) {
        $("#txtFirstName").val("");
        $("#txtSurname").val("");
        $("#txtDOB").val("");
        $("#txtMobile").val("");
        $("#txtHomeNo").val("");
        $("#txtWorkNo").val("");
    }
}


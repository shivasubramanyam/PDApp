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
    //dob = dob.replace(new RegExp("/", "gm"), "-");
    var patientData = {
        foreName: foreName,
        surName: surName,
        gender: gender,
        dob: dob,
        contactNumbers: {
            homeNumber: homeNo,
            workNumber: workNo,
            mobileNumber: mobileNo
        },
        createdBy: 0, //It should be the logged person's user id
        status: 'Active'
    };

    //Ajax call to post the data
    $.ajax({
        url: "http://localhost:59455/api/PatientDemograhic/AddPatientDemographic",
        type: "Post",
        dataType: "html",
        contentType: "application/json; charset=UTF-8",
        data: JSON.stringify(patientData),
        success: function (response) {
            //Showing the alert message to the user on successfully storing the data
            if (response === 'true') {
                ResetForm();
                alert("Patient demographic saved successfully!");
            }
            else
                alert("OOPS! Something went wrong please try again.");
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


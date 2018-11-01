$(document).ready(function () {
    $.validator.addMethod("dob", function (value, element) {
        var year = value.split('/');
        if (parseInt(year[2]) >= 1910 && isDate(value))
            return true;
        else
            return false;
    });

    $.validator.addMethod("telphoneno", function (value, element) {
        var year = value.split('/');
        if (isContactNo(value))
            return true;
        else
            return false;
    });

    $("#patientregistration").validate({
        rules: {
            txtFirstName: {
                required: true,
                minlength: 3,
                maxlength: 50
            },
            txtSurname: {
                required: true,
                minlength: 2,
                maxlength: 50
            }
            ,
            Gender: {
                required: true
            }
            ,
            txtDOB: {
                dob: true
            },
            txtMobile:
                {
                    telphoneno: true,
                    maxlength: 10
                },
            txtHomeNo:
                {
                    telphoneno: true,
                    maxlength: 10
                },
            txtWorkNo:
                {
                    telphoneno: true,
                    maxlength: 10
                }
        },
        messages:
            {
                txtFirstName: {
                    required: "Please enter your Forename",
                    minlength: "Your forename should atleast consists of 3 characters",
                    maxlength: "Your forename should be less than or equal to 50 characters"
                },
                txtSurname: {
                    required: "Please enter your Surname",
                    minlength: "Your Surname should atleast consists of 2 characters",
                    maxlength: "Your Surname should be less than or equal to 50 characters"
                }
                ,
                gender: {
                    required: "please select your gender"
                },
                txtDOB: {
                    dob: "Invalid Date! Year should be greater than 1910, Enter date in DD/MM/YYYY format"
                },
                txtMobile:
                    {
                        telphoneno: "Invalid contact no! Enter valid 10 digit mobile no",
                        maxlength: "Your mobile no should consists of not more than 10 digits"
                    },
                txtHomeNo:
                    {
                        telphoneno: "Invalid contact no! Enter valid mobile or landline no",
                        maxlength: "Your contact no should consists of not more than 10 digits"
                    },
                txtWorkNo:
                    {
                        telphoneno: "Invalid contact no! Enter valid mobile or landline no",
                        maxlength: "Your contact no should consists of not more than 10 digits"
                    }
            },

        errorElement: "em",
        errorPlacement: function (error, element) {
            // Add the `help-block` class to the error element
            error.addClass("help-block");

            // Add `has-feedback` class to the parent div.form-group
            // in order to add icons to inputs
            element.parents(".col-sm-5").addClass("has-feedback");

            if (element.prop("type") === "checkbox") {
                error.insertAfter(element.parent("label"));
            }
            if (element.prop("type") === "radio") {
                error.appendTo(element.parent("div"));
            } else {
                error.insertAfter(element);
            }

            // Add the span element, if doesn't exists, and apply the icon classes to it.
            if (!element.next("span")[0]) {
                $("<span class='glyphicon glyphicon-remove form-control-feedback'></span>").insertAfter(element);
            }
        },
        success: function (label, element) {
            // Add the span element, if doesn't exists, and apply the icon classes to it.
            if (!$(element).next("span")[0]) {
                $("<span class='glyphicon glyphicon-ok form-control-feedback'></span>").insertAfter($(element));
            }
        },
        highlight: function (element, errorClass, validClass) {
            $(element).parents(".col-sm-5").addClass("has-error").removeClass("has-success");
            $(element).next("span").addClass("glyphicon-remove").removeClass("glyphicon-ok");
        },
        unhighlight: function (element, errorClass, validClass) {
            $(element).parents(".col-sm-5").addClass("has-success").removeClass("has-error");
            $(element).next("span").addClass("glyphicon-ok").removeClass("glyphicon-remove");
        },

        submitHandler: function (form) {
            SavePatientDemographic();
        }
    });

    //validates date
    function isDate(txtDate) {
        var currVal = txtDate;
        if (currVal === '')
            return false;

        //Declare Regex 
        var rxDatePattern = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/;
        var dtArray = currVal.match(rxDatePattern); // is format OK?
        if (dtArray === null)
            return false;
        //Checks for mm/dd/yyyy format.
        dtDay = dtArray[1];
        dtMonth = dtArray[3];
        dtYear = dtArray[5];
        if (dtMonth < 1 || dtMonth > 12)
            return false;
        else if (dtDay < 1 || dtDay > 31)
            return false;
        else if ((dtMonth === 4 || dtMonth === 6 || dtMonth === 9 || dtMonth === 11) && dtDay === 31)
            return false;
        else if (dtMonth === 2) {
            var isleap = (dtYear % 4 === 0 && (dtYear % 100 !== 0 || dtYear % 400 === 0));
            if (dtDay > 29 || (dtDay === 29 && !isleap))
                return false;
        }
        return true;
    }

    //validates contact number
    function isContactNo(number) {
        debugger;
        if (number === '')
            return true;
        else {
            if (number.match(/\d{10}$/) === null)
                return false;
            else
                return true;
        }
        return true;
    }
});
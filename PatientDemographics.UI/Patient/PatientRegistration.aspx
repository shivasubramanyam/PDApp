<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PatientRegistration.aspx.cs" Inherits="PatientDemographics.UI.Patient.PatientRegistration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Patient Registration</title>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.1.js"></script>
    <script src="../Scripts/jquery.validate.js"></script>

    <%-- Contains patient registration form validation --%>
    <script src="../Scripts/CustomValidation/PatientRegValidation.js"></script>

    <%-- IS responsible for making jquery ajax calls--%>
    <script src="../Scripts/Operations/PatientOperations/PatientDemographic.js"></script>
</head>
<body>
    <div class="container body-content">
        <form id="patientregistration" runat="server" method="post">
            <div class="form-horizontal" style="margin-top: 100px">
                <h3 class="page-header">Patient Registration</h3>
                <div class="form-group">
                    <label class="control-label col-sm-2">ForeName:</label>
                    <div class="col-sm-5">
                        <asp:TextBox ID="txtFirstName" name="txtFirstName" CssClass="form-control" MaxLength="50" MinLength="3" placeholder="Enter ForeName..." runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2">SurName:</label>
                    <div class="col-sm-5">
                        <asp:TextBox ID="txtSurname" name="txtSurname" MaxLength="50" MinLength="2" CssClass="form-control" placeholder="Surame..." runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2">Gender:</label>
                    <div class="col-sm-5" id="gender">
                        <asp:RadioButton ID="rbFemale" GroupName="Gender" CssClass="radio-inline" Text="Female" runat="server" />
                        <asp:RadioButton ID="rbMale" GroupName="Gender" CssClass="radio-inline" Text="Male" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2">DOB:</label>
                    <div class="col-sm-5">
                        <asp:TextBox ID="txtDOB" name="txtDOB" placeholder="DD/MM/YYYY" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2">MObile No:</label>
                    <div class="col-sm-5">
                        <asp:TextBox ID="txtMobile" name="txtMobile" placeholder="Personal mobile no..." CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2">Home Phone No:</label>
                    <div class="col-sm-5">
                        <asp:TextBox ID="txtHomeNo" name="txtHomeNo" placeholder="Home phone no..." CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2">Work Phone No:</label>
                    <div class="col-sm-5">
                        <asp:TextBox ID="txtWorkNo" name="txtWorkNo" placeholder="Work phone no..." CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <hr />
                <div class="clearfix"></div>
                <div class="col-sm-offset-2">
                    <asp:Button ID="btnSubmit" CssClass="btn btn-primary btn-sm" Text="Save" runat="server" ToolTip="This will submit your form to the server" />
                    <asp:Button ID="btnReset" CssClass="btn btn-warning btn-sm" Text="Reset" ToolTip="this wil clear the form" runat="server" />
                </div>
            </div>
        </form>
    </div>
</body>
</html>

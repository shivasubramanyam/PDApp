# PDApp

Hello, Welcome to PatientDemographics application. This readme file will help you to understand the application components.
Firstly, lets see the applications layer
------------------------------------------------------------------------------------------------------------------------------------------------------------------
Sl.No		Project Name						Description
------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1			PatientDemographics.UI				This is the presentaion/UI, typically this is what the end user sees.
 2			PatientDemographics.Models			This project holds the structure of application data, more a kind of schema. This is shared accross project.
 3			PatientDemographics.API				Web API of this application, this handles the requests and process it accordingly. Calls DataAccess to either
												Save/Get the data.
 4			PatientDemographics.DataAccess		Responsible for managing database related activties.
 5			PatientDemographics.TestAPI			Used for testing the web api.
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------

Files and its purpose
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Layer		File Name							Description

UI 			PatientRegistration.aspx 			Patient sign up form to capture his/her demographics information.
			PatientList.aspx					Displays patient list.
			RegistrationValidation.js			Validates patient sign up form.
			PatientDemographics.js				Performs post operation to submit data to API.
		
Models		PatientData.cs						Holds the patient model, complex object
			ContactNumbers						Holds telephone no's, part of PatientData.cs model
			
API			PatientDemographicController		Has two methods to post and get the patient data.

DataAccess	IPatientDemographics.cs				Has defnition of two methods, for post and get of patient data. Also used to resolve dependency.
			PatientDemographics.cs				Implements IPatientDemographics.cs, performs tasks related to database.
			
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		
			Thank you :)
			
 

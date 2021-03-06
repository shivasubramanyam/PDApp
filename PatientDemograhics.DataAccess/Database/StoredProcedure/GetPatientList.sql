USE [Patient]
GO
/****** Object:  StoredProcedure [dbo].[GetPatientList]    Script Date: 01-11-2018 11:11:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPatientList]

/*
	Summary: Fetched patient demographic and contact details of all the patient. 
	Output : Returns the data of patient demographics along with contact no's as xml.
*/

AS
BEGIN
	SET NOCOUNT ON

	SELECT 
		1			AS TAG,
		0		AS parent,
		PDG.PatientID	AS [patient!1!patientid],
		PDG.Forename	AS [patient!1!forename],
		PDG.Surname		AS [patient!1!surname],
		PDG.Gender		AS [patient!1!gender],
		PDG.DOB			AS [patient!1!dob],
		NULL			AS [telephone!2!contactid],
		NULL			AS [telephone!2!type],
		NULL			AS [telephone!2!number]
	FROM  dbo.PatientDemographics PDG
	WHERE PDG.Status = 'Active'
	
	UNION ALL

	SELECT 
		2 AS TAG,					
		1 AS PARENT,					
		PDG.PatientID,				
		PDG.Forename,
		PDG.Surname,				
		PDG.Gender,				
		PDG.DOB,				
		CN.ContactID,	
		CNT.ContactTypeName, 
		CN.Number			
	FROM dbo.PatientDemographics PDG
		 INNER JOIN dbo.ContactNumber CN ON CN.PatientID = PDG.PatientID
		 INNER JOIN dbo.ContactNumberTypes CNT ON CN.ContactNumberType = CNT.ContactNoTypeID
	WHERE PDG.Status = 'Active'
		AND CN.Status = 'Active'
		AND CNT.Status = 'Active'
	ORDER BY [patient!1!patientid],[telephone!2!contactid]
	FOR XML EXPLICIT, ROOT('root')

	SET NOCOUNT OFF
END
GO


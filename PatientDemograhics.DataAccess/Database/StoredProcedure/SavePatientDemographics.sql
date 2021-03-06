USE [Patient]
GO
/****** Object:  StoredProcedure [dbo].[SavePatientDemographics]    Script Date: 01-11-2018 11:41:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SavePatientDemographics]
(
	@Forename			VARCHAR(50),
	@Surname			VARCHAR(50),
	@Gender				VARCHAR(10), 
	@DOB				DATETIME,
	@Home				VARCHAR(10), 
	@Work				VARCHAR(10), 
	@Mobile				VARCHAR(10), 
	@CreatedBy			BIGINT,
	@CreatedDateTime	DATETIME,
	@Status				VARCHAR(10)
)

/*
	Summary: Insert patients demographics into respective tables
	Output: None
*/

AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @PatientID BIGINT

	INSERT 
	INTO dbo.PatientDemographics 
	(
		Forename, 
		Surname, 
		Gender, 
		DOB, 
		CreatedBy, 
		CreatedDateTime, 
		Status
	)
	VALUES 
	(
		@Forename, 
		@Surname, 
		@Gender, 
		@DOB, 
		@CreatedBy, 
		@CreatedDateTime, 
		@Status
	)

	--Gets recently inserted ptient id
	SET @PatientID = SCOPE_IDENTITY()

	IF @PatientID > 0
	BEGIN
		IF @Home IS NOT NULL
		BEGIN		
			INSERT 
			INTO dbo.ContactNumber 
			(
				PatientId, 
				ContactNumberType, 
				Number, 
				CreatedBy, 
				CreatedDateTime, 
				Status
			)
			SELECT 
				@PatientID, 
				ContactNoTypeID,
				@Home, 
				@CreatedBy, 
				@CreatedDateTime, 
				@Status
			FROM dbo.ContactNumberTypes
			WHERE ContactTypeName = 'Home'
		END

		IF @Work IS NOT NULL
		BEGIN
			INSERT 
			INTO 
			dbo.ContactNumber 
			(
				PatientId, 
				ContactNumberType, 
				Number, 
				CreatedBy, 
				CreatedDateTime, 
				Status
			)
			SELECT 
				@PatientID, 
				ContactNoTypeID,
				@Work, 
				@CreatedBy, 
				@CreatedDateTime, 
				@Status
			FROM dbo.ContactNumberTypes
			WHERE ContactTypeName = 'Work'
		END

		IF @Mobile IS NOT NULL
		BEGIN
			INSERT 
			INTO dbo.ContactNumber 
			(
				PatientId, 
				ContactNumberType, 
				Number, 
				CreatedBy, 
				CreatedDateTime, 
				Status
			)
			SELECT 
				@PatientID, 
				ContactNoTypeID,
				@Mobile, 
				@CreatedBy, 
				@CreatedDateTime, 
				@Status
			FROM dbo.ContactNumberTypes
			WHERE ContactTypeName = 'Mobile'
		END
	END

	SET NOCOUNT OFF;
END
GO


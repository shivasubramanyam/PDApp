USE [master]
GO
/****** Object:  Database [Patient]    Script Date: 01-11-2018 11:58:31 ******/
CREATE DATABASE [Patient]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'UserInfo', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\UserInfo.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'UserInfo_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\UserInfo_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Patient] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Patient].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Patient] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Patient] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Patient] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Patient] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Patient] SET ARITHABORT OFF 
GO
ALTER DATABASE [Patient] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Patient] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Patient] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Patient] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Patient] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Patient] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Patient] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Patient] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Patient] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Patient] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Patient] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Patient] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Patient] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Patient] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Patient] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Patient] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Patient] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Patient] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Patient] SET RECOVERY FULL 
GO
ALTER DATABASE [Patient] SET  MULTI_USER 
GO
ALTER DATABASE [Patient] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Patient] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Patient] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Patient] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Patient', N'ON'
GO
USE [Patient]
GO
/****** Object:  User [DemographicInfo]    Script Date: 01-11-2018 11:58:32 ******/
CREATE USER [DemographicInfo] FOR LOGIN [DemographicInfo] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [DemographicInfo]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [DemographicInfo]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [DemographicInfo]
GO
/****** Object:  StoredProcedure [dbo].[GetPatientList]    Script Date: 01-11-2018 11:58:32 ******/
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
/****** Object:  StoredProcedure [dbo].[SavePatientDemographics]    Script Date: 01-11-2018 11:58:32 ******/
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

AS

BEGIN

	

	SET NOCOUNT ON;

	DECLARE @PatientID BIGINT

	

	INSERT INTO dbo.PatientDemographics (Forename, Surname, Gender, DOB, CreatedBy, CreatedDateTime, Status)

	VALUES (@Forename, @Surname, @Gender, @DOB, @CreatedBy, @CreatedDateTime, @Status)



	SET @PatientID = SCOPE_IDENTITY()



	IF @PatientID > 0

	BEGIN

		IF @Home IS NOT NULL

		BEGIN
		
			INSERT INTO dbo.ContactNumber (PatientId, ContactNumberType, Number, CreatedBy, CreatedDateTime, Status)

			SELECT @PatientID, ContactNoTypeID,@Home, @CreatedBy, @CreatedDateTime, @Status

			FROM dbo.ContactNumberTypes

			WHERE ContactTypeName = 'Home'

		END



		IF @Work IS NOT NULL

		BEGIN

			INSERT INTO dbo.ContactNumber (PatientId, ContactNumberType, Number, CreatedBy, CreatedDateTime, Status)

			SELECT @PatientID, ContactNoTypeID,@Work, @CreatedBy, @CreatedDateTime, @Status

			FROM dbo.ContactNumberTypes

			WHERE ContactTypeName = 'Work'

		END



		IF @Mobile IS NOT NULL

		BEGIN

			INSERT INTO dbo.ContactNumber (PatientId, ContactNumberType, Number, CreatedBy, CreatedDateTime, Status)

			SELECT @PatientID, ContactNoTypeID,@Mobile, @CreatedBy, @CreatedDateTime, @Status

			FROM dbo.ContactNumberTypes

			WHERE ContactTypeName = 'Mobile'

		END

	END

	

	SET NOCOUNT OFF;
	RETURN @PatientID
END

GO
/****** Object:  Table [dbo].[ContactNumber]    Script Date: 01-11-2018 11:58:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContactNumber](
	[ContactID] [bigint] IDENTITY(1,1) NOT NULL,
	[PatientID] [bigint] NOT NULL,
	[ContactNumberType] [int] NOT NULL,
	[Number] [varchar](20) NOT NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedBy] [bigint] NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[Status] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ContactNumber] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactNumberTypes]    Script Date: 01-11-2018 11:58:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContactNumberTypes](
	[ContactNoTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ContactTypeName] [varchar](20) NOT NULL,
	[Description] [varchar](100) NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedBy] [bigint] NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[Status] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ContactNumberTypes] PRIMARY KEY CLUSTERED 
(
	[ContactNoTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PatientDemographics]    Script Date: 01-11-2018 11:58:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PatientDemographics](
	[PatientID] [bigint] IDENTITY(1,1) NOT NULL,
	[Forename] [varchar](50) NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[DOB] [date] NULL,
	[Gender] [varchar](6) NOT NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedBy] [bigint] NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[Status] [varchar](10) NOT NULL,
 CONSTRAINT [PK_PatientDemographics] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PatientDemographics_2]    Script Date: 01-11-2018 11:58:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PatientDemographics_2](
	[PatientID] [bigint] IDENTITY(1,1) NOT NULL,
	[PatientData] [xml] NOT NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedBy] [bigint] NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[Status] [varchar](10) NOT NULL,
 CONSTRAINT [PK_PatientDemographics_1] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ContactNumber] ON 

INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (1, 1, 1, N'9739477287', 0, CAST(N'2018-10-30 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (2, 1, 2, N'9874563210', 0, CAST(N'2018-10-30 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (3, 1, 3, N'7896541233', 0, CAST(N'2018-10-30 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (6, 3, 3, N'9449202137', 0, CAST(N'2018-10-30 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (7, 3, 1, N'8794562314', 0, CAST(N'2018-10-30 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (8, 10012, 1, N'7894561230', 0, CAST(N'2018-10-31 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (9, 10012, 2, N'5698741230', 0, CAST(N'2018-10-31 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (10, 10012, 3, N'4712589630', 0, CAST(N'2018-10-31 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (11, 10013, 1, N'7899877899', 0, CAST(N'2018-10-31 22:03:59.107' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (12, 10013, 2, N'8799877894', 0, CAST(N'2018-10-31 22:03:59.107' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (13, 10013, 3, N'9877789898', 0, CAST(N'2018-10-31 22:03:59.107' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (10008, 20003, 1, N'', 0, CAST(N'2018-11-01 09:51:31.347' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (10009, 20003, 2, N'', 0, CAST(N'2018-11-01 09:51:31.347' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumber] ([ContactID], [PatientID], [ContactNumberType], [Number], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (10010, 20003, 3, N'', 0, CAST(N'2018-11-01 09:51:31.347' AS DateTime), NULL, NULL, N'Active')
SET IDENTITY_INSERT [dbo].[ContactNumber] OFF
SET IDENTITY_INSERT [dbo].[ContactNumberTypes] ON 

INSERT [dbo].[ContactNumberTypes] ([ContactNoTypeID], [ContactTypeName], [Description], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (1, N'Home', N'Can either be a mobile or landline number of your home.', 0, CAST(N'2018-10-27 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumberTypes] ([ContactNoTypeID], [ContactTypeName], [Description], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (2, N'Work', N'Can either be a mobile or landline number of your work location', 0, CAST(N'2018-10-27 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[ContactNumberTypes] ([ContactNoTypeID], [ContactTypeName], [Description], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (3, N'Mobile', N'Your personal mobile number', 0, CAST(N'2018-10-27 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
SET IDENTITY_INSERT [dbo].[ContactNumberTypes] OFF
SET IDENTITY_INSERT [dbo].[PatientDemographics] ON 

INSERT [dbo].[PatientDemographics] ([PatientID], [Forename], [Surname], [DOB], [Gender], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (1, N'Shiva', N'Subramanyam', CAST(N'1992-12-02' AS Date), N'Male', 0, CAST(N'2018-10-30 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics] ([PatientID], [Forename], [Surname], [DOB], [Gender], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (3, N'Sudhakar', N'Subramanyam', CAST(N'0986-01-05' AS Date), N'Male', 0, CAST(N'2018-10-30 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics] ([PatientID], [Forename], [Surname], [DOB], [Gender], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (10012, N'Harry', N'Potter', CAST(N'1990-10-31' AS Date), N'Male', 0, CAST(N'2018-10-31 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics] ([PatientID], [Forename], [Surname], [DOB], [Gender], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (10013, N'Bruce', N'Wayne', CAST(N'1985-05-05' AS Date), N'Male', 0, CAST(N'2018-10-31 22:03:59.107' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics] ([PatientID], [Forename], [Surname], [DOB], [Gender], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (20003, N'Sampath', N'KUmar', CAST(N'1993-10-21' AS Date), N'Male', 0, CAST(N'2018-11-01 09:51:31.347' AS DateTime), NULL, NULL, N'Active')
SET IDENTITY_INSERT [dbo].[PatientDemographics] OFF
SET IDENTITY_INSERT [dbo].[PatientDemographics_2] ON 

INSERT [dbo].[PatientDemographics_2] ([PatientID], [PatientData], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (5, N'<patient forename="Sudhakar" surname="subramanyam" gender="Male" dob="01/05/1985"><contactdetails><telephone type="Mobile" number="9449202137" /><telephone type="Work" number="0445623897" /></contactdetails></patient>', 0, CAST(N'2018-10-29 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics_2] ([PatientID], [PatientData], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (6, N'<patient forename="Shiva" surname="subramanyam" gender="Male" dob="02/12/1992"><contactdetails><telephone type="Mobile" number="9739477287" /><telephone type="Work" number="4546554545" /><telephone type="Home" number="1234567890" /></contactdetails></patient>', 0, CAST(N'2018-10-29 00:00:00.000' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics_2] ([PatientID], [PatientData], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (9, N'<patient forename="Vinay" surname="uddi" gender="Male" dob="10/09/1988"><contactdetails><telephone type="Mobile" number="9742400076" /></contactdetails></patient>', 0, CAST(N'2018-10-29 18:07:11.613' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics_2] ([PatientID], [PatientData], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (11, N'<patient forename="Sampath" surname="Kumar" gender="Male" dob="02/8/1992"><contactdetails><telephone type="Mobile" number="9739473220" /><telephone type="Home" number="8963254170" /><telephone type="Work" number="7845123698" /></contactdetails></patient>', 0, CAST(N'2018-10-29 20:04:58.287' AS DateTime), NULL, NULL, N'Active')
INSERT [dbo].[PatientDemographics_2] ([PatientID], [PatientData], [CreatedBy], [CreatedDateTime], [LastUpdatedBy], [LastUpdatedDateTime], [Status]) VALUES (12, N'<patient forename="Tarun" surname="Teja" gender="Male" dob="10/09/2015"><contactdetails><telephone type="Mobile" number="9797394772" /></contactdetails></patient>', 0, CAST(N'2018-10-29 20:35:03.293' AS DateTime), NULL, NULL, N'Active')
SET IDENTITY_INSERT [dbo].[PatientDemographics_2] OFF
ALTER TABLE [dbo].[ContactNumber]  WITH CHECK ADD  CONSTRAINT [FK_ContactNumberType_ContactNumber] FOREIGN KEY([ContactNumberType])
REFERENCES [dbo].[ContactNumberTypes] ([ContactNoTypeID])
GO
ALTER TABLE [dbo].[ContactNumber] CHECK CONSTRAINT [FK_ContactNumberType_ContactNumber]
GO
ALTER TABLE [dbo].[ContactNumber]  WITH CHECK ADD  CONSTRAINT [FK_PatientDemographics_ContactDetails] FOREIGN KEY([PatientID])
REFERENCES [dbo].[PatientDemographics] ([PatientID])
GO
ALTER TABLE [dbo].[ContactNumber] CHECK CONSTRAINT [FK_PatientDemographics_ContactDetails]
GO
USE [master]
GO
ALTER DATABASE [Patient] SET  READ_WRITE 
GO

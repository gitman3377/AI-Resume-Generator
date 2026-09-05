USE [testing_db]
GO
/****** Object:  Table [dbo].[Academic_record]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Academic_record](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[qualification_level] [text] NULL,
	[course] [text] NULL,
	[total_marks] [text] NULL,
	[obtained_marks] [text] NULL,
	[evaluation_metric] [text] NULL,
	[backlogs] [bit] NULL,
	[is_delete] [int] NULL,
	[UserId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Certifications]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Certifications](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NULL,
	[name] [text] NULL,
	[issuer] [text] NULL,
	[certificate_path] [text] NULL,
	[date] [date] NULL,
	[is_delete] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Internship]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Internship](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NULL,
	[internship_name] [text] NULL,
	[company_name] [text] NULL,
	[role_title] [text] NULL,
	[duration] [text] NULL,
	[from_date] [datetime] NULL,
	[to_date] [datetime] NULL,
	[stipend] [bit] NULL,
	[mentor] [text] NULL,
	[internship_type] [text] NULL,
	[certificate] [text] NULL,
	[is_delete] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NULL,
	[language] [text] NULL,
	[profeciency_level] [text] NULL,
	[mother_tongue] [text] NULL,
	[is_delete] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Resume]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resume](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NULL,
	[title] [nvarchar](150) NULL,
	[template_type] [nvarchar](50) NULL,
	[created_date] [date] NULL,
	[resume_path] [varchar](150) NULL,
	[is_delete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_skill_set]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_skill_set](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NULL,
	[skills] [text] NULL,
	[toolchain] [text] NULL,
	[domains] [text] NULL,
	[soft_skills] [text] NULL,
	[is_delete] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGeneralInfo]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGeneralInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[firstname] [text] NULL,
	[lastname] [text] NULL,
	[email] [text] NULL,
	[mobile_number] [text] NULL,
	[residential_address] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NULL,
	[email] [varchar](100) NULL,
	[password] [nvarchar](64) NULL,
	[created_date] [date] NULL,
	[is_delete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Academic_record] ADD  DEFAULT ((0)) FOR [backlogs]
GO
ALTER TABLE [dbo].[Academic_record] ADD  DEFAULT ((0)) FOR [is_delete]
GO
ALTER TABLE [dbo].[Certifications] ADD  DEFAULT ((0)) FOR [is_delete]
GO
ALTER TABLE [dbo].[Internship] ADD  DEFAULT ((0)) FOR [is_delete]
GO
ALTER TABLE [dbo].[Language] ADD  DEFAULT ((0)) FOR [is_delete]
GO
ALTER TABLE [dbo].[Resume] ADD  CONSTRAINT [DF_Resume_is_delete]  DEFAULT ((0)) FOR [is_delete]
GO
ALTER TABLE [dbo].[User_skill_set] ADD  DEFAULT ((0)) FOR [is_delete]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_is_delete]  DEFAULT ((0)) FOR [is_delete]
GO
/****** Object:  StoredProcedure [dbo].[ManageUsers]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ManageUsers]
    @i_name VARCHAR(255),
	@i_user_id int,
    @i_email VARCHAR(255),
    @i_password NVARCHAR(64),
    @i_process_by VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
	Declare @date date;

	SELECT @date = CAST(GETDATE() AS date);

    IF @i_process_by = 'add'
    BEGIN
	IF NOT EXISTS(SELECT 1 FROM Users WHERE name = @i_name AND email = @i_email AND is_delete = 0)
		BEGIN
			INSERT INTO Users (name, email, password, created_date, is_delete)
			VALUES (@i_name, @i_email, @i_password, @date, 0);

			SELECT 1 AS resultvalue, 'User added successfully' AS resultmessage;
		END
	ELSE
		BEGIN
			SELECT -1 AS resultvalue, 'User already exists' AS resultmessage;
		END
	END	
    ELSE if @i_process_by = 'update'
    BEGIN
		IF EXISTS (SELECT 1 FROM USERS WHERE id = @i_user_id AND is_delete = 0)
		BEGIN
		UPDATE Users
		SET		name = @i_name
			,	email = @i_email
			,	password = @i_password
			,	created_date = @date
		WHERE id = @i_user_id;
        SELECT 1 AS resultvalue, 'User updated successfully' AS resultmessage;
    END
	ELSE
		BEGIN
			SELECT -2 AS resultvalue, 'User does not exists' AS resultmessage;
		END
	END
	ELSE if @i_process_by = 'delete'
    BEGIN
		IF EXISTS (SELECT 1 FROM USERS WHERE id = @i_user_id AND is_delete = 0)
		BEGIN
			UPDATE Users
			SET	 is_delete = 1	
			WHERE id = @i_user_id;
			SELECT 0 AS resultvalue, 'User already deleted or not found' AS resultmessage;
		END
		ELSE
		BEGIN
			SELECT 0 AS resultvalue, 'User deleted successfully' AS resultmessage;
		END
	END
	ELSE
	BEGIN
		SELECT -2 AS resultvalue, 'Invalid operation requested' AS resultmessage;
	END
END;
GO
/****** Object:  StoredProcedure [dbo].[sploginuser]    Script Date: 02-09-2026 15:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sploginuser]
	@i_email NVARCHAR(64)

AS 
BEGIN

	IF EXISTS(SELECT 1 FROM Users WHERE email = @i_email AND is_delete = 0)
		BEGIN
			SELECT 
				1 as resultvalue,
				'Authorised User' as resultmessage, 
				password
			FROM Users 
			where email = @i_email AND is_delete = 0
		END
	ELSE
		BEGIN
		SELECT 
			0 as resultvalue,
			'Unauthorised User' as resultmessage
		END;
END;
GO
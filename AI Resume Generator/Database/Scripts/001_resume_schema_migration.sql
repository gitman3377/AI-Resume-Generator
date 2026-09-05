USE [testing_db];
GO

/* ============================================================
   AI RESUME GENERATOR
   PHASE 1 - RESUME SCHEMA MIGRATION
   File: 001_resume_schema_migration.sql

   Purpose
   - Add resumeId relationships to all resume section tables
   - Fix UserGeneralInfo structure
   - Replace deprecated TEXT columns with NVARCHAR
   - Change Internship.stipend from BIT to text
   - Standardise section is_delete columns as BIT NOT NULL DEFAULT 0
   - Add foreign keys and indexes

   Notes
   - Designed to tolerate a partially completed Phase 1 migration.
   - Legacy userId columns in child tables are intentionally retained
     until the new ResumeData flow is working end-to-end.
   ============================================================ */

/* ============================================================
   1. ADD resumeId TO RESUME SECTION TABLES
   ============================================================ */
IF COL_LENGTH('dbo.UserGeneralInfo', 'resumeId') IS NULL
    ALTER TABLE dbo.UserGeneralInfo ADD resumeId INT NULL;
GO

IF COL_LENGTH('dbo.Academic_record', 'resumeId') IS NULL
    ALTER TABLE dbo.Academic_record ADD resumeId INT NULL;
GO

IF COL_LENGTH('dbo.Certifications', 'resumeId') IS NULL
    ALTER TABLE dbo.Certifications ADD resumeId INT NULL;
GO

IF COL_LENGTH('dbo.Internship', 'resumeId') IS NULL
    ALTER TABLE dbo.Internship ADD resumeId INT NULL;
GO

IF COL_LENGTH('dbo.Language', 'resumeId') IS NULL
    ALTER TABLE dbo.Language ADD resumeId INT NULL;
GO

IF COL_LENGTH('dbo.User_skill_set', 'resumeId') IS NULL
    ALTER TABLE dbo.User_skill_set ADD resumeId INT NULL;
GO

/* ============================================================
   2. FIX UserGeneralInfo
   ============================================================ */
IF COL_LENGTH('dbo.UserGeneralInfo', 'is_delete') IS NULL
BEGIN
    ALTER TABLE dbo.UserGeneralInfo
    ADD is_delete BIT NOT NULL
        CONSTRAINT DF_UserGeneralInfo_is_delete DEFAULT (0);
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.key_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.UserGeneralInfo')
      AND type = 'PK'
)
BEGIN
    ALTER TABLE dbo.UserGeneralInfo
    ADD CONSTRAINT PK_UserGeneralInfo PRIMARY KEY (id);
END;
GO

/* ============================================================
   3. REPLACE DEPRECATED TEXT COLUMNS
   ============================================================ */
ALTER TABLE dbo.UserGeneralInfo ALTER COLUMN firstname NVARCHAR(100) NULL;
ALTER TABLE dbo.UserGeneralInfo ALTER COLUMN lastname NVARCHAR(100) NULL;
ALTER TABLE dbo.UserGeneralInfo ALTER COLUMN email NVARCHAR(255) NULL;
ALTER TABLE dbo.UserGeneralInfo ALTER COLUMN mobile_number NVARCHAR(50) NULL;
ALTER TABLE dbo.UserGeneralInfo ALTER COLUMN residential_address NVARCHAR(500) NULL;
GO

ALTER TABLE dbo.Academic_record ALTER COLUMN qualification_level NVARCHAR(150) NULL;
ALTER TABLE dbo.Academic_record ALTER COLUMN course NVARCHAR(250) NULL;
ALTER TABLE dbo.Academic_record ALTER COLUMN total_marks NVARCHAR(50) NULL;
ALTER TABLE dbo.Academic_record ALTER COLUMN obtained_marks NVARCHAR(50) NULL;
ALTER TABLE dbo.Academic_record ALTER COLUMN evaluation_metric NVARCHAR(100) NULL;
GO

ALTER TABLE dbo.Certifications ALTER COLUMN name NVARCHAR(250) NULL;
ALTER TABLE dbo.Certifications ALTER COLUMN issuer NVARCHAR(250) NULL;
ALTER TABLE dbo.Certifications ALTER COLUMN certificate_path NVARCHAR(500) NULL;
GO

ALTER TABLE dbo.Internship ALTER COLUMN internship_name NVARCHAR(250) NULL;
ALTER TABLE dbo.Internship ALTER COLUMN company_name NVARCHAR(250) NULL;
ALTER TABLE dbo.Internship ALTER COLUMN role_title NVARCHAR(200) NULL;
ALTER TABLE dbo.Internship ALTER COLUMN duration NVARCHAR(100) NULL;
ALTER TABLE dbo.Internship ALTER COLUMN mentor NVARCHAR(200) NULL;
ALTER TABLE dbo.Internship ALTER COLUMN internship_type NVARCHAR(100) NULL;
ALTER TABLE dbo.Internship ALTER COLUMN certificate NVARCHAR(500) NULL;
ALTER TABLE dbo.Internship ALTER COLUMN stipend NVARCHAR(100) NULL;
GO

ALTER TABLE dbo.Language ALTER COLUMN language NVARCHAR(100) NULL;
ALTER TABLE dbo.Language ALTER COLUMN profeciency_level NVARCHAR(100) NULL;
ALTER TABLE dbo.Language ALTER COLUMN mother_tongue NVARCHAR(100) NULL;
GO

ALTER TABLE dbo.User_skill_set ALTER COLUMN skills NVARCHAR(MAX) NULL;
ALTER TABLE dbo.User_skill_set ALTER COLUMN toolchain NVARCHAR(MAX) NULL;
ALTER TABLE dbo.User_skill_set ALTER COLUMN domains NVARCHAR(MAX) NULL;
ALTER TABLE dbo.User_skill_set ALTER COLUMN soft_skills NVARCHAR(MAX) NULL;
GO

/* ============================================================
   4. STANDARDISE is_delete AS BIT NOT NULL DEFAULT 0

   Existing tables use auto-generated default constraint names such as
   DF__Academic___is_de__693CA210. SQL Server will not ALTER the
   column while that constraint exists, so each block:
     1) finds and drops the existing default constraint,
     2) replaces NULL with 0,
     3) changes the column to BIT NOT NULL,
     4) creates a stable named DEFAULT(0) constraint.
   ============================================================ */

/* Academic_record */
DECLARE @ConstraintName NVARCHAR(128);
SELECT @ConstraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
  ON dc.parent_object_id = c.object_id
 AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Academic_record')
  AND c.name = 'is_delete';

IF @ConstraintName IS NOT NULL
    EXEC('ALTER TABLE dbo.Academic_record DROP CONSTRAINT [' + @ConstraintName + ']');

UPDATE dbo.Academic_record SET is_delete = 0 WHERE is_delete IS NULL;
ALTER TABLE dbo.Academic_record ALTER COLUMN is_delete BIT NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.Academic_record')
      AND name = 'DF_AcademicRecord_is_delete'
)
    ALTER TABLE dbo.Academic_record
    ADD CONSTRAINT DF_AcademicRecord_is_delete DEFAULT (0) FOR is_delete;
GO

/* Certifications */
DECLARE @ConstraintName NVARCHAR(128);
SELECT @ConstraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
  ON dc.parent_object_id = c.object_id
 AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Certifications')
  AND c.name = 'is_delete';

IF @ConstraintName IS NOT NULL
    EXEC('ALTER TABLE dbo.Certifications DROP CONSTRAINT [' + @ConstraintName + ']');

UPDATE dbo.Certifications SET is_delete = 0 WHERE is_delete IS NULL;
ALTER TABLE dbo.Certifications ALTER COLUMN is_delete BIT NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.Certifications')
      AND name = 'DF_Certifications_is_delete'
)
    ALTER TABLE dbo.Certifications
    ADD CONSTRAINT DF_Certifications_is_delete DEFAULT (0) FOR is_delete;
GO

/* Internship */
DECLARE @ConstraintName NVARCHAR(128);
SELECT @ConstraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
  ON dc.parent_object_id = c.object_id
 AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Internship')
  AND c.name = 'is_delete';

IF @ConstraintName IS NOT NULL
    EXEC('ALTER TABLE dbo.Internship DROP CONSTRAINT [' + @ConstraintName + ']');

UPDATE dbo.Internship SET is_delete = 0 WHERE is_delete IS NULL;
ALTER TABLE dbo.Internship ALTER COLUMN is_delete BIT NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.Internship')
      AND name = 'DF_Internship_is_delete'
)
    ALTER TABLE dbo.Internship
    ADD CONSTRAINT DF_Internship_is_delete DEFAULT (0) FOR is_delete;
GO

/* Language */
DECLARE @ConstraintName NVARCHAR(128);
SELECT @ConstraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
  ON dc.parent_object_id = c.object_id
 AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Language')
  AND c.name = 'is_delete';

IF @ConstraintName IS NOT NULL
    EXEC('ALTER TABLE dbo.Language DROP CONSTRAINT [' + @ConstraintName + ']');

UPDATE dbo.Language SET is_delete = 0 WHERE is_delete IS NULL;
ALTER TABLE dbo.Language ALTER COLUMN is_delete BIT NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.Language')
      AND name = 'DF_Language_is_delete'
)
    ALTER TABLE dbo.Language
    ADD CONSTRAINT DF_Language_is_delete DEFAULT (0) FOR is_delete;
GO

/* User_skill_set */
DECLARE @ConstraintName NVARCHAR(128);
SELECT @ConstraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
  ON dc.parent_object_id = c.object_id
 AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.User_skill_set')
  AND c.name = 'is_delete';

IF @ConstraintName IS NOT NULL
    EXEC('ALTER TABLE dbo.User_skill_set DROP CONSTRAINT [' + @ConstraintName + ']');

UPDATE dbo.User_skill_set SET is_delete = 0 WHERE is_delete IS NULL;
ALTER TABLE dbo.User_skill_set ALTER COLUMN is_delete BIT NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.User_skill_set')
      AND name = 'DF_UserSkillSet_is_delete'
)
    ALTER TABLE dbo.User_skill_set
    ADD CONSTRAINT DF_UserSkillSet_is_delete DEFAULT (0) FOR is_delete;
GO

/* ============================================================
   5. FOREIGN KEYS
   ============================================================ */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Resume_Users')
    ALTER TABLE dbo.Resume
    ADD CONSTRAINT FK_Resume_Users FOREIGN KEY (userId) REFERENCES dbo.Users(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_UserGeneralInfo_Resume')
    ALTER TABLE dbo.UserGeneralInfo
    ADD CONSTRAINT FK_UserGeneralInfo_Resume FOREIGN KEY (resumeId) REFERENCES dbo.Resume(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_AcademicRecord_Resume')
    ALTER TABLE dbo.Academic_record
    ADD CONSTRAINT FK_AcademicRecord_Resume FOREIGN KEY (resumeId) REFERENCES dbo.Resume(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Certifications_Resume')
    ALTER TABLE dbo.Certifications
    ADD CONSTRAINT FK_Certifications_Resume FOREIGN KEY (resumeId) REFERENCES dbo.Resume(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Internship_Resume')
    ALTER TABLE dbo.Internship
    ADD CONSTRAINT FK_Internship_Resume FOREIGN KEY (resumeId) REFERENCES dbo.Resume(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Language_Resume')
    ALTER TABLE dbo.Language
    ADD CONSTRAINT FK_Language_Resume FOREIGN KEY (resumeId) REFERENCES dbo.Resume(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_UserSkillSet_Resume')
    ALTER TABLE dbo.User_skill_set
    ADD CONSTRAINT FK_UserSkillSet_Resume FOREIGN KEY (resumeId) REFERENCES dbo.Resume(id);
GO

/* ============================================================
   6. INDEXES
   ============================================================ */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Resume_userId' AND object_id = OBJECT_ID('dbo.Resume'))
    CREATE INDEX IX_Resume_userId ON dbo.Resume(userId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserGeneralInfo_resumeId' AND object_id = OBJECT_ID('dbo.UserGeneralInfo'))
    CREATE INDEX IX_UserGeneralInfo_resumeId ON dbo.UserGeneralInfo(resumeId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AcademicRecord_resumeId' AND object_id = OBJECT_ID('dbo.Academic_record'))
    CREATE INDEX IX_AcademicRecord_resumeId ON dbo.Academic_record(resumeId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Certifications_resumeId' AND object_id = OBJECT_ID('dbo.Certifications'))
    CREATE INDEX IX_Certifications_resumeId ON dbo.Certifications(resumeId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Internship_resumeId' AND object_id = OBJECT_ID('dbo.Internship'))
    CREATE INDEX IX_Internship_resumeId ON dbo.Internship(resumeId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Language_resumeId' AND object_id = OBJECT_ID('dbo.Language'))
    CREATE INDEX IX_Language_resumeId ON dbo.Language(resumeId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserSkillSet_resumeId' AND object_id = OBJECT_ID('dbo.User_skill_set'))
    CREATE INDEX IX_UserSkillSet_resumeId ON dbo.User_skill_set(resumeId);
GO

/* ============================================================
   7. VERIFICATION
   ============================================================ */

/* Verify relevant column types */
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN
(
    'UserGeneralInfo',
    'Academic_record',
    'Certifications',
    'Internship',
    'Language',
    'User_skill_set'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

/* Verify foreign keys */
SELECT
    fk.name AS ForeignKey,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
  ON fk.object_id = fkc.constraint_object_id
WHERE fk.name LIKE 'FK_%Resume%'
   OR fk.name = 'FK_Resume_Users'
ORDER BY ChildTable;
GO

/* ============================================================
   8. OPTIONAL FK TEST - RUN MANUALLY IF REQUIRED
   ============================================================

BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Academic_record
    (
        qualification_level,
        course,
        resumeId,
        is_delete
    )
    VALUES
    (
        'Test',
        'Test Course',
        99999999,
        0
    );
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,
           ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
ROLLBACK TRANSACTION;

Expected result: the insert is rejected because resumeId 99999999
has no matching record in dbo.Resume.

   ============================================================ */

/* ============================================================
   LEGACY COLUMNS INTENTIONALLY RETAINED FOR NOW
   - Academic_record.UserId
   - Certifications.userId
   - Internship.userId
   - Language.userId
   - User_skill_set.userId

   These will be considered for removal after the new ResumeData
   save/retrieval flow has been implemented and tested.
   ============================================================ */
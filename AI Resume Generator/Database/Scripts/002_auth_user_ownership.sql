USE [testing_db];
GO

/* ============================================================
   AI RESUME GENERATOR
   PHASE 2 - AUTHENTICATION & USER OWNERSHIP

   Purpose
   - Return the actual database user ID during login.
   - Keep the existing password verification architecture.
   - Return a consistent result shape when the email does not exist.

   Note
   - Password verification continues to occur in the C# DAL.
   - JWT authentication will be implemented in a later phase.
   ============================================================ */

ALTER PROCEDURE [dbo].[sploginuser]
    @i_email NVARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Users
        WHERE email = @i_email
          AND is_delete = 0
    )
    BEGIN
        SELECT
            1 AS resultvalue,
            'Authorised User' AS resultmessage,
            id AS userid,
            password
        FROM dbo.Users
        WHERE email = @i_email
          AND is_delete = 0;
    END
    ELSE
    BEGIN
        SELECT
            0 AS resultvalue,
            'Unauthorised User' AS resultmessage,
            0 AS userid,
            CAST('' AS NVARCHAR(64)) AS password;
    END;
END;
GO


/* ============================================================
   MANAGE USERS - ENFORCE UNIQUE LOGIN EMAIL

   Email is the login identifier, therefore two active users
   must not share the same email address.
   ============================================================ */

ALTER PROCEDURE [dbo].[ManageUsers]
    @i_name VARCHAR(255),
    @i_user_id INT,
    @i_email VARCHAR(255),
    @i_password NVARCHAR(64),
    @i_process_by VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @date DATE;
    SELECT @date = CAST(GETDATE() AS DATE);

    /* -------------------------
       ADD USER
       ------------------------- */
    IF @i_process_by = 'add'
    BEGIN

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Users
            WHERE email = @i_email
              AND is_delete = 0
        )
        BEGIN

            INSERT INTO dbo.Users
            (
                name,
                email,
                password,
                created_date,
                is_delete
            )
            VALUES
            (
                @i_name,
                @i_email,
                @i_password,
                @date,
                0
            );

            SELECT
                1 AS resultvalue,
                'User added successfully' AS resultmessage;
        END
        ELSE
        BEGIN

            SELECT
                -1 AS resultvalue,
                'Email already registered' AS resultmessage;
        END

    END

    /* -------------------------
       UPDATE USER
       ------------------------- */
    ELSE IF @i_process_by = 'update'
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM dbo.Users
            WHERE id = @i_user_id
              AND is_delete = 0
        )
        BEGIN

            IF NOT EXISTS
            (
                SELECT 1
                FROM dbo.Users
                WHERE email = @i_email
                  AND id <> @i_user_id
                  AND is_delete = 0
            )
            BEGIN

                UPDATE dbo.Users
                SET
                    name = @i_name,
                    email = @i_email,
                    password = @i_password,
                    created_date = @date
                WHERE id = @i_user_id;

                SELECT
                    1 AS resultvalue,
                    'User updated successfully' AS resultmessage;

            END
            ELSE
            BEGIN

                SELECT
                    -1 AS resultvalue,
                    'Email already registered' AS resultmessage;

            END

        END
        ELSE
        BEGIN

            SELECT
                -2 AS resultvalue,
                'User does not exist' AS resultmessage;

        END

    END

    /* -------------------------
       DELETE USER
       ------------------------- */
    ELSE IF @i_process_by = 'delete'
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM dbo.Users
            WHERE id = @i_user_id
              AND is_delete = 0
        )
        BEGIN

            UPDATE dbo.Users
            SET is_delete = 1
            WHERE id = @i_user_id;

            SELECT
                1 AS resultvalue,
                'User deleted successfully' AS resultmessage;

        END
        ELSE
        BEGIN

            SELECT
                0 AS resultvalue,
                'User already deleted or not found' AS resultmessage;

        END

    END

    ELSE
    BEGIN

        SELECT
            -2 AS resultvalue,
            'Invalid operation requested' AS resultmessage;

    END

END;
GO
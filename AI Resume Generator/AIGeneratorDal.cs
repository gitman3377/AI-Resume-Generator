using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using AI_Resume_Generator;

namespace AI_Resume_Generator
{
	public class AIGeneratorDal : DBConnection
	{
		public List<UserLogin_Response> ManageUsers(UserLogin_Request obj)
		{
			DataTable dt = new DataTable();
			string connectionstring = ConfigurationManager.ConnectionStrings["SqlDbConnection"].ConnectionString;

			using (SqlConnection conn = new SqlConnection(connectionstring))
			{
                string hashedPassword = HelperFunction.PasswordHashing(obj.password);
                conn.Open();
				var Transaction = conn.BeginTransaction();
				var cmd = new SqlCommand("ManageUsers", conn);
				cmd.Parameters.AddWithValue("@i_name", obj.name);
                cmd.Parameters.AddWithValue("@i_user_id", obj.userid);
                cmd.Parameters.AddWithValue("@i_email", obj.email);
                cmd.Parameters.AddWithValue("@i_password", hashedPassword);
                cmd.Parameters.AddWithValue("@i_process_by", obj.process_by);
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Transaction = Transaction;
				SqlDataAdapter da = new SqlDataAdapter(cmd);
				da.Fill(dt);
				cmd.Transaction.Commit();
				da.Dispose();
				conn.Close();
            }
			List<UserLogin_Response> rslt = new List<UserLogin_Response>();
			rslt = ConvertDataTable<UserLogin_Response>(dt);
			return rslt;
		}

        public AuthoriseLogin_Response AuthoriseUser(string password, string email)
        {
            DataTable dt = new DataTable();

            string connectionstring =
                ConfigurationManager.ConnectionStrings["SqlDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                conn.Open();

                var Transaction = conn.BeginTransaction();

                var cmd = new SqlCommand("sploginuser", conn);

                cmd.Parameters.AddWithValue("@i_email", email);

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Transaction = Transaction;

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);

                cmd.Transaction.Commit();

                da.Dispose();
                conn.Close();
            }

            List<AuthoriseLogin_Response> rslt =
                ConvertDataTable<AuthoriseLogin_Response>(dt);

            // Safety check in case the stored procedure unexpectedly returns no rows.
            if (rslt == null || rslt.Count == 0)
            {
                return new AuthoriseLogin_Response
                {
                    resultvalue = 0,
                    resultmessage = "Unauthorised User",
                    userid = 0
                };
            }

            AuthoriseLogin_Response response = rslt[0];

            // If the email was not found, do not attempt password verification.
            if (response.resultvalue != 1 || string.IsNullOrEmpty(response.password))
            {
                response.resultvalue = 0;
                response.resultmessage = "Unauthorised User";
                response.userid = 0;
                response.password = null;

                return response;
            }

            bool verifyPassword =
                HelperFunction.VerifyPassword(password, response.password);

            // Password/hash is only required internally for verification.
            response.password = null;

            if (verifyPassword)
            {
                response.resultvalue = 1;
                response.resultmessage = "Authorised User";

                // Keep the userid returned by sploginuser.
            }
            else
            {
                response.resultvalue = 0;
                response.resultmessage = "Unauthorised User";
                response.userid = 0;
            }

            return response;
        }

    }
}
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
			string connectionstring = ConfigurationManager.ConnectionStrings["SqlDbConnection"].ConnectionString;

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
			List<AuthoriseLogin_Response> rslt = new List<AuthoriseLogin_Response>();
            rslt = ConvertDataTable<AuthoriseLogin_Response>(dt);
            var verifypassword = HelperFunction.VerifyPassword(password, rslt[0].password);
			if(verifypassword == true)
			{
				rslt[0].resultvalue = 1;
				rslt[0].resultmessage = "Authorised User";

            }
			else
			{
                rslt[0].resultvalue = 0;
                rslt[0].resultmessage = "Unauthorised User";
            }
			return rslt[0];
		}	

    }
}
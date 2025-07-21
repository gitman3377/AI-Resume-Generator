using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;

namespace AI_Resume_Generator
{
	public class HelperFunction
	{
		public static string PasswordHashing(string password)
		{
			byte[] salt;
			new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);

			var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 100000);
			byte[] hash = pbkdf2.GetBytes(20);

			byte[] hashbytes = new byte[36];
			Array.Copy(salt, 0, hashbytes, 0, 16);
            Array.Copy(hash, 0, hashbytes, 16, 20);

			return Convert.ToBase64String(hashbytes);
        }

		public static bool VerifyPassword(string inputpassword, string storedhash)
		{
			byte[] hashbytes = Convert.FromBase64String(storedhash);

			byte[] salt = new byte[16];
			Array.Copy(hashbytes, 0, salt, 0, 16);

			var pbkdf2 = new Rfc2898DeriveBytes(inputpassword, salt, 100000);
			byte[] inputhash = pbkdf2.GetBytes(20);

			for (int i = 0; i < 20; i++)
			{
				if (hashbytes[i + 16] != inputhash[i])
				{
					return false;
				}
			}
			return true;
		}
	}
}
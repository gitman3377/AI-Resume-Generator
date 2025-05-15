using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AI_Resume_Generator
{
		public class UserLogin_Response
		{
			public int resultvalue { get; set; }
            public string resultmessage { get; set; }
        }

		public class UserLogin_Request
		{
			public string name { get; set; }
			public int userid { get; set; }
			public string email { get; set; }
			public string password { get; set; }
            public string process_by { get; set; }
        }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AI_Resume_Generator
{
	public class AIGeneratorBal
	{
		public static List<UserLogin_Response>ManageUsers (UserLogin_Request obj)
		{
            AIGeneratorDal objDal = new AIGeneratorDal();
            return objDal.ManageUsers(obj);
        }

    }
}
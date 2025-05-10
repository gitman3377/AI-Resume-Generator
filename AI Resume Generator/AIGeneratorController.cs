using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;

namespace AI_Resume_Generator
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class AIGeneratorController: ApiController
    {
		[HttpPost]
		[Route("api/AIGenerator/ManageUsers")]
		public HttpResponseMessage ManageUsers (HttpRequestMessage request, UserLogin_Request obj)
		{
			try
			{
				HttpResponseMessage result = new HttpResponseMessage();
				List<UserLogin_Response> res = new List<UserLogin_Response>();
				res = AIGeneratorBal.ManageUsers(obj);
				result = request.CreateResponse(HttpStatusCode.Created, res);
				return result;

			}
			catch(Exception e)
			{
                List<UserLogin_Response> resultlist = new List<UserLogin_Response>();
				UserLogin_Response resobj = new UserLogin_Response();
				resobj.resultvalue = -1;
				resobj.resultmessage = e.Message;
				resultlist.Add(resobj);
				return request.CreateResponse<List<UserLogin_Response>>(HttpStatusCode.BadRequest, resultlist);
            }
		}

    }
}
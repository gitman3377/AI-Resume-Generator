using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace AI_Resume_Generator.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }
    }
}

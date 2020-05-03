using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace local.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult LocalInventory()
        {
            PowerShell shell = PowerShell.Create();

            string path = Server.MapPath("~/Out");
            shell.Commands.AddScript(path + "\\GetInventory.ps1 -ComputerName localhost -Nomail");

            var results = shell.Invoke();
            if (results.Count > 0)
            {
                var builder = new StringBuilder();
                foreach (var psObject in results)
                {
                    builder.Append(psObject.BaseObject.ToString() + "\r\n");
                }
                string outpath = (path + "\\Dev.html");

                ViewBag.Results = Server.HtmlEncode(builder.ToString());
                string decodestr = WebUtility.HtmlDecode(ViewBag.Results);

                System.IO.File.WriteAllText(outpath, decodestr);
            }

            List<SelectListItem> Env = new List<SelectListItem>() {
                new SelectListItem {
                    Text = "Dev", Value = "Dev"
                },
                new SelectListItem {
                    Text = "Prod", Value = "Prod"
                },
            };

            ViewBag.Results = Env;

            return View();
        }
    }
}
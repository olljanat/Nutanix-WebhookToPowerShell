using System;
using System.Management.Automation;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebhookToPowerShell.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class Controller : ControllerBase
    {
        [HttpGet]
        public ActionResult Index()
        {
            return Content("Nothing to see here!");
        }

        [HttpPost]
        public async Task<string> ReadStringDataManual()
        {   
            using (StreamReader reader = new StreamReader(Request.Body, Encoding.UTF8))
            {
                var content = await reader.ReadToEndAsync();
                PowerShell.Create().
                        AddCommand(Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + "/Scripts/ProcessWebhooks.ps1").
                        AddParameter("Data", content).
                        Invoke();
            }
            return "";
        }
    }
}

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
            var logFolder = System.IO.Path.GetTempPath() + "WebhookToPowerShell";
            if (!Directory.Exists(logFolder)) {
                Directory.CreateDirectory(logFolder);
            }

            var logPath = logFolder + "/" + Guid.NewGuid() + ".json";
            System.Console.WriteLine("Saving web hook to file: " + logPath);
            using (StreamReader reader = new StreamReader(Request.Body, Encoding.UTF8))
            {  
                using (var writer = System.IO.File.CreateText(logPath)) {
                    writer.Write(await reader.ReadToEndAsync());
                }
            }

            using (var ps = PowerShell.Create())
            {
                var command = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + "/Scripts/ProcessWebhooks.ps1";
                ps.AddScript(command);
                ps.Invoke();
            }

            return "";
        }
    }
}

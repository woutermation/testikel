using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Reflection;

namespace MyWebApp.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SampleController(
        ILogger<SampleController> logger,
        IConfiguration config
        ) : ControllerBase
    {
        private readonly string logPrefix = MethodBase.GetCurrentMethod()?.DeclaringType?.Name ?? "";
        private readonly ILogger<SampleController> _logger = logger;
        private readonly IConfiguration _config = config;

        [HttpGet]
        [Authorize]
        public string Get()
        {
            string test = "test";
            _logger.LogTrace("[ {test} ] Get method was called", test);
            return $"Hello from API! {DateTime.Now:HH:mm:ss tt}";
        }
    }
}
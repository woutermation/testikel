using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MyWebApp.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SampleController(ILogger<SampleController> logger) : ControllerBase
    {
        private readonly ILogger<SampleController> _logger = logger;

        [HttpGet]
        public string Get()
        {
            string test = "test";
            _logger.LogTrace("[ {test} ] Get method was called", test);
            return $"Hello from API! {DateTime.Now:HH:mm:ss tt}";
        }
    }
}
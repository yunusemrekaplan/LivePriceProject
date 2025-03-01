using LivePriceBackend.Services.ParityServices;
using Microsoft.AspNetCore.Mvc;

namespace LivePriceBackend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HamParitiesController : ControllerBase
{
    [HttpGet("harem")]
    public async Task<IActionResult> GetHarem()
    {
        var data = await HaremService.GetAll();
        return Ok(data);
    }
    
    [HttpGet("luna")]
    public async Task<IActionResult> GetLuna()
    {
        var data = await LunaService.GetAll();
        return Ok(data);
    }
    
}
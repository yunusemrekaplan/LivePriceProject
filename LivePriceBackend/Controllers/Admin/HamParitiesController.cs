using LivePriceBackend.Services.ParityServices;
using Microsoft.AspNetCore.Mvc;

namespace LivePriceBackend.Controllers.Admin;

[ApiController]
[Route("api/admin/[controller]")]
public class HamParitiesController : ControllerBase
{
    [HttpGet("luna")]
    public async Task<IActionResult> GetLuna()
    {
        var data = await LunaService.GetAll();
        return Ok(data);
    }
    
}
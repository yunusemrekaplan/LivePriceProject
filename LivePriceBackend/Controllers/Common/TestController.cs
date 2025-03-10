using LivePriceBackend.Data;
using LivePriceBackend.Entities;
using LivePriceBackend.Services;
using LivePriceBackend.Services.ParityServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LivePriceBackend.Controllers.Common;

[AllowAnonymous]
[ApiController]
[Route("api/test")]
public class TestController : ControllerBase
{
    private readonly LivePriceDbContext _context;
    private readonly ILogger<TestController> _logger;
    private readonly ConnectionTracker _connectionTracker;

    public TestController(
        LivePriceDbContext context,
        ILogger<TestController> logger,
        ConnectionTracker connectionTracker)
    {
        _context = context;
        _logger = logger;
        _connectionTracker = connectionTracker;
    }

    [HttpGet("ping")]
    public IActionResult Ping()
    {
        return Ok(new { message = "Pong!", timestamp = DateTime.UtcNow });
    }

    [HttpGet("harem-data")]
    public async Task<IActionResult> GetHaremData()
    {
        try
        {
            var result = await HaremService.GetAll();
            return Ok(new
            {
                success = true,
                count = result.Count,
                data = result
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "API çağrısı sırasında hata oluştu");
            return StatusCode(500, new
            {
                success = false,
                message = ex.Message,
                stackTrace = ex.StackTrace
            });
        }
    }

    [HttpGet("connections")]
    public IActionResult GetConnections()
    {
        var customerIds = _connectionTracker.GetConnectedCustomerIds().ToList();
        var connections = new List<object>();
        
        foreach(var customerId in customerIds)
        {
            var customer = _context.Customers.FirstOrDefault(c => c.Id == customerId);
            connections.Add(new
            {
                customerId,
                customerName = customer?.Name ?? "Unknown",
                hasConnections = _connectionTracker.HasConnections(customerId)
            });
        }
        
        return Ok(new
        {
            totalConnections = connections.Count,
            connections
        });
    }

    [HttpGet("customer-rules")]
    public async Task<IActionResult> GetCustomerRules(int customerId)
    {
        var customer = await _context.Customers.FirstOrDefaultAsync(c => c.Id == customerId);
        if (customer == null)
            return NotFound(new { message = "Müşteri bulunamadı" });
        
        var parityRules = await _context.CParityRules
            .AsNoTracking()
            .Where(r => r.CustomerId == customerId && !r.IsDeleted)
            .ToListAsync();
        
        var groupRules = await _context.CParityGroupRules
            .AsNoTracking()
            .Where(r => r.CustomerId == customerId && !r.IsDeleted)
            .ToListAsync();
        
        return Ok(new
        {
            customer = new
            {
                id = customer.Id,
                name = customer.Name,
                apiKey = customer.ApiKey
            },
            parityRulesCount = parityRules.Count,
            groupRulesCount = groupRules.Count,
            parityRules,
            groupRules
        });
    }
} 
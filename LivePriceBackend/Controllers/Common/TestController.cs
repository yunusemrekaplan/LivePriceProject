using LivePriceBackend.Data;
using LivePriceBackend.Entities;
using LivePriceBackend.Services;
using LivePriceBackend.Services.Caching;
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
    private readonly ParityCache _parityCache;
    private readonly IHaremService _haremService;
    private readonly CacheInvalidator _cacheInvalidator;

    public TestController(
        LivePriceDbContext context,
        ILogger<TestController> logger,
        ConnectionTracker connectionTracker,
        ParityCache parityCache,
        IHaremService haremService,
        CacheInvalidator cacheInvalidator)
    {
        _context = context;
        _logger = logger;
        _connectionTracker = connectionTracker;
        _parityCache = parityCache;
        _haremService = haremService;
        _cacheInvalidator = cacheInvalidator;
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
            var data = await _haremService.GetAllAsync();
            return Ok(new
            {
                count = data.Count,
                data = data
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "HaremService verisi alınırken hata oluştu");
            return StatusCode(500, new { error = "Veri alınamadı", message = ex.Message });
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

    [HttpGet("refresh-cache")]
    public async Task<IActionResult> RefreshCache()
    {
        try
        {
            await _cacheInvalidator.InvalidateAllCacheAsync();
            return Ok(new { message = "Tüm önbellek başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Önbellek temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Önbellek temizlenirken bir hata oluştu", message = ex.Message });
        }
    }

    [HttpGet("refresh-customer-cache/{customerId}")]
    public async Task<IActionResult> RefreshCustomerCache(int customerId)
    {
        try
        {
            await _cacheInvalidator.InvalidateCustomerCacheAsync(customerId);
            return Ok(new { message = $"Müşteri {customerId} önbelleği başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Müşteri önbelleği temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Müşteri önbelleği temizlenirken bir hata oluştu", message = ex.Message });
        }
    }
    
    [HttpGet("refresh-parity-cache/{parityId}")]
    public async Task<IActionResult> RefreshParityCache(int parityId)
    {
        try
        {
            await _cacheInvalidator.InvalidateParityCacheAsync(parityId);
            return Ok(new { message = $"Parite {parityId} önbelleği başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Parite önbelleği temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Parite önbelleği temizlenirken bir hata oluştu", message = ex.Message });
        }
    }
    
    [HttpGet("refresh-group-cache/{groupId}")]
    public async Task<IActionResult> RefreshGroupCache(int groupId)
    {
        try
        {
            await _cacheInvalidator.InvalidateParityGroupCacheAsync(groupId);
            return Ok(new { message = $"Parite grubu {groupId} önbelleği başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Parite grubu önbelleği temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Parite grubu önbelleği temizlenirken bir hata oluştu", message = ex.Message });
        }
    }

    [HttpGet("enable-customers")]
    public async Task<IActionResult> EnableCustomers()
    {
        try
        {
            var customers = await _context.Customers.ToListAsync();
            int count = 0;
            
            foreach (var customer in customers)
            {
                customer.IsEnabled = true;
                count++;
            }
            
            await _context.SaveChangesAsync();
            
            return Ok(new { message = $"{count} müşteri aktif edildi" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Müşteriler aktif edilirken hata oluştu");
            return StatusCode(500, new { error = "Müşterileri aktif etme sırasında bir hata oluştu", message = ex.Message });
        }
    }
} 
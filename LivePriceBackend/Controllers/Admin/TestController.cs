using LivePriceBackend.Data;
using LivePriceBackend.Services;
using LivePriceBackend.Services.Caching;
using LivePriceBackend.Services.ParityServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LivePriceBackend.Controllers.Admin;

[AllowAnonymous]
[ApiController]
[Route("api/test")]
public class TestController(
    LivePriceDbContext context,
    ILogger<TestController> logger,
    ConnectionTracker connectionTracker,
    ParityCache parityCache,
    IHaremService haremService,
    CacheInvalidator cacheInvalidator)
    : ControllerBase
{
    private readonly ParityCache _parityCache = parityCache;

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
            var data = await haremService.GetAllAsync();
            return Ok(new
            {
                count = data.Count,
                data = data
            });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "HaremService verisi alınırken hata oluştu");
            return StatusCode(500, new { error = "Veri alınamadı", message = ex.Message });
        }
    }

    [HttpGet("customer-rules")]
    public async Task<IActionResult> GetCustomerRules(int customerId)
    {
        var customer = await context.Customers.FirstOrDefaultAsync(c => c.Id == customerId);
        if (customer == null)
            return NotFound(new { message = "Müşteri bulunamadı" });
        
        var parityRules = await context.CParityRules
            .AsNoTracking()
            .Where(r => r.CustomerId == customerId && !r.IsDeleted)
            .ToListAsync();
        
        var groupRules = await context.CParityGroupRules
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
            await cacheInvalidator.InvalidateAllCacheAsync();
            return Ok(new { message = "Tüm önbellek başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Önbellek temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Önbellek temizlenirken bir hata oluştu", message = ex.Message });
        }
    }

    [HttpGet("refresh-customer-cache/{customerId}")]
    public async Task<IActionResult> RefreshCustomerCache(int customerId)
    {
        try
        {
            await cacheInvalidator.InvalidateCustomerCacheAsync(customerId);
            return Ok(new { message = $"Müşteri {customerId} önbelleği başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Müşteri önbelleği temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Müşteri önbelleği temizlenirken bir hata oluştu", message = ex.Message });
        }
    }
    
    [HttpGet("refresh-parity-cache/{parityId}")]
    public async Task<IActionResult> RefreshParityCache(int parityId)
    {
        try
        {
            await cacheInvalidator.InvalidateParityCacheAsync(parityId);
            return Ok(new { message = $"Parite {parityId} önbelleği başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Parite önbelleği temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Parite önbelleği temizlenirken bir hata oluştu", message = ex.Message });
        }
    }
    
    [HttpGet("refresh-group-cache/{groupId}")]
    public async Task<IActionResult> RefreshGroupCache(int groupId)
    {
        try
        {
            await cacheInvalidator.InvalidateParityGroupCacheAsync(groupId);
            return Ok(new { message = $"Parite grubu {groupId} önbelleği başarıyla temizlendi" });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Parite grubu önbelleği temizlenirken hata oluştu");
            return StatusCode(500, new { error = "Parite grubu önbelleği temizlenirken bir hata oluştu", message = ex.Message });
        }
    }

    [HttpGet("enable-customers")]
    public async Task<IActionResult> EnableCustomers()
    {
        try
        {
            var customers = await context.Customers.ToListAsync();
            int count = 0;
            
            foreach (var customer in customers)
            {
                customer.IsEnabled = true;
                count++;
            }
            
            await context.SaveChangesAsync();
            
            return Ok(new { message = $"{count} müşteri aktif edildi" });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Müşteriler aktif edilirken hata oluştu");
            return StatusCode(500, new { error = "Müşterileri aktif etme sırasında bir hata oluştu", message = ex.Message });
        }
    }

    [HttpGet("connected-customers")]
    public IActionResult GetConnectedCustomers()
    {
        var customerIds = connectionTracker.GetConnectedCustomerIds().ToList();
        var customers = new List<object>();
        
        foreach(var customerId in customerIds)
        {
            var customer = context.Customers.FirstOrDefault(c => c.Id == customerId);
            customers.Add(new
            {
                customerId,
                customerName = customer?.Name ?? "Unknown",
                connectionCount = connectionTracker.GetConnectionCount(customerId)
            });
        }
        
        return Ok(new
        {
            totalCustomers = customers.Count,
            customers
        });
    }

    [HttpGet("active-connections")]
    public IActionResult GetActiveConnections()
    {
        var connections = new List<object>();
        var customerIds = connectionTracker.GetConnectedCustomerIds().ToList();
        
        foreach(var customerId in customerIds)
        {
            var customer = context.Customers.FirstOrDefault(c => c.Id == customerId);
            var customerConnections = connectionTracker.GetCustomerConnections(customerId);
            
            foreach(var connectionId in customerConnections)
            {
                connections.Add(new
                {
                    connectionId,
                    customerId,
                    customerName = customer?.Name ?? "Unknown",
                    customerApiKey = customer?.ApiKey ?? "Unknown",
                    connectionTime = connectionTracker.GetConnectionTime(connectionId),
                    lastActivityTime = connectionTracker.GetLastActivityTime(connectionId)
                });
            }
        }
        
        return Ok(new
        {
            totalConnections = connections.Count,
            connections = connections.OrderByDescending(c => ((DateTime)((dynamic)c).connectionTime))
        });
    }
} 
using LivePriceBackend.Data;
using LivePriceBackend.Entities;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace LivePriceBackend.Services.Hubs;

public class ParityHub : Hub
{
    private readonly LivePriceDbContext _context;
    private readonly ILogger<ParityHub> _logger;
    private readonly ConnectionTracker _connectionTracker;

    public ParityHub(
        LivePriceDbContext context, 
        ILogger<ParityHub> logger,
        ConnectionTracker connectionTracker)
    {
        _context = context;
        _logger = logger;
        _connectionTracker = connectionTracker;
    }

    public override async Task OnConnectedAsync()
    {
        try
        {
            var httpContext = Context.GetHttpContext();
            var apiKey = httpContext?.Request.Query["apiKey"].ToString();

            _logger.LogInformation("Yeni bağlantı: ConnectionId={ConnectionId}, ApiKey={ApiKey}", 
                Context.ConnectionId, apiKey);

            if (string.IsNullOrWhiteSpace(apiKey))
            {
                _logger.LogWarning("API Key eksik");
                Context.Abort();
                return;
            }

            var customer = await _context.Customers
                .FirstOrDefaultAsync(c => c.ApiKey == apiKey);

            if (customer == null)
            {
                _logger.LogWarning("Geçersiz API Key: {ApiKey}", apiKey);
                Context.Abort();
                return;
            }

            // Müşteri ID'si ile bir grup oluştur (her müşteri ayrı kanalda olacak)
            _logger.LogInformation("Müşteri bulundu: {CustomerId}, {CustomerName}", 
                customer.Id, customer.Name);
            
            await Groups.AddToGroupAsync(Context.ConnectionId, $"customer_{customer.Id}");
            
            // Bağlantıyı takip et
            _connectionTracker.AddConnection(customer.Id, Context.ConnectionId);
            
            _logger.LogInformation("Müşteri {CustomerId} bağlandı, mevcut bağlantı sayısı: {ConnectionCount}", 
                customer.Id, _connectionTracker.GetConnectedCustomerIds().Count());

            await base.OnConnectedAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Bağlantı sırasında hata oluştu");
            Context.Abort();
        }
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        try
        {
            var httpContext = Context.GetHttpContext();
            var apiKey = httpContext?.Request.Query["apiKey"].ToString();

            if (!string.IsNullOrWhiteSpace(apiKey))
            {
                var customer = await _context.Customers
                    .FirstOrDefaultAsync(c => c.ApiKey == apiKey);

                if (customer != null)
                {
                    _connectionTracker.RemoveConnection(customer.Id, Context.ConnectionId);
                    _logger.LogInformation("Müşteri {CustomerId} bağlantısı kesildi", customer.Id);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Bağlantı kesme sırasında hata oluştu");
        }

        await base.OnDisconnectedAsync(exception);
    }
} 
using LivePriceBackend.Data;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace LivePriceBackend.Services.Hub;

public interface IHubAuthenticationService
{
    Task<(bool IsAuthenticated, int? CustomerId, string? ErrorMessage)> AuthenticateAsync(string apiKey);
}

public class HubAuthenticationService : IHubAuthenticationService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<HubAuthenticationService> _logger;

    public HubAuthenticationService(IServiceProvider serviceProvider, ILogger<HubAuthenticationService> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    /// <summary>
    /// API anahtarı ile kimlik doğrulama yapar
    /// </summary>
    /// <param name="apiKey">Müşteri API anahtarı</param>
    /// <returns>Doğrulama durumu, müşteri ID ve hata mesajı (varsa)</returns>
    public async Task<(bool IsAuthenticated, int? CustomerId, string? ErrorMessage)> AuthenticateAsync(string apiKey)
    {
        try
        {
            if (string.IsNullOrEmpty(apiKey))
            {
                _logger.LogWarning("API anahtarı belirtilmemiş");
                return (false, null, "API anahtarı belirtilmemiş");
            }

            using var scope = _serviceProvider.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<LivePriceDbContext>();

            var customer = await dbContext.Customers
                .AsNoTracking()
                .FirstOrDefaultAsync(c => c.ApiKey == apiKey && !c.IsDeleted);

            if (customer == null)
            {
                _logger.LogWarning("Geçersiz API anahtarı: {ApiKey}", apiKey);
                return (false, null, "Geçersiz API anahtarı");
            }

            if (!customer.IsEnabled)
            {
                _logger.LogWarning("Pasif müşteri erişim denemesi: {CustomerId}, {CustomerName}", 
                    customer.Id, customer.Name);
                return (false, null, "Müşteri hesabı pasif durumda");
            }

            _logger.LogInformation("Müşteri kimlik doğrulama başarılı: {CustomerId}, {CustomerName}", 
                customer.Id, customer.Name);
            return (true, customer.Id, null);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Kimlik doğrulama sırasında hata oluştu");
            return (false, null, "Kimlik doğrulama sırasında bir hata oluştu");
        }
    }
} 
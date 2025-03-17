using LivePriceBackend.Services.Hub;
using Microsoft.AspNetCore.SignalR;

namespace LivePriceBackend.Services.Hubs;

public class ParityHub : Microsoft.AspNetCore.SignalR.Hub
{
    private readonly IHubAuthenticationService _authService;
    private readonly IConnectionManagementService _connectionService;
    private readonly ILogger<ParityHub> _logger;

    public ParityHub(
        IHubAuthenticationService authService,
        IConnectionManagementService connectionService,
        ILogger<ParityHub> logger)
    {
        _authService = authService;
        _connectionService = connectionService;
        _logger = logger;
    }

    public override async Task OnConnectedAsync()
    {
        try
        {
            var httpContext = Context.GetHttpContext();
            var apiKey = httpContext?.Request.Query["apiKey"].ToString();

            _logger.LogInformation("Yeni bağlantı girişimi: ConnectionId={ConnectionId}", Context.ConnectionId);
            
            var (isAuthenticated, customerId, errorMessage) = await _authService.AuthenticateAsync(apiKey);
            
            if (!isAuthenticated || customerId == null)
            {
                _logger.LogWarning("Kimlik doğrulama başarısız: {Error}", errorMessage);
                Context.Abort();
                return;
            }

            // Bağlantıyı gruba ekle ve izlemeye al
            var hubContext = Context.GetHttpContext()?.RequestServices.GetRequiredService<IHubContext<ParityHub>>();
            if (hubContext != null)
            {
                await _connectionService.AddToGroupAsync(hubContext, Context.ConnectionId, customerId.Value);
                _connectionService.TrackConnection(Context.ConnectionId, customerId.Value);
            }
            
            await base.OnConnectedAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Bağlantı sırasında hata: {ConnectionId}", Context.ConnectionId);
            Context.Abort();
        }
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        try
        {
            _logger.LogInformation("Bağlantı koptu: {ConnectionId}", Context.ConnectionId);
            
            // Bağlantıyı gruptan çıkar ve izlemeden kaldır
            var hubContext = Context.GetHttpContext()?.RequestServices.GetRequiredService<IHubContext<ParityHub>>();
            if (hubContext != null)
            {
                var connectionId = Context.ConnectionId;
                var connections = Context.GetHttpContext()?.RequestServices.GetRequiredService<ConnectionTracker>();
                if (connections != null)
                {
                    foreach (var customerId in connections.GetConnectedCustomerIds())
                    {
                        if (connections.GetCustomerConnections(customerId).Contains(connectionId))
                        {
                            await _connectionService.RemoveFromGroupAsync(hubContext, connectionId, customerId);
                            _connectionService.RemoveConnection(connectionId, customerId);
                            break;
                        }
                    }
                }
            }
            
            await base.OnDisconnectedAsync(exception);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Bağlantı kopması sırasında hata: {ConnectionId}", Context.ConnectionId);
        }
    }
} 
using LivePriceBackend.Services.Hubs;
using Microsoft.AspNetCore.SignalR;

namespace LivePriceBackend.Services.Hub
{
    public interface IConnectionManagementService
    {
        Task AddToGroupAsync(IHubContext<ParityHub> hubContext, string connectionId, int customerId);
        Task RemoveFromGroupAsync(IHubContext<ParityHub> hubContext, string connectionId, int customerId);
        void TrackConnection(string connectionId, int customerId);
        void RemoveConnection(string connectionId, int customerId);
    }

    public class ConnectionManagementService : IConnectionManagementService
    {
        private readonly ConnectionTracker _connectionTracker;
        private readonly ILogger<ConnectionManagementService> _logger;

        public ConnectionManagementService(
            ConnectionTracker connectionTracker,
            ILogger<ConnectionManagementService> logger)
        {
            _connectionTracker = connectionTracker;
            _logger = logger;
        }

        /// <summary>
        /// Bağlantıyı müşteri grubuna ekler
        /// </summary>
        public async Task AddToGroupAsync(IHubContext<ParityHub> hubContext, string connectionId, int customerId)
        {
            try
            {
                var groupName = $"customer_{customerId}";
                await hubContext.Clients.Client(connectionId).SendAsync("ReceiveMessage", $"Bağlantı başarılı: müşteri ID {customerId}");
                await hubContext.Groups.AddToGroupAsync(connectionId, groupName);
                _logger.LogInformation("Bağlantı {ConnectionId} müşteri grubuna eklendi: {GroupName}", 
                    connectionId, groupName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Müşteri {CustomerId} grubuna bağlantı eklenirken hata oluştu", customerId);
                throw;
            }
        }

        /// <summary>
        /// Bağlantıyı müşteri grubundan çıkarır
        /// </summary>
        public async Task RemoveFromGroupAsync(IHubContext<ParityHub> hubContext, string connectionId, int customerId)
        {
            try
            {
                var groupName = $"customer_{customerId}";
                await hubContext.Groups.RemoveFromGroupAsync(connectionId, groupName);
                _logger.LogInformation("Bağlantı {ConnectionId} müşteri grubundan çıkarıldı: {GroupName}",
                    connectionId, groupName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Müşteri {CustomerId} grubundan bağlantı çıkarılırken hata oluştu", customerId);
                // Hata durumunda bağlantıyı gruptan çıkaramama kritik değil, yutuyoruz.
            }
        }

        /// <summary>
        /// Bağlantıyı izlemeye alır
        /// </summary>
        public void TrackConnection(string connectionId, int customerId)
        {
            try
            {
                _connectionTracker.AddConnection(connectionId, customerId);
                _logger.LogInformation("Bağlantı izlemeye alındı: {ConnectionId} -> Müşteri: {CustomerId}",
                    connectionId, customerId);
                _logger.LogInformation("Müşteri {CustomerId} için toplam bağlantı sayısı: {ConnectionCount}",
                    customerId, _connectionTracker.GetConnectionCount(customerId));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Bağlantı izlemeye alınırken hata oluştu: {ConnectionId}, {CustomerId}",
                    connectionId, customerId);
                throw;
            }
        }

        /// <summary>
        /// Bağlantıyı izlemeden çıkarır
        /// </summary>
        public void RemoveConnection(string connectionId, int customerId)
        {
            try
            {
                _connectionTracker.RemoveConnection(connectionId, customerId);
                _logger.LogInformation("Bağlantı izlemeden çıkarıldı: {ConnectionId} -> Müşteri: {CustomerId}",
                    connectionId, customerId);

                var remainingConnections = _connectionTracker.GetConnectionCount(customerId);
                _logger.LogInformation("Müşteri {CustomerId} için kalan bağlantı sayısı: {ConnectionCount}",
                    customerId, remainingConnections);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Bağlantı izlemeden çıkarılırken hata oluştu: {ConnectionId}, {CustomerId}",
                    connectionId, customerId);
                // Kritik değil, hatayı yutuyoruz
            }
        }
    }
} 
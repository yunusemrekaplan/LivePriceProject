using System.Collections.Concurrent;

namespace LivePriceBackend.Services;

public class ConnectionTracker
{
    private readonly ConcurrentDictionary<string, int> _connections = new(); // ConnectionId -> CustomerId
    private readonly ConcurrentDictionary<int, HashSet<string>> _customerConnections = new(); // CustomerId -> ConnectionId[]
    private readonly ConcurrentDictionary<string, DateTime> _connectionTimes = new(); // ConnectionId -> ConnectionTime
    private readonly ConcurrentDictionary<string, DateTime> _lastActivityTimes = new(); // ConnectionId -> LastActivityTime
    private readonly object _lock = new();

    public void AddConnection(string connectionId, int customerId)
    {
        _connections[connectionId] = customerId;
        _connectionTimes[connectionId] = DateTime.UtcNow;
        _lastActivityTimes[connectionId] = DateTime.UtcNow;
        
        lock (_lock)
        {
            if (!_customerConnections.TryGetValue(customerId, out var connections))
            {
                connections = new HashSet<string>();
                _customerConnections[customerId] = connections;
            }
            connections.Add(connectionId);
        }
    }

    public void RemoveConnection(string connectionId, int customerId)
    {
        _connections.TryRemove(connectionId, out _);
        _connectionTimes.TryRemove(connectionId, out _);
        _lastActivityTimes.TryRemove(connectionId, out _);

        lock (_lock)
        {
            if (_customerConnections.TryGetValue(customerId, out var connections))
            {
                connections.Remove(connectionId);
                if (connections.Count == 0)
                {
                    _customerConnections.TryRemove(customerId, out _);
                }
            }
        }
    }

    public void UpdateLastActivity(string connectionId)
    {
        _lastActivityTimes[connectionId] = DateTime.UtcNow;
    }

    public DateTime GetConnectionTime(string connectionId)
    {
        return _connectionTimes.TryGetValue(connectionId, out var time) ? time : DateTime.MinValue;
    }

    public DateTime GetLastActivityTime(string connectionId)
    {
        return _lastActivityTimes.TryGetValue(connectionId, out var time) ? time : DateTime.MinValue;
    }

    public IEnumerable<int> GetConnectedCustomerIds()
    {
        return _customerConnections.Keys;
    }

    public bool HasConnections(int customerId)
    {
        return _customerConnections.TryGetValue(customerId, out var connections) && connections.Count > 0;
    }

    public int GetConnectionCount(int customerId)
    {
        if (_customerConnections.TryGetValue(customerId, out var connections))
        {
            return connections.Count;
        }
        return 0;
    }

    public IEnumerable<string> GetCustomerConnections(int customerId)
    {
        if (_customerConnections.TryGetValue(customerId, out var connections))
        {
            return connections.ToList();
        }
        return Array.Empty<string>();
    }
} 
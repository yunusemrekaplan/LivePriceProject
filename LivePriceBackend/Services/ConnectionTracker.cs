using System.Collections.Concurrent;

namespace LivePriceBackend.Services;

public class ConnectionTracker
{
    private readonly ConcurrentDictionary<int, HashSet<string>> _customerConnections = new();
    private readonly object _lock = new();

    public void AddConnection(int customerId, string connectionId)
    {
        lock (_lock)
        {
            if (!_customerConnections.ContainsKey(customerId))
            {
                _customerConnections[customerId] = new HashSet<string>();
            }
            _customerConnections[customerId].Add(connectionId);
        }
    }

    public void RemoveConnection(int customerId, string connectionId)
    {
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

    public bool HasConnections(int customerId)
    {
        return _customerConnections.ContainsKey(customerId) && 
               _customerConnections[customerId].Count > 0;
    }

    public IEnumerable<int> GetConnectedCustomerIds()
    {
        return _customerConnections.Keys;
    }
} 
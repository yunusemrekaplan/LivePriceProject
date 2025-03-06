using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class CustomerParityVisibility : AuditableEntity
{
    public required int CustomerId { get; set; }
    public required int ParityId { get; set; }
    public bool IsVisible { get; set; }
    
    public Customer? Customer { get; set; }
    public Parity? Parity { get; set; }
}
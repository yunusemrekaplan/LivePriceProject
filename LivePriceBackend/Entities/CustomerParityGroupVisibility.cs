using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class CustomerParityGroupVisibility : AuditableEntity
{
    public required int CustomerId { get; set; }
    public required int ParityGroupId { get; set; }
    public bool IsVisible { get; set; } // true: görünür, false: görünmez
    
    public Customer? Customer { get; set; }
    public ParityGroup? ParityGroup { get; set; }
}
using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class ParityGroup : AuditableEntity
{
    public string Name { get; set; } = null!;
    public string Description { get; set; } = null!;
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    
    public ICollection<Parity> Parities { get; set; } = [];
    public ICollection<CustomerParityGroupVisibility> CustomerVisibilities { get; set; } = [];
}
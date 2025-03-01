using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class Parity : AuditableEntity
{
    public required string Name { get; set; } // Örneğin: "Gram Altın"
    public required string Symbol { get; set; } // Örneğin: "XAU/TRY"
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    public int ParityGroupId { get; set; }
    public ParityGroup ParityGroup { get; set; } = null!;
    public ICollection<CustomerPriceRule> CustomerPriceRules { get; set; } = [];
}
using LivePriceBackend.Constants.Enums;
using LivePriceBackend.Core.Entities;
using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class CustomerPriceRule : AuditableEntity
{
    public required int CustomerId { get; set; }
    public required int ParityId { get; set; }
    public required PriceRuleType PriceRuleType { get; set; }
    public decimal Value { get; set; }

    public Customer? Customer { get; set; }
    public Parity? Parity { get; set; }
}
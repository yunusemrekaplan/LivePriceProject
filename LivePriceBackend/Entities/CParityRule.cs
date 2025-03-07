using LivePriceBackend.Constants.Enums;
using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class CParityRule : AuditableEntity
{
    
    public required int CustomerId { get; set; }
    public required int ParityId { get; set; }
    public bool IsVisible { get; set; }
    public SpreadRuleType? SpreadRuleType { get; set; }
    public decimal? SpreadForAsk { get; set; }
    public decimal? SpreadForBid { get; set; }
    
    public Customer? Customer { get; set; }
    public Parity? Parity { get; set; }
}
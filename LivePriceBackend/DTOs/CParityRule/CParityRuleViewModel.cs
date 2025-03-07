using LivePriceBackend.Constants.Enums;
using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.CParityRule;

public class CParityRuleViewModel : BaseAuditableDto
{
    public int CustomerId { get; set; }
    public int ParityId { get; set; }
    public bool IsVisible { get; set; }
    public SpreadRuleType? SpreadRuleType { get; set; }
    public decimal? SpreadForAsk { get; set; }
    public decimal? SpreadForBid { get; set; }
}
using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.CParityRule;

public class CParityRuleCreateModel
{
    public int CustomerId { get; set; }
    public int ParityId { get; set; }
    public bool IsVisible { get; set; }
    public SpreadRuleType? SpreadRuleType { get; set; }
    public decimal? SpreadForAsk { get; set; }
    public decimal? SpreadForBid { get; set; }
}
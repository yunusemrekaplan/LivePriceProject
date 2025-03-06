using LivePriceBackend.Constants.Enums;
using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.AdminPriceRule;

public class AdminPriceRuleViewModel : BaseAuditableDto
{
    public int ParityId { get; set; }
    public SpreadRuleType? PriceRuleType { get; set; }
    public decimal? ValueForAsk { get; set; }
    public decimal? ValueForBid { get; set; }
    public string? ParityName { get; set; }
}
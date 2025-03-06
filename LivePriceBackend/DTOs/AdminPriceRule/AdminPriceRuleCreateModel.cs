using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.AdminPriceRule;

public class AdminPriceRuleCreateModel
{
    public required int ParityId { get; set; }
    public required SpreadRuleType SpreadRuleType { get; set; }
    public required decimal ValueForAsk { get; set; }
    public required decimal ValueForBid { get; set; }
}
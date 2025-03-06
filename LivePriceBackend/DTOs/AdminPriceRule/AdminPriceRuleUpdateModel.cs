using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.AdminPriceRule;

public class AdminPriceRuleUpdateModel
{
    public required SpreadRuleType SpreadRuleType { get; set; }
    public required decimal ValueForAsk { get; set; }
    public required decimal ValueForBid { get; set; }
}
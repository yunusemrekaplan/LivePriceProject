using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.CustomerPriceRule;

public class CustomerPriceRuleUpdateModel
{
    public required SpreadRuleType SpreadRuleType { get; set; }
    public required decimal Value { get; set; }
} 
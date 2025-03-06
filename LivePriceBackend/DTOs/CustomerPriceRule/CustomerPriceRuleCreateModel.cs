using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.CustomerPriceRule;

public class CustomerPriceRuleCreateModel
{
    public required int CustomerId { get; set; }
    public required int ParityId { get; set; }
    public required SpreadRuleType SpreadRuleType { get; set; }
    public required decimal Value { get; set; }
} 
using LivePriceBackend.Constants.Enums;
using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.CustomerPriceRule;

public class CustomerPriceRuleViewModel : BaseAuditableDto
{
    public int CustomerId { get; set; }
    public int ParityId { get; set; }
    public PriceRuleType? PriceRuleType { get; set; }
    public decimal Value { get; set; }
    public string? CustomerName { get; set; }
    public string? ParityName { get; set; }
} 
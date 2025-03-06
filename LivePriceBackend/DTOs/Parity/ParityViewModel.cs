using LivePriceBackend.Constants.Enums;
using LivePriceBackend.DTOs.AdminPriceRule;
using LivePriceBackend.DTOs.Base;
using LivePriceBackend.DTOs.CustomerParityVisibility;
using LivePriceBackend.DTOs.CustomerPriceRule;

namespace LivePriceBackend.DTOs.Parity;

public class ParityViewModel : BaseAuditableDto
{
    public string? Name { get; set; }
    public string? Symbol { get; set; }
    public string? RawSymbol { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    public int Scale { get; set; }
    public SpreadRuleType? SpreadRuleType { get; set; }
    public decimal? SpreadForAsk { get; set; }
    public decimal? SpreadForBid { get; set; }
    public int ParityGroupId { get; set; }
    public ICollection<CustomerPriceRuleViewModel>? CustomerPriceRules { get; set; }
    public ICollection<CustomerParityVisibilityViewModel>? CustomerVisibilities { get; set; }
}
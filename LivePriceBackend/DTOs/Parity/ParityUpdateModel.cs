using LivePriceBackend.Constants.Enums;
using LivePriceBackend.DTOs.AdminPriceRule;

namespace LivePriceBackend.DTOs.Parity;

public class ParityUpdateModel
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
    public AdminPriceRuleUpdateModel? AdminPriceRule { get; set; }
} 
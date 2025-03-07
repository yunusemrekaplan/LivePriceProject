using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.Parity;

public class ParityCreateModel
{
    public required string Name { get; set; }
    public required string Symbol { get; set; }
    public required string RawSymbol { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    public int Scale { get; set; }
    public SpreadRuleType? SpreadRuleType { get; set; }
    public decimal? SpreadForAsk { get; set; }
    public decimal? SpreadForBid { get; set; }
    public int ParityGroupId { get; set; }
} 
using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.Parity;

public class ParityCustomerViewModel
{
    public int Id { get; set; }
    public string? Name { get; set; }
    public string? Symbol { get; set; }
    public bool IsVisible { get; set; }
    public SpreadRuleType? SpreadRuleType { get; set; }
    public decimal? SpreadForAsk { get; set; }
    public decimal? SpreadForBid { get; set; }
    public int ParityGroupId { get; set; }
}
using System.Collections;
using LivePriceBackend.Constants.Enums;
using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class Parity : AuditableEntity
{
    public required string Name { get; set; } // Örneğin: "Gram Altın"
    public required string Symbol { get; set; } // Örneğin: "XAU/TRY"
    public required string RawSymbol { get; set; }
    public int RawMarketCode { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    public int Scale { get; set; } = 2;
    public SpreadRuleType? SpreadRuleType { get; set; }
    public decimal? SpreadForAsk { get; set; }
    public decimal? SpreadForBid { get; set; }
    public int ParityGroupId { get; set; }

    public ParityGroup ParityGroup { get; set; } = null!;

    public ICollection<CParityRule> CParityRules { get; set; } = [];
}
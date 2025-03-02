using LivePriceBackend.DTOs.Base;
using LivePriceBackend.DTOs.CustomerPriceRule;

namespace LivePriceBackend.DTOs.Parity;

public class ParityViewModel : BaseAuditableDto
{
    public string? Name { get; set; }
    public string? Symbol { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    public int ParityGroupId { get; set; }
    public ICollection<CustomerPriceRuleViewModel>? CustomerPriceRules { get; set; }
} 
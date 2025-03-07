using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.CParityGroupRule;

public class CParityGroupRuleViewModel : BaseAuditableDto
{
    public int CustomerId { get; set; }
    public int ParityGroupId { get; set; }
    public bool IsVisible { get; set; }
}
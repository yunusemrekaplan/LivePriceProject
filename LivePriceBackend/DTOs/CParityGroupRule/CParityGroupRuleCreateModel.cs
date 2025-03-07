namespace LivePriceBackend.DTOs.CParityGroupRule;

public class CParityGroupRuleCreateModel
{
    public int CustomerId { get; set; }
    public int ParityGroupId { get; set; }
    public bool IsVisible { get; set; }
}
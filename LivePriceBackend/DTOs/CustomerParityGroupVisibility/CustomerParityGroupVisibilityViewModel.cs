using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.CustomerParityGroupVisibility;

public class CustomerParityGroupVisibilityViewModel : BaseAuditableDto
{
    public int CustomerId { get; set; }
    public int ParityGroupId { get; set; }
    public bool IsVisible { get; set; }
    public string? CustomerName { get; set; }
    public string? ParityGroupName { get; set; }
}
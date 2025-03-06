using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.CustomerParityVisibility;

public class CustomerParityVisibilityViewModel : BaseAuditableDto
{
    public int CustomerId { get; set; }
    public int ParityId { get; set; }
    public bool IsVisible { get; set; }
    public string? CustomerName { get; set; }
    public string? ParityName { get; set; }
}
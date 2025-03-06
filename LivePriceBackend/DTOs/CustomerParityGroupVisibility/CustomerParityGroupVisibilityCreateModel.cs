namespace LivePriceBackend.DTOs.CustomerParityGroupVisibility;

public class CustomerParityGroupVisibilityCreateModel
{
    public required int CustomerId { get; set; }
    public required int ParityGroupId { get; set; }
    public bool IsVisible { get; set; } = true;
}
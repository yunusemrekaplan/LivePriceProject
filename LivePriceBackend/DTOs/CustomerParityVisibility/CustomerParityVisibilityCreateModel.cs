namespace LivePriceBackend.DTOs.CustomerParityVisibility;

public class CustomerParityVisibilityCreateModel
{
    public required int CustomerId { get; set; }
    public required int ParityId { get; set; }
    public bool IsVisible { get; set; } = true;
}
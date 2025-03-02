namespace LivePriceBackend.DTOs.ParityGroup;

public class ParityGroupUpdateModel
{
    public string? Name { get; set; }
    public string? Description { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
}
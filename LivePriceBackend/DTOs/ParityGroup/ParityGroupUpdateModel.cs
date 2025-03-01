namespace LivePriceBackend.DTOs.ParityGroup;

public class ParityGroupUpdateModel
{
    public required string Name { get; set; }
    public required string Description { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
}
namespace LivePriceBackend.DTOs.ParityGroup;

public class ParityGroupViewModel
{
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public string Description { get; set; } = null!;
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
}
namespace LivePriceBackend.DTOs.Parity;

public class ParityCreateModel
{
    public required string Name { get; set; }
    public required string Symbol { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    public int ParityGroupId { get; set; }
} 
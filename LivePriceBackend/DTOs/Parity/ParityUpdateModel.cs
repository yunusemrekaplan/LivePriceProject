namespace LivePriceBackend.DTOs.Parity;

public class ParityUpdateModel
{
    public string? Name { get; set; }
    public string? Symbol { get; set; }
    public string? ApiSymbol { get; set; }
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
    public int ParityGroupId { get; set; }
} 
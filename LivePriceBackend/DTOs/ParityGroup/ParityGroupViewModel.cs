using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.ParityGroup;

public class ParityGroupViewModel : BaseAuditableDto
{
    public string Name { get; set; } = null!;
    public string Description { get; set; } = null!;
    public bool IsEnabled { get; set; }
    public int OrderIndex { get; set; }
}
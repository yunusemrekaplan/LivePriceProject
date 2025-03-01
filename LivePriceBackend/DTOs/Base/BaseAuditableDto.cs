namespace LivePriceBackend.DTOs.Base;

public abstract class BaseAuditableDto
{
    public int Id { get; set; }
    public DateTime? CreatedAt { get; set; }
    public int? CreatedById { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public int? UpdatedById { get; set; }
} 
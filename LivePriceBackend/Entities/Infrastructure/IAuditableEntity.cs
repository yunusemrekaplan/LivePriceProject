namespace ProductAPI.Entities.Schemas.Infrastructure;

public interface IAuditableEntity : IKeyEntity
{
    public DateTime? CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public DateTime? DeletedAt { get; set; }
    
    public int? CreatedById { get; set; }
    public int? UpdatedById { get; set; }
    public int? DeletedById { get; set; }
    
    public bool IsDeleted { get; set; }
}
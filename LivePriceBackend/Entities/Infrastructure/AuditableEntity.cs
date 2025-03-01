using LivePriceBackend.Entities;
using ProductAPI.Entities.Schemas.Infrastructure;

namespace LivePriceBackend.Core.Entities.Infrastructure;

public abstract class AuditableEntity : IAuditableEntity
{
    public int Id { get; set; }
    public DateTime? CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public DateTime? DeletedAt { get; set; }
    public int? CreatedById { get; set; }
    public int? UpdatedById { get; set; }
    public int? DeletedById { get; set; }
    
    public User? CreatedBy { get; set; }
    
    public User? UpdatedBy { get; set; }
    
    public User? DeletedBy { get; set; }
    
    public bool IsDeleted { get; set; }
}
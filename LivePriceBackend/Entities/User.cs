using System.ComponentModel.DataAnnotations;
using LivePriceBackend.Constants.Enums;
using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class User : AuditableEntity
{
    [MaxLength(50)]
    public required string Name { get; set; }
        
    [MaxLength(50)]
    public required string Surname { get; set; }
        
    [MaxLength(50)]
    public required string Username { get; set; }
        
    [EmailAddress]
    [MaxLength(100)]
    public required string Email { get; set; }
        
    [MaxLength(500)]
    public string? PasswordHash { get; set; }
    
    public Role Role { get; set; } // "Admin" veya "Müşteri"
    
    public int? CustomerId { get; set; } // Eğer müşteri kullanıcısıysa hangi müşteriye ait olduğunu gösterir
    
    public Customer? Customer { get; set; }
    
    public string? RefreshToken { get; set; }
    
    public DateTime? RefreshTokenExpiry { get; set; }
}
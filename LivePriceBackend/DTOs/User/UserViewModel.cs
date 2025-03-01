using LivePriceBackend.Constants.Enums;
using LivePriceBackend.DTOs.Base;

namespace LivePriceBackend.DTOs.User;

public class UserViewModel : BaseAuditableDto
{
    public string? Name { get; set; }
    public string? Surname { get; set; }
    public string? Username { get; set; }
    public string? Email { get; set; }
    public Role Role { get; set; }
    public int? CustomerId { get; set; }
    public string? CustomerName { get; set; }
} 
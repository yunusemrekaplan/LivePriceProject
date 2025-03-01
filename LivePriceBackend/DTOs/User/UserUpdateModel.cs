using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.User;

public class UserUpdateModel
{
    public string? Name { get; set; }
    public string? Surname { get; set; }
    public string? Username { get; set; }
    public string? Email { get; set; }
    public string? Password { get; set; }
    public Role? Role { get; set; }
    public int? CustomerId { get; set; }
} 
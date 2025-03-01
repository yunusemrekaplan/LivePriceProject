using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.User;

public class UserCreateModel
{
    public required string Name { get; set; }
    public required string Surname { get; set; }
    public required string Username { get; set; }
    public required string Email { get; set; }
    public required string Password { get; set; }
    public required Role Role { get; set; }
    public int? CustomerId { get; set; }
} 
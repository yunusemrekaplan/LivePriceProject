using System.ComponentModel.DataAnnotations;
using LivePriceBackend.Constants.Enums;

namespace LivePriceBackend.DTOs.Auth.Requests;

public class RegisterRequest
{
    public required string Username { get; set; }
    public required string Password { get; set; }
    [EmailAddress] public required string Email { get; set; }
    public required string Name { get; set; }
    public required string Surname { get; set; }
    public Role Role { get; set; }
    
    public int? CustomerId { get; set; }
}
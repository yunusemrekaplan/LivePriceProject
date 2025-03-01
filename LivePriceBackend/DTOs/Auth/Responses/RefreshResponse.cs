namespace LivePriceBackend.DTOs.Auth.Responses;

public class RefreshResponse
{
    public required string AccessToken { get; set; }
    public required string RefreshToken { get; set; }
}
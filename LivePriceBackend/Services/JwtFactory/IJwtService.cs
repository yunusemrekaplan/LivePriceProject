namespace LivePriceBackend.Services.JwtFactory;

public interface IJwtService
{
    string GenerateAccessToken(Entities.User user);
}
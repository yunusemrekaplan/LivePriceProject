using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace LivePriceBackend.Services.JwtFactory
{
    public class JwtService(IConfiguration configuration) : IJwtService
    {
        private readonly string _key = configuration["JwtSettings:Key"] ?? throw new ArgumentNullException(nameof(configuration), "Key is not configured");
        private readonly string _issuer = configuration["JwtSettings:Issuer"] ?? throw new ArgumentNullException(nameof(configuration), "Issuer is not configured");
        private readonly string _audience = configuration["JwtSettings:Audience"] ?? throw new ArgumentNullException(nameof(configuration), "Audience is not configured");

        public string GenerateAccessToken(Entities.User user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_key);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                    new Claim(ClaimTypes.Name, user.Username)
                }),
                Expires = DateTime.UtcNow.AddMinutes(5),
                Issuer = _issuer,
                Audience = _audience,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }

        public static string GenerateRefreshToken()
        {
            var randomNumber = new byte[32];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomNumber);
            return Convert.ToBase64String(randomNumber);
        }
    }
}
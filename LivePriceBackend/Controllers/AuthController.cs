using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.Auth.Requests;
using LivePriceBackend.DTOs.Auth.Responses;
using LivePriceBackend.Entities;
using LivePriceBackend.Services.JwtFactory;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;

namespace LivePriceBackend.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController(LivePriceDbContext context, IJwtService jwtService) : ControllerBase
    {
        [HttpPost("login")]
        [AllowAnonymous]
        [SwaggerOperation(Summary = "Logs in a user and returns access and refresh tokens.")]
        [SwaggerResponse(200, "Login successful", typeof(LoginResponse))]
        [SwaggerResponse(400, "Invalid username or password")]
        public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
        {
            var user = await context.Users.FirstOrDefaultAsync(u => u.Username == loginRequest.Username);

            if (user == null || !BCrypt.Net.BCrypt.Verify(loginRequest.Password, user.PasswordHash))
                return BadRequest(new { message = ErrorMessages.InvalidUsernameOrPassword });

            var accessToken = jwtService.GenerateAccessToken(user);
            var refreshToken = JwtService.GenerateRefreshToken();

            user.RefreshToken = refreshToken;
            user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(7);

            await context.SaveChangesAsync();

            return Ok(new LoginResponse
            {
                Id = user.Id,
                UserName = user.Username,
                AccessToken = accessToken,
                RefreshToken = refreshToken
            });
        }

        [HttpPost("refresh")]
        [AllowAnonymous]
        [SwaggerOperation(Summary = "Refreshes the access token using a refresh token.")]
        [SwaggerResponse(200, "Token refreshed successfully", typeof(RefreshResponse))]
        [SwaggerResponse(401, "Invalid or expired refresh token")]
        public async Task<IActionResult> Refresh([FromBody] string refreshToken)
        {
            var user = await context.Users.FirstOrDefaultAsync(u => u.RefreshToken == refreshToken);

            if (user == null || user.RefreshTokenExpiry < DateTime.UtcNow)
                return BadRequest(new { message = ErrorMessages.InvalidOrExpiredRefreshToken });

            var newAccessToken = jwtService.GenerateAccessToken(user);
            var newRefreshToken = JwtService.GenerateRefreshToken();

            user.RefreshToken = newRefreshToken;
            user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(7);

            await context.SaveChangesAsync();

            return Ok(new RefreshResponse
            {
                AccessToken = newAccessToken,
                RefreshToken = newRefreshToken
            });
        }

        [HttpPost("register")]
        [SwaggerOperation(Summary = "Registers a new user.")]
        [SwaggerResponse(200, "User registered successfully")]
        [SwaggerResponse(400, "Username already exists")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest registerRequest)
        {
            var existingUser = await context.Users.FirstOrDefaultAsync(u => u.Username == registerRequest.Username);

            if (existingUser != null)
                return BadRequest(new { message = ErrorMessages.UsernameAlreadyExists });

            var user = new User
            {
                Name = registerRequest.Name,
                Surname = registerRequest.Surname,
                Username = registerRequest.Username,
                Email = registerRequest.Email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(registerRequest.Password),
                Role = registerRequest.Role,
                CustomerId = registerRequest.CustomerId
            };

            await context.Users.AddAsync(user);
            await context.SaveChangesAsync();

            return Ok(new { message = "User registered successfully" });
        }

        [HttpPost("logout")]
        [SwaggerOperation(Summary = "Logs out a user by invalidating the refresh token.")]
        [SwaggerResponse(200, "Logged out successfully")]
        [SwaggerResponse(404, "User not found")]
        public async Task<IActionResult> Logout([FromBody] string refreshToken)
        {
            var user = await context.Users.FirstOrDefaultAsync(u => u.RefreshToken == refreshToken);

            if (user == null)
                return NotFound(new { message = ErrorMessages.UserNotFound });

            user.RefreshToken = null;
            user.RefreshTokenExpiry = null;

            await context.SaveChangesAsync();

            return Ok(new { message = "Logged out successfully" });
        }
    }
}
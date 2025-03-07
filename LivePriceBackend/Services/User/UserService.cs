using LivePriceBackend.Extensions;

namespace LivePriceBackend.Services.User;

public class UserService(IHttpContextAccessor httpContextAccessor) : IUserService
{
    public int? GetCurrentUserId()
    {
        return httpContextAccessor.HttpContext?.User.GetUserId();
    }
    
    public int? GetCurrentCustomerId()
    {
        return httpContextAccessor.HttpContext?.User.GetCustomerId();
    }
}
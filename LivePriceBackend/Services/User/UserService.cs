using ProductAPI.Extensions;
using ProductAPI.Services.User;

namespace LivePriceBackend.Services.User;

public class UserService(IHttpContextAccessor httpContextAccessor) : IUserService
{
    public int? GetCurrentUserId()
    {
        return httpContextAccessor.HttpContext?.User.GetUserId();
    }
}
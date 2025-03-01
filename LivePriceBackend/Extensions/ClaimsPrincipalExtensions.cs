using System.Security.Claims;

namespace ProductAPI.Extensions;

public static class ClaimsPrincipalExtensions
{
    public static bool IsAuthenticated(this ClaimsPrincipal user)
    {
        return user.Identity!.IsAuthenticated;
    }
    
    public static int? GetUserId(this ClaimsPrincipal user)
    {
        return user.IsAuthenticated() ? int.Parse(user.Claims.First(claim => claim.Type is ClaimTypes.NameIdentifier or "nameid").Value) : null;
    }
}
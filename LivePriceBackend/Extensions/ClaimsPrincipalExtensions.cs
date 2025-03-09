using System.Security.Claims;

namespace LivePriceBackend.Extensions;

public static class ClaimsPrincipalExtensions
{
    public static bool IsAuthenticated(this ClaimsPrincipal user)
    {
        return user.Identity!.IsAuthenticated;
    }

    public static int? GetUserId(this ClaimsPrincipal user)
    {
        return user.IsAuthenticated()
            ? int.Parse(user.Claims.First(claim => claim.Type is ClaimTypes.NameIdentifier or "nameid").Value)
            : null;
    }

    public static int? GetCustomerId(this ClaimsPrincipal user)
    {
        if (!user.IsAuthenticated())
        {
            return null;
        }

        var customerIdClaim = user.Claims.FirstOrDefault(claim => claim.Type == "CustomerId")?.Value;

        if (string.IsNullOrEmpty(customerIdClaim))
        {
            return null;
        }

        return int.Parse(customerIdClaim);
    }
}
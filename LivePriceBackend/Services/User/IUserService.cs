namespace LivePriceBackend.Services.User;

public interface IUserService
{
    int? GetCurrentUserId();
    int? GetCurrentCustomerId();
}
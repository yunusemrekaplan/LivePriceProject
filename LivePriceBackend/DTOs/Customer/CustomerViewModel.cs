using LivePriceBackend.DTOs.Base;
using LivePriceBackend.DTOs.User;

namespace LivePriceBackend.DTOs.Customer;

public class CustomerViewModel : BaseAuditableDto
{
    public required string Name { get; set; }
    public ICollection<UserViewModel>? Users { get; set; }
}
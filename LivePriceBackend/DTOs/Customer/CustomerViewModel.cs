using LivePriceBackend.DTOs.Base;
using LivePriceBackend.DTOs.CustomerPriceRule;
using LivePriceBackend.DTOs.User;

namespace LivePriceBackend.DTOs.Customer;

public class CustomerViewModel : BaseAuditableDto
{
    public required string Name { get; set; }
    public string? ApiKey { get; set; }
    public ICollection<UserViewModel>? Users { get; set; }
    public ICollection<CustomerPriceRuleViewModel>? CustomerPriceRules { get; set; }
} 
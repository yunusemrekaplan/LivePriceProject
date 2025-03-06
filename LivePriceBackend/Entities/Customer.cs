using LivePriceBackend.Core.Entities;
using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class Customer : AuditableEntity
{
    public string Name { get; set; }
    public string ApiKey { get; set; } // API erişimi için
    
    public ICollection<User> Users { get; set; } = [];
    public ICollection<CustomerPriceRule> CustomerPriceRules { get; set; } = new List<CustomerPriceRule>();
    public ICollection<CustomerParityVisibility> ParityVisibilities { get; set; } = [];
    public ICollection<CustomerParityGroupVisibility> ParityGroupVisibilities { get; set; } = [];

}
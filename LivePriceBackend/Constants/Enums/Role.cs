using System.ComponentModel;

namespace LivePriceBackend.Constants.Enums;

public enum Role
{
    [Description("Admin")]
    Admin = 0,
    
    [Description("Müşteri")]
    Customer = 1
}
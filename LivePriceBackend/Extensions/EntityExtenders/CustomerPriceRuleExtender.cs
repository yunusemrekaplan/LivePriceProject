using LivePriceBackend.DTOs.CustomerPriceRule;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class CustomerPriceRuleExtender
{
    public static CustomerPriceRuleViewModel ToViewModel(this CustomerPriceRule customerPriceRule)
    {
        return new CustomerPriceRuleViewModel
        {
            Id = customerPriceRule.Id,
            CustomerId = customerPriceRule.CustomerId,
            ParityId = customerPriceRule.ParityId,
            PriceRuleType = customerPriceRule.PriceRuleType,
            Value = customerPriceRule.Value,
            CustomerName = customerPriceRule.Customer?.Name,
            ParityName = customerPriceRule.Parity?.Name,
            CreatedAt = customerPriceRule.CreatedAt,
            CreatedById = customerPriceRule.CreatedById,
            UpdatedAt = customerPriceRule.UpdatedAt,
            UpdatedById = customerPriceRule.UpdatedById
        };
    }

    public static CustomerPriceRule ToEntity(this CustomerPriceRuleCreateModel customerPriceRuleCreateModel)
    {
        return new CustomerPriceRule
        {
            CustomerId = customerPriceRuleCreateModel.CustomerId,
            ParityId = customerPriceRuleCreateModel.ParityId,
            PriceRuleType = customerPriceRuleCreateModel.PriceRuleType,
            Value = customerPriceRuleCreateModel.Value
        };
    }

    public static void UpdateEntity(this CustomerPriceRuleUpdateModel customerPriceRuleUpdateModel, CustomerPriceRule customerPriceRule)
    {
        customerPriceRule.PriceRuleType = customerPriceRuleUpdateModel.PriceRuleType;
        customerPriceRule.Value = customerPriceRuleUpdateModel.Value;
    }
}
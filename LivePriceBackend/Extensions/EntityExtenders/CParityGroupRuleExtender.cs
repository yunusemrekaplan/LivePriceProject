using LivePriceBackend.DTOs.CParityGroupRule;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class CParityGroupRuleExtender
{
    public static CParityGroupRuleViewModel ToViewModel(this CParityGroupRule cParityGroupRule)
    {
        return new CParityGroupRuleViewModel
        {
            Id = cParityGroupRule.Id,
            CustomerId = cParityGroupRule.CustomerId,
            ParityGroupId = cParityGroupRule.ParityGroupId,
            IsVisible = cParityGroupRule.IsVisible,
            CreatedAt = cParityGroupRule.CreatedAt,
            CreatedById = cParityGroupRule.CreatedById,
            UpdatedAt = cParityGroupRule.UpdatedAt,
            UpdatedById = cParityGroupRule.UpdatedById
        };
    }
    
    
    public static CParityGroupRule ToEntity(this CParityGroupRuleCreateModel cParityGroupRuleCreateModel)
    {
        return new CParityGroupRule
        {
            CustomerId = cParityGroupRuleCreateModel.CustomerId,
            ParityGroupId = cParityGroupRuleCreateModel.ParityGroupId,
            IsVisible = cParityGroupRuleCreateModel.IsVisible
        };
    }
    
    public static void UpdateEntity(this CParityGroupRuleUpdateModel cParityGroupRuleUpdateModel, CParityGroupRule cParityGroupRule)
    {
        cParityGroupRule.IsVisible = cParityGroupRuleUpdateModel.IsVisible;
    }
}
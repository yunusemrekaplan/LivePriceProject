using LivePriceBackend.DTOs.CParityRule;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class CParityRuleExtender
{
    public static CParityRuleViewModel ToViewModel(this CParityRule cParityRule)
    {
        return new CParityRuleViewModel
        {
            Id = cParityRule.Id,
            CustomerId = cParityRule.CustomerId,
            ParityId = cParityRule.ParityId,
            IsVisible = cParityRule.IsVisible,
            SpreadRuleType = cParityRule.SpreadRuleType,
            SpreadForAsk = cParityRule.SpreadForAsk,
            SpreadForBid = cParityRule.SpreadForBid,
            CreatedAt = cParityRule.CreatedAt,
            CreatedById = cParityRule.CreatedById,
            UpdatedAt = cParityRule.UpdatedAt,
            UpdatedById = cParityRule.UpdatedById
        };
    }
    
    public static CParityRule ToEntity(this CParityRuleCreateModel cParityRuleCreateModel)
    {
        return new CParityRule
        {
            CustomerId = cParityRuleCreateModel.CustomerId,
            ParityId = cParityRuleCreateModel.ParityId,
            IsVisible = cParityRuleCreateModel.IsVisible,
            SpreadRuleType = cParityRuleCreateModel.SpreadRuleType,
            SpreadForAsk = cParityRuleCreateModel.SpreadForAsk,
            SpreadForBid = cParityRuleCreateModel.SpreadForBid
        };
    }
    
    public static void UpdateEntity(this CParityRuleUpdateModel cParityRuleUpdateModel, CParityRule cParityRule)
    {
        cParityRule.IsVisible = cParityRuleUpdateModel.IsVisible;
        cParityRule.SpreadRuleType = cParityRuleUpdateModel.SpreadRuleType;
        cParityRule.SpreadForAsk = cParityRuleUpdateModel.SpreadForAsk;
        cParityRule.SpreadForBid = cParityRuleUpdateModel.SpreadForBid;
    }
}
using LivePriceBackend.DTOs.CustomerParityGroupVisibility;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class CustomerParityGroupVisibilityExtender
{
    public static CustomerParityGroupVisibilityViewModel ToViewModel(this CustomerParityGroupVisibility customerParityGroupVisibility)
    {
        return new CustomerParityGroupVisibilityViewModel
        {
            Id = customerParityGroupVisibility.Id,
            CustomerId = customerParityGroupVisibility.CustomerId,
            ParityGroupId = customerParityGroupVisibility.ParityGroupId,
            IsVisible = customerParityGroupVisibility.IsVisible,
            CustomerName = customerParityGroupVisibility.Customer?.Name,
            ParityGroupName = customerParityGroupVisibility.ParityGroup?.Name,
            CreatedAt = customerParityGroupVisibility.CreatedAt,
            CreatedById = customerParityGroupVisibility.CreatedById,
            UpdatedAt = customerParityGroupVisibility.UpdatedAt,
            UpdatedById = customerParityGroupVisibility.UpdatedById
        };
    }

    public static CustomerParityGroupVisibility ToEntity(this CustomerParityGroupVisibilityCreateModel model)
    {
        return new CustomerParityGroupVisibility
        {
            CustomerId = model.CustomerId,
            ParityGroupId = model.ParityGroupId,
            IsVisible = model.IsVisible
        };
    }

    public static void UpdateEntity(this CustomerParityGroupVisibilityUpdateModel model, CustomerParityGroupVisibility entity)
    {
        entity.IsVisible = model.IsVisible;
    }
}
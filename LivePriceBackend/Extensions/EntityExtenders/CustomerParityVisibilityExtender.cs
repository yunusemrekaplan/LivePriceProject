using LivePriceBackend.DTOs.CustomerParityVisibility;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class CustomerParityVisibilityExtender
{
    public static CustomerParityVisibilityViewModel ToViewModel(this CustomerParityVisibility customerParityVisibility)
    {
        return new CustomerParityVisibilityViewModel
        {
            Id = customerParityVisibility.Id,
            CustomerId = customerParityVisibility.CustomerId,
            ParityId = customerParityVisibility.ParityId,
            IsVisible = customerParityVisibility.IsVisible,
            CustomerName = customerParityVisibility.Customer?.Name,
            ParityName = customerParityVisibility.Parity?.Name,
            CreatedAt = customerParityVisibility.CreatedAt,
            CreatedById = customerParityVisibility.CreatedById,
            UpdatedAt = customerParityVisibility.UpdatedAt,
            UpdatedById = customerParityVisibility.UpdatedById
        };
    }

    public static CustomerParityVisibility ToEntity(this CustomerParityVisibilityCreateModel model)
    {
        return new CustomerParityVisibility
        {
            CustomerId = model.CustomerId,
            ParityId = model.ParityId,
            IsVisible = model.IsVisible
        };
    }

    public static void UpdateEntity(this CustomerParityVisibilityUpdateModel model, CustomerParityVisibility entity)
    {
        entity.IsVisible = model.IsVisible;
    }
}
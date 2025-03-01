using LivePriceBackend.DTOs.ParityGroup;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class ParityGroupExtender
{
    public static ParityGroupViewModel ToViewModel(this ParityGroup parityGroup)
    {
        return new ParityGroupViewModel
        {
            Id = parityGroup.Id,
            Name = parityGroup.Name,
            Description = parityGroup.Description,
            IsEnabled = parityGroup.IsEnabled,
            OrderIndex = parityGroup.OrderIndex
        };
    }

    public static ParityGroup ToEntity(this ParityGroupCreateModel model)
    {
        return new ParityGroup
        {
            Name = model.Name,
            Description = model.Description,
            IsEnabled = model.IsEnabled,
            OrderIndex = model.OrderIndex
        };
    }

    public static void UpdateEntity(this ParityGroupUpdateModel model, ParityGroup parityGroup)
    {
        parityGroup.Name = model.Name;
        parityGroup.Description = model.Description;
        parityGroup.IsEnabled = model.IsEnabled;
        parityGroup.OrderIndex = model.OrderIndex;
    }
}
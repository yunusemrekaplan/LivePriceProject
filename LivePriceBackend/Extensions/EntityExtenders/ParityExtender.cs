using LivePriceBackend.DTOs.Parity;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class ParityExtender
{
    public static ParityViewModel ToViewModel(this Parity parity)
    {
        return new ParityViewModel
        {
            Id = parity.Id,
            Name = parity.Name,
            Symbol = parity.Symbol,
            IsEnabled = parity.IsEnabled,
            OrderIndex = parity.OrderIndex,
            ParityGroupId = parity.ParityGroupId,
            CustomerPriceRules = parity.CustomerPriceRules.Select(cpr => cpr.ToViewModel()).ToList(),
            CreatedAt = parity.CreatedAt,
            CreatedById = parity.CreatedById,
            UpdatedAt = parity.UpdatedAt,
            UpdatedById = parity.UpdatedById
        };
    }

    public static Parity ToEntity(this ParityCreateModel parityCreateModel)
    {
        return new Parity
        {
            Name = parityCreateModel.Name,
            Symbol = parityCreateModel.Symbol,
            IsEnabled = parityCreateModel.IsEnabled,
            OrderIndex = parityCreateModel.OrderIndex,
            ParityGroupId = parityCreateModel.ParityGroupId
        };
    }

    public static void UpdateEntity(this ParityUpdateModel parityUpdateModel, Parity parity)
    {
        parity.Name = parityUpdateModel.Name ?? parity.Name;
        parity.Symbol = parityUpdateModel.Symbol ?? parity.Symbol;
        parity.IsEnabled = parityUpdateModel.IsEnabled;
        parity.OrderIndex = parityUpdateModel.OrderIndex;
        parity.ParityGroupId = parityUpdateModel.ParityGroupId;
    }
}
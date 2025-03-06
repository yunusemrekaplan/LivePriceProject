using LivePriceBackend.DTOs.Customer;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class CustomerExtender
{
    public static CustomerViewModel ToViewModel(this Customer customer)
    {
        return new CustomerViewModel
        {
            Id = customer.Id,
            Name = customer.Name,
            Users = customer.Users?.Select(u => u.ToViewModel()).ToList(),
            CustomerPriceRules = customer.CustomerPriceRules?.Select(cpr => cpr.ToViewModel()).ToList(),
            ParityVisibilities = customer.ParityVisibilities?.Select(pv => pv.ToViewModel()).ToList(),
            ParityGroupVisibilities = customer.ParityGroupVisibilities?.Select(pgv => pgv.ToViewModel()).ToList(),
            CreatedAt = customer.CreatedAt,
            CreatedById = customer.CreatedById,
            UpdatedAt = customer.UpdatedAt,
            UpdatedById = customer.UpdatedById
        };
    }

    public static Customer ToEntity(this CustomerCreateModel customerCreateModel)
    {
        return new Customer
        {
            Name = customerCreateModel.Name
        };
    }

    public static void UpdateEntity(this CustomerUpdateModel customerUpdateModel, Customer customer)
    {
        customer.Name = customerUpdateModel.Name;
    }
}
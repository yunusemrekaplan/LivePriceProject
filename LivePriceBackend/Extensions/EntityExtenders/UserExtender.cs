using LivePriceBackend.DTOs.User;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class UserExtender
{
    public static UserViewModel ToViewModel(this User user)
    {
        return new UserViewModel
        {
            Id = user.Id,
            Name = user.Name,
            Surname = user.Surname,
            Username = user.Username,
            Email = user.Email,
            Role = user.Role,
            CustomerId = user.CustomerId,
            CustomerName = user.Customer?.Name,
            CreatedAt = user.CreatedAt,
            CreatedById = user.CreatedById,
            UpdatedAt = user.UpdatedAt,
            UpdatedById = user.UpdatedById
        };
    }

    public static User ToEntity(this UserCreateModel userCreateModel)
    {
        return new User
        {
            Name = userCreateModel.Name,
            Surname = userCreateModel.Surname,
            Username = userCreateModel.Username,
            Email = userCreateModel.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(userCreateModel.Password),
            Role = userCreateModel.Role,
            CustomerId = userCreateModel.CustomerId
        };
    }

    public static void UpdateEntity(this UserUpdateModel userUpdateModel, User user)
    {
        user.Name = userUpdateModel.Name ?? user.Name;
        user.Surname = userUpdateModel.Surname ?? user.Surname;
        user.Username = userUpdateModel.Username ?? user.Username;
        user.Email = userUpdateModel.Email ?? user.Email;

        if (!string.IsNullOrEmpty(userUpdateModel.Password))
        {
            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(userUpdateModel.Password);
        }

        user.Role = userUpdateModel.Role ?? user.Role;
        user.CustomerId = userUpdateModel.CustomerId ?? user.CustomerId;
    }
}
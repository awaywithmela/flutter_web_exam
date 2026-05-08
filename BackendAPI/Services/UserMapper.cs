using BackendAPI.DTOs;
using BackendAPI.Models;

namespace BackendAPI.Services;

public static class UserMapper
{
    public static UserProfileDto ToProfileDto(User user)
    {
        return new UserProfileDto(
            user.Id,
            user.FirstName,
            user.MiddleName,
            user.LastName,
            user.Email,
            user.PhoneNumber,
            user.BirthDate,
            user.Gender,
            user.Address,
            user.City,
            user.Country,
            user.ProfilePictureUrl,
            user.CreatedAt,
            user.UpdatedAt,
            user.IsAdmin);
    }
}

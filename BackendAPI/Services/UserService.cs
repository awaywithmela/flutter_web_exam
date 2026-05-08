using BackendAPI.Data;
using BackendAPI.DTOs;
using BackendAPI.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace BackendAPI.Services;

public class UserService(AppDbContext dbContext) : IUserService
{
    public async Task<UserProfileDto> GetProfileAsync(int userId)
    {
        var user = await dbContext.Users.FindAsync(userId)
            ?? throw new KeyNotFoundException("User was not found.");

        return UserMapper.ToProfileDto(user);
    }

    public async Task<IEnumerable<UserProfileDto>> GetAllUsersAsync()
    {
        var users = await dbContext.Users.ToListAsync();
        return users.Select(UserMapper.ToProfileDto);
    }

    public async Task<UserProfileDto> UpdateProfileAsync(int userId, UpdateUserDto dto)
    {
        var user = await dbContext.Users.FindAsync(userId)
            ?? throw new KeyNotFoundException("User was not found.");

        user.FirstName = dto.FirstName.Trim();
        user.MiddleName = string.IsNullOrWhiteSpace(dto.MiddleName) ? null : dto.MiddleName.Trim();
        user.LastName = dto.LastName.Trim();
        user.PhoneNumber = dto.PhoneNumber;
        user.BirthDate = dto.BirthDate;
        user.Gender = dto.Gender;
        user.Address = dto.Address;
        user.City = dto.City;
        user.Country = dto.Country;
        user.ProfilePictureUrl = dto.ProfilePictureUrl;
        user.UpdatedAt = DateTime.UtcNow;

        await dbContext.SaveChangesAsync();

        return UserMapper.ToProfileDto(user);
    }
}

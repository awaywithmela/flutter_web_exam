using BackendAPI.DTOs;

namespace BackendAPI.Interfaces;

public interface IUserService
{
    Task<UserProfileDto> GetProfileAsync(int userId);
    Task<IEnumerable<UserProfileDto>> GetAllUsersAsync();

    Task<UserProfileDto> UpdateProfileAsync(int userId, UpdateUserDto dto);
}

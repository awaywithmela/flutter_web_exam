using BackendAPI.Data;
using BackendAPI.DTOs;
using BackendAPI.Interfaces;
using BackendAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BackendAPI.Services;

public class AuthService(AppDbContext dbContext, JwtService jwtService) : IAuthService
{
    public async Task<AuthResponseDto> RegisterAsync(RegisterDto dto)
    {
        var normalizedEmail = dto.Email.Trim().ToLowerInvariant();
        var emailExists = await dbContext.Users.AnyAsync(user => user.Email == normalizedEmail);

        if (emailExists)
        {
            throw new InvalidOperationException("A user with this email already exists.");
        }

        var now = DateTime.UtcNow;
        var user = new User
        {
            FirstName = dto.FirstName.Trim(),
            MiddleName = string.IsNullOrWhiteSpace(dto.MiddleName) ? null : dto.MiddleName.Trim(),
            LastName = dto.LastName.Trim(),
            Email = normalizedEmail,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
            PhoneNumber = dto.PhoneNumber,
            BirthDate = dto.BirthDate,
            Gender = dto.Gender,
            Address = dto.Address,
            City = dto.City,
            Country = dto.Country,
            CreatedAt = now,
            UpdatedAt = now
        };

        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        return new AuthResponseDto(jwtService.GenerateToken(user), UserMapper.ToProfileDto(user));
    }

    public async Task<AuthResponseDto> LoginAsync(LoginDto dto)
    {
        var normalizedEmail = dto.Email.Trim().ToLowerInvariant();
        var user = await dbContext.Users.SingleOrDefaultAsync(user => user.Email == normalizedEmail);

        if (user is null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Invalid email or password.");
        }

        return new AuthResponseDto(jwtService.GenerateToken(user), UserMapper.ToProfileDto(user));
    }
}

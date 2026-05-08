namespace BackendAPI.DTOs;

public record UserProfileDto(
    int Id,
    string FirstName,
    string? MiddleName,
    string LastName,
    string Email,
    string? PhoneNumber,
    DateTime? BirthDate,
    string? Gender,
    string? Address,
    string? City,
    string? Country,
    string? ProfilePictureUrl,
    DateTime CreatedAt,
    DateTime UpdatedAt,
    bool IsAdmin);

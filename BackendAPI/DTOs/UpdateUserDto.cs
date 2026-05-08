using System.ComponentModel.DataAnnotations;

namespace BackendAPI.DTOs;

public record UpdateUserDto(
    [Required, MaxLength(100)] string FirstName,
    [MaxLength(100)] string? MiddleName,
    [Required, MaxLength(100)] string LastName,
    [MaxLength(40)] string? PhoneNumber,
    DateTime? BirthDate,
    [MaxLength(40)] string? Gender,
    string? Address,
    [MaxLength(100)] string? City,
    [MaxLength(100)] string? Country,
    string? ProfilePictureUrl);

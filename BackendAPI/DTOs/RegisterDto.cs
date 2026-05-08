using System.ComponentModel.DataAnnotations;

namespace BackendAPI.DTOs;

public record RegisterDto(
    [Required, MaxLength(100)] string FirstName,
    [MaxLength(100)] string? MiddleName,
    [Required, MaxLength(100)] string LastName,
    [Required, EmailAddress, MaxLength(255)] string Email,
    [Required, MinLength(8)] string Password,
    [MaxLength(40)] string? PhoneNumber,
    DateTime? BirthDate,
    [MaxLength(40)] string? Gender,
    string? Address,
    [MaxLength(100)] string? City,
    [MaxLength(100)] string? Country);

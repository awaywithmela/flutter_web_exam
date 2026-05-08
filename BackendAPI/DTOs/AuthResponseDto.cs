namespace BackendAPI.DTOs;

public record AuthResponseDto(string Token, UserProfileDto User);

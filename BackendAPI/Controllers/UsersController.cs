using System.Security.Claims;
using BackendAPI.DTOs;
using BackendAPI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BackendAPI.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class UsersController(IUserService userService) : ControllerBase
{
    [HttpGet("profile")]
    public async Task<ActionResult<UserProfileDto>> GetProfile()
    {
        var userId = GetCurrentUserId();
        return Ok(await userService.GetProfileAsync(userId));
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<UserProfileDto>>> GetAllUsers()
    {
        var userId = GetCurrentUserId();
        var profile = await userService.GetProfileAsync(userId);
        if (!profile.IsAdmin) return Forbid();

        return Ok(await userService.GetAllUsersAsync());
    }

    [HttpPut("profile")]
    public async Task<ActionResult<UserProfileDto>> UpdateProfile(UpdateUserDto dto)
    {
        var userId = GetCurrentUserId();
        return Ok(await userService.UpdateProfileAsync(userId, dto));
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<UserProfileDto>> UpdateUser(int id, UpdateUserDto dto)
    {
        var adminId = GetCurrentUserId();
        var profile = await userService.GetProfileAsync(adminId);
        if (!profile.IsAdmin) return Forbid();

        return Ok(await userService.UpdateProfileAsync(id, dto));
    }

    private int GetCurrentUserId()
    {
        var id = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!int.TryParse(id, out var userId))
        {
            throw new UnauthorizedAccessException("JWT does not contain a valid user id.");
        }

        return userId;
    }
}

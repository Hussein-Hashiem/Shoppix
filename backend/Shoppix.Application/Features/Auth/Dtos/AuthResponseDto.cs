namespace Shoppix.Application.Features.Auth.Dtos;

public sealed record AuthResponseDto(
    string Name,
    string Email,
    string Token,
    int ExpiresIn,
    string RefreshToken,
    DateTime RefreshTokenExpiration);

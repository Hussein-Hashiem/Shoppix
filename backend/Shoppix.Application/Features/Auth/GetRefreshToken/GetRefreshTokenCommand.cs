namespace Shoppix.Application.Features.Auth.GetRefreshToken;

public sealed record GetRefreshTokenCommand(
    string token,
    string refreshToken) : IRequest<Result<AuthResponseDto>>;


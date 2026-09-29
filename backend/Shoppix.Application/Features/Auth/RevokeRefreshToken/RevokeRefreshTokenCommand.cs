namespace Shoppix.Application.Features.Auth.RevokeRefreshToken;

public sealed record RevokeRefreshTokenCommand(
    string token,
    string refreshToken) : IRequest<Result>;


namespace Shoppix.Application.Features.Auth.Logout;

public sealed record LogoutCommand(string RefreshToken) : IRequest<Result>;

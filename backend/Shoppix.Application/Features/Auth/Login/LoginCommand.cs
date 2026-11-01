namespace Shoppix.Application.Features.Auth.Login;

public sealed record LoginCommand(string Email, string Password) : IRequest<Result<AuthResponseDto>>;

namespace Shoppix.Application.Features.Auth.Register;

public sealed record RegisterCommand(
    string Name,
    string Email,
    string Password) : IRequest<Result<RegisterResponseDto>>;

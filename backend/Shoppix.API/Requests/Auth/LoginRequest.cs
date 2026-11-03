namespace Shoppix.API.Requests.Auth;

public sealed record LoginRequest(
    string Email,
    string Password);

public static class LoginRequestMappings
{
    public static LoginCommand ToCommand(this LoginRequest request) =>
        new(request.Email, request.Password);
}

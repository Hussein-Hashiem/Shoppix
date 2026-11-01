namespace Shoppix.API.Requests.Auth;

public sealed record RegisterRequest(
   string Name,
   string Email,
   string Password);

public static class RegisterRequestMappings
{
    public static RegisterCommand ToCommand(this RegisterRequest request) =>
        new(request.Name, request.Email, request.Password);
}

namespace Shoppix.Application.Features.Auth.Register;

public sealed record RegisterResponseDto(
    string UserId,
    string name,
    string email);

public static class RegisterMappings
{
    public static RegisterResponseDto ToRegisterResponse(this ApplicationUser user) 
        => new(user.Id.ToString(), user.Name, user.Email! );
}

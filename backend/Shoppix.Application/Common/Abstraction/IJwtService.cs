namespace Shoppix.Application.Common.Abstraction;

public interface IJwtService
{
    (string token, int expiresIn) GenerateToken(ApplicationUser user, IEnumerable<string> roles);
    string? ValidateToken(string token);
}

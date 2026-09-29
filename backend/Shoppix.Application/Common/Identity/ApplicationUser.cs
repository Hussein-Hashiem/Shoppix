namespace Shoppix.Application.Identity;

public class ApplicationUser : IdentityUser<Guid>
{
    public string Name { get; set; } = string.Empty;

    public ICollection<RefreshToken> RefreshTokens { get; set; } = [];
}

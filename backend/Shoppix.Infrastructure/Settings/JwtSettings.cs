namespace Shoppix.Infrastructure.Settings;

public class JwtSettings
{
    public static string Name = "Jwt";

    [Required]
    public string Key { get; set; } = string.Empty;

    [Required]
    public string Issuer { get; set; } = string.Empty;

    [Required]
    public string Audience { get; set; } = string.Empty;

    [Range(1, int.MaxValue)]
    public int ExpiryMinutes { get; set; }

    [Range(1, 30)]
    public int RefreshTokenExpiryDays { get; set; }
}

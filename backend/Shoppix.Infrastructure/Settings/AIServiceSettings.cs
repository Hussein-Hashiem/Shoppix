namespace Shoppix.Infrastructure.Settings;

public class AIServiceSettings
{
    public const string Name = "AiService";

    public string BaseUrl { get; set; } = string.Empty;
    public int TimeoutSeconds { get; set; } 
}
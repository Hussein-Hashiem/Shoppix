namespace Shoppix.Infrastructure.Settings
{
    public class CloudinarySettings
    {
        public const string Name = "CloudinarySettings";
        [Required]
        public string CloudName { get; set; } = string.Empty;
        [Required]
        public string ApiKey { get; set; } = string.Empty;
        [Required]
        public string ApiSecret { get; set; } = string.Empty;
    }
}

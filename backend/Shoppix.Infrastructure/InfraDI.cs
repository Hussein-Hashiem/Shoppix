namespace Shoppix.Infrastructure;

public static class InfraDI
{
    public static IServiceCollection AddInfrastructureDependency(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<AppDbContext>(options
            => options.UseSqlServer(configuration.GetConnectionString("defaultConnection")));

        services.AddScoped<IAppDbContext, AppDbContext>();
        services.AddScoped<IFileService, CloudinaryFileService>();

        services.AddSingleton<IJwtService, JwtService>();

        services
                .AddIdentity<ApplicationUser, ApplicationRole>()
                .AddEntityFrameworkStores<AppDbContext>()
                .AddDefaultTokenProviders();

        services
            .AddOptions<JwtSettings>()
            .BindConfiguration(JwtSettings.Name)
            .ValidateDataAnnotations()
            .ValidateOnStart();

        var jwtSettings = configuration.GetSection(JwtSettings.Name).Get<JwtSettings>();

        services.AddAuthentication(options =>
        {
            options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
            options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
        })
        .AddJwtBearer(o =>
        {
            o.SaveToken = true;
            o.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings!.Key)),
                ValidIssuer = jwtSettings.Issuer,
                ValidAudience = jwtSettings.Audience
            };
        });

        services.Configure<IdentityOptions>(options =>
        {
            options.Password.RequiredLength = 8;

            options.User.RequireUniqueEmail = true;
        });

        services.Configure<CloudinarySettings>(configuration.GetSection(CloudinarySettings.Name));

        return services;
    }
}

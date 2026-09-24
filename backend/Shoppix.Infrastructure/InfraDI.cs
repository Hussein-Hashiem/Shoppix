namespace Shoppix.Infrastructure;

public static class InfraDI
{
    public static IServiceCollection AddInfrastructureDependency(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<AppDbContext>(options
            => options.UseSqlServer(configuration.GetConnectionString("defaultConnection")));

        services.AddScoped<IAppDbContext, AppDbContext>();

        return services;
    }
}

using Shoppix.Application.Common.Behaviours;

namespace Shoppix.Application;

public static class ApplicationDI
{
    public static IServiceCollection AddApplicationDependency(this IServiceCollection services)
    {
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());

        services.AddMediatR(cfg =>
        {
            cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());

            cfg.AddOpenBehavior(typeof(ValidationBehavior<,>));
        });

        return services;
    }
}

namespace Shoppix.Application.Common.Abstraction;

public interface IAppDbContext
{
    // DbSet

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}

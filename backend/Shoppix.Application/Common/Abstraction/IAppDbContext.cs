namespace Shoppix.Application.Common.Abstraction;

public interface IAppDbContext
{
    // DbSet
    public DbSet<Product> Products { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}

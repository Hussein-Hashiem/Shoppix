namespace Shoppix.Application.Common.Abstraction;

public interface IAppDbContext
{
    // DbSet
    public DbSet<Product> Products { get; }
    public DbSet<Order> Orders { get; }
    public DbSet<OrderItem> OrderItems { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}

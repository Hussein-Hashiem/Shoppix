namespace Shoppix.Application.Common.Abstraction;

public interface IRelatedProductsClientService
{
    Task<IReadOnlyList<RelatedProductScore>> GetRelatedAsync(
        int productId, int limit, CancellationToken cancellationToken);
}

public record RelatedProductScore(int Id, double Score);
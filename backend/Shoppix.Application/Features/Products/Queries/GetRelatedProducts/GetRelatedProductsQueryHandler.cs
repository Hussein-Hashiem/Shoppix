using Microsoft.Extensions.Logging;

namespace Shoppix.Application.Features.Products.Queries.GetRelatedProducts;

public class GetRelatedProductsQueryHandler(
    IRelatedProductsClientService aiClient,
    IAppDbContext _db,
    ILogger<GetRelatedProductsQueryHandler> logger)
    : IRequestHandler<GetRelatedProductsQuery, Result<IReadOnlyList<RelatedProductDto>>>
{
    public async Task<Result<IReadOnlyList<RelatedProductDto>>> Handle(
        GetRelatedProductsQuery request, CancellationToken ct)
    {
        IReadOnlyList<RelatedProductDto> empty = Array.Empty<RelatedProductDto>();

        IReadOnlyList<RelatedProductScore> related;
        try
        {
            related = await aiClient.GetRelatedAsync(request.ProductId, request.Limit, ct);
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            logger.LogWarning(ex, "AI related-products call failed for product {ProductId}", request.ProductId);
            return Result.Success(empty);
        }

        var relevant = related.Where(r => r.Score >= 0.02).ToList();

        if (relevant.Count == 0)
            return Result.Success(empty);

        var ids = relevant.Select(r => r.Id).ToList();

        var products = await _db.Products
            .AsNoTracking()
            .Where(p => ids.Contains(p.Id) && p.StockQuantity > 0)
            .ToListAsync(ct);

        var scores = relevant.ToDictionary(r => r.Id, r => r.Score);

        IReadOnlyList<RelatedProductDto> dtos = products
            .OrderByDescending(p => scores[p.Id])
            .Select(p => new RelatedProductDto(
                p.Id, p.Name, p.Description, p.Price, p.StockQuantity, p.Url, scores[p.Id]))
            .ToList();

        return Result.Success(dtos);
    }
}
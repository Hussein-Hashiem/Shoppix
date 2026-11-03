namespace Shoppix.Application.Features.Products.Queries.GetRelatedProducts;

public sealed record GetRelatedProductsQuery(int ProductId, int Limit = 4)
    : IRequest<Result<IReadOnlyList<RelatedProductDto>>>;

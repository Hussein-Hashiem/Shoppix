namespace Shoppix.Application.Features.Products.Queries.GetProducts
{
    public sealed record GetProductsQuery() : IRequest<Result<List<ProductResponseDto>>>;
}

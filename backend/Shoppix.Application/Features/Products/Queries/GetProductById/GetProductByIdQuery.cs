namespace Shoppix.Application.Features.Products.Queries.GetProductById
{
    public sealed record GetProductByIdQuery(int Id) : IRequest<Result<ProductResponseDto>>;
}

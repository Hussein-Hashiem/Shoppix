namespace Shoppix.Application.Features.Products.Command.CreateProduct
{
    public sealed record CreateProductCommand(
        string Name,
        string Description,
        decimal Price,
        int StockQuantity,
        IFormFile Image) : IRequest<Result<ProductResponseDto>>;
}

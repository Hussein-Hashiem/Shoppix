namespace Shoppix.Application.Features.Products.Command.UpdateProduct
{
    public sealed record UpdateProductCommand(
        int Id,
        string Name,
        string Description,
        decimal Price,
        int StockQuantity) : IRequest<Result>;
}

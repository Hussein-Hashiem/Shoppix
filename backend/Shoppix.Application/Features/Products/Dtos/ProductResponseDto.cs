namespace Shoppix.Application.Features.Products.Dtos
{
    public sealed record ProductResponseDto(int Id, string Description, string Name, decimal Price, int StockQuantity,string ImageUrl);

    public static class ProductMappings
    {
        public static ProductResponseDto ToProductResponse(this Product product) => new(
                product.Id,
                product.Description,
                product.Name,
                product.Price,
                product.StockQuantity,
                product.Url
            );
    }
}

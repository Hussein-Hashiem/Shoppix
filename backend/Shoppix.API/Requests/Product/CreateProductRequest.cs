namespace Shoppix.API.Requests.Product
{
    public sealed record CreateProductRequest(string Name,string Description, decimal Price, int StockQuantity,IFormFile Image);

    public static class ProductCreateRequestMappings
    {
        public static CreateProductCommand ToCommand(this CreateProductRequest request) =>
            new(
                request.Name,
                request.Description,
                request.Price,
                request.StockQuantity,
                request.Image
            );
    }
}

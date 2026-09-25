namespace Shoppix.API.Requests.Product
{
    public sealed record UpdateProductRequest(string Name,string Description, decimal Price,int StockQuantity);

    public static class ProductUpdateRequestMappings
    {
        public static UpdateProductCommand ToCommand(this UpdateProductRequest request, int id)
        {
            return new UpdateProductCommand(
                id,
                request.Description,
                request.Name,
                request.Price,
                request.StockQuantity);
        }
    }
}

namespace Shoppix.Application.Common.Errors
{
    public static class ProductErrors
    {
        public static readonly Error NotFound = new Error("Product.NotFound", "Product not found", ErrorType.NotFound);
    }
}

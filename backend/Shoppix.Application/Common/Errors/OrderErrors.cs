namespace Shoppix.Application.Common.Errors;

public static class OrderErrors
{
    public static Error Unauthorized => Error.Unauthorized("Order.Unauthorized", "The current user could not be identified.");

    public static Error MissingProducts(IEnumerable<int> productIds) =>
        Error.NotFound("Order.ProductsNotFound", $"Products not found: {string.Join(", ", productIds)}.");

    public static Error InsufficientStock(string productName, int availableStock) =>
        Error.Validation("Order.InsufficientStock", $"Product '{productName}' has only {availableStock} items available.");
}

namespace Shoppix.Application.Features.Products.Dtos;

public record RelatedProductDto(
    int Id,
    string Name,
    string? Description,
    decimal Price,
    int StockQuantity,
    string? ImageUrl,
    double Score);

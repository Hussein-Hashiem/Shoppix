namespace Shoppix.Application.Features.Orders.Dtos;

public sealed record OrderResponseDto(int Id, DateTime OrderDate, decimal TotalPrice, string Status);

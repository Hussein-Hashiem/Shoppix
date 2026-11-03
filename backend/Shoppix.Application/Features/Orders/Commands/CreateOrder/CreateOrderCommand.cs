using Shoppix.Application.Features.Orders.Dtos;

namespace Shoppix.Application.Features.Orders.Commands.CreateOrder;

public sealed record CreateOrderItem(int ProductId, int Quantity);

public sealed record CreateOrderCommand(IReadOnlyList<CreateOrderItem>? Items)
    : IRequest<Result<OrderResponseDto>>;

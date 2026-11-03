using Shoppix.Application.Features.Orders.Dtos;

namespace Shoppix.Application.Features.Orders.Queries.GetMyOrders;

public sealed record GetMyOrdersQuery : IRequest<Result<List<OrderResponseDto>>>;

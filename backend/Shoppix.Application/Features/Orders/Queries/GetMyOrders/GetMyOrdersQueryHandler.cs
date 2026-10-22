using Shoppix.Application.Features.Orders.Dtos;

namespace Shoppix.Application.Features.Orders.Queries.GetMyOrders;

public class GetMyOrdersQueryHandler(IAppDbContext db, ICurrentUserService currentUser)
    : IRequestHandler<GetMyOrdersQuery, Result<List<OrderResponseDto>>>
{
    public async Task<Result<List<OrderResponseDto>>> Handle(
        GetMyOrdersQuery request,
        CancellationToken cancellationToken)
    {
        if (currentUser.UserId is not Guid userId)
            return Result.Failure<List<OrderResponseDto>>(OrderErrors.Unauthorized);

        var orders = await db.Orders
            .AsNoTracking()
            .Where(order => order.UserId == userId)
            .OrderByDescending(order => order.OrderDate)
            .Select(order => new OrderResponseDto(
                order.Id,
                order.OrderDate,
                order.TotalPrice,
                order.Status.ToString()))
            .ToListAsync(cancellationToken);

        return Result.Success(orders);
    }
}

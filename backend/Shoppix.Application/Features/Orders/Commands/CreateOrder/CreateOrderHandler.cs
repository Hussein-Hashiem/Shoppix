using Shoppix.Application.Features.Orders.Dtos;

namespace Shoppix.Application.Features.Orders.Commands.CreateOrder;

public class CreateOrderHandler(IAppDbContext db, ICurrentUserService currentUser)
    : IRequestHandler<CreateOrderCommand, Result<OrderResponseDto>>
{
    public async Task<Result<OrderResponseDto>> Handle(
        CreateOrderCommand request,
        CancellationToken cancellationToken)
    {
        if (currentUser.UserId is not Guid userId)
            return Result.Failure<OrderResponseDto>(OrderErrors.Unauthorized);

        var requestedItems = request.Items!
            .GroupBy(item => item.ProductId)
            .Select(group => new
            {
                ProductId = group.Key,
                Quantity = group.Sum(item => item.Quantity)
            })
            .ToList();

        var productIds = requestedItems.Select(item => item.ProductId).ToList();
        var products = await db.Products
            .Where(product => productIds.Contains(product.Id))
            .ToListAsync(cancellationToken);

        var productsById = products.ToDictionary(product => product.Id);
        var missingProductIds = productIds.Where(productId => !productsById.ContainsKey(productId)).ToList();
        if (missingProductIds.Count > 0)
            return Result.Failure<OrderResponseDto>(OrderErrors.MissingProducts(missingProductIds));

        foreach (var item in requestedItems)
        {
            var product = productsById[item.ProductId];
            if (product.StockQuantity < item.Quantity)
                return Result.Failure<OrderResponseDto>(OrderErrors.InsufficientStock(product.Name, product.StockQuantity));
        }

        var order = new Order
        {
            UserId = userId,
            OrderDate = DateTime.UtcNow,
            Status = OrderStatus.Confirmed
        };

        foreach (var item in requestedItems)
        {
            var product = productsById[item.ProductId];
            order.Items.Add(new OrderItem
            {
                ProductId = product.Id,
                Quantity = item.Quantity,
                UnitPrice = product.Price
            });
        }

        order.TotalPrice = order.Items.Sum(item => item.UnitPrice * item.Quantity);
        db.Orders.Add(order);
        await db.SaveChangesAsync(cancellationToken);

        return Result.Success(new OrderResponseDto(
            order.Id,
            order.OrderDate,
            order.TotalPrice,
            order.Status.ToString()));
    }
}

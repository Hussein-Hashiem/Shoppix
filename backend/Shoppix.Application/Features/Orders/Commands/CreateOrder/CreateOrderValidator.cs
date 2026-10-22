namespace Shoppix.Application.Features.Orders.Commands.CreateOrder;

public class CreateOrderValidator : AbstractValidator<CreateOrderCommand>
{
    public CreateOrderValidator()
    {
        RuleFor(x => x.Items)
            .NotNull()
            .NotEmpty();

        RuleForEach(x => x.Items)
            .ChildRules(item =>
            {
                item.RuleFor(x => x.ProductId)
                    .GreaterThan(0);

                item.RuleFor(x => x.Quantity)
                    .GreaterThan(0)
                    .LessThanOrEqualTo(1000);
            });
    }
}

namespace Shoppix.Application.Features.Products.Queries.GetRelatedProducts;

public class GetRelatedProductsQueryValidator : AbstractValidator<GetRelatedProductsQuery>
{
    public GetRelatedProductsQueryValidator()
    {
        RuleFor(x => x.ProductId).GreaterThan(0);
        RuleFor(x => x.Limit).InclusiveBetween(1, 20);
    }
}
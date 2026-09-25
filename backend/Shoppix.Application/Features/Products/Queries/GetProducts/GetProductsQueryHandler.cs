namespace Shoppix.Application.Features.Products.Queries.GetProducts
{
    public class GetProductsQueryHandler(IAppDbContext _db) : IRequestHandler<GetProductsQuery, Result<List<ProductResponseDto>>>
    {
        public async Task<Result<List<ProductResponseDto>>> Handle(GetProductsQuery request, CancellationToken cancellationToken)
        {
            var products = await _db.Products.AsNoTracking().Select(p => p.ToProductResponse()).ToListAsync(cancellationToken);
            return Result.Success(products);
        }
    }
}

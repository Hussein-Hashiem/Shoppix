namespace Shoppix.Application.Features.Products.Queries.GetProductById
{
    public class GetProductByIdQueryHandler(IAppDbContext _db) : IRequestHandler<GetProductByIdQuery, Result<ProductResponseDto>>
    {
        public async Task<Result<ProductResponseDto>> Handle(GetProductByIdQuery request, CancellationToken cancellationToken)
        {
            var product = await _db.Products.FindAsync(request.Id, cancellationToken);

            if(product is null)
            {
                return Result.Failure<ProductResponseDto>(ProductErrors.NotFound);
            }

            return Result.Success(product.ToProductResponse());
        }
    }
}

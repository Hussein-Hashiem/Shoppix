namespace Shoppix.Application.Features.Products.Command.UpdateProduct
{
    internal class UpdateProductHandler(IAppDbContext _db) : IRequestHandler<UpdateProductCommand, Result>
    {
        public async Task<Result> Handle(UpdateProductCommand request, CancellationToken cancellationToken)
        {
            var product = await _db.Products.FirstAsync(p => p.Id == request.Id, cancellationToken);
            if(product is null)
            {
                return Result.Failure(ProductErrors.NotFound);
            }

            product.Name = request.Name;
            product.Description = request.Description;
            product.Price = request.Price;
            product.StockQuantity = request.StockQuantity;

            await _db.SaveChangesAsync(cancellationToken);
            return Result.Success();
        }
    }
}

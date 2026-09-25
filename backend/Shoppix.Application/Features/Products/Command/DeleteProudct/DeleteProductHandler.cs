namespace Shoppix.Application.Features.Products.Command.DeleteProudct
{
    public class DeleteProductHandler(IAppDbContext _db,IFileService _fileService) : IRequestHandler<DeleteProductCommand, Result>
    {
        public async Task<Result> Handle(DeleteProductCommand request, CancellationToken cancellationToken)
        {
            var product = await _db.Products.FindAsync(new object[] { request.Id }, cancellationToken);

            if (product is null)
            {
                return Result.Failure(ProductErrors.NotFound);
            }

            await _fileService.DeleteImageAsync(product!.PublicId, cancellationToken);

            _db.Products.Remove(product);
            await _db.SaveChangesAsync(cancellationToken);
            return Result.Success();
        }
    }
}
namespace Shoppix.Application.Features.Products.Command.CreateProduct
{
    public class CreateProductHandler(IAppDbContext _db, IFileService _fileService): IRequestHandler<CreateProductCommand, Result<ProductResponseDto>>
    {
        public async Task<Result<ProductResponseDto>> Handle(CreateProductCommand request, CancellationToken cancellationToken)
        {
            var cloudFile = await _fileService.UploadImageAsync(request.Image,cancellationToken);

            var product = new Product
            {
                Name = request.Name,
                Description = request.Description,
                Price = request.Price,
                StockQuantity = request.StockQuantity,
                PublicId = cloudFile.PublicId,
                Url = cloudFile.Url,
                ContentType = cloudFile.ContentType
            };

            _db.Products.Add(product);

            await _db.SaveChangesAsync(cancellationToken);
            return Result.Success(product.ToProductResponse());
        }
    }
}
namespace Shoppix.Application.Features.Products.Command.CreateProduct;

public class CreateProductValidator : AbstractValidator<CreateProductCommand>
{

    private static readonly string[] AllowedContentTypes =
    [
        "image/jpeg",
        "image/png",
        "image/webp"
    ];

    private const long MaxFileSize = 5 * 1024 * 1024; // 5 MB
    public CreateProductValidator()
    {

        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(50);

        RuleFor(x => x.Description)
            .NotEmpty()
            .MaximumLength(2000);

        RuleFor(x => x.Price)
            .GreaterThan(0);

        RuleFor(x => x.StockQuantity)
            .GreaterThanOrEqualTo(0);

        RuleFor(x => x.Image)

            .NotNull()
            .WithMessage("Product image is required.")
            .Must(IsValidImage)
            .WithMessage("Image must be a JPG, PNG, or WEBP file and must not exceed 5 MB.");
    }

    private static bool IsValidImage(IFormFile? file)
    {
        if (file is null || file.Length == 0)
            return false;

        if (file.Length > MaxFileSize)
            return false;

        return AllowedContentTypes.Contains(
            file.ContentType,
            StringComparer.OrdinalIgnoreCase);
    }
}
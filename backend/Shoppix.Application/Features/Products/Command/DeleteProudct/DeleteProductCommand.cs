namespace Shoppix.Application.Features.Products.Command.DeleteProudct
{
    public sealed record DeleteProductCommand(int Id) : IRequest<Result>;
}

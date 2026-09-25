namespace Shoppix.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController(IMediator mediator) : ControllerBase
    {

        [HttpGet]
        public async Task<IActionResult> GetProducts(CancellationToken cancellationToken)
        {
            var result = await mediator.Send(new GetProductsQuery(), cancellationToken);

            return result.IsSuccess ? Ok(result.Value) : result.ToProblem();
        }


        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetProductById(int id,CancellationToken cancellationToken)
        {
            var result = await mediator.Send(new GetProductByIdQuery(id), cancellationToken);

            return result.IsSuccess ? Ok(result.Value) : result.ToProblem();
        }

        [HttpPost]
        public async Task<IActionResult> CreateProduct([FromForm] CreateProductRequest request, CancellationToken cancellationToken)
        {
            var result = await mediator.Send(request.ToCommand(), cancellationToken);

            return result.IsSuccess ? CreatedAtAction(nameof(GetProductById), new { id = result.Value.Id }, result.Value)
                : result.ToProblem();
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> UpdateProduct(int id,[FromBody] UpdateProductRequest request, CancellationToken cancellationToken)
        {
            var result = await mediator.Send(request.ToCommand(id), cancellationToken);

            return result.IsSuccess ? NoContent() : result.ToProblem();
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> DeleteProduct(int id, CancellationToken cancellationToken)
        {
            var result = await mediator.Send(new DeleteProductCommand(id),cancellationToken);

            return result.IsSuccess ? NoContent() : result.ToProblem();
        }
    }
}

using Shoppix.API.Requests.Studnet;
using Shoppix.Application.Features.Test.Command.AddStudent;
using Shoppix.Application.Features.Test.Queries.GetStudent;

namespace Shoppix.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TestStudentsController(IMediator mediator) : ControllerBase
    {
        [HttpPost("")]
        public async Task<IActionResult> Add([FromBody] AddStudentRequest request, CancellationToken cancellationToken)
        {
            var result = await mediator.Send(new AddStudentCommand(request.Name), cancellationToken);

            return result.IsSuccess ? Ok(result.Value) : result.ToProblem();
        }


        [HttpGet("{id}")]
        public async Task<IActionResult> GetStudnet([FromRoute] int id, CancellationToken cancellationToken)
        {
            var result = await mediator.Send(new GetStudentQuery(id), cancellationToken);

            return result.IsSuccess ? Ok(result.Value) : result.ToProblem();
        }
    }
}

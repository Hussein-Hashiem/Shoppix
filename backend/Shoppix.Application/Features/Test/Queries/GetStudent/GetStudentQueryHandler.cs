using Shoppix.Application.Features.Test.Dtos;

namespace Shoppix.Application.Features.Test.Queries.GetStudent;

public class GetStudentQueryHandler(IAppDbContext context) : IRequestHandler<GetStudentQuery, Result<StudentResponse>>
{
    public async Task<Result<StudentResponse>> Handle(GetStudentQuery request, CancellationToken cancellationToken)
    {
        var studnetOperations = new StudentOperations();

        var student = studnetOperations.GetAll().FirstOrDefault(x => x.Id == request.Id);

        if (student is null)
            return Result.Failure<StudentResponse>(Error.NotFound("Student.NotFound", $"This student not found with this id {request.Id}"));

        return Result.Success(new StudentResponse(student.Name));
    }
}

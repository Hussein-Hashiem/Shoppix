namespace Shoppix.Application.Features.Test.Command.AddStudent;

public class AddStudentCommandHandler : IRequestHandler<AddStudentCommand, Result<int>>
{
    public async Task<Result<int>> Handle(AddStudentCommand request, CancellationToken cancellationToken)
    {
        var studentOperations = new StudentOperations();

        int maxId = studentOperations.GetAll().Max(x => x.Id);

        var student = new Student { Id = maxId + 1, Name = request.Name};

        studentOperations.Add(student);

        return Result.Success(student.Id);
    }
}

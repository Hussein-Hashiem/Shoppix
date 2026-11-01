namespace Shoppix.Application.Features.Test.Command.AddStudent;

public record AddStudentCommand(string Name) : IRequest<Result<int>>;

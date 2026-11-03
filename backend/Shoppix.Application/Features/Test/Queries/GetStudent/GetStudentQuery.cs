using Shoppix.Application.Features.Test.Dtos;

namespace Shoppix.Application.Features.Test.Queries.GetStudent;

public record GetStudentQuery(int Id) : IRequest<Result<StudentResponse>>;


namespace Shoppix.Application.Features.Test.Queries.GetStudent;

public class GetStudentValidator : AbstractValidator<GetStudentQuery>
{
    public GetStudentValidator()
    {
        RuleFor(x => x.Id)
            .Cascade(CascadeMode.Stop)
            .NotEmpty()
            .GreaterThan(0);
    }
}

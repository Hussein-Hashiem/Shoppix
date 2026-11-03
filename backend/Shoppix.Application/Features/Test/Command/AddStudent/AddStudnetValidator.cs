namespace Shoppix.Application.Features.Test.Command.AddStudent;

public class AddStudnetValidator : AbstractValidator<AddStudentCommand>
{
    public AddStudnetValidator()
    {
        RuleFor(x => x.Name)
            .Cascade(CascadeMode.Stop)
            .NotEmpty()
            .MinimumLength(3)
            .MaximumLength(100);
    }
}

namespace Shoppix.Application.Features.Auth.Register;

public class RegisterCommandHandler(UserManager<ApplicationUser> userManager)
    : IRequestHandler<RegisterCommand, Result<RegisterResponseDto>>
{
    public async Task<Result<RegisterResponseDto>> Handle(RegisterCommand request, CancellationToken cancellationToken)
    {
        var existingUser = await userManager.FindByEmailAsync(request.Email);

        if (existingUser is not null)
        {
            return Result.Failure<RegisterResponseDto>(UserErrors.DuplicatedEmail);
        }

        var user = new ApplicationUser
        {
            Email = request.Email,
            UserName = request.Email,
            Name = request.Name,
            EmailConfirmed = true
        };

        var createResult = await userManager.CreateAsync(user, request.Password);

        if (!createResult.Succeeded)
        {
            var error = createResult.Errors.First();

            return Result.Failure<RegisterResponseDto>(new Error(error.Code, error.Description, ErrorType.BadRequest));
        }

        

        return Result.Success(user.ToRegisterResponse());
    }
}
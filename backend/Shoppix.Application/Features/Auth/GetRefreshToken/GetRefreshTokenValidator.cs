namespace Shoppix.Application.Features.Auth.GetRefreshToken;

public class GetRefreshTokenValidator : AbstractValidator<GetRefreshTokenCommand>
{
    public GetRefreshTokenValidator()
    {
        RuleFor(x => x.refreshToken)
            .NotEmpty();
        RuleFor(x => x.token)
            .NotEmpty();
    }
}

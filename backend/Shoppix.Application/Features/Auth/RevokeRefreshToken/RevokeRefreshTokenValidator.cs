namespace Shoppix.Application.Features.Auth.RevokeRefreshToken;
public class RevokeRefreshTokenValidator : AbstractValidator<RevokeRefreshTokenCommand>
{
    public RevokeRefreshTokenValidator()
    {
        RuleFor(x => x.refreshToken)
            .NotEmpty();
        RuleFor(x => x.token)
            .NotEmpty();
    }
}

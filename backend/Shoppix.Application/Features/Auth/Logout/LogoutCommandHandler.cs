namespace Shoppix.Application.Features.Auth.Logout;

public class LogoutCommandHandler(UserManager<ApplicationUser> _userManager)
: IRequestHandler<LogoutCommand, Result>
{
    public async Task<Result> Handle( LogoutCommand request,CancellationToken cancellationToken)
    {
        var user = await _userManager.Users.SingleOrDefaultAsync(u => u.RefreshTokens.Any(rt => rt.Token == request.RefreshToken),
                cancellationToken);

        if (user is null)
            return Result.Failure(UserErrors.InvalidTokens);

        var refreshToken = user.RefreshTokens.FirstOrDefault(rt => rt.Token == request.RefreshToken);

        if (refreshToken is null || !refreshToken.IsActive)
            return Result.Failure(UserErrors.InvalidTokens);

        refreshToken.RevokedOn = DateTime.UtcNow;

        await _userManager.UpdateAsync(user);

        return Result.Success();
    }
}

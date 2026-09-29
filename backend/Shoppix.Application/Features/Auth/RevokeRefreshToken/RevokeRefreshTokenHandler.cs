namespace Shoppix.Application.Features.Auth.RevokeRefreshToken;

public class RevokeRefreshTokenHandler(
    UserManager<ApplicationUser> _userManager,
    IJwtService _jwtService) : IRequestHandler<RevokeRefreshTokenCommand, Result>
{
    public async Task<Result> Handle(RevokeRefreshTokenCommand request, CancellationToken cancellationToken)
    {
        var userId = _jwtService.ValidateToken(request.token);
        if (userId is null)
            return Result.Failure(UserErrors.InvalidTokens);

        var user = await _userManager.FindByIdAsync(userId);
        if (user is null)
            return Result.Failure(UserErrors.InvalidCredentials);

        var userRefreshToken = user.RefreshTokens.FirstOrDefault(u => u.Token == request.refreshToken && u.IsActive);
        if (userRefreshToken is null)
            return Result.Failure(UserErrors.InvalidTokens);

        userRefreshToken.RevokedOn = DateTime.UtcNow;

        await _userManager.UpdateAsync(user);
        return Result.Success();
    }
}

namespace Shoppix.Application.Features.Auth.GetRefreshToken;

public class GetRefreshTokenHandler(
    UserManager<ApplicationUser> _userManager,
    IJwtService _jwtService) : IRequestHandler<GetRefreshTokenCommand, Result<AuthResponseDto>>
{
    public int _refreshTokenExpiryDays = 15;
    public async Task<Result<AuthResponseDto>> Handle(GetRefreshTokenCommand request, CancellationToken cancellationToken)
    {
        var userId = _jwtService.ValidateToken(request.token);
        if (userId is null)
            return Result.Failure<AuthResponseDto>(UserErrors.InvalidTokens);

        var user = await _userManager.FindByIdAsync(userId);
        if (user is null) return Result.Failure<AuthResponseDto>(UserErrors.InvalidCredentials);

        var userRefreshToken = user.RefreshTokens.FirstOrDefault(x => x.Token == request.refreshToken && x.IsActive);
        if (userRefreshToken is null) return Result.Failure<AuthResponseDto>(UserErrors.InvalidTokens);

        userRefreshToken.RevokedOn = DateTime.UtcNow;

        var userRoles = await _userManager.GetRolesAsync(user);

        var (newToken, expiresIn) = _jwtService.GenerateToken(user, userRoles);

        var newRefreshToken = GenerateRefreshToken();
        var refreshTokenExpiration = DateTime.UtcNow.AddDays(_refreshTokenExpiryDays);

        user.RefreshTokens.Add(new RefreshToken
        {
            Token = newRefreshToken,
            ExpiresOn = refreshTokenExpiration
        });
        await _userManager.UpdateAsync(user);

        var result = new AuthResponseDto(user.Name, user.Email!, newToken, expiresIn, newRefreshToken, refreshTokenExpiration);
        return Result.Success(result);
    }
    private static string GenerateRefreshToken()
    {
        return Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
    }
}

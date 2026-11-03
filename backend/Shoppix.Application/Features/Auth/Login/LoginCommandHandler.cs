namespace Shoppix.Application.Features.Auth.Login;

public class LoginCommandHandler(UserManager<ApplicationUser> _userManager, IJwtService _jwtService)
    : IRequestHandler<LoginCommand, Result<AuthResponseDto>>
{
    private readonly int _refreshTokenExpiryDays = 15;
    public async Task<Result<AuthResponseDto>> Handle(LoginCommand request, CancellationToken cancellationToken)
    {
        var user = await _userManager.FindByEmailAsync(request.Email);

        if (user is null)
            return Result.Failure<AuthResponseDto>(UserErrors.InvalidCredentials);

        var isValidPassword = await _userManager.CheckPasswordAsync(user, request.Password);

        if (!isValidPassword)
            return Result.Failure<AuthResponseDto>(UserErrors.InvalidCredentials);

        var userRoles = await _userManager.GetRolesAsync(user);

        var (token, expiresIn) = _jwtService.GenerateToken(user, userRoles);

        var refreshToken = GenerateRefreshToken();
        var refreshTokenExpiration = DateTime.UtcNow.AddDays(_refreshTokenExpiryDays);

        user.RefreshTokens.Add(new RefreshToken
        {
            Token = refreshToken,
            ExpiresOn = refreshTokenExpiration
        });

        var updateResult = await _userManager.UpdateAsync(user);

        if (!updateResult.Succeeded)
        {
            var error = updateResult.Errors.First();

            return Result.Failure<AuthResponseDto>(new Error(error.Code,error.Description,ErrorType.BadRequest));
        }
        return Result.Success(new AuthResponseDto(user.Name,user.Email!,token, expiresIn, refreshToken, refreshTokenExpiration));
    }
    private static string GenerateRefreshToken()
    {
        return Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
    }
}
namespace Shoppix.API.Requests.Auth;

public sealed record GetRefreshTokenRequest(
    string Token,
    string RefreshToken
);

public static class RefreshRequestMappings
{
    public static GetRefreshTokenCommand ToCommand(this GetRefreshTokenRequest request) =>
        new(request.Token, request.RefreshToken);
}

namespace Shoppix.Application.Common.Errors;

public static class UserErrors
{
    public static readonly Error DuplicatedEmail = new Error("User.DuplicatedEmail", "Another user with the same emial is already exists", ErrorType.Conflict);
    public static Error InvalidCredentials = new Error("User.InvalidCredentials", "Invalid email or password", ErrorType.Unauthorized);
    public static readonly Error InvalidTokens = new Error("User.InvalidCredentials", "Invalid token or resfresh token", ErrorType.Unauthorized);
}

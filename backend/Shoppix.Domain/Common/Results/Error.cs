namespace Shoppix.Domain.Common.Results;

public record Error(string Code, string Description, ErrorType? Type)
{
    public static readonly Error None = new Error(string.Empty, string.Empty, null);

    public static Error Failure(string Code = nameof(Failure), string Description = "General Failure") => new Error(Code, Description, ErrorType.Failure);

    public static Error Validation(string code = nameof(Validation), string description = "Validation Error") => new Error(code, description, ErrorType.Validation);

    public static Error Conflict(string code = nameof(Conflict), string description = "Conflict Error") => new Error(code, description, ErrorType.Conflict);

    public static Error NotFound(string code = nameof(NotFound), string description = "NotFound Error") => new Error(code, description, ErrorType.NotFound);

    public static Error Unauthorized(string code = nameof(Unauthorized), string description = "Unauthorized Error") => new Error(code, description, ErrorType.Unauthorized);

    public static Error Forbidden(string code = nameof(Forbidden), string description = "Forbidden Error") => new Error(code, description, ErrorType.Forbidden);

}

public sealed record ValidationError(IReadOnlyList<Error> Errors)
    : Error("Validation", "One or more validation errors occurred", ErrorType.Validation);
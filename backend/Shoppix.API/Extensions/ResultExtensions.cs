namespace Shoppix.API.Extensions;

public static class ResultExtensions
{
    public static ObjectResult ToProblem(this Result result)
    {
        if (result.IsSuccess)
            throw new InvalidOperationException("Cannot convert success result to a problem.");

        var (status, title) = result.Error.Type switch
        {
            ErrorType.Validation => (StatusCodes.Status400BadRequest, "Validation"),
            ErrorType.NotFound => (StatusCodes.Status404NotFound, "Not Found"),
            ErrorType.Conflict => (StatusCodes.Status409Conflict, "Conflict"),
            ErrorType.Unauthorized => (StatusCodes.Status401Unauthorized, "Unauthorized"),
            ErrorType.Forbidden => (StatusCodes.Status403Forbidden, "Forbidden"),
            _ => (StatusCodes.Status500InternalServerError, "Server Error"),
            //_ => (StatusCodes.Status400BadRequest, "Bad Request")
        };

        Dictionary<string, string[]> errors = result.Error is ValidationError validationError
            ? validationError.Errors
                .GroupBy(e => e.Code)
                .ToDictionary(g => g.Key, g => g.Select(e => e.Description)
                .ToArray())
            : new()
            {
                [result.Error.Code] = [result.Error.Description]
            };

        var problem = new ProblemDetails
        {
            Status = status,
            Title = title,
            Extensions = { ["errors"] = errors }
        };

        return new ObjectResult(problem) { StatusCode = status };
    }
}

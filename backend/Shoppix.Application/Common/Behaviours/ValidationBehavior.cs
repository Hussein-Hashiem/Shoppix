namespace Shoppix.Application.Common.Behaviours;

public class ValidationBehavior<TRequest, TResponse>(IEnumerable<IValidator<TRequest>> validators)
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : notnull
    where TResponse : Result
{
    public async Task<TResponse> Handle(
        TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        if (!validators.Any())
            return await next(cancellationToken);

        var context = new ValidationContext<TRequest>(request);

        var results = await Task.WhenAll(
            validators.Select(v => v.ValidateAsync(context, cancellationToken)));

        var errors = results
            .SelectMany(r => r.Errors)
            .Where(f => f is not null)
            .Select(f => Error.Validation(f.PropertyName, f.ErrorMessage))
            .ToList();

        if (errors.Count == 0)
            return await next(cancellationToken);

        return CreateFailure(new ValidationError(errors));
    }

    private static TResponse CreateFailure(Error error)
    {
        if (typeof(TResponse) == typeof(Result))
            return (TResponse)Result.Failure(error);

        var valueType = typeof(TResponse).GetGenericArguments()[0];

        var failure = typeof(Result)
            .GetMethods()
            .Single(m => m.Name == nameof(Result.Failure) && m.IsGenericMethodDefinition)
            .MakeGenericMethod(valueType)
            .Invoke(null, [error])!;

        return (TResponse)failure;
    }
}
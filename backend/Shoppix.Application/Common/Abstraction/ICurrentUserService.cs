namespace Shoppix.Application.Common.Abstraction;

public interface ICurrentUserService
{
    Guid? UserId { get; }
}

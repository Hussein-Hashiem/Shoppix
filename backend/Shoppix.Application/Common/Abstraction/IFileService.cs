namespace Shoppix.Application.Common.Abstraction
{
    public interface IFileService
    {
        Task<CloudFile> UploadImageAsync(IFormFile file, CancellationToken cancellationToken = default);

        Task<bool> DeleteImageAsync(string publicId, CancellationToken cancellationToken = default);
    }
}

using System.Net;
using System.Net.Http.Json;
using System.Text.Json.Serialization;

namespace Shoppix.Infrastructure.Services;

public class RelatedProductsClientService(HttpClient http) : IRelatedProductsClientService
{
    public async Task<IReadOnlyList<RelatedProductScore>> GetRelatedAsync(
        int productId, int limit, CancellationToken cancellationToken)
    {
        using var response = await http.GetAsync(
            $"related/{productId}?limit={limit}", cancellationToken);

        if (response.StatusCode == HttpStatusCode.NotFound)
            return [];

        response.EnsureSuccessStatusCode();

        var items = await response.Content.ReadFromJsonAsync<List<AiItem>>(cancellationToken)
                    ?? [];

        return items.Select(i => new RelatedProductScore(i.Id, i.Score)).ToList();
    }

    private sealed record AiItem(
        [property: JsonPropertyName("id")] int Id,
        [property: JsonPropertyName("score")] double Score);
}

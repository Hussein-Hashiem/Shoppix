namespace Shoppix.Domain.Entities
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int StockQuantity { get; set; }

        // Image
        public string Url { get; set; } = null!;
        public string PublicId { get; set; } = null!;
        public string ContentType { get; set; } = string.Empty;

    }
}

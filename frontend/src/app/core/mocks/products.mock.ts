import { ProductModel } from "../models/product.model";

export const MOCK_PRODUCTS : ProductModel[] = [
  {
    id: 1,
    name: "Precision Artisan Coffee",
    description: "Dual-wall extraction chassis for stable thermal brewing.",
    price: 24,
    stockQuantity: 5,
    image: "https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500"
  },
  {
    id: 2,
    name: "Ceramic Pour Over Dripper",
    description: "Conical design with spiral ribs for optimal extraction flow.",
    price: 18,
    stockQuantity: 12,
    image: "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500"
  },
  {
    id: 3,
    name: "Electric Gooseneck Kettle",
    description: "Variable temperature control for precise pour-over control.",
    price: 65,
    stockQuantity: 8,
    image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500"
  },
  {
    id: 4,
    name: "Stainless Steel Burr Grinder",
    description: "Conical burrs for consistent particle size distribution.",
    price: 45,
    stockQuantity: 3,
    image: "https://images.unsplash.com/photo-1589396263127-90c74e84ffb9?w=500"
  }
];
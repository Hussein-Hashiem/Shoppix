# Shoppix AI Service

A lightweight service that suggests related products for the Shoppix e-commerce site.
Given a product id, it returns similar products using TF-IDF and cosine similarity on the product name and description.

## Run locally

```bash
pip install -r requirements.txt
uvicorn main:app --reload
```

The service runs on `http://127.0.0.1:8000`.

## Usage

```
GET /related/{product_id}?limit=4
```

Example:

```
GET /related/12
```

The response is a list of products, each with:
`id, name, description, price, stockQuantity, imageUrl, score`

| Status | Meaning |
|---|---|
| 200 | List of related products |
| 404 | Product id not found |

## How it works

- Fetches all products from the backend (`GET /api/products`) on startup.
- Excludes the product itself, out-of-stock products, and duplicates with the same name.
- If the requested id is unknown, it re-fetches the products once before returning 404.

## Interactive docs

After starting the service, open `http://127.0.0.1:8000/docs` to try the endpoints from the browser.

## Author

Developed by **Mariam Marei** — [GitHub](https://github.com/mmry00977-marei)

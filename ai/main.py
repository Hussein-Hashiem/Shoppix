import os
from typing import List

import httpx
import numpy as np
from fastapi import FastAPI, HTTPException
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

BACKEND_URL = os.getenv("BACKEND_API_URL", "https://shoppix.runasp.net/api/products")

app = FastAPI(title="Shoppix Related Products")
products, matrix, id_to_idx = [], None, {}


def load_products():
    global products, matrix, id_to_idx
    r = httpx.get(BACKEND_URL, timeout=15)
    r.raise_for_status()
    data = r.json()
    products = data
    corpus = [f"{p['name']} {p['name']} {p['name']} {p.get('description') or ''}" for p in data]
    matrix = TfidfVectorizer(stop_words="english").fit_transform(corpus)
    id_to_idx = {p["id"]: i for i, p in enumerate(data)}


@app.on_event("startup")
def startup():
    load_products()


@app.get("/related/{product_id}")
def related(product_id: int, limit: int = 4):
    if product_id not in id_to_idx:
        load_products()
        if product_id not in id_to_idx:
            raise HTTPException(404, "Product not found")

    i = id_to_idx[product_id]
    name = products[i]["name"].lower()
    scores = cosine_similarity(matrix[i], matrix).flatten()

    out, seen = [], {name}
    for j in np.argsort(-scores):
        p = products[j]
        if p["id"] == product_id or p["stockQuantity"] <= 0 or p["name"].lower() in seen:
            continue
        seen.add(p["name"].lower())
        out.append({**p, "score": round(float(scores[j]), 4)})
        if len(out) >= limit:
            break
    return out
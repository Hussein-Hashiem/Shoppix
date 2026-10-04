import { inject, Service } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { ProductModel } from '../models/product.model';
import { MOCK_PRODUCTS } from '../mocks/products.mock';
import { delay, Observable, of } from 'rxjs';

@Service()
export class ProductDetailsService {
  baseUrl = `${environment.apiUrl}/products`;
  http = inject(HttpClient);

  getProductById(id: string | number): Observable<ProductModel> {
    // return this.http.get<ProductModel>(`${this.baseUrl}/${id}`);

    const product = MOCK_PRODUCTS.find(p => +p.id === +id) || MOCK_PRODUCTS[1];
    return of(product)// .pipe(delay(3000)); // Simulate a 1-second delay for loading
  }

  getRelatedProducts(id: string | number): Observable<ProductModel[]> {
    // return this.http.get<ProductModel[]>(`${this.baseUrl}/${id}/related`);

    return of(MOCK_PRODUCTS.slice(0, 4));
  }
}

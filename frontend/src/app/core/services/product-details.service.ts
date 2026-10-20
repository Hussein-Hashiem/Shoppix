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
    return this.http.get<ProductModel>(`${this.baseUrl}/${id}`);
  }

  getRelatedProducts(id: string | number): Observable<ProductModel[]> {
    return this.http.get<ProductModel[]>(`${this.baseUrl}/${id}/related`);
  }
}

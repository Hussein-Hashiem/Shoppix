import { inject, Service } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { delay, Observable, of } from 'rxjs';
import { ProductModel } from '../models/product.model';
import { MOCK_PRODUCTS } from '../mocks/products.mock';

@Service()
export class ProductsService {
  baseUrl = environment.apiUrl + '/products';
  http = inject(HttpClient);

  getProducts(): Observable<ProductModel[]> {
    // return this.http.get<ProductModel[]>(this.baseUrl);
    return of(MOCK_PRODUCTS)// .pipe(delay(3000)); // Simulate a 1-second delay for loading
  }
}

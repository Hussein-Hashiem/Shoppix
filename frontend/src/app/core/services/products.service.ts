import { inject, Service } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import {  Observable } from 'rxjs';
import { ProductModel } from '../models/product.model';

@Service()
export class ProductsService {
  baseUrl = environment.apiUrl + '/products';
  http = inject(HttpClient);

  getProducts(): Observable<ProductModel[]> {
    return this.http.get<ProductModel[]>(this.baseUrl);
  }
}

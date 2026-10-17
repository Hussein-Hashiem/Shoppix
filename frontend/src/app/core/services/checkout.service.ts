import { HttpClient } from '@angular/common/http';
import { inject, Service } from '@angular/core';
import { Observable, of } from 'rxjs';
import { environment } from '../../../environments/environment';
import { OrderModel } from '../models/order.model';
import { ProductModel } from '../models/product.model';
import { MOCK_ORDERS } from '../mocks/orders.mock';

@Service()
export class CheckoutService {
  private readonly httpClient = inject(HttpClient);
  baseUrl = environment.apiUrl + '/orders';

  processCheckout(): Observable<OrderModel> {
    const cart = localStorage.getItem('cart');
    const cartProducts = cart ? JSON.parse(cart) : [];

    const orderPayload = {
      items: cartProducts.map((item: ProductModel) => ({
        productId: item.id,
        quantity: item.quantity
      }))
    };
    return this.httpClient.post<OrderModel>(this.baseUrl, orderPayload);
  }

  getOrders(): Observable<OrderModel[]> {
    // return this.httpClient.get<OrderModel[]>(this.baseUrl);

    return of(MOCK_ORDERS);
  }
}

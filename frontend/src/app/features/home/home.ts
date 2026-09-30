import { Component } from '@angular/core';
import { ProductCard } from '../../shared/components/product-card/product-card';
import { ProductModel } from '../../core/models/product.model';
import { MOCK_PRODUCTS } from '../../core/mocks/products.mock';

@Component({
  imports: [ProductCard],
  selector: 'app-home',
  styleUrl: './home.css',
  templateUrl: './home.html',
})
export class Home {
  // temp data 
  products :ProductModel[] = MOCK_PRODUCTS ;
}

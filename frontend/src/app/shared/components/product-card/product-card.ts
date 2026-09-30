import { Component, input, output } from '@angular/core';
import { ProductModel } from '../../../core/models/product.model';
import { CommonModule } from '@angular/common';
import { LucideShoppingCartPlus } from '@lucide/angular';
import { RouterLink } from '@angular/router';

@Component({
  imports: [CommonModule , LucideShoppingCartPlus, RouterLink],
  selector: 'app-product-card',
  styleUrl: './product-card.css',
  templateUrl: './product-card.html',
})
export class ProductCard {
  product = input.required<ProductModel>();

  
  AddToCart = output<number>();

  onAddToCart(){
    this.AddToCart.emit(this.product().id);
  }
}

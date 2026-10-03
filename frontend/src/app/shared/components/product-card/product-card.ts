import { Component, computed, inject, input, output } from '@angular/core';
import { ProductModel } from '../../../core/models/product.model';
import { CommonModule } from '@angular/common';
import { LucideShoppingCartPlus } from '@lucide/angular';
import { RouterLink } from '@angular/router';
import { CartService } from '../../../core/services/cart.service';

@Component({
  imports: [CommonModule , LucideShoppingCartPlus, RouterLink],
  selector: 'app-product-card',
  styleUrl: './product-card.css',
  templateUrl: './product-card.html',
})
export class ProductCard {
  // Injections
  cartService = inject(CartService);

  product = input.required<ProductModel>();
  AddToCart = output<boolean>();

  onAddToCart(){
    const isSuccess = this.cartService.addToCart(this.product());
    this.AddToCart.emit(isSuccess);
  }

  isOutOfStock = computed(() => {
  const cartItem = this.cartService.cartItems().find(item => item.product.id === this.product().id);
  const currentQuantityInCart = cartItem ? cartItem.quantity : 0;
  return currentQuantityInCart >= this.product().stockQuantity;
});
}

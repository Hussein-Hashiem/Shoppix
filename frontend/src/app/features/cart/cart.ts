import { AuthService } from './../../core/services/auth.service';
import { Component, inject } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { LucideHandbag, LucideHouse, LucideMoveRight, LucidePlus, LucideMinus, LucideMopSparkles } from '@lucide/angular';
import { CartService } from '../../core/services/cart.service';
import { CommonModule } from '@angular/common';
import { HotToastService } from '@ngxpert/hot-toast';
import { ConfirmCheckoutSwal, ConfirmSwal } from '../../core/utils/swal.config';
import { CheckoutService } from '../../core/services/checkout.service';
import { take } from 'rxjs';

@Component({
  imports: [LucideHandbag, LucideHouse, LucideMopSparkles, LucidePlus, LucideMinus, LucideMoveRight, RouterLink, CommonModule],
  selector: 'app-cart',
  styleUrl: './cart.css',
  templateUrl: './cart.html',
})
export class Cart {
  // Injections
  cartService = inject(CartService);
  private readonly checkoutService = inject(CheckoutService);
  authService = inject(AuthService);
  private readonly router = inject(Router);
  toastService = inject(HotToastService);

  async confirmRemove(productId: number, productName: string) {
    const result = await ConfirmSwal.fire({
      title: 'Remove item?',
      text: `${productName} will be removed from your cart.`,
      icon: 'warning',
      iconColor: '#e11d48',
      confirmButtonText: 'Remove',
      cancelButtonText: 'Keep it',
    });

    if (result.isConfirmed) {
      this.cartService.removeFromCart(productId);
      this.toastService.success('Item removed from cart successfully.');
    }
  }

  async confirmClear() {
    const result = await ConfirmSwal.fire({
      title: 'Clear cart?',
      text: `All items will be removed from your cart.`,
      icon: 'warning',
      iconColor: '#e11d48',
      confirmButtonText: 'Clear',
      cancelButtonText: 'Keep them',
    });

    if (result.isConfirmed) {
      this.cartService.clearCart();
      this.toastService.success('Cart cleared successfully.');
    }
  }

  areYouLogined() {
    if (this.authService.isLoggedIn()) {
      this.confirmCheckout();
    } else {
      this.toastService.error('Please login first');
      this.router.navigate(['/auth/login'], {
        queryParams: { returnUrl: '/cart' }
      });
    }
  }

  async confirmCheckout() {
    const result = await ConfirmCheckoutSwal.fire({
      title: 'Complete checkout?',
      text: 'Are you sure you want to proceed with your order?',
      icon: 'question',
      iconColor: '#006045',
      confirmButtonText: 'Checkout',
      cancelButtonText: 'Cancel',
    });

    if (result.isConfirmed) {
      this.checkoutService.processCheckout().pipe(take(1)).subscribe({
        next: () => {
          this.toastService.success('Order placed successfully.');
          this.router.navigate(['/order-history']);
          this.cartService.clearCart();
        },
        error: () => {
          ConfirmSwal.fire({
            title: 'Checkout Failed',
            text: 'Something went wrong while processing your order. Please try again.',
            icon: 'error',
            iconColor: '#e11d48',
            confirmButtonText: 'OK',
            showCancelButton: false,
          });
        },
      });
    }
  }

  changePrdQuantity(productId: number, isIncrease: boolean) {
    const success = this.cartService.changePrdQuantityinCart(productId, isIncrease);
    if (success) {
      if (isIncrease) {
        this.toastService.success('Item quantity increased successfully.');
      } else {
        this.toastService.success('Item quantity decreased successfully.');
      }
    } else {
      if (isIncrease) {
        this.toastService.error('Cannot increase quantity. Stock limit reached.');
      } else {
        this.toastService.error('Cannot decrease quantity. Minimum quantity reached.');
      }
    }
  }
}

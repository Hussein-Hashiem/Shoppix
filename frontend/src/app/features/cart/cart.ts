import { Component, inject, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { LucideHandbag, LucideHouse, LucideMoveLeft, LucideMoveRight, LucidePlus, LucideMinus, LucideMopSparkles } from '@lucide/angular';
import { CartService } from '../../core/services/cart.service';
import { CommonModule } from '@angular/common';
import Swal from 'sweetalert2';
import { HotToastService } from '@ngxpert/hot-toast';
import { ConfirmSwal } from '../../core/utils/swal.config';

@Component({
  imports: [LucideHandbag, LucideHouse, LucideMopSparkles , LucideMoveLeft, LucidePlus, LucideMinus, LucideMoveRight, RouterLink, CommonModule],
  selector: 'app-cart',
  styleUrl: './cart.css',
  templateUrl: './cart.html',
})
export class Cart implements OnInit {
  // Injections
  cartService = inject(CartService);
  toastService = inject(HotToastService);
  ngOnInit() {
    console.log(this.cartService.cartItems())
  }

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

  async confirmClear(){
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


  changePrdQuantity(productId:number , isIncrease:boolean){
    const success = this.cartService.changePrdQuantityinCart(productId,isIncrease);
    if(success){
      if(isIncrease){
        this.toastService.success('Item quantity increased successfully.');
    }else{
      this.toastService.success('Item quantity decreased successfully.');
    }
  }else{
    if(isIncrease){
      this.toastService.error('Cannot increase quantity. Stock limit reached.');
    }else{
      this.toastService.error('Cannot decrease quantity. Minimum quantity reached.');
    }
  }
}
}

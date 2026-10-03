import { effect, Service, signal , computed } from '@angular/core';
import { ProductModel } from '../models/product.model';

@Service()
export class CartService {
  cartItems = signal<{ product: ProductModel, quantity: number }[]>(this.loadCartFromStorage());
  
  // for navbar cart icon
  totalCartCount = computed(()=>{
    return this.cartItems().reduce((total, item)=> total + item.quantity, 0);
  })
  constructor(){
    effect(()=>{
      localStorage.setItem("cart", JSON.stringify(this.cartItems()))
    })
  }

  loadCartFromStorage(): { product: ProductModel, quantity: number }[] {
    try {
      const cartItems = localStorage.getItem("cart");
      return cartItems ? JSON.parse(cartItems) : [];
    } catch (error) {
      return [];
    }
  }
  addToCart(product: ProductModel) : boolean {
    let isSuccess = true;
    this.cartItems.update((cart) => {
      const existingIndex = cart.findIndex((item) => item.product.id === product.id);

      if (existingIndex > -1) {
        const currentItem = cart[existingIndex];
        const newQuantity = currentItem.quantity + 1;

        if (newQuantity > product.stockQuantity) {
          isSuccess = false;
          return cart;
        }
          return cart.map((item, index) => 
          index === existingIndex 
            ? { ...item, quantity: newQuantity } 
            : item
        );
        
      } else {
        if(product.stockQuantity <= 0){
          isSuccess = false;
          return cart;
        }
        return [...cart, { product: product, quantity: 1 }];
      }
    });
    return isSuccess;
  }
}

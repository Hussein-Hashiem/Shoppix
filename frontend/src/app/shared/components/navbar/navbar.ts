import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { LucideLogOut, LucideMenu, LucideReceiptText, LucideShoppingBag } from '@lucide/angular';
import { CartService } from '../../../core/services/cart.service';

@Component({
  imports: [RouterLink, RouterLinkActive, LucideMenu, LucideShoppingBag, LucideReceiptText, LucideLogOut],
  selector: 'app-navbar',
  styleUrl: './navbar.css',
  templateUrl: './navbar.html',
})
export class Navbar { 
  // Injections
  cartService = inject(CartService);
}

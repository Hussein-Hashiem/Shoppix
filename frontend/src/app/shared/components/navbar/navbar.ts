import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { LucideLogOut, LucideMenu, LucideReceiptText, LucideShoppingBag } from '@lucide/angular';
import { CartService } from '../../../core/services/cart.service';
import { AuthService } from '../../../core/services/auth.service';
import { ConfirmSwal } from '../../../core/utils/swal.config';

@Component({
  imports: [RouterLink, RouterLinkActive, LucideMenu, LucideShoppingBag, LucideReceiptText, LucideLogOut],
  selector: 'app-navbar',
  styleUrl: './navbar.css',
  templateUrl: './navbar.html',
})
export class Navbar {
  // Injections
  cartService = inject(CartService);
  authService = inject(AuthService);

  async logOut(){
      const logOutAlert = await  ConfirmSwal.fire({
      title: 'Log Out?',
      text: `Are you sure you want to log out.`,
      icon: 'warning',
      iconColor: '#e11d48',
      confirmButtonText: 'yes',
      cancelButtonText: 'cancel',
    });
    if(logOutAlert.isConfirmed)
      this.authService.logout();
    else 
      return ;
  }
}

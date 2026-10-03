import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { LucideLogOut, LucideMenu, LucideReceiptText, LucideShoppingBag } from '@lucide/angular';

@Component({
  imports: [RouterLink, RouterLinkActive, LucideMenu, LucideShoppingBag, LucideReceiptText, LucideLogOut],
  selector: 'app-navbar',
  styleUrl: './navbar.css',
  templateUrl: './navbar.html',
})
export class Navbar { }

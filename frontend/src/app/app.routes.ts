import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth-guard';
import { saveChangesGuard } from './core/guards/save-changes-guard';

export const routes: Routes = [
  {
    path: 'home', loadComponent: () =>
      import('./features/home/home').then((m) => m.Home), title: "Home"
  },
  {
    path: 'cart', loadComponent: () =>
      import('./features/cart/cart').then((m) => m.Cart), title: "Cart"
  },
  {
    path: 'auth',
    canActivate: [authGuard],
    children: [
      {
        canDeactivate: [saveChangesGuard],
        path: 'login', loadComponent: () =>
          import('./features/auth/login/login').then((m) => m.Login), title: "Login"
      },
      {
        canDeactivate: [saveChangesGuard],
        path: 'register', loadComponent: () =>
          import('./features/auth/register/register').then((m) => m.Register), title: "Register"
      },
      { path: '**', redirectTo: 'login' }
    ]
  },
  {
    path: 'order-history', loadComponent: () =>
      import('./features/order-history/order-history').then((m) => m.OrderHistory), title: "Orders History"
  },
  {
    path: 'product-details/:id', loadComponent:
      () => import('./features/product-details/product-details').then((m) => m.ProductDetails), title: "Product Details"
  },
  { path: '**', redirectTo: 'home' },
];

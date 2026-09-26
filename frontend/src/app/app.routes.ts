import { Routes } from '@angular/router';

export const routes: Routes = [
  { path : 'home' , loadComponent: () =>
                                    import('./features/home/home').then((m) => m.Home) },
  { path:'cart' , loadComponent: () =>
                                    import('./features/cart/cart').then((m) => m.Cart) },
  {
    path:'auth',
    children: [ // auth guard will be added

      { path:'login' , loadComponent: () =>
                                    import('./features/auth/login/login').then((m) => m.Login) },
      { path:'register' , loadComponent: () =>
                                    import('./features/auth/register/register').then((m) => m.Register) },
      { path:'**' , redirectTo: 'login' }
    ]
  },
  { path:'checkout' , loadComponent: () =>
                                    import('./features/checkout/checkout').then((m) => m.Checkout) },
  { path:'order-history' , loadComponent: () =>
                                    import('./features/order-history/order-history').then((m) => m.OrderHistory) },
  { path:'product-details/:id' , loadComponent:
                                    () => import('./features/product-details/product-details').then((m) => m.ProductDetails) },
  { path:'**' , redirectTo: 'home' },
];

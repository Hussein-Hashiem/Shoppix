import { CheckoutService } from './../../core/services/checkout.service';
import { Component, signal, inject, OnInit } from '@angular/core';
import { LucideHouse } from '@lucide/angular';
import { OrderCard } from '../../shared/components/order-card/order-card';
import { OrderModel } from '../../core/models/order.model';
import { RouterLink } from '@angular/router';
import { OrderCardSkeleton } from '../../shared/components/order-card-skeleton/order-card-skeleton';

@Component({
  imports: [LucideHouse, OrderCard, RouterLink, OrderCardSkeleton],
  selector: 'app-order-history',
  styleUrl: './order-history.css',
  templateUrl: './order-history.html',
})
export class OrderHistory implements OnInit {
  // Injections
  private readonly checkoutService = inject(CheckoutService);
  ordersList = signal<OrderModel[]>([]);
  isLoading = signal<boolean>(true);
  hasError = signal<boolean>(false);

  ngOnInit(): void {
    this.loadOrders();
  }

  loadOrders() {
    this.isLoading.set(true);
    this.hasError.set(false);

    this.checkoutService.getOrders().subscribe({
      next: (res) => {
        this.ordersList.set(res);
        this.isLoading.set(false);
      },
      error: () => {
        this.isLoading.set(false);
        this.hasError.set(true);
      }
    })
  }
}

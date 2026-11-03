import { CheckoutService } from './../../core/services/checkout.service';
import { Component, signal, inject, OnInit, computed, DestroyRef } from '@angular/core';
import { LucideHouse, LucideWifiOff, LucideServerOff, LucideRefreshCw, LucideTriangleAlert, LucideClipboardCheck } from '@lucide/angular';
import { OrderCard } from '../../shared/components/order-card/order-card';
import { OrderModel } from '../../core/models/order.model';
import { RouterLink } from '@angular/router';
import { OrderCardSkeleton } from '../../shared/components/order-card-skeleton/order-card-skeleton';
import { HttpErrorResponse } from '@angular/common/http';
import { getApiErrorMessages } from '../../core/utils/error-handling.util';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ErrorState } from '../../core/models/api-error.model';

@Component({
  imports: [LucideHouse, OrderCard, RouterLink, OrderCardSkeleton, LucideWifiOff, LucideServerOff, LucideRefreshCw, LucideTriangleAlert, LucideClipboardCheck],
  selector: 'app-order-history',
  styleUrl: './order-history.css',
  templateUrl: './order-history.html',
})
export class OrderHistory implements OnInit {
  // Injections
  private readonly checkoutService = inject(CheckoutService);
  private readonly destroyRef = inject(DestroyRef);

  ordersList = signal<OrderModel[]>([]);
  isLoading = signal<boolean>(true);
  hasError = signal<boolean>(false);

  errorMessage = signal<string>('')
  state = signal<ErrorState>('');

  errorView = computed(() => {
    switch (this.state()) {
      case 'OFFLINE':
        return {
          title: "You're offline",
          description: 'Check your Wi-Fi or mobile data, then try again.',
          tone: 'amber',
          icon: 'offline'
        };
      case 'SERVER':
        return {
          title: 'Server is having trouble',
          description: 'Something went wrong on our side. Please try again in a moment.',
          tone: 'red',
          icon: 'server'
        };
      default:
        return {
          title: 'Something went wrong',
          description: this.errorMessage() || 'We could not load your order history right now.',
          tone: 'gray',
          icon: 'warning'
        };
    }
  });

  ngOnInit(): void {
    this.loadOrders();
  }

  loadOrders() {
    this.isLoading.set(true);
    this.hasError.set(false);
    this.state.set('');

    this.checkoutService.getOrders()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (res) => {
          this.ordersList.set(res);
          this.isLoading.set(false);
        },
        error: (err: HttpErrorResponse) => {
          this.handleError(err);
        }
      })
  }

  private handleError(err: HttpErrorResponse) {
    const { errors, status } = getApiErrorMessages(err);

    if (status === 0 || status === 408) {
      this.state.set('OFFLINE');
    } else if (status === 500) {
      this.state.set('SERVER');
    }

    this.errorMessage.set(errors.join('\n'));
    this.isLoading.set(false);
    this.hasError.set(true);
  }
}

import { Component, inject, input, signal } from '@angular/core';
import { OrderModel } from '../../../core/models/order.model';
import { HotToastService } from '@ngxpert/hot-toast';
import { DatePipe } from '@angular/common';
import { LucideBadgeCheck, LucideCalendar, LucideCopy } from '@lucide/angular';

@Component({
  imports: [DatePipe, LucideCopy, LucideCalendar, LucideBadgeCheck],
  selector: 'app-order-card',
  styleUrl: './order-card.css',
  templateUrl: './order-card.html',
})
export class OrderCard {
  toastService = inject(HotToastService);

  order = input<OrderModel>();

  copyOrderId(id: number = 1) {
    const textToCopy = `#SHP-${id}`;

    navigator.clipboard.writeText(textToCopy).then(() => {
      this.toastService.success(`Order ID ${textToCopy} copied successfully!`)
    }).catch(err => {
      console.error('Failed to copy text: ', err);
    });
  }
}

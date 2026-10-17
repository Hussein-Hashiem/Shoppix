import { OrderModel } from "../models/order.model";

export const MOCK_ORDERS: OrderModel[] = [
  {
    id: 101,
    userId: 10,
    orderDate: "2026-10-12T14:02:00Z",
    totalPrice: 57.98,
    status: "Confirmed"
  },
  {
    id: 102,
    userId: 15,
    orderDate: "2026-10-11T09:30:00Z",
    totalPrice: 124.50,
    status: "Pending"
  },
  {
    id: 103,
    userId: 8,
    orderDate: "2026-10-10T18:45:00Z",
    totalPrice: 210.00,
    status: "Shipped"
  },
  {
    id: 104,
    userId: 22,
    orderDate: "2026-10-09T11:15:00Z",
    totalPrice: 45.25,
    status: "Delivered"
  },
  {
    id: 105,
    userId: 5,
    orderDate: "2026-10-08T16:20:00Z",
    totalPrice: 310.80,
    status: "Cancelled"
  }
];

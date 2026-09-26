export interface OrderModel {
  id : number;
  userId : number;
  totalPrice : number;
  orderDate : Date;
  status : string;
}

export interface OrderItemModel {
  id : number;
  orderId : number;
  productId : number;
  quantity : number;
  unitPrice : number;
}

class CartModel {
  final int productId;
  final int productQuantity;

  CartModel({required this.productId, required this.productQuantity});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(productId: json['product_id'], productQuantity: json['quantity']);
  }
  Map<String,dynamic>toJson(){
    return{
      'product_id':productId,
      'quantity':productQuantity
    };
  }
}

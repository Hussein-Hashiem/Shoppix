import 'dart:convert';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSource {
  final SharedPreferences pref;

  CartLocalDataSource({required this.pref});
  static const _key='cart';
  Future<void>saveCartProducts(List<CartModel> items)async{
    try {
      final json=jsonEncode(items.map((b)=>b.toJson()).toList());
      await pref.setString(_key, json);
    } catch (e) {
      throw CacheException(message: 'Couldn’t update your cart. Please try again.');
    }
  }
  Future<List<CartModel>> getCartProducts()async{
    try {
      final raw=pref.getString(_key);
      if(raw ==null){
        return [];
      }
      final list=jsonDecode(raw) as List;
      return list.map((e)=>CartModel.fromJson(e as Map<String,dynamic>)).toList();
    } catch (e) {
      throw CacheException(message: 'Couldn’t load your cart. Please try again');
    }
  }
  
}
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSource {
  final SharedPreferences pref;
  final SecureTokenStorage? tokenStorage;

  CartLocalDataSource({required this.pref, this.tokenStorage});

  static const _key = 'cart';

  Future<String> _cartKey() async {
    final token = await tokenStorage?.readToken();
    if (token == null || token.isEmpty) return '${_key}_guest';
    final accountKey = sha256.convert(utf8.encode(token)).toString();
    return '${_key}_$accountKey';
  }

  Future<void> saveCartProducts(List<CartModel> items) async {
    try {
      final json = jsonEncode(items.map((item) => item.toJson()).toList());
      await pref.setString(await _cartKey(), json);
    } catch (e) {
      throw CacheException(
        message: 'Couldn’t update your cart. Please try again.',
      );
    }
  }

  Future<List<CartModel>> getCartProducts() async {
    try {
      final raw = pref.getString(await _cartKey());
      if (raw == null) return [];
      final list = jsonDecode(raw) as List;
      return list
          .map((item) => CartModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Couldn’t load your cart. Please try again.',
      );
    }
  }

  Future<void> clearCart() async {
    try {
      await pref.remove(await _cartKey());
    } catch (e) {
      throw CacheException(
        message: 'Couldn’t clear your cart. Please try again.',
      );
    }
  }
}
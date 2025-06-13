import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/GlobalVariables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/model/sales.dart';
import 'package:amazon_clone/model/order.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amazon_clone/constants/error_handling.dart';

class AdminServices {

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic("dlwhfclyb", "vsqqpjud");
      List<String> imageUrl = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrl.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrl,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$url/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': provider.user.token,
        },
        body: jsonEncode(product.toMap()),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': provider.user.token,
        },
      );
      // print(provider.user.token);
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(jsonEncode(jsonDecode(res.body)[i])),
            );
          }
          ;
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/admin/delete-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': provider.user.token,
        },
        body: jsonEncode({'id': product.id}),
      );
      httpErrorHandling(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$url/admin/change-order-status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': provider.user.token,
        },
        body: jsonEncode({'id': order.id, 'status': status}),
      );
      // print('Order ID: ${order.id}');
      // print('Status: $status');
      httpErrorHandling(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/admin/get-all-orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': provider.user.token,
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(Order.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }

        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return orderList;
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    var earnings=0;
    try {
      http.Response res = await http.get(
        Uri.parse('$url/admin/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': provider.user.token,
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          earnings = response['totalPrice'];
          sales =[
            Sales('Mobiles', response['mobileEarnings']) ,
            Sales('Essentials', response['essentialEarnings']),
            Sales('Appliances', response['appliancesEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Fashion', response['fashionEarnings']),
            Sales('Electronics', response['electronicsEarnings']),

          ];

        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return {
      'sales':sales,
      'totalEarnings':earnings
    };
  }
}

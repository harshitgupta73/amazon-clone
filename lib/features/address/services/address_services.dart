import 'dart:convert';

import 'package:amazon_clone/constants/GlobalVariables.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/model/user_model.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices{

  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    try {

      http.Response res = await http.post(
        Uri.parse('$url/api/save-user-address'),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': provider.user.token,
        },
        body: jsonEncode({
          'address':address
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          User user = provider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );
          provider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$url/api/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'totalPrice': totalSum,
          }));

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Your order has been placed!');
          User user = userProvider.user.copyWith(
            cart: [],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

}
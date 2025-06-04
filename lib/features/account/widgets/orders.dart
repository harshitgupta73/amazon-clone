import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/GlobalVariables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_dart.dart';
import 'package:amazon_clone/features/order_details/screen/order_detail_screen.dart';
import 'package:amazon_clone/model/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await AccountServices().fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Your Orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15),
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: GlobalVariables.selectedNavBarColor,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 170,
              padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap:() => Navigator.pushNamed(
                      context,
                      OrderDetailScreen.routeName,
                      arguments: orders![index],
                    ),
                    child: SingleProduct(
                      src: orders![index].products[0].images[0],
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }
}

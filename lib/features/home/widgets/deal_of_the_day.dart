import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details_screen/screen/product_details_screen.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:flutter/material.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  Product? product;

  @override
  void initState() {
    fetchDealOfDay();
    super.initState();
  }

  final HomeServices homeServices = HomeServices();

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return product == null ? const Loader() : (product!.name.isEmpty)
        ? SizedBox()
        : GestureDetector(
      onTap: () =>
          Navigator.pushNamed(
              context, ProductDetailsScreen.routeName, arguments: product),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10, top: 15),
            child: const Text(
              'Deal of the day',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Image.network(
            product!.images[0],
            fit: BoxFit.fitHeight,
            height: 235,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
            child: const Text("\$999", style: TextStyle(fontSize: 18)),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
            child: const Text(
              "Asus VivoBook 15 i5 11th gen",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
              product!.images
                  .map(
                    (e) =>
                    Image.network(
                      e,
                      fit: BoxFit.fitHeight,
                      height: 100,
                      width: 100,
                    ),
              )
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ).copyWith(left: 15),
            alignment: Alignment.topLeft,
            child: Text(
              "See all deals",
              style: TextStyle(color: Colors.cyan[800]),
            ),
          ),
        ],
      ),
    );
  }
}

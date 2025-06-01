import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/auth/screens/auth_screens.dart';
import 'package:amazon_clone/features/home/screens/category_deal.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/product_details_screen/screen/product_details_screen.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:flutter/material.dart';

import 'features/admin/screens/add_product_screen.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreens.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AuthScreens(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const BottomBar(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AddProductScreen(),
      );
    case SearchScreen.routeName:
      String searchQuery = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => SearchScreen(searchQuery: searchQuery),
      );
    case CategoryDealScreen.routeName:
      final String category = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>  CategoryDealScreen(category: category),
      );
    case ProductDetailsScreen.routeName:
      var product = settings.arguments as Product;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>  ProductDetailsScreen(product: product),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder:
            (context) => const Scaffold(body: Center(child: Text('Screen doesnt exist'))),
      );
  }
}

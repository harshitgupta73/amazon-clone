import 'package:amazon_clone/constants/GlobalVariables.dart';
import 'package:amazon_clone/features/home/screens/category_deal.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  void navigateToCategory(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      CategoryDealScreen.routeName,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: GlobalVariables.categoryImages.length,
        itemExtent: 75,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap:() => navigateToCategory(
              context,
              GlobalVariables.categoryImages[index]['title']!,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      GlobalVariables.categoryImages[index]['image']!,
                      fit: BoxFit.fitHeight,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  GlobalVariables.categoryImages[index]['title']!,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

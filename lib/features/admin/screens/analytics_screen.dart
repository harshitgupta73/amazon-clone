import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/model/sales.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/category_product_charts.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalEarnings;
  List<Sales>? earnings;

  @override
  void initState() {
    getEarnings();
    super.initState();
  }

  void getEarnings() async {
    var earningData =await adminServices.getEarnings(context);
    totalEarnings = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalEarnings == null
        ? const Loader()
        : Column(
      children: [
        Text(
          '\$$totalEarnings',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 250,
          child: CategoryProductsChart(data: [
            Sales('Mobiles', earnings!.firstWhere((e) => e.label == 'Mobiles').earnings),
            Sales('Essentials', earnings!.firstWhere((e) => e.label == 'Essentials').earnings),
            Sales('Appliances', earnings!.firstWhere((e) => e.label == 'Appliances').earnings),
            Sales('Books', earnings!.firstWhere((e) => e.label == 'Books').earnings),
            Sales('Fashion', earnings!.firstWhere((e) => e.label == 'Fashion').earnings),
            Sales('Electronics', earnings!.firstWhere((e) => e.label == 'Electronics').earnings),
          ],),
        )
      ],
    );
  }
}

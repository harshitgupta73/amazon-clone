import 'package:amazon_clone/features/admin/model/sales.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> data;
  const CategoryProductsChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    index >= 0 && index < data.length ? data[index].label : '',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 30,
              interval: 1,
            ),
          ),
        ),
        barGroups: data.asMap().entries.map((entry) {
          int index = entry.key;
          Sales sale = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: sale.earnings.toDouble(),
                width: 16,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}

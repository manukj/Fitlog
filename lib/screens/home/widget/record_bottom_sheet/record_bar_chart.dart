import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gainz/resource/firebase/model/reps_record.dart';
import 'package:intl/intl.dart';

class RepsBarChart extends StatelessWidget {
  final List<RepsRecord> data;

  const RepsBarChart({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data
                .map((e) => e.count)
                .reduce((a, b) => a > b ? a : b)
                .toDouble() +
            10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              interval: 10,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 30,
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final date = data[index].date;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(DateFormat('MM/d').format(date)),
                  );
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: const Text(''),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data
            .asMap()
            .entries
            .map((entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.count.toDouble(),
                      color: Colors.blue,
                      width: 16,
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

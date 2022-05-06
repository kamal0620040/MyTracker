import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'category.dart';
import 'package:collection/collection.dart';

class PieData {
  PieData();
}

class Data {
  final String name;
  final double percent;
  final Color color;
  Data({required this.name, required this.percent, required this.color});
}

Category cat = Category(catId: '5', title: 'title', color: Colors.red);

List<PieChartSectionData> getSections(
        int touchedIndex, Map<String, int> pieSection) =>
    pieSection.keys
        .toList()
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          final isTouched = index == touchedIndex;
          double fontSize = isTouched ? 25 : 16;
          double radius = isTouched ? 120 : 100;

          final value = PieChartSectionData(
            color: cat.catidToColor(data),
            value: pieSection.values.toList()[index] /
                pieSection.values.toList().sum *
                100,
            title: pieSection.values.toList()[index] /
                        pieSection.values.toList().sum *
                        100 >
                    7
                ? '${(pieSection.values.toList()[index] / pieSection.values.toList().sum * 100).toStringAsPrecision(3)}%'
                : '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
          return MapEntry(index, value);
        })
        .values
        .toList();

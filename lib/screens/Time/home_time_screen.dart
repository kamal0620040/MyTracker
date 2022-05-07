import 'package:flutter/material.dart';
import 'package:mytracker/screens/Time/pie_chart_sections.dart';

import 'category.dart';

class CategoryHome extends StatelessWidget {
  const CategoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(25),
      children: dummyCategories
          .map(
            (catData) => CategoryTime(
              catId: catData.catId,
              title: catData.title,
              color: catData.color,
              icon: catData.icon,
            ),
          )
          .toList(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}

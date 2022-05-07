//this is the home page of ExpenseTracker
import 'package:flutter/material.dart';
import 'category.dart';

class CategoryHome extends StatelessWidget {
  const CategoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExpenseTracker')),
      body: GridView(
        padding: const EdgeInsets.all(25),
        // DUMMY_CATEGORIES is List of CategoryExpense
        children: DUMMY_CATEGORIES
            .map(
              //with this method we are accessing, each CategoryExpense in DUMMY_CATEGORIES list & displaying as children of GridView
              (catData) => CategoryExpense(
                title: catData.title,
                color: catData.color,
                expenseCategoryIcon: catData.expenseCategoryIcon,
              ),
            )
            .toList(), //map is iterable so we need to change to List
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}

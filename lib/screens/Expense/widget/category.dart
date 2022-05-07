// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: non_constant_identifier_names

// We are creating a List of CategoryExpenses
final DUMMY_CATEGORIES = [
  CategoryExpense(
    title: 'Food',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.lunch_dining,
      color: Color.fromARGB(255, 255, 153, 0),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Entertainment',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.live_tv,
      color: Color.fromARGB(255, 251, 17, 0),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Eating Out',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.restaurant,
      color: Color.fromARGB(255, 255, 230, 0),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Sports',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.sports_soccer,
      color: Colors.white,
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Transport',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.directions_bus,
      color: Color.fromARGB(255, 0, 169, 253),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Rent',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.home,
      color: Color.fromARGB(255, 74, 255, 189),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Cloth',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      FontAwesomeIcons.shirt,
      color: Color.fromARGB(255, 255, 68, 102),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Gifts',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      FontAwesomeIcons.gift,
      color: Color.fromARGB(255, 214, 148, 255),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Study',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.school,
      color: Color.fromARGB(255, 136, 255, 0),
      size: 60,
    ),
  ),
  CategoryExpense(
    title: 'Others',
    color: Color.fromARGB(255, 8, 92, 11),
    expenseCategoryIcon: const Icon(
      Icons.public,
      color: Color.fromARGB(255, 100, 255, 105),
      size: 60,
    ),
  ),
];

// class Category {
//   final String title;
//   final Color color;
//   final Icon expenseCategoryIcon;
//   Category(
//       {required this.title,
//       required this.color,
//       required this.expenseCategoryIcon});
// }

class CategoryExpense extends StatelessWidget {
  // static const routeNAme = '/categoryexpense';
  final String title;
  final Color color;
  final Icon expenseCategoryIcon;

  CategoryExpense({
    required this.title,
    required this.color,
    required this.expenseCategoryIcon,
  });

  /* void selectCategory(BuildContext ctx) {
    // Navigator.of(ctx).pushNamed(EventList.routeName, arguments: {
    //   'id': cat_id,
    //   'title': title,
    // });
  } */

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //onTap of each category screen navigates to TransactionScreen of respective category
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (TransactionScreen(
              title:
                  title, //we are passing this category's title to use in TransactionScreen
            )),
          ),
        );
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: expenseCategoryIcon,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

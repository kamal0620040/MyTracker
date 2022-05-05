// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, sized_box_for_whitespace

import '../models/transaction.dart';
// import 'package:expense_tracker/widget/category.dart';
import 'package:flutter/material.dart';

import '../widget/transaction_item.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  final String CategoryTitle;
  TransactionList(this.transactions, this.deleteTx, this.CategoryTitle);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final List<Transaction> test = widget.transactions
        .where((element) => element.category == widget.CategoryTitle)
        .toList();
// print(test[0]);
    return Container(
      // color: Theme.of(context).primaryColor,
      height: 350,
      child: test.isEmpty
          ? Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'No Transactions yet!',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                // SizedBox(height: 10),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/noTransaction.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Please, press add button to add new transactions',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                // print(test[index]);
                return TransactionItem(
                    transaction: test[index], deleteTx: widget.deleteTx);
              },
              itemCount: test.length,
              // children: transactions.map((tx) {}).toList(),
            ),
    );
  }
}

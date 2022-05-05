// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './new_transaction.dart';
import './transaction_list.dart';
import './chart.dart';

class TransactionScreen extends StatefulWidget {
  final String title;
  TransactionScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  static final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Futsal',
      amount: 7.69,
      date: DateTime.now(),
      category: 'Sports',
    ),
    Transaction(
      id: 't2',
      title: 'Momo ',
      amount: 100.56,
      date: DateTime.now(),
      category: 'Eating out',
    ),
    Transaction(
      id: 't3',
      title: 'Cricket ',
      amount: 10.56,
      date: DateTime.now(),
      category: 'Sports',
    ),
    Transaction(
      id: 't4',
      title: 'Food ',
      amount: 10.56,
      date: DateTime.now(),
      category: 'Sports',
    ),
    Transaction(
      id: 't5',
      title: 'Food ',
      amount: 10.56,
      date: DateTime.now(),
      category: 'Sports',
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(), //just for unqiue id
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      category: widget.title,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    // print(widget.title);
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {}, //to not disapper sheet when tapped
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            onPressed: () => startAddNewTransaction(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions, widget.title),

            // UserTransactions(),
            TransactionList(
                _userTransactions, _deleteTransaction, widget.title),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}

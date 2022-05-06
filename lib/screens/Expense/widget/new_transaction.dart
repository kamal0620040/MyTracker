// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytracker/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../../../models/users.dart';
import '../../../provider/user_provider.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  final String categoryTitle;
  
 //addTx is function that will be passed from transaction_screen ie._addNewTransaction(String , double , DateTime )
  NewTransaction(this.addTx,this.categoryTitle);

  @override
  State<NewTransaction> createState() => _NewTransactionState(categoryTitle);
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final catTitle;
  
  DateTime? _selectedDate;

  _NewTransactionState(this.catTitle);

  void _submitData(String uid) async {
    print(catTitle);

    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    //upon submiting data it is also uploaded into firebase
    String res = await FireStoreMethods().uploadExpense(
      uid,
      enteredTitle,
      enteredAmount,
      _selectedDate!,
      catTitle,
    );
    print(res);

    //upon submiting, addTx method is called 
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    //after submitting the value, the showModalBottomSheet should disappear so we have pop one screen back
    //otherwise we have to mannually click of background
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //this class is provided from users.dart
    User user = Provider.of<UserProvider>(context).getUser;
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleController,
              // onSubmitted: (_) => _submitData(user.uid),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              // onSubmitted: (_) => _submitData(user.uid),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  )
                ],
              ),
            ),
            RaisedButton(
              onPressed: ()=>_submitData(user.uid),
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button?.color,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mytracker/models/users.dart' as model;
import 'package:mytracker/provider/user_provider.dart';
import 'package:provider/provider.dart';

class Nutrition extends StatefulWidget {
  const Nutrition({Key? key}) : super(key: key);

  @override
  State<Nutrition> createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}

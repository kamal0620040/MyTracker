import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytracker/models/monthly.dart';
import 'package:mytracker/models/post_nutrition.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadMonth(
    String uid,
    String currentYear,
    String currentMonth,
    double protein,
    double energy,
    double fats,
    double carbs,
  ) async {
    String res = "Some error occured.";
    try {
      Month month = Month(
        protein: protein,
        energy: energy,
        fats: fats,
        carbs: carbs,
      );
      _firestore
          .collection("monthly")
          .doc(uid)
          .collection("year")
          .doc(currentYear)
          .collection("month")
          .doc(currentMonth)
          .set(
            month.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Upload Nutrition
  Future<String> uploadNutrition(
    String eat,
    String uid,
    DateTime date,
    String meal,
    double quantity,
    String unit,
    double energy,
    double protein,
    double fats,
    double crab,
  ) async {
    String res = "Some error occured.";
    try {
      String nutritionId = const Uuid().v1();
      PostNutriton postNutriton = PostNutriton(
        eat: eat,
        uid: uid,
        nutritionId: nutritionId,
        date: date,
        meal: meal,
        quantity: quantity,
        unit: unit,
        energy: energy,
        protein: protein,
        fats: fats,
        crab: crab,
      );

      _firestore.collection("nutritionPost").doc(nutritionId).set(
            postNutriton.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

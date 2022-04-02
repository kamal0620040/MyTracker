import 'package:cloud_firestore/cloud_firestore.dart';

class PostNutriton {
  final String eat;
  final String uid;
  final String nutritionId;
  final DateTime date;
  final String meal;
  final double quantity;
  final String unit;
  final double energy;
  final double protein;
  final double fats;
  final double crab;

  const PostNutriton(
      {required this.eat,
      required this.uid,
      required this.nutritionId,
      required this.date,
      required this.meal,
      required this.quantity,
      required this.unit,
      required this.energy,
      required this.protein,
      required this.fats,
      required this.crab});

  Map<String, dynamic> toJson() => {
        "name": eat,
        "uid": uid,
        "nutritionId": nutritionId,
        "date": date,
        "meal": meal,
        "quantity": quantity,
        "unit": unit,
        "energy": energy,
        "protein": protein,
        "fats": fats,
        "crab": crab,
      };

  static PostNutriton fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostNutriton(
      eat: snapshot['eat'],
      uid: snapshot['uid'],
      nutritionId: snapshot['nutrition'],
      date: snapshot['date'],
      meal: snapshot['meal'],
      quantity: snapshot['quantity'],
      unit: snapshot['unit'],
      energy: snapshot['energy'],
      protein: snapshot['protein'],
      fats: snapshot['fats'],
      crab: snapshot['crab'],
    );
  }
}

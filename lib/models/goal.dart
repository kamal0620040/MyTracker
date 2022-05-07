import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionGoal {
  final double protein;
  final double energy;
  final double fats;
  final double carbs;

  const NutritionGoal({
    required this.protein,
    required this.energy,
    required this.fats,
    required this.carbs,
  });

  Map<String, dynamic> toJson() => {
        "carbs": carbs,
        "protein": protein,
        "energy": energy,
        "fats": fats,
      };

  static NutritionGoal fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return NutritionGoal(
      carbs: snapshot['carbs'],
      protein: snapshot['protein'],
      energy: snapshot['energy'],
      fats: snapshot['fats'],
    );
  }
}

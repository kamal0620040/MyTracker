import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  final double protein;
  final double energy;
  final double fats;
  final double carbs;

  const Month({
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

  static Month fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Month(
      carbs: snapshot['carbs'],
      protein: snapshot['protein'],
      energy: snapshot['energy'],
      fats: snapshot['fats'],
    );
  }
}

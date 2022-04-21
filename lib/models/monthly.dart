import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  final int protein;
  final int energy;
  final int fats;
  final int carbs;

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

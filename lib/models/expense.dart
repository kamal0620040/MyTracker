import 'package:cloud_firestore/cloud_firestore.dart';

class PostExpense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  const PostExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "amount": amount,
        "date": date,
        "category": category,
      };

  static PostExpense fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostExpense(
      id: snapshot['id'],
      title: snapshot['title'],
      amount: snapshot['amount'],
      date: snapshot['date'],
      category: snapshot['category'],
    );
  }
}

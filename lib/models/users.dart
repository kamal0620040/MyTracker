import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String name;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      name: snapshot['name'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}

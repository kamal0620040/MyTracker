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
}

class UserFirebaseModel {
  final String uid;
  final String email;
  final String username;

  UserFirebaseModel({
    required this.uid,
    required this.email,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'username': username};
  }

  factory UserFirebaseModel.fromMap(Map<String, dynamic> map) {
    return UserFirebaseModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
    );
  }
}

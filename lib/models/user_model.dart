class UserModel {
  final int? id;
  final String email;
  final String password;

  UserModel({this.id, required this.email, required this.password});

  // Convert UserModel to Map for database insertion
  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password};
  }

  // Create UserModel from Map (database retrieval)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, email: $email, password: $password)';
}

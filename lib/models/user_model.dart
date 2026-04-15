import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? id;
  final String email;
  final String password;
  final String? role;
  final String? nama;

  final String? photoUrl;
  final String? phone;
  final String? bio;
  final String? school;
  final String? location;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    this.role,
    this.nama,
    this.photoUrl,
    this.phone,
    this.bio,
    this.school,
    this.location,
  });

  // Convert UserModel to Map for database insertion
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'role': role,
      'nama': nama,
      'photoUrl': photoUrl,
      'phone': phone,
      'bio': bio,
      'school': school,
      'location': location,
    };
  }

  // Create UserModel from Map (database retrieval)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] != null ? map['role'] as String : null,
      nama: map['nama'] != null ? map['nama'] as String : null,
      photoUrl: map['photoUrl'] as String?,
      phone: map['phone'] as String?,
      bio: map['bio'] as String?,
      school: map['school'] as String?,
      location: map['location'] as String?,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, email: $email, password: $password)';

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

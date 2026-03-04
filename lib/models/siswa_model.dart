class SiswaModel {
  final int? id;
  final String nama;
  final String email;
  final String password;

  SiswaModel({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
  });

  // Convert SiswaModel to Map for database insertion
  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama, 'email': email, 'password': password};
  }

  // Create SiswaModel from Map (database retrieval)
  factory SiswaModel.fromMap(Map<String, dynamic> map) {
    return SiswaModel(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  @override
  String toString() =>
      'SiswaModel(id: $id, nama: $nama, email: $email, password: $password)';
}

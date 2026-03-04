class TutorModel {
  final int? id;
  final String nama;
  final String noHp;
  final String mataaPelajaran;

  TutorModel({
    this.id,
    required this.nama,
    required this.noHp,
    required this.mataaPelajaran,
  });

  // Convert TutorModel to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'no_hp': noHp,
      'mata_pelajaran': mataaPelajaran,
    };
  }

  // Create TutorModel from Map (database retrieval)
  factory TutorModel.fromMap(Map<String, dynamic> map) {
    return TutorModel(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      noHp: map['no_hp'] as String,
      mataaPelajaran: map['mata_pelajaran'] as String,
    );
  }

  @override
  String toString() =>
      'TutorModel(id: $id, nama: $nama, noHp: $noHp, mataaPelajaran: $mataaPelajaran)';
}

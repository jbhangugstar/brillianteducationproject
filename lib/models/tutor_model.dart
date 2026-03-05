class TutorModel {
  final int? id;
  final String nama;
  final String noHp;
  final String mataaPelajaran;
  final String foto;

  TutorModel({
    this.id,
    required this.nama,
    required this.noHp,
    required this.mataaPelajaran,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'no_hp': noHp,
      'mata_pelajaran': mataaPelajaran,
      'foto': foto,
    };
  }

  factory TutorModel.fromMap(Map<String, dynamic> map) {
    return TutorModel(
      id: map['id'],
      nama: map['nama'],
      noHp: map['no_hp'],
      mataaPelajaran: map['mata_pelajaran'],
      foto: map['foto'],
    );
  }
}

class Kelas {
  int? id;
  String namaKelas;
  int harga;
  String jadwal;
  String tutor;

  Kelas({
    this.id,
    required this.namaKelas,
    required this.harga,
    required this.jadwal,
    required this.tutor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kelas': namaKelas,
      'harga': harga,
      'jadwal': jadwal,
      'tutor': tutor,
    };
  }

  factory Kelas.fromMap(Map<String, dynamic> map) {
    return Kelas(
      id: map['id'],
      namaKelas: map['nama_kelas'],
      harga: map['harga'],
      jadwal: map['jadwal'],
      tutor: map['tutor'],
    );
  }
}

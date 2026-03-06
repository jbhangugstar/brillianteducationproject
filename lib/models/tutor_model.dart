class TutorModel {
  final int? id;
  final String nama;
  final String noHp;
  final String mataaPelajaran;
  final String foto;
  final String? email;
  final String? deskripsi;
  final double? rating;
  final int? jumlahSiswa;
  final String? pendidikan;
  final String? pengalaman;
  final String? keahlian;

  TutorModel({
    this.id,
    required this.nama,
    required this.noHp,
    required this.mataaPelajaran,
    required this.foto,
    this.email,
    this.deskripsi,
    this.rating,
    this.jumlahSiswa,
    this.pendidikan,
    this.pengalaman,
    this.keahlian,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'no_hp': noHp,
      'mata_pelajaran': mataaPelajaran,
      'foto': foto,
      'email': email,
      'deskripsi': deskripsi,
      'rating': rating,
      'jumlah_siswa': jumlahSiswa,
      'pendidikan': pendidikan,
      'pengalaman': pengalaman,
      'keahlian': keahlian,
    };
  }

  factory TutorModel.fromMap(Map<String, dynamic> map) {
    return TutorModel(
      id: map['id'],
      nama: map['nama'],
      noHp: map['no_hp'],
      mataaPelajaran: map['mata_pelajaran'],
      foto: map['foto'],
      email: map['email'],
      deskripsi: map['deskripsi'],
      rating: map['rating'],
      jumlahSiswa: map['jumlah_siswa'],
      pendidikan: map['pendidikan'],
      pengalaman: map['pengalaman'],
      keahlian: map['keahlian'],
    );
  }
}

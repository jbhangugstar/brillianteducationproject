class Kelas {
  int? id;
  String namaKelas;
  int harga;
  String jadwal;
  String tutor;
  String? deskripsi;
  String? foto;
  String? kategori;
  int? durasi;
  String? tingkatKesukaran;
  int? idTutor;
  int? jumlahSiswa;
  double? rating;
  String? status;
  String? tujuanPembelajaran;

  Kelas({
    this.id,
    required this.namaKelas,
    required this.harga,
    required this.jadwal,
    required this.tutor,
    this.deskripsi,
    this.foto,
    this.kategori,
    this.durasi,
    this.tingkatKesukaran,
    this.idTutor,
    this.jumlahSiswa,
    this.rating,
    this.status,
    this.tujuanPembelajaran,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kelas': namaKelas,
      'harga': harga,
      'jadwal': jadwal,
      'tutor': tutor,
      'deskripsi': deskripsi,
      'foto': foto,
      'kategori': kategori,
      'durasi': durasi,
      'tingkat_kesukaran': tingkatKesukaran,
      'id_tutor': idTutor,
      'jumlah_siswa': jumlahSiswa,
      'rating': rating,
      'status': status,
      'tujuan_pembelajaran': tujuanPembelajaran,
    };
  }

  factory Kelas.fromMap(Map<String, dynamic> map) {
    return Kelas(
      id: map['id'],
      namaKelas: map['nama_kelas'],
      harga: map['harga'],
      jadwal: map['jadwal'],
      tutor: map['tutor'],
      deskripsi: map['deskripsi'],
      foto: map['foto'],
      kategori: map['kategori'],
      durasi: map['durasi'],
      tingkatKesukaran: map['tingkat_kesukaran'],
      idTutor: map['id_tutor'],
      jumlahSiswa: map['jumlah_siswa'],
      rating: map['rating'],
      status: map['status'],
      tujuanPembelajaran: map['tujuan_pembelajaran'],
    );
  }
}

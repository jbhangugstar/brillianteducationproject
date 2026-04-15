class Kelas {
  String? id;
  String namaKelas;
  int harga;
  String jadwal;
  String tutor;
  String? deskripsi;
  String? foto;
  String? kategori;
  int? durasi;
  String? tingkatKesukaran;
  String? idTutor;
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

  // =================== COPYWITH ===================
  Kelas copyWith({
    String? id,
    String? namaKelas,
    int? harga,
    String? jadwal,
    String? tutor,
    String? deskripsi,
    String? foto,
    String? kategori,
    int? durasi,
    String? tingkatKesukaran,
    String? idTutor,
    int? jumlahSiswa,
    double? rating,
    String? status,
    String? tujuanPembelajaran,
  }) {
    return Kelas(
      id: id ?? this.id,
      namaKelas: namaKelas ?? this.namaKelas,
      harga: harga ?? this.harga,
      jadwal: jadwal ?? this.jadwal,
      tutor: tutor ?? this.tutor,
      deskripsi: deskripsi ?? this.deskripsi,
      foto: foto ?? this.foto,
      kategori: kategori ?? this.kategori,
      durasi: durasi ?? this.durasi,
      tingkatKesukaran: tingkatKesukaran ?? this.tingkatKesukaran,
      idTutor: idTutor ?? this.idTutor,
      jumlahSiswa: jumlahSiswa ?? this.jumlahSiswa,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      tujuanPembelajaran: tujuanPembelajaran ?? this.tujuanPembelajaran,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
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
    map.removeWhere((key, value) => value == null);
    return map;
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
      rating: map['rating']?.toDouble(),
      status: map['status'],
      tujuanPembelajaran: map['tujuan_pembelajaran'],
    );
  }
}

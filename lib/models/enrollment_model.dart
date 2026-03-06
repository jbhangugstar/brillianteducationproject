class EnrollmentModel {
  final int? id;
  final int idSiswa;
  final int idKelas;
  final String namaSiswa;
  final String namaKelas;
  final String tanggalDaftar;
  final String status;
  final double? nilaiProgress;

  EnrollmentModel({
    this.id,
    required this.idSiswa,
    required this.idKelas,
    required this.namaSiswa,
    required this.namaKelas,
    required this.tanggalDaftar,
    required this.status,
    this.nilaiProgress,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_siswa': idSiswa,
      'id_kelas': idKelas,
      'nama_siswa': namaSiswa,
      'nama_kelas': namaKelas,
      'tanggal_daftar': tanggalDaftar,
      'status': status,
      'nilai_progress': nilaiProgress,
    };
  }

  factory EnrollmentModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentModel(
      id: map['id'],
      idSiswa: map['id_siswa'],
      idKelas: map['id_kelas'],
      namaSiswa: map['nama_siswa'],
      namaKelas: map['nama_kelas'],
      tanggalDaftar: map['tanggal_daftar'],
      status: map['status'],
      nilaiProgress: map['nilai_progress'],
    );
  }
}

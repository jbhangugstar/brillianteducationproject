import 'package:brillianteducationproject/models/tutor_model.dart';
import 'package:brillianteducationproject/database/db_helper.dart';

class TutorController {
  // Fungsi untuk mendaftarkan tutor baru
  static Future<int> registerTutor(TutorModel tutor) async {
    final dbs = await DBHelper.db();
    return await dbs.insert('tutor', tutor.toMap());
  }

  // Fungsi untuk mengambil semua data tutor
  static Future<List<TutorModel>> getAllTutor() async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query("tutor");
    return results.map((e) => TutorModel.fromMap(e)).toList();
  }

  // Fungsi untuk mengambil data tutor berdasarkan ID
  static Future<TutorModel?> getTutorById(int id) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "tutor",
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return TutorModel.fromMap(results.first);
    }
    return null;
  }

  // Fungsi untuk mencari tutor berdasarkan nama, mata pelajaran, atau keahlian
  static Future<List<TutorModel>> searchTutor(String keyword) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "tutor",
      where: 'nama LIKE ? OR mata_pelajaran LIKE ? OR keahlian LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
    );
    return results.map((e) => TutorModel.fromMap(e)).toList();
  }

  // Fungsi untuk mengambil tutor berdasarkan mata pelajaran
  static Future<List<TutorModel>> getTutorBySubject(String subject) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "tutor",
      where: 'mata_pelajaran LIKE ?',
      whereArgs: ['%$subject%'],
    );
    return results.map((e) => TutorModel.fromMap(e)).toList();
  }

  // Fungsi untuk memperbarui data tutor
  static Future<int> updateTutor(TutorModel tutor) async {
    final dbs = await DBHelper.db();
    if (tutor.id == null) {
      throw Exception("ID wajib ada");
    }
    return dbs.update(
      'tutor',
      tutor.toMap(),
      where: 'id = ?',
      whereArgs: [tutor.id],
    );
  }

  // Fungsi untuk menghapus tutor berdasarkan ID
  static Future<int> deleteTutor(int id) async {
    final dbs = await DBHelper.db();
    return dbs.delete('tutor', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk mendapatkan tutor dengan rating tertinggi
  static Future<List<TutorModel>> getTopRatedTutor({int limit = 5}) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "tutor",
      orderBy: 'rating DESC',
      limit: limit,
    );
    return results.map((e) => TutorModel.fromMap(e)).toList();
  }

  // Fungsi untuk mendapatkan tutor dengan siswa terbanyak
  static Future<List<TutorModel>> getPopularTutor({int limit = 5}) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "tutor",
      orderBy: 'jumlah_siswa DESC',
      limit: limit,
    );
    return results.map((e) => TutorModel.fromMap(e)).toList();
  }

  // Fungsi untuk memperbarui jumlah siswa yang diajar oleh tutor
  static Future<void> updateTutorStudentCount(int tutorId, int count) async {
    final dbs = await DBHelper.db();
    await dbs.update(
      'tutor',
      {'jumlah_siswa': count},
      where: 'id = ?',
      whereArgs: [tutorId],
    );
  }

  // Fungsi untuk memperbarui rating tutor
  static Future<void> updateTutorRating(int tutorId, double rating) async {
    final dbs = await DBHelper.db();
    await dbs.update(
      'tutor',
      {'rating': rating},
      where: 'id = ?',
      whereArgs: [tutorId],
    );
  }
}

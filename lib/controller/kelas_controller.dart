import 'package:brillianteducationproject/database/db_helper.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:sqflite/sqflite.dart';

class KelasController {
  // CREATE KELAS
  static Future<int> createKelas(Kelas kelas) async {
    final db = await DBHelper.db();
    return await db.insert('kelas', kelas.toMap());
  }

  // READ ALL KELAS
  static Future<List<Kelas>> getAllKelas() async {
    final db = await DBHelper.db();
    final result = await db.query('kelas');
    return result.map((e) => Kelas.fromMap(e)).toList();
  }

  // READ KELAS BY ID
  static Future<Kelas?> getKelasById(int id) async {
    final db = await DBHelper.db();
    final result = await db.query('kelas', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Kelas.fromMap(result.first);
    }
    return null;
  }

  // READ KELAS BY TUTOR
  static Future<List<Kelas>> getKelasByTutor(int tutorId) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'kelas',
      where: 'id_tutor = ?',
      whereArgs: [tutorId],
    );
    return result.map((e) => Kelas.fromMap(e)).toList();
  }

  // READ KELAS BY KATEGORI
  static Future<List<Kelas>> getKelasByKategori(String kategori) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'kelas',
      where: 'kategori = ?',
      whereArgs: [kategori],
    );
    return result.map((e) => Kelas.fromMap(e)).toList();
  }

  // SEARCH KELAS
  static Future<List<Kelas>> searchKelas(String keyword) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'kelas',
      where: 'nama_kelas LIKE ? OR deskripsi LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return result.map((e) => Kelas.fromMap(e)).toList();
  }

  // UPDATE KELAS
  static Future<int> updateKelas(int id, Kelas kelas) async {
    final db = await DBHelper.db();
    return await db.update(
      'kelas',
      kelas.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE KELAS
  static Future<int> deleteKelas(int id) async {
    final db = await DBHelper.db();
    return await db.delete('kelas', where: 'id = ?', whereArgs: [id]);
  }

  // GET TOTAL STUDENTS IN CLASS
  static Future<int> getTotalStudentsInClass(int kelasId) async {
    final db = await DBHelper.db();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM enrollment WHERE id_kelas = ? AND status = ?',
      [kelasId, 'aktif'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // GET TOP RATED CLASSES
  static Future<List<Kelas>> getTopRatedKelas({int limit = 5}) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'kelas',
      orderBy: 'rating DESC',
      limit: limit,
    );
    return result.map((e) => Kelas.fromMap(e)).toList();
  }

  // GET POPULAR CLASSES
  static Future<List<Kelas>> getPopularKelas({int limit = 5}) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'kelas',
      orderBy: 'jumlah_siswa DESC',
      limit: limit,
    );
    return result.map((e) => Kelas.fromMap(e)).toList();
  }

  // UPDATE STUDENT COUNT
  static Future<void> updateStudentCount(int kelasId) async {
    final count = await getTotalStudentsInClass(kelasId);
    final db = await DBHelper.db();
    await db.update(
      'kelas',
      {'jumlah_siswa': count},
      where: 'id = ?',
      whereArgs: [kelasId],
    );
  }
}

import 'package:brillianteducationproject/database/db_helper.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:sqflite/sqflite.dart';

class KelasController {
  // ===============================
  // CREATE KELAS
  // ===============================
  static Future<int> createKelas(Kelas kelas) async {
    try {
      print('\n>>> KelasController.createKelas()');
      print('    Nama: ${kelas.namaKelas}');
      print('    Harga: ${kelas.harga}');

      final db = await DBHelper.db();
      print('    ✅ Database terbuka');

      final map = kelas.toMap();
      print('    Map keys: ${map.keys.toList()}');
      print('    Map values: ${map.values.toList()}');

      // Validate required fields
      if (!map.containsKey('nama_kelas')) {
        throw Exception('Field nama_kelas tidak boleh kosong!');
      }
      if (!map.containsKey('harga')) {
        throw Exception('Field harga tidak boleh kosong!');
      }

      final result = await db.insert(
        'kelas',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('    ✅ Insert result: $result (type: ${result.runtimeType})');

      // Verify data tersimpan
      if (result > 0) {
        final verify = await db.query(
          'kelas',
          where: 'id = ?',
          whereArgs: [result],
        );
        print('    ✅ Verify: Data ditemukan = ${verify.isNotEmpty}');
        if (verify.isNotEmpty) {
          print('    ✅ Data di DB: ${verify.first}');
        }
      }

      return result;
    } catch (e, st) {
      print('    ❌ ERROR: $e');
      print('    Stack: $st');
      rethrow; // Re-throw untuk biar handle di screen level
    }
  }

  // ===============================
  // READ ALL KELAS
  // ===============================
  static Future<List<Kelas>> getAllKelas() async {
    try {
      final db = await DBHelper.db();

      final result = await db.query('kelas');

      return result.map((e) => Kelas.fromMap(e)).toList();
    } catch (e) {
      print("Error getAllKelas: $e");
      return [];
    }
  }

  // ===============================
  // READ KELAS BY ID
  // ===============================
  static Future<Kelas?> getKelasById(int id) async {
    try {
      final db = await DBHelper.db();

      final result = await db.query('kelas', where: 'id = ?', whereArgs: [id]);

      if (result.isNotEmpty) {
        return Kelas.fromMap(result.first);
      }

      return null;
    } catch (e) {
      print("Error getKelasById: $e");
      return null;
    }
  }

  // ===============================
  // READ KELAS BY TUTOR
  // ===============================
  static Future<List<Kelas>> getKelasByTutor(int tutorId) async {
    try {
      final db = await DBHelper.db();

      final result = await db.query(
        'kelas',
        where: 'id_tutor = ?',
        whereArgs: [tutorId],
      );

      return result.map((e) => Kelas.fromMap(e)).toList();
    } catch (e) {
      print("Error getKelasByTutor: $e");
      return [];
    }
  }

  // ===============================
  // READ KELAS BY KATEGORI
  // ===============================
  static Future<List<Kelas>> getKelasByKategori(String kategori) async {
    try {
      final db = await DBHelper.db();

      final result = await db.query(
        'kelas',
        where: 'kategori = ?',
        whereArgs: [kategori],
      );

      return result.map((e) => Kelas.fromMap(e)).toList();
    } catch (e) {
      print("Error getKelasByKategori: $e");
      return [];
    }
  }

  // ===============================
  // SEARCH KELAS (case insensitive)
  // ===============================
  static Future<List<Kelas>> searchKelas(String keyword) async {
    try {
      final db = await DBHelper.db();

      final result = await db.query(
        'kelas',
        where: 'LOWER(nama_kelas) LIKE ? OR LOWER(deskripsi) LIKE ?',
        whereArgs: ['%${keyword.toLowerCase()}%', '%${keyword.toLowerCase()}%'],
      );

      return result.map((e) => Kelas.fromMap(e)).toList();
    } catch (e) {
      print("Error searchKelas: $e");
      return [];
    }
  }

  // ===============================
  // UPDATE KELAS
  // ===============================
  static Future<int> updateKelas(int id, Kelas kelas) async {
    try {
      final db = await DBHelper.db();

      return await db.update(
        'kelas',
        kelas.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updateKelas: $e");
      return -1;
    }
  }

  // ===============================
  // DELETE KELAS
  // ===============================
  static Future<int> deleteKelas(int id) async {
    try {
      final db = await DBHelper.db();

      return await db.delete('kelas', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleteKelas: $e");
      return -1;
    }
  }

  // ===============================
  // TOTAL SISWA DALAM KELAS
  // ===============================
  static Future<int> getTotalStudentsInClass(int kelasId) async {
    try {
      final db = await DBHelper.db();

      final result = await db.rawQuery(
        'SELECT COUNT(*) as total FROM enrollment WHERE id_kelas = ? AND status = ?',
        [kelasId, 'aktif'],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print("Error getTotalStudentsInClass: $e");
      return 0;
    }
  }

  // ===============================
  // TOP RATED CLASSES
  // ===============================
  static Future<List<Kelas>> getTopRatedKelas({int limit = 5}) async {
    try {
      final db = await DBHelper.db();

      final result = await db.query(
        'kelas',
        orderBy: 'rating DESC',
        limit: limit,
      );

      return result.map((e) => Kelas.fromMap(e)).toList();
    } catch (e) {
      print("Error getTopRatedKelas: $e");
      return [];
    }
  }

  // ===============================
  // POPULAR CLASSES
  // ===============================
  static Future<List<Kelas>> getPopularKelas({int limit = 5}) async {
    try {
      final db = await DBHelper.db();

      final result = await db.query(
        'kelas',
        orderBy: 'jumlah_siswa DESC',
        limit: limit,
      );

      return result.map((e) => Kelas.fromMap(e)).toList();
    } catch (e) {
      print("Error getPopularKelas: $e");
      return [];
    }
  }

  // ===============================
  // UPDATE JUMLAH SISWA
  // ===============================
  static Future<void> updateStudentCount(int kelasId) async {
    try {
      final count = await getTotalStudentsInClass(kelasId);

      final db = await DBHelper.db();

      await db.update(
        'kelas',
        {'jumlah_siswa': count},
        where: 'id = ?',
        whereArgs: [kelasId],
      );
    } catch (e) {
      print("Error updateStudentCount: $e");
    }
  }

  // ===============================
  // TOTAL KELAS
  // ===============================
  static Future<int> getTotalKelas() async {
    try {
      final db = await DBHelper.db();

      final result = await db.rawQuery('SELECT COUNT(*) FROM kelas');

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print("Error getTotalKelas: $e");
      return 0;
    }
  }
}

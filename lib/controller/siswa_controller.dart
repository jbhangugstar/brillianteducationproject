import 'package:brillianteducationproject/models/siswa_model.dart';
import 'package:brillianteducationproject/database/db_helper.dart';

class SiswaController {
  static Future<int> registerSiswa(SiswaModel siswa) async {
    final dbs = await DBHelper.db();
    return await dbs.insert('siswa', siswa.toMap());
  }

  static Future<List<SiswaModel>> getAllSiswa() async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query("siswa");
    return results.map((e) => SiswaModel.fromMap(e)).toList();
  }

  static Future<SiswaModel?> getSiswaById(int id) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "siswa",
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return SiswaModel.fromMap(results.first);
    }
    return null;
  }

  static Future<SiswaModel?> getSiswaByEmail(String email) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "siswa",
      where: 'email = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      return SiswaModel.fromMap(results.first);
    }
    return null;
  }

  static Future<List<SiswaModel>> searchSiswa(String keyword) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "siswa",
      where: 'nama LIKE ? OR email LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return results.map((e) => SiswaModel.fromMap(e)).toList();
  }

  static Future<int> updateSiswa(SiswaModel siswa) async {
    final dbs = await DBHelper.db();
    if (siswa.id == null) {
      throw Exception("ID wajib ada");
    }
    return await dbs.update(
      'siswa',
      siswa.toMap(),
      where: 'id = ?',
      whereArgs: [siswa.id],
    );
  }

  static Future<int> deleteSiswa(int id) async {
    final dbs = await DBHelper.db();
    return await dbs.delete('siswa', where: 'id = ?', whereArgs: [id]);
  }
}

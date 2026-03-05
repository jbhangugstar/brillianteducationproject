import 'package:brillianteducationproject/models/siswa_model.dart';
import 'package:brillianteducationproject/database/sqflite.dart';

class SiswaController {
  static Future<void> registerSiswa(SiswaModel siswa) async {
    final dbs = await DBHelper.db();
    await dbs.insert('siswa', siswa.toMap());
  }

  static Future<List<SiswaModel>> getAllSiswa() async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query("siswa");
    return results.map((e) => SiswaModel.fromMap(e)).toList();
  }

  static Future<void> updateSiswa(SiswaModel siswa) async {
    final dbs = await DBHelper.db();

    await dbs.update(
      'siswa',
      siswa.toMap(),
      where: 'id = ?',
      whereArgs: [siswa.id],
    );
  }

  static Future<void> deleteSiswa(int id) async {
    final dbs = await DBHelper.db();

    await dbs.delete('siswa', where: 'id = ?', whereArgs: [id]);
  }
}

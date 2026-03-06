import 'package:brillianteducationproject/database/db_helper.dart';

class KelasController {
  // CREATE KELAS
  static Future<void> createKelas(Map<String, dynamic> data) async {
    final db = await DBHelper.db();
    await db.insert('kelas', data);
  }

  // READ KELAS
  static Future<List<Map<String, dynamic>>> getAllKelas() async {
    final db = await DBHelper.db();
    final result = await db.query('kelas');
    return result;
  }

  // UPDATE KELAS
  static Future<void> updateKelas(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.db();

    await db.update('kelas', data, where: 'id = ?', whereArgs: [id]);
  }

  // DELETE KELAS
  static Future<void> deleteKelas(int id) async {
    final db = await DBHelper.db();

    await db.delete('kelas', where: 'id = ?', whereArgs: [id]);
  }
}

import 'package:brillianteducationproject/models/tutor_model.dart';
import 'package:brillianteducationproject/database/sqflite.dart';

class TutorController {
  static Future<void> registerTutor(TutorModel tutor) async {
    final dbs = await DBHelper.db();
    await dbs.insert('tutor', tutor.toMap());
    print(tutor.toMap());
  }

  static Future<List<TutorModel>> getAllTutor() async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query("tutor");
    print(results.map((e) => TutorModel.fromMap(e)).toList());
    return results.map((e) => TutorModel.fromMap(e)).toList();
  }

  static Future<int> updateTutor(TutorModel tutor) async {
    final dbs = await DBHelper.db();
    if (tutor.id == null) {
      throw Exception("ID Wajid ada");
    }
    return dbs.update(
      'tutor',
      tutor.toMap(),
      where: 'id = ?',
      whereArgs: [tutor.id],
    );
  }

  static Future<int> deleteTutor(int id) async {
    final dbs = await DBHelper.db();
    return dbs.delete('tutor', where: 'id = ?', whereArgs: [id]);
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:brillianteducationproject/models/user_model.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'Brilliant_Education.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user ( id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
        );

        await db.execute(
          'CREATE TABLE tutor ( id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, no_hp TEXT, mata_pelajaran TEXT)',
        );
      },
      version: 5,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 5) {
          await db.execute(
            'CREATE TABLE tutor ( id INTEGER PRIMARY KEY AUTOINCREMENT , nama TEXT, no_hp TEXT, mata_pelajaran TEXT)',
          );
        }
      },
    );
  }

  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert('user', user.toMap());
  }

  static Future<UserModel?> loginuser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "user",
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }
}

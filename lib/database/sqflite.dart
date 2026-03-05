import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:brillianteducationproject/models/user_model.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'Brilliant_Education.db'),
      onCreate: (db, version) async {
        // TABEL USER
        await db.execute(
          'CREATE TABLE user ( id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
        );

        // TABEL TUTOR
        await db.execute(
          'CREATE TABLE tutor ( id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, no_hp TEXT, mata_pelajaran TEXT)',
        );

        // TABEL SISWA (DITAMBAHKAN)
        await db.execute(
          'CREATE TABLE siswa ( id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, password TEXT)',
        );

        // TABEL KELAS (DITAMBAHKAN)
        await db.execute('''
        CREATE TABLE kelas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama_kelas TEXT,
          harga INTEGER,
          jadwal TEXT,
          tutor TEXT,
          deskripsi TEXT
          foto TEXT
        )
        ''');
      },
      version: 8,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 7) {
          await db.execute(
            'CREATE TABLE tutor ( id INTEGER PRIMARY KEY AUTOINCREMENT , nama TEXT, no_hp TEXT, mata_pelajaran TEXT)',
          );

          // TAMBAHAN TABEL SISWA
          await db.execute(
            'CREATE TABLE siswa ( id INTEGER PRIMARY KEY AUTOINCREMENT , nama TEXT, email TEXT, password TEXT)',
          );
        }

        // TAMBAHAN TABEL KELAS
        if (oldVersion < 8) {
          await db.execute('''
          CREATE TABLE kelas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_kelas TEXT,
            harga INTEGER,
            jadwal TEXT,
            tutor TEXT,
            deskripsi TEXT,
            foto TEXT
          )
          ''');
        }
      },
    );
  }

  // REGISTER USER
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert('user', user.toMap());
  }

  // LOGIN USER
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

  // menampilkan kelas
  Future<List<Map<String, dynamic>>> getAllKelas() async {
    final dbs = await db();
    return await dbs.query('kelas');
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:brillianteducationproject/models/user_model.dart';

class DBHelper {
  static Future<Database> db() async {
    print('\n>>> DBHelper.db() - Getting database...');
    final dbPath = await getDatabasesPath();
    final dbFile = join(dbPath, 'Brilliant_Education.db');
    print('    Path: $dbFile');

    return openDatabase(
      dbFile,
      onCreate: (db, version) async {
        print('    🆕 Creating new database (version $version)...');
        await db.execute(
          'CREATE TABLE user ( id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT, role TEXT, nama TEXT)',
        );

        // TABEL TUTOR
        await db.execute('''
        CREATE TABLE tutor (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT NOT NULL,
          no_hp TEXT,
          mata_pelajaran TEXT,
          foto TEXT,
          email TEXT,
          deskripsi TEXT,
          rating REAL,
          jumlah_siswa INTEGER DEFAULT 0,
          pendidikan TEXT,
          pengalaman TEXT,
          keahlian TEXT,
          id_user INTEGER
        )
        ''');

        // TABEL SISWA
        await db.execute(
          'CREATE TABLE siswa ( id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, password TEXT)',
        );

        // TABEL KELAS - IMPORTANT!
        await db.execute('''
        CREATE TABLE kelas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama_kelas TEXT NOT NULL,
          harga INTEGER,
          jadwal TEXT,
          tutor TEXT,
          deskripsi TEXT,
          foto TEXT,
          kategori TEXT,
          durasi INTEGER,
          tingkat_kesukaran TEXT,
          id_tutor INTEGER,
          jumlah_siswa INTEGER DEFAULT 0,
          rating REAL,
          status TEXT DEFAULT 'aktif',
          tujuan_pembelajaran TEXT
        )
        ''');

        // TABEL ENROLLMENT
        await db.execute('''
        CREATE TABLE enrollment (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          id_siswa INTEGER NOT NULL,
          id_kelas INTEGER NOT NULL,
          nama_siswa TEXT,
          nama_kelas TEXT,
          tanggal_daftar TEXT,
          status TEXT DEFAULT 'aktif',
          nilai_progress REAL DEFAULT 0
        )
        ''');
        print('    ✅ Tables created!');
      },
      version: 10,
      onUpgrade: (db, oldVersion, newVersion) async {
        print('    🔄 Upgrading from v$oldVersion to v$newVersion...');
        try {
          // Drop old tables
          await db.execute('DROP TABLE IF EXISTS kelas');
          await db.execute('DROP TABLE IF EXISTS enrollment');
          await db.execute('DROP TABLE IF EXISTS tutor');
          await db.execute('DROP TABLE IF EXISTS siswa');
          await db.execute('DROP TABLE IF EXISTS user');
          print('    ✅ Old tables dropped');

          // Recreate new tables
          await db.execute(
            'CREATE TABLE user ( id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT, role TEXT, nama TEXT)',
          );

          await db.execute('''
          CREATE TABLE tutor (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            no_hp TEXT,
            mata_pelajaran TEXT,
            foto TEXT,
            email TEXT,
            deskripsi TEXT,
            rating REAL,
            jumlah_siswa INTEGER DEFAULT 0,
            pendidikan TEXT,
            pengalaman TEXT,
            keahlian TEXT,
            id_user INTEGER
          )
          ''');

          await db.execute(
            'CREATE TABLE siswa ( id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, password TEXT)',
          );

          await db.execute('''
          CREATE TABLE kelas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_kelas TEXT NOT NULL,
            harga INTEGER,
            jadwal TEXT,
            tutor TEXT,
            deskripsi TEXT,
            foto TEXT,
            kategori TEXT,
            durasi INTEGER,
            tingkat_kesukaran TEXT,
            id_tutor INTEGER,
            jumlah_siswa INTEGER DEFAULT 0,
            rating REAL,
            status TEXT DEFAULT 'aktif',
            tujuan_pembelajaran TEXT
          )
          ''');

          await db.execute('''
          CREATE TABLE enrollment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_siswa INTEGER NOT NULL,
            id_kelas INTEGER NOT NULL,
            nama_siswa TEXT,
            nama_kelas TEXT,
            tanggal_daftar TEXT,
            status TEXT DEFAULT 'aktif',
            nilai_progress REAL DEFAULT 0
          )
          ''');

          print('    ✅ New tables created!');
        } catch (e) {
          print('    ❌ Error during upgrade: $e');
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

  // Get kelas by ID
  Future<Map<String, dynamic>?> getKelasById(int id) async {
    final dbs = await db();
    final result = await dbs.query('kelas', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Get tutor by ID
  Future<Map<String, dynamic>?> getTutorById(int id) async {
    final dbs = await db();
    final result = await dbs.query('tutor', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Get all students in a class
  Future<List<Map<String, dynamic>>> getStudentsByKelas(int kelasId) async {
    final dbs = await db();
    return await dbs.query(
      'enrollment',
      where: 'id_kelas = ?',
      whereArgs: [kelasId],
    );
  }

  // Get all classes for a tutor
  Future<List<Map<String, dynamic>>> getKelasByTutor(int tutorId) async {
    final dbs = await db();
    return await dbs.query(
      'kelas',
      where: 'id_tutor = ?',
      whereArgs: [tutorId],
    );
  }
}

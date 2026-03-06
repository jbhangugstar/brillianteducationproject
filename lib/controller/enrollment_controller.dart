import 'package:brillianteducationproject/database/db_helper.dart';
import 'package:brillianteducationproject/models/enrollment_model.dart';
import 'package:sqflite/sqflite.dart';

class EnrollmentController {
  // CREATE ENROLLMENT
  static Future<int> enrollStudent(EnrollmentModel enrollment) async {
    final db = await DBHelper.db();
    return await db.insert('enrollment', enrollment.toMap());
  }

  // READ ALL ENROLLMENTS
  static Future<List<EnrollmentModel>> getAllEnrollments() async {
    final db = await DBHelper.db();
    final result = await db.query('enrollment');
    return result.map((e) => EnrollmentModel.fromMap(e)).toList();
  }

  // READ ENROLLMENTS BY STUDENT
  static Future<List<EnrollmentModel>> getEnrollmentsByStudent(
    int siswaId,
  ) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'enrollment',
      where: 'id_siswa = ?',
      whereArgs: [siswaId],
    );
    return result.map((e) => EnrollmentModel.fromMap(e)).toList();
  }

  // READ ENROLLMENTS BY CLASS
  static Future<List<EnrollmentModel>> getEnrollmentsByClass(
    int kelasId,
  ) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'enrollment',
      where: 'id_kelas = ?',
      whereArgs: [kelasId],
    );
    return result.map((e) => EnrollmentModel.fromMap(e)).toList();
  }

  // CHECK IF STUDENT ALREADY ENROLLED
  static Future<bool> isStudentEnrolled(int siswaId, int kelasId) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'enrollment',
      where: 'id_siswa = ? AND id_kelas = ?',
      whereArgs: [siswaId, kelasId],
    );
    return result.isNotEmpty;
  }

  // UPDATE ENROLLMENT
  static Future<int> updateEnrollment(
    int id,
    EnrollmentModel enrollment,
  ) async {
    final db = await DBHelper.db();
    return await db.update(
      'enrollment',
      enrollment.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ENROLLMENT
  static Future<int> deleteEnrollment(int id) async {
    final db = await DBHelper.db();
    return await db.delete('enrollment', where: 'id = ?', whereArgs: [id]);
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

  // UPDATE STUDENT PROGRESS
  static Future<int> updateStudentProgress(
    int enrollmentId,
    double progress,
  ) async {
    final db = await DBHelper.db();
    return await db.update(
      'enrollment',
      {'nilai_progress': progress},
      where: 'id = ?',
      whereArgs: [enrollmentId],
    );
  }

  // GET ACTIVE ENROLLMENTS FOR CLASS
  static Future<List<EnrollmentModel>> getActiveEnrollmentsByClass(
    int kelasId,
  ) async {
    final db = await DBHelper.db();
    final result = await db.query(
      'enrollment',
      where: 'id_kelas = ? AND status = ?',
      whereArgs: [kelasId, 'aktif'],
    );
    return result.map((e) => EnrollmentModel.fromMap(e)).toList();
  }

  // CANCEL ENROLLMENT
  static Future<int> cancelEnrollment(int enrollmentId) async {
    final db = await DBHelper.db();
    return await db.update(
      'enrollment',
      {'status': 'dibatalkan'},
      where: 'id = ?',
      whereArgs: [enrollmentId],
    );
  }
}

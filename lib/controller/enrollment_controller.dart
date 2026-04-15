import 'package:brillianteducationproject/models/enrollment_model.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/service/firebase_service.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';

class EnrollmentController {
  // CREATE ENROLLMENT
  static Future<String> enrollStudent(EnrollmentModel enrollment) async {
    return await FirebaseService.enrollStudent(enrollment);
  }

  // READ ALL ENROLLMENTS
  static Future<List<EnrollmentModel>> getAllEnrollments() async {
    // Current FirebaseService implementation fetches all
    return await FirebaseService.getEnrollmentsForTutor("").first; 
  }

  // READ ENROLLMENTS BY STUDENT
  static Future<List<EnrollmentModel>> getEnrollmentsByStudent(
    String siswaId,
  ) async {
    return await FirebaseService.getStudentEnrollments(siswaId);
  }

  // READ ENROLLMENTS BY CLASS
  static Future<List<EnrollmentModel>> getEnrollmentsByClass(
    String kelasId,
  ) async {
    final all = await FirebaseService.getEnrollmentsForTutor("").first;
    return all.where((e) => e.idKelas == kelasId).toList();
  }

  // CHECK IF STUDENT ALREADY ENROLLED
  static Future<bool> isStudentEnrolled(String siswaId, String kelasId) async {
    final mine = await FirebaseService.getStudentEnrollments(siswaId);
    return mine.any((e) => e.idKelas == kelasId);
  }

  // UPDATE ENROLLMENT
  static Future<void> updateEnrollment(
    EnrollmentModel enrollment,
  ) async {
    // Basic implementation: overwrite or update in Firestore
    // For now, implement if needed in FirebaseService
  }

  // DELETE ENROLLMENT
  static Future<void> deleteEnrollment(String id) async {
    // Add delete logic in FirebaseService if needed
  }

  // GET TOTAL STUDENTS IN CLASS
  static Future<int> getTotalStudentsInClass(String kelasId) async {
    final all = await FirebaseService.getEnrollmentsForTutor("").first;
    return all.where((e) => e.idKelas == kelasId && e.status == 'aktif').length;
  }

  // GET ENROLLED CLASSES WITH FULL DETAILS FOR STUDENT
  static Future<List<Kelas>> getEnrolledClassesByStudent(String siswaId) async {
    final enrollments = await FirebaseService.getStudentEnrollments(siswaId);
    final List<Kelas> result = [];
    
    for (var enrollment in enrollments) {
      final kelas = await KelasController.getKelasById(enrollment.idKelas);
      if (kelas != null) {
        result.add(kelas);
      }
    }
    
    return result;
  }
}

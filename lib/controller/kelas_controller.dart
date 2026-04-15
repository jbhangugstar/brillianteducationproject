import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/service/firebase_service.dart';

class KelasController {
  // ===============================
  // CREATE KELAS
  // ===============================
  static Future<String> createKelas(Kelas kelas) async {
    try {
      print('\n>>> KelasController.createKelas()');
      return await FirebaseService.createKelas(kelas);
    } catch (e) {
      print('    ❌ ERROR: $e');
      rethrow;
    }
  }

  // ===============================
  // READ ALL KELAS
  // ===============================
  static Future<List<Kelas>> getAllKelas() async {
    try {
      return await FirebaseService.getAllKelas();
    } catch (e) {
      print("Error getAllKelas: $e");
      return [];
    }
  }

  // ===============================
  // READ KELAS BY ID
  // ===============================
  static Future<Kelas?> getKelasById(String id) async {
    try {
      final all = await FirebaseService.getAllKelas();
      return all.firstWhere((element) => element.id == id);
    } catch (e) {
      print("Error getKelasById: $e");
      return null;
    }
  }

  // ===============================
  // READ KELAS BY TUTOR
  // ===============================
  static Future<List<Kelas>> getKelasByTutor(String tutorId) async {
    try {
      final all = await FirebaseService.getAllKelas();
      return all.where((element) => element.idTutor == tutorId).toList();
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
      final all = await FirebaseService.getAllKelas();
      return all.where((element) => element.kategori == kategori).toList();
    } catch (e) {
      print("Error getKelasByKategori: $e");
      return [];
    }
  }

  // ===============================
  // SEARCH KELAS
  // ===============================
  static Future<List<Kelas>> searchKelas(String keyword) async {
    try {
      final all = await FirebaseService.getAllKelas();
      return all
          .where((e) =>
              e.namaKelas.toLowerCase().contains(keyword.toLowerCase()) ||
              (e.deskripsi?.toLowerCase().contains(keyword.toLowerCase()) ??
                  false))
          .toList();
    } catch (e) {
      print("Error searchKelas: $e");
      return [];
    }
  }

  // ===============================
  // UPDATE KELAS
  // ===============================
  static Future<void> updateKelas(Kelas kelas) async {
    try {
      await FirebaseService.updateKelas(kelas);
    } catch (e) {
      print("Error updateKelas: $e");
    }
  }

  // ===============================
  // DELETE KELAS
  // ===============================
  static Future<void> deleteKelas(String id) async {
    try {
      await FirebaseService.deleteKelas(id);
    } catch (e) {
      print("Error deleteKelas: $e");
    }
  }

  // ===============================
  // TOTAL SISWA DALAM KELAS
  // ===============================
  static Future<int> getTotalStudentsInClass(String kelasId) async {
    // This will be handled by listening to enrollments in Firebase
    return 0; 
  }

  // ===============================
  // TOP RATED CLASSES
  // ===============================
  static Future<List<Kelas>> getTopRatedKelas({int limit = 5}) async {
    final all = await FirebaseService.getAllKelas();
    all.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    return all.take(limit).toList();
  }

  // ===============================
  // POPULAR CLASSES
  // ===============================
  static Future<List<Kelas>> getPopularKelas({int limit = 5}) async {
    final all = await FirebaseService.getAllKelas();
    all.sort((a, b) => (b.jumlahSiswa ?? 0).compareTo(a.jumlahSiswa ?? 0));
    return all.take(limit).toList();
  }
}

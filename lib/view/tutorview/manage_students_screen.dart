import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/enrollment_controller.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/database/preference.dart';
import 'package:brillianteducationproject/widget/search_bar.dart'
    as custom_search;

class ManageStudentsScreen extends StatefulWidget {
  final int kelasId;
  final String namaKelas;

  const ManageStudentsScreen({
    Key? key,
    required this.kelasId,
    required this.namaKelas,
  }) : super(key: key);

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  late Future<List<dynamic>> studentsFuture;
  List<dynamic> allStudents = [];
  List<dynamic> filteredStudents = [];
  String searchQuery = '';
  String filterStatus = 'Semua';
  bool isAuthorized = true;

  final List<String> statusOptions = [
    'Semua',
    'aktif',
    'selesai',
    'dibatalkan',
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    try {
      final tutorId = await PreferenceHandler.getTutorId();
      final kelas = await KelasController.getKelasById(widget.kelasId);

      if (tutorId != null && kelas != null && kelas.idTutor == tutorId) {
        // ✅ Authorized
        setState(() {
          isAuthorized = true;
          studentsFuture = EnrollmentController.getEnrollmentsByClass(
            widget.kelasId,
          );
        });
      } else {
        // ❌ Tidak authorized
        setState(() {
          isAuthorized = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Anda tidak memiliki akses untuk mengelola kelas ini',
              ),
              backgroundColor: Colors.red,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      print('Error checking authorization: $e');
      setState(() {
        isAuthorized = false;
      });
    }
  }

  void _filterStudents() {
    setState(() {
      filteredStudents = allStudents.where((student) {
        final matchesSearch = student['nama_siswa']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        final matchesStatus =
            filterStatus == 'Semua' ||
            student['status'].toString().toLowerCase() ==
                filterStatus.toLowerCase();

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _updateStudentProgress(int enrollmentId, double newProgress) {
    if (!isAuthorized) return; // 🔒 Lindungi aksi
    EnrollmentController.updateStudentProgress(enrollmentId, newProgress).then((
      _,
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Progress siswa berhasil diperbarui"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        studentsFuture = EnrollmentController.getEnrollmentsByClass(
          widget.kelasId,
        );
      });
    });
  }

  void _removeStudent(int enrollmentId) {
    if (!isAuthorized) return; // 🔒 Lindungi aksi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Siswa"),
        content: const Text("Apakah Anda yakin ingin menghapus siswa ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              EnrollmentController.deleteEnrollment(enrollmentId).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Siswa berhasil dihapus"),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                  ),
                );
                setState(() {
                  studentsFuture = EnrollmentController.getEnrollmentsByClass(
                    widget.kelasId,
                  );
                });
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Kelola Siswa - ${widget.namaKelas}',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      body: !isAuthorized
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<dynamic>>(
              future: studentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C4FD8)),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Belum ada siswa di kelas ini",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                allStudents = snapshot.data!;
                if (filteredStudents.isEmpty &&
                    (searchQuery.isNotEmpty || filterStatus != 'Semua')) {
                  _filterStudents();
                } else if (filteredStudents.isEmpty) {
                  filteredStudents = allStudents;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: custom_search.SearchBar(
                          hintText: "Cari siswa...",
                          onChanged: (value) {
                            searchQuery = value;
                            _filterStudents();
                          },
                        ),
                      ),

                      // Status Filter
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: statusOptions.length,
                          itemBuilder: (context, index) {
                            final status = statusOptions[index];
                            final isSelected = filterStatus == status;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    filterStatus = status;
                                  });
                                  _filterStudents();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF6C4FD8)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Results Info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Menampilkan ${filteredStudents.length} siswa",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            if (searchQuery.isNotEmpty ||
                                filterStatus != 'Semua')
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchQuery = '';
                                    filterStatus = 'Semua';
                                    filteredStudents = allStudents;
                                  });
                                },
                                child: const Text(
                                  "Reset Filter",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6C4FD8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

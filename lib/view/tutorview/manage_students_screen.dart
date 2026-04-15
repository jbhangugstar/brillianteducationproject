import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/enrollment_controller.dart';
import 'package:brillianteducationproject/models/enrollment_model.dart';
import 'package:intl/intl.dart';

class ManageStudentsScreen extends StatefulWidget {
  final String kelasId;
  final String namaKelas;

  const ManageStudentsScreen({
    super.key,
    required this.kelasId,
    required this.namaKelas,
  });

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  late Future<List<EnrollmentModel>> studentsFuture;
  List<EnrollmentModel> allEnrollments = [];
  List<EnrollmentModel> filteredEnrollments = [];
  String searchQuery = '';
  String filterStatus = 'Semua';
  bool isAuthorized = true;

  final List<String> statusOptions = [
    'Semua',
    'Aktif',
    'Selesai',
    'Dibatalkan',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      studentsFuture = EnrollmentController.getEnrollmentsByClass(
        widget.kelasId,
      );
    });
  }

  void _filterEnrollments() {
    setState(() {
      filteredEnrollments = allEnrollments.where((enrollment) {
        final matchesSearch =
            enrollment.namaSiswa.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            enrollment.emailSiswa.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );

        final matchesStatus =
            filterStatus == 'Semua' ||
            enrollment.status.toLowerCase() == filterStatus.toLowerCase();

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _removeStudent(String enrollmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Siswa"),
        content: const Text(
          "Apakah Anda yakin ingin mengeluarkan siswa ini dari kelas?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await EnrollmentController.deleteEnrollment(enrollmentId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Siswa berhasil dihapus"),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadData();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gagal menghapus siswa: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C4FD8), Color(0xFF9966FF)],
            ),
          ),
        ),
        title: Text(
          widget.namaKelas,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<EnrollmentModel>>(
        future: studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
          }

          allEnrollments = snapshot.data ?? [];
          _filterEnrollments();

          if (allEnrollments.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _buildFilterSection(),
              Expanded(
                child: filteredEnrollments.isEmpty
                    ? const Center(child: Text("Siswa tidak ditemukan"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredEnrollments.length,
                        itemBuilder: (context, index) {
                          return _buildStudentCard(filteredEnrollments[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              searchQuery = value;
              _filterEnrollments();
            },
            decoration: InputDecoration(
              hintText: "Cari nama atau email...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statusOptions.map((status) {
                final isSelected = filterStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        filterStatus = status;
                      });
                      _filterEnrollments();
                    },
                    selectedColor: const Color(0xFF6C4FD8).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF6C4FD8),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF6C4FD8)
                          : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(EnrollmentModel enrollment) {
    String formattedDate = enrollment.tanggalDaftar;
    try {
      final dt = DateTime.parse(enrollment.tanggalDaftar);
      formattedDate = DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF6C4FD8),
          child: Text(
            enrollment.namaSiswa.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          enrollment.namaSiswa,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              enrollment.emailSiswa,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Mendaftar: $formattedDate",
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    enrollment.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.person_remove_outlined, color: Colors.red),
          onPressed: () => _removeStudent(enrollment.id!),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
            "Belum ada siswa terdaftar",
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
}

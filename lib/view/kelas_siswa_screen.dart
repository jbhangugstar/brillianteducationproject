import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/widget/class_card.dart';
import 'package:brillianteducationproject/widget/search_bar.dart'
    as custom_search;

class KelasSiswaScreen extends StatefulWidget {
  const KelasSiswaScreen({super.key});

  @override
  State<KelasSiswaScreen> createState() => _KelasSiswaScreenState();
}

class _KelasSiswaScreenState extends State<KelasSiswaScreen> {
  late Future<List<dynamic>> kelasFuture;
  List<dynamic> allKelas = [];
  List<dynamic> filteredKelas = [];
  String selectedCategory = 'Semua';
  String searchQuery = '';

  final List<String> categories = [
    'Semua',
    'Matematika',
    'Sains',
    'Bahasa',
    'IPS',
    'Seni',
  ];

  @override
  void initState() {
    super.initState();
    kelasFuture = KelasController.getAllKelas();
  }

  void _filterKelas() {
    setState(() {
      filteredKelas = allKelas.where((kelas) {
        final matchesSearch =
            kelas['nama_kelas'].toString().toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            kelas['deskripsi']?.toString().toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ==
                true;

        final matchesCategory =
            selectedCategory == 'Semua' ||
            kelas['kategori']?.toString() == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Katalog Kelas",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: kelasFuture,
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
                    Icons.school_outlined,
                    size: 80,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Belum ada kelas tersedia",
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

          allKelas = snapshot.data!;
          if (filteredKelas.isEmpty &&
              (searchQuery.isNotEmpty || selectedCategory != 'Semua')) {
            _filterKelas();
          } else if (filteredKelas.isEmpty) {
            filteredKelas = allKelas;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: custom_search.SearchBar(
                    hintText: "Cari nama kelas atau tutor...",
                    onChanged: (value) {
                      searchQuery = value;
                      _filterKelas();
                    },
                  ),
                ),

                // Category Filter
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                            _filterKelas();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
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
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
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
                  child: Text(
                    "Menampilkan ${filteredKelas.length} kelas",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 12),

                // Kelas List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredKelas.length,
                  itemBuilder: (context, index) {
                    final kelas = filteredKelas[index];

                    return ClassCard(
                      namaKelas: kelas['nama_kelas'] ?? 'Kelas Tanpa Nama',
                      namaTutor: kelas['tutor'] ?? 'Tutor Tidak Diketahui',
                      jadwal: kelas['jadwal'] ?? 'Jadwal Tidak Tersedia',
                      harga: kelas['harga'] ?? 0,
                      deskripsi: kelas['deskripsi'],
                      jumlahSiswa: kelas['jumlah_siswa'],
                      rating: kelas['rating'] != null
                          ? double.parse(kelas['rating'].toString())
                          : null,
                      kategori: kelas['kategori'],
                      onTap: () {
                        // Navigate to class detail
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${kelas['nama_kelas']} - Detail"),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      onBook: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Konfirmasi Pendaftaran"),
                            content: Text(
                              "Apakah Anda yakin ingin mendaftar ke kelas ${kelas['nama_kelas']}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        "Berhasil mendaftar ke ${kelas['nama_kelas']}!",
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C4FD8),
                                ),
                                child: const Text("Daftar"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

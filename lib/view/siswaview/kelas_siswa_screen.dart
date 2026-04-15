import 'package:brillianteducationproject/view/siswaview/class_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/widget/class_card.dart';
import 'package:brillianteducationproject/widget/search_bar.dart'
    as custom_search;

class KelasSiswaScreen extends StatefulWidget {
  const KelasSiswaScreen({super.key});

  @override
  State<KelasSiswaScreen> createState() => _KelasSiswaScreenState();
}

class _KelasSiswaScreenState extends State<KelasSiswaScreen> {
  List<Kelas> allKelas = [];
  List<Kelas> filteredKelas = [];

  bool isLoading = true;

  String selectedCategory = 'Semua';
  String searchQuery = '';

  final List<String> categories = [
    'Semua',
    'Matematika',
    'Bahasa',
    'Sains',
    'IPS',
    'Teknologi',
    'Seni',
  ];

  @override
  void initState() {
    super.initState();
    loadKelas();
  }

  // =============================
  // LOAD DATA DARI FIRESTORE
  // =============================
  Future<void> loadKelas() async {
    setState(() => isLoading = true);
    final data = await KelasController.getAllKelas();

    setState(() {
      allKelas = data;
      filteredKelas = data;
      isLoading = false;
    });
  }

  // =============================
  // FILTER SEARCH + CATEGORY
  // =============================
  void _filterKelas() {
    List<Kelas> result = allKelas;

    if (searchQuery.isNotEmpty) {
      result = result.where((kelas) {
        return kelas.namaKelas.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            (kelas.deskripsi ?? "").toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            kelas.tutor.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (selectedCategory != 'Semua') {
      result = result
          .where((kelas) => kelas.kategori == selectedCategory)
          .toList();
    }

    setState(() {
      filteredKelas = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB23AEE),
        elevation: 0,
        title: const Text(
          "Katalog Kelas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: loadKelas,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF6C4FD8)),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6C4FD8)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    if (!isSelected)
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                      ),
                                  ],
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (filteredKelas.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text("Tidak ada kelas yang ditemukan"),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredKelas.length,
                        itemBuilder: (context, index) {
                          final kelas = filteredKelas[index];

                          return ClassCard(
                            namaKelas: kelas.namaKelas,
                            namaTutor: kelas.tutor,
                            jadwal: kelas.jadwal,
                            harga: kelas.harga,
                            deskripsi: kelas.deskripsi,
                            jumlahSiswa: kelas.jumlahSiswa,
                            rating: kelas.rating,
                            kategori: kelas.kategori,
                            foto: kelas.foto,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassDetailScreen(
                                    kelasId: kelas.id!,
                                    namaKelas: kelas.namaKelas,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}

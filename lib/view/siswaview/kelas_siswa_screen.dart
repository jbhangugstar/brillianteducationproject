import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/widget/class_card.dart';
import 'package:brillianteducationproject/widget/search_bar.dart'
    as custom_search;
import 'package:brillianteducationproject/view/siswaview/pembayaran_screen.dart';

class KelasSiswaScreen extends StatefulWidget {
  const KelasSiswaScreen({super.key});

  @override
  State<KelasSiswaScreen> createState() => _KelasSiswaScreenState();
}

class _KelasSiswaScreenState extends State<KelasSiswaScreen> {
  List<Kelas> allKelas = [];
  List<Kelas> filteredKelas = [];

  bool isLoading = true;

  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> categories = [
    'All',
    'Science',
    'Literature',
    'Languages',
    'Programming & Technology',
    'Business & Economics',
    'Design & Creativity',
    'Test Preparation',
    'Music & Arts',
    'Personal Development',
    'Basic Computer Skills',
    'School Subjects',
  ];

  @override
  void initState() {
    super.initState();
    loadKelas();
  }

  // =============================
  // LOAD DATA DARI DATABASE
  // =============================
  Future<void> loadKelas() async {
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

    if (selectedCategory != 'All') {
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Katalog Kelas",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C4FD8)),
            )
          : SingleChildScrollView(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF6C4FD8)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
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

                        onBook: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PembayaranScreen(kelas: kelas),
                            ),
                          );

                          if (result == "jadwal") {
                            DefaultTabController.of(context).animateTo(2);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

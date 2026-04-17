import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/helper/image_helper.dart';
import 'package:brillianteducationproject/helper/currency_helper.dart';

import 'package:flutter/material.dart';

class HomeSiswaScreen extends StatefulWidget {
  const HomeSiswaScreen({super.key});

  @override
  State<HomeSiswaScreen> createState() => _HomeSiswaScreenState();
}

class _HomeSiswaScreenState extends State<HomeSiswaScreen> {
  late Future<List<Kelas>> _kelasFuture;
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
    _kelasFuture = KelasController.getAllKelas();
  }

  void _refreshData() {
    setState(() {
      if (_searchKeyword.isEmpty) {
        _kelasFuture = KelasController.getAllKelas();
      } else {
        _kelasFuture = KelasController.searchKelas(_searchKeyword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Brilliant Education",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB23AEE),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 199, 196, 201),
              Color.fromARGB(255, 197, 84, 235),
              Color.fromARGB(255, 214, 80, 210),
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _refreshData(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SEARCH
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        _searchKeyword = value;
                        _refreshData();
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Cari mata pelajaran",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BANNER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xffB23AEF), Color(0xff7B2FF7)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.videocam_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Belajar dengan Live Tutor",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Sesi 1-on-1 dengan tutor berpengalaman",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("Mulai Sekarang"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// KATEGORI
                  const Text(
                    "Kategori Pelajaran",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryItem(
                        icon: Icons.science,
                        label: "Science",
                        color: const Color(0xffEAD9FF),
                        onTap: () {
                          setState(() {
                            _kelasFuture =
                                KelasController.getKelasByKategori("Science");
                          });
                        },
                      ),
                      CategoryItem(
                        icon: Icons.language,
                        label: "Languages",
                        color: const Color(0xffD9E7FF),
                        onTap: () {
                          setState(() {
                            _kelasFuture =
                                KelasController.getKelasByKategori("Languages");
                          });
                        },
                      ),
                      CategoryItem(
                        icon: Icons.computer,
                        label: "Technology",
                        color: const Color(0xffD9FFE4),
                        onTap: () {
                          setState(() {
                            _kelasFuture =
                                KelasController.getKelasByKategori("Programming & Technology");
                          });
                        },
                      ),
                      CategoryItem(
                        icon: Icons.all_inclusive,
                        label: "All",
                        color: const Color(0xffFFE8CC),
                        onTap: () => _refreshData(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// DAFTAR KELAS
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kelas Tersedia",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  FutureBuilder<List<Kelas>>(
                    future: _kelasFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      final kelasList = snapshot.data ?? [];

                      if (kelasList.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Tidak ada kelas ditemukan"),
                          ),
                        );
                      }

                      return Column(
                        children: kelasList
                            .map((kelas) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: KelasCard(kelas: kelas),
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.purple),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class KelasCard extends StatelessWidget {
  final Kelas kelas;

  const KelasCard({
    super.key,
    required this.kelas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImageHelper.buildImage(
              kelas.foto,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: Container(
                height: 60,
                width: 60,
                color: Colors.purple.shade50,
                child: const Icon(Icons.book, color: Colors.purple, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kelas.namaKelas,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  CurrencyHelper.formatRupiah(kelas.harga),
                  style: const TextStyle(color: Colors.purple, fontSize: 13),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "${kelas.rating ?? 0} (${kelas.jumlahSiswa ?? 0} Siswa)",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB23AEE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              // Navigation to detail class logic
            },
            child: const Text(
              "Detail",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

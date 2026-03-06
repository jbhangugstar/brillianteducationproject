import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru.dart';
import 'package:flutter/material.dart';

class BuatKelasStep2Screen extends StatelessWidget {
  const BuatKelasStep2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.push(BuatKelasBaruScreen());
          },
        ),
        title: const Text(
          "Buat Kelas Baru",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// STEP INFO
            const Text(
              "Langkah 2 dari 2",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Hampir Selesai",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "100%",
                  style: TextStyle(
                    color: Color(0xff3D5AFE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: 1,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xff3D5AFE),
              minHeight: 6,
            ),

            const SizedBox(height: 25),

            /// MATERI KELAS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kurikulum / Materi Kelas",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8EDFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "3 Materi",
                    style: TextStyle(color: Color(0xff3D5AFE), fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            materiItem("Materi 1: Pengenalan Aljabar", "Durasi: 10 Menit"),

            materiItem("Materi 2: Latihan Dasar Logika", "Kuis: 10 Soal"),

            materiItem("Materi 3: Fungsi Kuadrat Dasar", "Video: 20 Menit"),

            const SizedBox(height: 10),

            /// TAMBAH MATERI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "+ Tambah Materi Baru",
                  style: TextStyle(
                    color: Color(0xff3D5AFE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// VISIBILITAS
            const Text(
              "Pengaturan Visibilitas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            visibilityCard(
              title: "Publik",
              subtitle: "Dapat ditemukan semua orang di pencarian",
              selected: true,
            ),

            const SizedBox(height: 10),

            visibilityCard(
              title: "Privat",
              subtitle: "Hanya siswa dengan link yang bisa masuk",
              selected: false,
            ),

            const SizedBox(height: 25),

            /// PERSYARATAN
            const Text(
              "Persyaratan Siswa (OPSIONAL)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Contoh: Memahami operasi hitung dasar matematika...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// BUTTON
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(BuatKelasBaruScreen());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Kembali"),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3D5AFE),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Terbitkan Kelas",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// WIDGET MATERI ITEM
  Widget materiItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Color(0xff3D5AFE)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.delete_outline, color: Colors.grey),
        ],
      ),
    );
  }

  /// WIDGET VISIBILITY
  Widget visibilityCard({
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffEEF1FF) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? const Color(0xff3D5AFE) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: const Color(0xff3D5AFE),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

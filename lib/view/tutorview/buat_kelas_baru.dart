import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru2.dart';
import 'package:brillianteducationproject/view/tutorview/tutor_main_screen.dart';
import 'package:flutter/material.dart';

class BuatKelasBaruScreen extends StatelessWidget {
  const BuatKelasBaruScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            /// TAB STEP
            Row(
              children: [
                const Text(
                  "Detail Kelas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3D5AFE),
                  ),
                ),
                const SizedBox(width: 100),
                Text(
                  "Langkah 1 dari 2",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Container(width: 110, height: 3, color: const Color(0xff3D5AFE)),

            const SizedBox(height: 25),

            /// NAMA KELAS
            const Text(
              "Nama Kelas",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                hintText: "misal: Kalkulus Tingkat Lanjut & Aljabar Linear",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// KATEGORI
            const Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: "math", child: Text("Matematika")),
                DropdownMenuItem(value: "science", child: Text("Science")),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Pilih kategori mata pelajaran",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// JADWAL
            const Text("Jadwal", style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.schedule),
                hintText: "Sen, Rab jam 16:00",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// HARGA
            const Text(
              "Harga per Sesi",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: "USD",
                hintText: "0.00",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DESKRIPSI
            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "Jelaskan apa yang akan dipelajari siswa di kelas ini...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Direkomendasikan: Minimal 50 karakter untuk deskripsi yang lebih baik",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            /// GAMBAR KELAS
            const Text(
              "Gambar Sampul Kelas",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade400,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt_outlined, size: 30, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    "Unggah gambar sampul",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON
            Row(
              children: [
                /// TOMBOL KEMBALI
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(TutorMainScreen());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Kembali"),
                  ),
                ),

                const SizedBox(width: 15),

                /// TOMBOL LANJUT
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(const BuatKelasStep2Screen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3D5AFE),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Lanjut ke Langkah 2",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
}

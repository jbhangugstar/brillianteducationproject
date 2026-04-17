import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru2.dart';
import 'package:brillianteducationproject/view/tutorview/tutor_main_screen.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/database/preference.dart';
import 'package:brillianteducationproject/service/firebase_service.dart';
import 'package:brillianteducationproject/helper/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String cleaned = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String result = '';
    int count = 0;
    for (int i = cleaned.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = '.' + result;
        count = 0;
      }
      result = cleaned[i] + result;
      count++;
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class JadwalKelas {
  String hari;
  String jam;
  JadwalKelas({required this.hari, required this.jam});
}

class BuatKelasBaruScreen extends StatefulWidget {
  final Kelas? kelas;
  final String? kelasId;
  const BuatKelasBaruScreen({super.key, this.kelas, this.kelasId});

  @override
  State<BuatKelasBaruScreen> createState() => _BuatKelasBaruState();
}
// ... (rest of the code similar but with String for IDs)

class _BuatKelasBaruState extends State<BuatKelasBaruScreen> {
  late TextEditingController namaKelasController;
  late TextEditingController hargaController;
  late TextEditingController tutorController;
  late TextEditingController deskripsiController;

  String? kategoriController;
  File? coverImage;
  final ImagePicker _picker = ImagePicker();
  List<JadwalKelas> jadwalList = [];

  // =====================
  // DAFTAR KATEGORI
  // =====================
  final List<String> categories = [
    "All",
    "Science",
    "Literature",
    "Languages",
    "Programming & Technology",
    "Business & Economics",
    "Design & Creativity",
    "Test Preparation",
    "Music & Arts",
    "Personal Development",
    "Basic Computer Skills",
    "School Subjects",
  ];

  // =====================
  // MAPPING KATEGORI LAMA
  // =====================
  String mapKategori(String? kategoriDb) {
    switch (kategoriDb) {
      case "Business":
        return "Business & Economics";
      case "Design":
        return "Design & Creativity";
      case "Music":
        return "Music & Arts";
      case "Computer Basics":
        return "Basic Computer Skills";
      case "Test Prep":
        return "Test Preparation";
      case "School":
        return "School Subjects";
      default:
        return kategoriDb != null && categories.contains(kategoriDb)
            ? kategoriDb
            : "Science"; // fallback
    }
  }

  // =====================
  // INIT STATE
  // =====================
  @override
  void initState() {
    super.initState();

    namaKelasController = TextEditingController();
    hargaController = TextEditingController();
    tutorController = TextEditingController();
    deskripsiController = TextEditingController();

    // Default kategori (aman untuk edit)
    kategoriController = mapKategori(widget.kelas?.kategori);

    if (widget.kelas != null) {
      namaKelasController.text = widget.kelas!.namaKelas;
      String hargaStr = widget.kelas!.harga.toString();
      String result = '';
      int count = 0;
      for (int i = hargaStr.length - 1; i >= 0; i--) {
        if (count == 3) {
          result = '.' + result;
          count = 0;
        }
        result = hargaStr[i] + result;
        count++;
      }
      hargaController.text = result;
      tutorController.text = widget.kelas!.tutor;
      deskripsiController.text = widget.kelas!.deskripsi ?? "";

      if (widget.kelas!.jadwal.isNotEmpty) {
        final jadwalSplit = widget.kelas!.jadwal.split(",");
        for (var j in jadwalSplit) {
          final parts = j.trim().split(" ");
          if (parts.length >= 2) {
            jadwalList.add(JadwalKelas(hari: parts[0], jam: parts[1]));
          }
        }
      }
    }
  }

  // =====================
  // PICK IMAGE
  // =====================
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        coverImage = File(image.path);
      });
    }
  }

  // =====================
  // TAMBAH JADWAL
  // =====================
  Future<void> tambahJadwal() async {
    String? hariDipilih;
    TimeOfDay? pickedTime;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Jadwal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              hint: const Text("Pilih Hari"),
              items: const [
                DropdownMenuItem(value: "Senin", child: Text("Senin")),
                DropdownMenuItem(value: "Selasa", child: Text("Selasa")),
                DropdownMenuItem(value: "Rabu", child: Text("Rabu")),
                DropdownMenuItem(value: "Kamis", child: Text("Kamis")),
                DropdownMenuItem(value: "Jumat", child: Text("Jumat")),
                DropdownMenuItem(value: "Sabtu", child: Text("Sabtu")),
                DropdownMenuItem(value: "Minggu", child: Text("Minggu")),
              ],
              onChanged: (value) => hariDipilih = value,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (hariDipilih != null && pickedTime != null) {
                  setState(() {
                    jadwalList.add(
                      JadwalKelas(
                        hari: hariDipilih!,
                        jam: pickedTime!.format(context),
                      ),
                    );
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text("Pilih Jam"),
            ),
          ],
        ),
      ),
    );
  }

  String getJadwalString() =>
      jadwalList.map((e) => "${e.hari} ${e.jam}").join(", ");

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  // =====================
  // BUILD
  // =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.push(const TutorMainScreen()),
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
            const Text(
              "Langkah 1 dari 2",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Kelas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "50%",
                  style: TextStyle(
                    color: Color(0xff3D5AFE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xff3D5AFE),
              minHeight: 6,
            ),
            const SizedBox(height: 25),
            const Text(
              "Nama Kelas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: namaKelasController,
              decoration: inputDecoration("Contoh: Calculus Advanced"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: kategoriController,
              decoration: inputDecoration("Select category"),
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  kategoriController = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Jadwal Kelas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ...jadwalList.map((jadwal) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule, color: Color(0xff3D5AFE)),
                        const SizedBox(width: 10),
                        Expanded(child: Text("${jadwal.hari} - ${jadwal.jam}")),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => setState(() {
                            jadwalList.remove(jadwal);
                          }),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: tambahJadwal,
                    child: const Center(
                      child: Text(
                        "+ Tambah Jadwal",
                        style: TextStyle(
                          color: Color(0xff3D5AFE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Harga", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyFormat()],
              decoration: inputDecoration("Contoh: 50.000"),
            ),
            const SizedBox(height: 20),
            const Text("Tutor", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: tutorController,
              decoration: inputDecoration("Nama tutor"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: deskripsiController,
              maxLines: 4,
              decoration: inputDecoration("Jelaskan isi kelas ini..."),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gambar Sampul",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    (coverImage == null &&
                        (widget.kelas?.foto == null ||
                            widget.kelas!.foto!.isEmpty))
                    ? const Center(
                        child: Text(
                          "Upload Gambar Sampul",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: coverImage != null
                            ? Image.file(coverImage!, fit: BoxFit.cover)
                            : ImageHelper.buildImage(
                                widget.kelas!.foto!,
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.push(const TutorMainScreen()),
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
                    onPressed: () async {
                      if (namaKelasController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nama kelas kosong")),
                        );
                        return;
                      }
                      if (jadwalList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Tambahkan jadwal")),
                        );
                        return;
                      }

                      final tutorId = await PreferenceHandler().getTutorId();

                      String base64Image = "";
                      if (coverImage != null) {
                        base64Image =
                            await FirebaseService.imageToBase64(coverImage!) ??
                            "";
                      } else if (widget.kelas?.foto != null) {
                        base64Image = widget.kelas!.foto!;
                      }

                      if (!context.mounted) return;
                      context.push(
                        BuatKelasStep2Screen(
                          namaKelas: namaKelasController.text,
                          kategori: kategoriController ?? "",
                          jadwal: getJadwalString(),
                          harga: hargaController.text.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          ),
                          tutor: tutorController.text,
                          deskripsi: deskripsiController.text,
                          gambar: base64Image,
                          kelasId: widget.kelas?.id,
                          tutorId: tutorId,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3D5AFE),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Lanjut ke Langkah 2",
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
}

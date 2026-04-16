import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/models/user_model.dart';
import 'package:brillianteducationproject/helper/image_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTutorScreen extends StatefulWidget {
  const HomeTutorScreen({super.key});

  @override
  State<HomeTutorScreen> createState() => _HomeTutorScreenState();
}

class _HomeTutorScreenState extends State<HomeTutorScreen> {
  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser == null) {
      return const Scaffold(body: Center(child: Text("Silakan login kembali")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userData = userSnapshot.hasData && userSnapshot.data!.exists
            ? UserModel.fromMap(
                userSnapshot.data!.data() as Map<String, dynamic>,
              )
            : null;

        return Scaffold(
          backgroundColor: const Color(0xFFF2F3F7),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 184, 193, 197),
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: ImageHelper.getImageProvider(userData?.photoUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Halo, ${userData?.nama?.split(' ').first ?? 'Tutor'}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userData?.school?.toUpperCase() ?? "PENDIDIK",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color.fromARGB(255, 48, 10, 185),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.notifications_none, color: Colors.black),
              ),
            ],
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
              child: FutureBuilder<List<Kelas>>(
                future: KelasController.getKelasByTutor(authUser.uid),
                builder: (context, kelasSnapshot) {
                  if (kelasSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final classes = kelasSnapshot.data ?? [];
                  int totalStudents = 0;
                  int totalIncome = 0;
                  for (var k in classes) {
                    totalStudents += k.jumlahSiswa ?? 0;
                    totalIncome += (k.jumlahSiswa ?? 0) * (k.harga);
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// STATISTICS
                        Row(
                          children: [
                            Expanded(
                              child: statCard(
                                title: "Kelas Aktif",
                                value: "${classes.length}",
                                icon: Icons.bar_chart,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: statCard(
                                title: "Total Siswa",
                                value: "$totalStudents",
                                icon: Icons.people,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// INCOME CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 216, 29, 223),
                                Color(0xFF3949AB),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "ESTIMASI PENGHASILAN",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Rp. $totalIncome",
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// HEADER JADWAL
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Kelas Saya",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        /// CLASS LIST
                        if (classes.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Belum ada kelas yang dibuat"),
                            ),
                          )
                        else
                          ...classes.map(
                            (kelas) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: scheduleCard(
                                day:
                                    (kelas.kategori != null &&
                                                kelas.kategori!.length >= 3
                                            ? kelas.kategori!.substring(0, 3)
                                            : kelas.kategori ?? "GEN")
                                        .toUpperCase(),
                                date: "${kelas.rating ?? 0}",
                                subject: kelas.namaKelas,
                                time: kelas.jadwal,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        /// NOTE CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tips Mengajar",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "- Pastikan materi siap sebelum kelas dimulai\n"
                                "- Interaksi aktif meningkatkan rating tutor\n"
                                "- Gunakan fitur live tutor untuk diskusi mendalam",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// STAT CARD
  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// SCHEDULE CARD
  Widget scheduleCard({
    required String day,
    required String date,
    required String subject,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// DATE BOX (Used for category/rating display)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(day, style: const TextStyle(fontSize: 10)),
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          /// CLASS INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeTutorScreen extends StatelessWidget {
  const HomeTutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 193, 197),
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/images/tutor.jpg"),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Halo, Sarah",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  "PENDIDIK SENIOR",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(255, 48, 10, 185),
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

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// STATISTICS
                    Row(
                      children: [
                        Expanded(
                          child: statCard(
                            title: "Kelas Aktif",
                            value: "12",
                            icon: Icons.bar_chart,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: statCard(
                            title: "Siswa Terdaftar",
                            value: "150",
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
                        children: const [
                          Text(
                            "PENGHASILAN",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Rp. 450.000",
                            style: TextStyle(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Jadwal Mendatang",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Lihat Semua",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// SCHEDULE LIST
                    scheduleCard(
                      day: "MON",
                      date: "14",
                      subject: "Biology Grade 10",
                      time: "14:00 - 15:30",
                    ),

                    const SizedBox(height: 10),

                    scheduleCard(
                      day: "TUE",
                      date: "15",
                      subject: "Mathematics Grade 12",
                      time: "10:00 - 11:30",
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
                            "Catatan Desain UX",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "- Metrik ard menggunakan kode warna\n"
                            "- Item navigasi penting dibuat lebih jelas\n"
                            "- Navigasi lengkap dan header jelas",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
          /// DATE BOX
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

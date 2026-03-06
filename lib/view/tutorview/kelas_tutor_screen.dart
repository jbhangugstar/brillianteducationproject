import 'package:flutter/material.dart';

class KelasTutorScreen extends StatelessWidget {
  const KelasTutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Kelas Saya", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.black),
            ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// BUTTON BUAT KELAS
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Buat Kelas Baru",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB23AEE),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Atur sesi baru dengan cepat dan undang siswa.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Kelas Berlangsung",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Lihat Semua >",
                          style: TextStyle(color: Color(0xFF4A5BD4)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// CARD 1
                    kelasCard(
                      image: "assets/images/biology.jpg",
                      title: "Biology Advanced",
                      price: "\$50/hr",
                      schedule: "Sen, Rab 15:00",
                      students: "12 Siswa terdaftar",
                    ),

                    const SizedBox(height: 16),

                    /// CARD 2
                    kelasCard(
                      image: "assets/images/science.jpg",
                      title: "Elementary Science",
                      price: "\$30/hr",
                      schedule: "Sel 16:00",
                      students: "8 Siswa terdaftar",
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

  Widget kelasCard({
    required String image,
    required String title,
    required String price,
    required String schedule,
    required String students,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(price),
                  ),
                ),
              ],
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.more_horiz),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text(schedule),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.group, size: 16),
                    const SizedBox(width: 6),
                    Text(students),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Kelola Kelas",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB23AEE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bar_chart),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

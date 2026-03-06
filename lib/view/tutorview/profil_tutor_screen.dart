import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:flutter/material.dart';

class ProfilTutorScreen extends StatefulWidget {
  const ProfilTutorScreen({super.key});

  @override
  State<ProfilTutorScreen> createState() => _ProfilTutorScreenState();
}

class _ProfilTutorScreenState extends State<ProfilTutorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profil", style: TextStyle(color: Colors.black)),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ),
        ],
      ),

      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(
                child: Column(
                  children: [
                    Icon(Icons.settings, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  context.pushAndRemoveAll(LoginScreen());
                  // LOGOUT
                },
              ),
            ],
          ),
        ),
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
                    /// HEADER IMAGE
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          "assets/images/library.jpg",
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        Positioned(
                          bottom: -40,
                          left: 20,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              "assets/images/tutor.jpg",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    /// PROFILE INFO
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dr. Sarah Johnson, PhD",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "Spesialis Biologi",
                            style: TextStyle(
                              color: Color.fromARGB(255, 8, 69, 119),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: const [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Color.fromARGB(255, 6, 109, 58),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "San Francisco, California",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 43, 28, 177),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// BUTTON
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit),
                                  label: const Text(
                                    "Edit Profil",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      166,
                                      87,
                                      206,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.share),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// TENTANG
                          const Text(
                            "Tentang",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Pendidik berdedikasi dengan pengalaman lebih dari 8 tahun dalam ilmu biologi. "
                            "Bersemangat dalam membuat konsep ilmiah yang kompleks dapat diakses oleh siswa "
                            "di semua tingkatan. Spesialisasi dalam Biologi Molekuler dan Genetika.",
                            style: TextStyle(color: Colors.black87),
                          ),

                          const SizedBox(height: 24),

                          /// PENGALAMAN
                          const Text(
                            "Pengalaman",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 14),

                          pengalamanItem(
                            icon: Icons.school,
                            title: "Tutor Senior",
                            company: "EduGlobal • Penuh waktu",
                            year: "2018 – 2023",
                          ),

                          const SizedBox(height: 12),

                          pengalamanItem(
                            icon: Icons.science,
                            title: "Asisten Peneliti",
                            company: "UNX Laboratory",
                            year: "2015 – 2018",
                          ),

                          const SizedBox(height: 24),

                          /// SERTIFIKASI
                          const Text(
                            "Sertifikasi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.workspace_premium,
                                  color: Color(0xFF4A5BD4),
                                ),

                                SizedBox(width: 10),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pendidik Tersertifikasi Google",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Diterbitkan 2022",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// PORTOFOLIO
                          const Text(
                            "Portofolio",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Row(
                                  children: [
                                    Icon(Icons.description),
                                    SizedBox(width: 10),
                                    Text("Tautan Karya Ilmiah"),
                                  ],
                                ),
                                Icon(Icons.open_in_new),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
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
}

Widget pengalamanItem({
  required IconData icon,
  required String title,
  required String company,
  required String year,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: const Color(0xFF4A5BD4)),

      const SizedBox(width: 12),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

          Text(company, style: const TextStyle(color: Colors.grey)),

          Text(year, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    ],
  );
}

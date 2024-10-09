import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/daftar_poliklinik.dart';

class EmptyStateWidget extends StatelessWidget {
  final String type;

  const EmptyStateWidget({
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pana3.png',
            height: 220,
          ), // Add your illustration
          const SizedBox(height: 24),
          const Text(
            "Belum Ada Riwayat Layanan untuk Anda",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C5F5C),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Silakan daftar poliklinik jika belum pernah melakukan pendaftaran dan jika sudah pernah silakan cek dengan menekan tombol Cek Riwayat",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (type == "poliklinik")
                ElevatedButton(
                  onPressed: () {
                    // Navigate to DaftarPoliklinik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DaftarPoliklinik(title: "Daftar Poliklinik"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF0C5F5C)),
                  ),
                  child: const Text(
                    "Daftar Poliklinik",
                    style: TextStyle(color: Color(0xFF0C5F5C)),
                  ),
                ),
              ElevatedButton(
                  onPressed: () {
                    // Navigate to DaftarPoliklinik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DaftarPoliklinik(title: "Daftar Poliklinik"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF0C5F5C)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Text(
                      "Cek Riwayat",
                      style: TextStyle(color: Color(0xFF0C5F5C)),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

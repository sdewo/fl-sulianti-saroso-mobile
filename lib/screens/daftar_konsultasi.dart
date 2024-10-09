import 'package:flutter/material.dart';

class DaftarKonsultasi extends StatefulWidget {
  final String title;

  DaftarKonsultasi({required this.title});

  @override
  _DaftarKonsultasiState createState() => _DaftarKonsultasiState();
}

class _DaftarKonsultasiState extends State<DaftarKonsultasi> {
  final TextEditingController _rekamMedisController = TextEditingController();
  DateTime? _selectedDate;

  // Function to submit form

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pana2.png',
            height: 130.03,
          ), // Add your illustration
          const SizedBox(height: 24),
          const Text(
            "Coming Soon!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C5F5C),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Fitur ini sedang dalam tahap pengembangan dan akan segera tersedia untuk Anda. ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         // Navigate to DaftarPoliklinik
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 DaftarPoliklinik(title: "Daftar Poliklinik"),
          //           ),
          //         );
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.white,
          //         side: const BorderSide(color: Color(0xFF0C5F5C)),
          //       ),
          //       child: const Text(
          //         "Daftar Poliklinik",
          //         style: TextStyle(color: Color(0xFF0C5F5C)),
          //       ),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/daftar_poliklinik_page1.dart';
import 'package:fl_rspi/screens/daftar_pasien_page1.dart';

class DaftarPoliklinik extends StatefulWidget {
  @override
  _DaftarPoliklinikState createState() => _DaftarPoliklinikState();
}

class _DaftarPoliklinikState extends State<DaftarPoliklinik> {
  final TextEditingController _rekamMedisController = TextEditingController();
  DateTime? _selectedDate;

  // Fungsi untuk memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Fungsi untuk memformat tanggal secara manual tanpa menggunakan intl
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Poliklinik',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                // Gambar ilustrasi
                Center(
                  child: Image.asset(
                    'assets/images/pana2.png',
                    height: 130.03,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
            const SizedBox(height: 40),
            // Input untuk Nomor Rekam Medis/NIK
            TextField(
              controller: _rekamMedisController,
              decoration: InputDecoration(
                labelText: 'Nomor Rekam Medis/NIK',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Input untuk Tanggal Lahir
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: _selectedDate == null
                        ? 'Pilih tanggal lahir'
                        : formatDate(
                            _selectedDate!), // Gunakan fungsi formatDate
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Link untuk pendaftaran pasien baru
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  // Aksi jika link "Daftar di sini" ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationFormPage1()),
                  );
                },
                child: const Text(
                  'Pasien baru? Daftar di sini',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Masuk
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PoliklinikPage1()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Registrasi Placeholder
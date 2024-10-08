import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/daftar_pasien_page1.dart';

class PatientLoginPage extends StatefulWidget {
  @override
  _PatientLoginPageState createState() => _PatientLoginPageState();
}

class _PatientLoginPageState extends State<PatientLoginPage> {
  final TextEditingController _rekamMedisController = TextEditingController();
  DateTime? _selectedDate;

  // Fungsi untuk memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.teal.shade900, // Body text color
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                iconColor: Colors.teal, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
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
                  'Masuk untuk Melanjutkan',
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
                  borderSide: const BorderSide(
                      color: Colors.grey, width: 2), // Focus color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                      borderSide: const BorderSide(
                          color: Colors.grey, width: 2), // Focus color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C5F5C),
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
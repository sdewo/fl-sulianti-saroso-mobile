import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/landing.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_rspi/screens/masuk.dart';

class DaftarPasienPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang!",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700]),
              ),
              SizedBox(height: 8),
              Text("Isi formulir berikut untuk mendaftar"),
              SizedBox(height: 16),
              // Illustration image can be added here with Image.asset or network image.
              Center(
                child: Image.asset(
                  'assets/images/pana.png',
                  height: 130.03,
                ),
              ),
              SizedBox(height: 16),
              buildDropdownField("Kewarganegaraan", ["Indonesia", "Lainnya"]),
              buildTextField("Alamat", "Alamat"),
              buildTextField("Provinsi", "Provinsi"),
              buildTextField("Nomor Telepon", "Nomor Telepon"),
              buildTextField("Nomor KTP/Identitas", "Nomor KTP/Identitas"),
              buildTextField("Nomor BPJS", "Nomor BPJS"),
              buildTextField("Pendidikan Terakhir", "Pendidikan Terakhir"),
              buildTextField("Pekerjaan", "Pekerjaan"),
              buildDropdownField(
                  "Status Pernikahan", ["Belum Menikah", "Menikah", "Cerai"]),
              buildTextField("Nama Penanggung Jawab", "Nama Penanggung Jawab"),
              buildDropdownField(
                  "Status Penanggung Jawab", ["Keluarga", "Teman", "Lainnya"]),
              SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Pasien lama? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Masuk akun di sini',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Aksi yang dilakukan saat teks diklik
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PatientLoginPage()), // Ganti dengan halaman yang dituju
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          titlePadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.zero,
                          content: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon dokter atau gambar ilustrasi
                                Image.asset(
                                  'assets/images/pana2.png',
                                  height: 130.03,
                                ),
                                SizedBox(height: 16),
                                const Text(
                                  'Pendaftaran Berhasil!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Harap sebutkan nama atau nomor rekam medis Anda di konter administrasi RSPI Sulianti Saroso untuk proses verifikasi data.',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                // Informasi nomor rekam medis dan nama
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Nomor Rekam Medis: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('123456789'),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Nama: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('Wati'),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Landing()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                  ),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text("Daftar", style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          // Handle change
        },
      ),
    );
  }
}

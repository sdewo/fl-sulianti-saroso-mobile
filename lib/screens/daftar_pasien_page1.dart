import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/daftar_pasien_page2.dart';
import 'package:fl_rspi/screens/masuk.dart';
import 'package:flutter/gestures.dart';

class RegistrationFormPage1 extends StatelessWidget {
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
              SizedBox(height: 24),
              // Illustration image can be added here with Image.asset or network image.
              Center(
                child: Image.asset(
                  'assets/images/pana.png',
                  height: 130.03,
                ),
              ),
              SizedBox(height: 24),
              buildTextField("Nama Pasien", "Nama pasien"),
              buildTextField("Alamat Email", "Alamat email"),
              buildTextField("Tempat Lahir", "Tempat lahir"),
              buildDateField(context, "Tanggal Lahir"),
              buildDropdownField("Jenis Kelamin", ["Laki-laki", "Perempuan"]),
              buildDropdownField(
                  "Agama", ["Islam", "Kristen", "Katolik", "Hindu", "Budha"]),
              buildDropdownField("Golongan Darah", ["A", "B", "AB", "O"]),
              buildDropdownField(
                  "Rhesus Golongan Darah", ["Positif", "Negatif"]),
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
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DaftarPasienPage2()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text("Selanjutnya", style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(
                height: 24,
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

  Widget buildDateField(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: "dd/mm/yyyy",
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          // Handle selected date
        },
      ),
    );
  }
}

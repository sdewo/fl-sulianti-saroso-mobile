import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding the data
import 'package:fl_rspi/screens/daftar_poliklinik_page1.dart';
import 'package:fl_rspi/screens/daftar_pasien_page1.dart';

class DaftarPoliklinik extends StatefulWidget {
  final String title;

  DaftarPoliklinik({required this.title});

  @override
  _DaftarPoliklinikState createState() => _DaftarPoliklinikState();
}

class _DaftarPoliklinikState extends State<DaftarPoliklinik> {
  final TextEditingController _rekamMedisController = TextEditingController();
  DateTime? _selectedDate;

  // Function to select a date of birth
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to format date manually without intl
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // Function to submit form
  Future<void> _submitForm() async {
    final String noMrNik = _rekamMedisController.text;
    final String? tglLahir = _selectedDate?.toIso8601String().split('T')[0];

    if (noMrNik.isEmpty || tglLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
      ));
      return;
    }

    // Prepare the URI
    final url = Uri.parse(
        'https://rspiss.com/rspi/simrs-ci/website/RspissWebsite/cekPasien');

    // Create the request
    final request = http.Request('GET', url);

    // Prepare headers
    request.headers.addAll({
      'x-token':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.D40InPMAGpdkU1rM9aA5JRQLAP8Jff462hso3w7d9qw',
      'x-username': 'rspiss22',
      'Content-Type': 'application/json',
    });

    // Add the body (though not typical in GET)
    request.body = jsonEncode({
      'no_mr_nik': noMrNik,
      'tgl_lahir': tglLahir,
    });

    // Send the request
    final streamedResponse = await request.send();

    // Convert the streamed response to a full response
    final response = await http.Response.fromStream(streamedResponse);

    // Parse the response body (assuming it's JSON)
    final responseData = jsonDecode(response.body);
    final metadata = responseData['metadata']['code'];

    print("Response body: $metadata ");

    if (metadata == 200) {
      final patientList = responseData['response']['list'];

      // Extract the first patient data as a map (JSON)
      final Map<String, dynamic> patientData = patientList[0];

      // Navigate to the next page and pass the patient data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PoliklinikPage1(
            pageTitle: "Daftar Poliklinik",
            patientData: patientData,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Patient not found'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Title and Step Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title, // Dynamic title
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C5F5C),
                  ),
                ),
                const Text(
                  '1/3', // Page indicator
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Label and Input for Nomor Rekam Medis/NIK
            const Text(
              'Nomor Rekam Medis/NIK',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _rekamMedisController,
              style: TextStyle(height: 0.2),
              decoration: InputDecoration(
                labelText: 'Nomor Rekam Medis/NIK',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Colors.grey, width: 2), // Focus color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 16),
            // Label and Input for Tanggal Lahir
            const Text(
              'Tanggal Lahir',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  style: const TextStyle(height: 0.2),
                  decoration: InputDecoration(
                    labelText: _selectedDate == null
                        ? 'Pilih tanggal lahir'
                        : formatDate(_selectedDate!), // Use formatDate function
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
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              const Text(
                'Pasien baru?',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    // Action for "Daftar di sini"
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationFormPage1()),
                    );
                  },
                  child: const Text(
                    ' Daftar di sini',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _submitForm, // Submit form on press
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C5F5C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: const Text(
                'Selanjutnya',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

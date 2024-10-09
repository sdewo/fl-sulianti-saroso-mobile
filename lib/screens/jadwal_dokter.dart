import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_rspi/widget/doctor_card.dart';
import 'package:fl_rspi/screens/daftar_pasien_page1.dart';
import 'package:dropdown_search/dropdown_search.dart';

class JadwalDokterPage extends StatefulWidget {
  const JadwalDokterPage({Key? key}) : super(key: key);

  @override
  _JadwalDokterPageState createState() => _JadwalDokterPageState();
}

class _JadwalDokterPageState extends State<JadwalDokterPage> {
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _filteredDoctors =
      []; // Daftar dokter yang terfilter
  bool _isLoading = true;
  String? _selectedDoctor;
  String? _selectedSpecialist;
  List<String> _doctorNames = [];
  List<String> _specialistNames = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final response = await http.get(Uri.parse(
        'https://rspiss.com/rspi/simrs-ci/website/RspissShow/jadwalDokter'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      setState(() {
        _doctors = data.map((doctor) {
          return {
            "nama": doctor["nama"],
            "spesialis": doctor["spesialis"],
            "foto": doctor["foto"],
            "jadwal": {
              "reguler": doctor["jadwal"]["reguler"],
              "eksekutif": doctor["jadwal"]["eksekutif"]
            }
          };
        }).toList();
        _doctorNames =
            _doctors.map((doctor) => doctor["nama"] as String).toList();
        _doctorNames.insert(0, "Semua Dokter"); // Tambahkan opsi "Semua Dokter"
        _specialistNames = _doctors
            .map((doctor) => doctor["spesialis"] as String)
            .toSet()
            .toList();
        _specialistNames.insert(
            0, "Semua Spesialis"); // Tambahkan opsi "Semua Spesialis"
        _filteredDoctors = _doctors; // Semua dokter awalnya ditampilkan
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  // Logika filter dokter berdasarkan salah satu dropdown
  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        // Jika "Semua Dokter" atau "Semua Spesialis" dipilih, tampilkan semua dokter
        if ((_selectedDoctor == "Semua Dokter" || _selectedDoctor == null) &&
            (_selectedSpecialist == "Semua Spesialis" ||
                _selectedSpecialist == null)) {
          return true;
        }

        if (_selectedDoctor != "Semua Dokter" &&
            _selectedSpecialist == "Semua Spesialis") {
          return doctor["nama"] == _selectedDoctor;
        }

        if (_selectedSpecialist != "Semua Spesialis" &&
            _selectedDoctor == "Semua Dokter") {
          return doctor["spesialis"] == _selectedSpecialist;
        }

        if (_selectedDoctor != "Semua Dokter" &&
            _selectedSpecialist != "Semua Spesialis") {
          return doctor["nama"] == _selectedDoctor &&
              doctor["spesialis"] == _selectedSpecialist;
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo_kemenkes_rspi.png',
              height: 28,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12, bottom: 12),
            child: TextButton(
              onPressed: () {
                // Navigate to DaftarPasienPage1
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationFormPage1()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF0C5F5C), // Green background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                minimumSize:
                    const Size(70, 12), // Mengatur ukuran minimal button
                padding: const EdgeInsets.symmetric(
                    horizontal: 10), // Horizontal padding
              ),
              child: const Text(
                'Daftar Pasien Baru',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 14, // Font size lebih kecil
                  fontWeight: FontWeight.bold, // Bold text style
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Jadwal Dokter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0C5F5C),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSearchableDropdown("Pilih Dokter", _doctorNames,
                            (String? value) {
                          setState(() {
                            _selectedDoctor = value;
                            _selectedSpecialist =
                                "Semua Spesialis"; // Reset spesialis
                            _filterDoctors(); // Filter setelah memilih dokter
                          });
                        }),
                        const SizedBox(
                          width: 10,
                        ),
                        _buildSearchableDropdown(
                            "Pilih Spesialis", _specialistNames,
                            (String? value) {
                          setState(() {
                            _selectedSpecialist = value;
                            _selectedDoctor = "Semua Dokter"; // Reset dokter
                            _filterDoctors(); // Filter setelah memilih spesialis
                          });
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = _filteredDoctors[index];
                        return DoctorCard(doctor: doctor);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchableDropdown(
      String label, List<String> options, void Function(String?) onChanged) {
    return Expanded(
      child: DropdownSearch<String>(
        items: options,
        popupProps: const PopupProps.menu(showSearchBox: true),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: label,
            labelStyle:
                const TextStyle(color: Colors.grey), // Warna label default
            floatingLabelBehavior:
                FloatingLabelBehavior.never, // Hilangkan floating label
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.grey, width: 2), // Focus color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Colors.grey, width: 2), // Warna outline ketika focus
            ),
          ),
        ),
        dropdownButtonProps: const DropdownButtonProps(
          icon: Icon(Icons.arrow_drop_down_outlined,
              color: Colors.grey), // Custom arrow icon
          iconSize: 30, // Change the size of the arrow icon
          padding: EdgeInsets.zero, // Adjust padding if necessary
        ),
        onChanged: onChanged,
        selectedItem: label == "Pilih Dokter"
            ? _selectedDoctor
            : _selectedSpecialist, // Menampilkan item terpilih
        dropdownBuilder: (context, selectedItem) {
          return Text(
            selectedItem ?? label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Untuk menghindari overflow teks
          );
        },
      ),
    );
  }
}

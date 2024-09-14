import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_rspi/widget/doctor_card_interactive.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DoctorListPage extends StatefulWidget {
  final String specialist;

  const DoctorListPage({Key? key, required this.specialist}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  bool _isLoading = true;
  String? _selectedDoctor;
  List<String> _doctorNames = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctorsBySpecialist(widget.specialist);
  }

  Future<void> _fetchDoctorsBySpecialist(String specialist) async {
    final response = await http.get(Uri.parse(
        'https://rspiss.com/rspi/simrs-ci/website/RspissShow/jadwalDokter'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      setState(() {
        _doctors = data
            .where((doctor) => doctor["spesialis"] == specialist)
            .map((doctor) {
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
        _filteredDoctors = _doctors; // Semua dokter awalnya ditampilkan
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        if (_selectedDoctor == "Semua Dokter" || _selectedDoctor == null) {
          return true;
        }
        return doctor["nama"] == _selectedDoctor;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Dokter - ${widget.specialist}"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Jadwal Dokter",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C5F5C),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _buildSearchableDropdown(
                        "Pilih Dokter", _doctorNames, (String? value) {
                      setState(() {
                        _selectedDoctor = value;
                        _filterDoctors();
                      });
                    }),
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
    return DropdownSearch<String>(
      items: options,
      popupProps: const PopupProps.menu(showSearchBox: true),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(color: Colors.grey), // Default label color
          floatingLabelBehavior:
              FloatingLabelBehavior.never, // No floating label
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Colors.grey, width: 2), // Focus color
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
      selectedItem: _selectedDoctor ?? "Pilih Dokter", // Display selected item
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem ?? label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Avoid overflow text
        );
      },
    );
  }
}

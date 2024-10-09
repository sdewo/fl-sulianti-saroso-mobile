import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_rspi/widget/doctor_card_interactive.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DoctorListPage extends StatefulWidget {
  final String specialist;
  final String pageTitle;
  final String poliId;
  final String poliNama;
  final Map<String, dynamic> patientData;

  const DoctorListPage(
      {Key? key,
      required this.specialist,
      required this.pageTitle,
      required this.poliId,
      required this.poliNama,
      required this.patientData})
      : super(key: key);

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
      print(data);
      setState(() {
        _doctors = data
            .where((doctor) => doctor["spesialis"] == specialist)
            .map((doctor) {
          return {
            "nama": doctor["nama"],
            "spesialis": doctor["spesialis"],
            "foto": doctor["foto"],
            "id_dokter": doctor["id_dokter"],
            "jadwal": {
              "reguler": doctor["jadwal"]["reguler"],
              "eksekutif": doctor["jadwal"]["eksekutif"]
            }
          };
        }).toList();

        _doctorNames =
            _doctors.map((doctor) => doctor["nama"] as String).toList();
        _doctorNames.insert(0, "Semua Dokter"); // Add "Semua Dokter" option
        _filteredDoctors = _doctors; // Show all doctors initially
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Navigate back on press
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black, // Icon color
                          size: 14,
                        ),
                        label: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontSize: 12, // Adjust font size
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove padding
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.pageTitle, // Use the dynamic title
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C5F5C),
                        ),
                      ),
                      const Text(
                        '3/3', // Page indicator
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      "Jadwal Dokter ${widget.specialist}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (_doctors.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Pusatkan secara vertikal
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch, // Peregangan horizontal
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/pana2.png',
                              height:
                                  130, // Atur tinggi gambar sesuai kebutuhan
                            ),
                          ), // Pusatkan gambar secara horizontal
                          const SizedBox(height: 24),
                          const Text(
                            "Belum ada dokter tersedia pada poli ini.",
                            textAlign: TextAlign.center, // Pusatkan teks
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    )
                  else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: _buildSearchableDropdown(
                        "Pilih Dokter",
                        _doctorNames,
                        (String? value) {
                          setState(() {
                            _selectedDoctor = value;
                            _filterDoctors();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: _filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = _filteredDoctors[index];
                          return DoctorCardInteractive(
                            doctor: doctor,
                            poliId: widget.poliId,
                            poliNama: widget.specialist,
                            patientData: widget.patientData,
                          );
                        },
                      ),
                    ),
                  ],
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
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
        ),
      ),
      dropdownButtonProps: const DropdownButtonProps(
        icon: Icon(Icons.arrow_drop_down_outlined, color: Colors.grey),
        iconSize: 30,
        padding: EdgeInsets.zero,
      ),
      onChanged: onChanged,
      selectedItem: _selectedDoctor ?? "Pilih Dokter",
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem ?? label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}

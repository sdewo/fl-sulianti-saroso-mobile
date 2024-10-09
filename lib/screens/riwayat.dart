import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_rspi/widget/show_input_popup.dart';
import 'package:fl_rspi/widget/history_card.dart';
import 'package:fl_rspi/screens/daftar_poliklinik.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> historyData = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadHistoryData(); // Load history data when the page is initialized
    _autoFetchHistory();
  }

  Future<void> _autoFetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? noMrNik = prefs.getString('noMrNik');
    String? tglLahirString = prefs.getString('tglLahir');

    if (noMrNik != null && tglLahirString != null) {
      DateTime tglLahir = DateTime.parse(tglLahirString);
      _submitForm(noMrNik, tglLahir); // Auto-fetch the data
    }
  }

  // Load history data from Shared Preferences
  Future<void> _loadHistoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyDataString = prefs.getString('historyData');

    if (historyDataString != null) {
      List<dynamic> historyDataList = jsonDecode(historyDataString);
      setState(() {
        historyData = historyDataList;
      });
    }
  }

  // Method to submit the form and fetch history data from the API
  Future<void> _submitForm(String noMrNik, DateTime tglLahir) async {
    // Format the DateTime to a String
    final String formattedDate = DateFormat('yyyy-MM-dd').format(tglLahir);

    if (noMrNik.isEmpty || formattedDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Save no_mr and tgl_lahir to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('noMrNik', noMrNik);
    await prefs.setString('tglLahir', formattedDate);

    // Continue with fetching data from API as before...
    final Uri url = Uri.parse(
        'https://rspiss.com/rspi/simrs-ci/website/RspissWebsite/historyPoliKlinik');

    // Create the request
    final request = http.Request('GET', url);

    // Prepare headers
    request.headers.addAll({
      'x-token':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.D40InPMAGpdkU1rM9aA5JRQLAP8Jff462hso3w7d9qw',
      'x-username': 'rspiss22',
      'Content-Type': 'application/json',
    });

    request.body = jsonEncode({
      'no_mr_nik': noMrNik,
      'tgl_lahir': formattedDate,
    });

    try {
      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['response']['list'] is List) {
          setState(() {
            historyData = responseData['response']['list'];
          });

          // Save fetched history data (optional)
          await prefs.setString('historyData', jsonEncode(historyData));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unexpected data format received.')),
          );
        }
      } else {
        print("Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching data.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server.')),
      );
      print("Error occurred: $e");
    }
  }

  // Function to show the input popup for NIK and Tanggal Lahir
  void showInputPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InputPopup(
          onSubmit: (String noMrNik, DateTime tglLahir) {
            _submitForm(noMrNik, tglLahir); // Call _submitForm to fetch data
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Poliklinik',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0C5F5C),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: historyData.isEmpty
                  ? Padding(
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
                            "Silakan daftar poliklinik jika belum pernah melakukan pendaftaran, jika sudah pernah mendaftar silakan cek riwayat dengan menekan tombol Cek Riwayat",
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
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to DaftarPoliklinik
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DaftarPoliklinik(
                                          title: "Daftar Poliklinik"),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xFF0C5F5C)),
                                ),
                                child: const Text(
                                  "Daftar Poliklinik",
                                  style: TextStyle(color: Color(0xFF0C5F5C)),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed:
                                      showInputPopup, // Trigger the input popup
                                  //   child: const Text('Cek Riwayat'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Color(0xFF0C5F5C)),
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 13),
                                    child: Text(
                                      "Cek Riwayat",
                                      style:
                                          TextStyle(color: Color(0xFF0C5F5C)),
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: historyData.length,
                      itemBuilder: (context, index) {
                        final history = historyData[index];
                        return HistoryCard(
                          date: history['tanggal_kunjungan'] ?? '',
                          poliklinik: history['poli'] ?? '',
                          doctor: history['dokter'] ?? '',
                          price: history['price'] ?? '',
                          status: history['status'] ?? '',
                          statusColor: Colors.green,
                          // history['status'] == 'Selesai'
                          //     ? Colors.green
                          //     : Colors.red,
                          icon: Icons.check_circle,
                          // history['status'] == 'Selesai'
                          //     ? Icons.check_circle
                          //     : Icons.cancel,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BarcodePopup(
                                  medicalRecordNumber:
                                      history['kode_booking'] ?? '',
                                  department: history['poli'] ?? '',
                                  doctorName: history['dokter'] ?? '',
                                  qrcode: history['qr_code'] ?? '',
                                  schedule: history['tanggal_kunjungan'] ??
                                      '', // Include any other relevant field
                                  close: false,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Popup for displaying detailed visit information
class BarcodePopup extends StatelessWidget {
  final String? medicalRecordNumber;
  final String department;
  final String doctorName;
  final String schedule;
  final String qrcode;
  final bool close;

  const BarcodePopup({
    Key? key,
    required this.medicalRecordNumber,
    required this.department,
    required this.doctorName,
    required this.schedule,
    required this.qrcode,
    required this.close,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titlePadding: const EdgeInsets.only(
          top: 10, left: 16, right: 16), // Adjust padding for title
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Konfirmasi Pendaftaran Poliklinik',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (close) {
                Navigator.pop(context);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Pendaftaran Berhasil!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF0C5F5C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tunjukkan kode QR ini kepada petugas poliklinik untuk verifikasi antrean Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 16),
          Image.network(
            qrcode, // Replace with the actual URL
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Kode Booking', medicalRecordNumber ?? "kosong"),
          const SizedBox(height: 8),
          _buildInfoRow('Poliklinik', department),
          const SizedBox(height: 8),
          _buildInfoRow('Dokter', doctorName),
          const SizedBox(height: 8),
          _buildInfoRow('Jadwal', schedule),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Aligns both label and value to the left
      children: [
        Text(
          title, // The label part
          style: const TextStyle(
            fontWeight: FontWeight.w400, // Semi-bold for label
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4), // Space between label and value
        Text(
          value, // The value part
          style: const TextStyle(
            fontWeight: FontWeight.w600, // Bold for value
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

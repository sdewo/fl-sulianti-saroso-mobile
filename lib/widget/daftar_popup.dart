import 'package:flutter/material.dart';
import 'package:fl_rspi/widget/barcode_popup.dart';
import 'dart:convert'; // For jsonEncode
import 'package:http/http.dart' as http;

class ConfirmationPopup extends StatefulWidget {
  final String? selectedDay;
  final String? selectedTime;
  final String? selectedDateTime;
  final String? poliId;
  final String? poliNama;
  final Map<String, dynamic>? doctor;
  final Map<String, dynamic>? patientData;

  const ConfirmationPopup({
    Key? key,
    this.selectedDay,
    this.selectedTime,
    this.selectedDateTime,
    this.doctor,
    this.patientData,
    this.poliId,
    this.poliNama,
  }) : super(key: key);

  @override
  _ConfirmationPopupState createState() => _ConfirmationPopupState();
}

class _ConfirmationPopupState extends State<ConfirmationPopup> {
  bool isUsingBpjs = false; // State for BPJS toggle
  final TextEditingController _rujukanController = TextEditingController();

  @override
  void dispose() {
    _rujukanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure patientData is not null
    final Map<String, dynamic> patient = widget.patientData ?? {};

    // Retrieve no_mr from patientData
    final String noMr = patient['no_mr'] ?? 'Tidak ada data';

    // Retrieve other data if necessary
    final String namaPasien = patient['nama_pasien'] ?? 'Tidak ada data';
    final String spesialisasi = widget.doctor?['spesialis'] ?? 'Tidak ada data';
    final String namaDokter = widget.doctor?['nama'] ?? 'Tidak ada data';

    final String formattedStartTime =
        widget.selectedTime?.split(' - ')[0] ?? '12:00:00'; // Default if null

    final String selectedStartTime = '$formattedStartTime'; // Add :00
    final String jadwal =
        widget.selectedDay != null ? '${widget.selectedDay}' : 'Tidak ada data';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'Rincian Pendaftaran Konsultasi Online',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const Text(
              'Periksa kembali rincian pendaftaran sebelum melanjutkan.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            // Display dynamic data
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Nomor Rekam Medis\n',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                    text: '$noMr\n\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(
                    text: 'Spesialisasi\n',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                    text: '$spesialisasi\n\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(
                    text: 'Dokter\n',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                    text: '$namaDokter\n\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(
                    text: 'Jadwal\n',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                    text: '$jadwal',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  const Text('Wajib isi jika menggunakan BPJS'),
                  Switch(
                    value: isUsingBpjs,
                    activeTrackColor: Color(0xFF0C5F5C),
                    inactiveTrackColor: Color.fromARGB(255, 225, 246, 246),
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() {
                        isUsingBpjs = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            // If BPJS is selected, show the referral number TextField
            if (isUsingBpjs)
              TextField(
                controller: _rujukanController,
                decoration: InputDecoration(
                  hintText: "Nomor Rujukan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.red, width: 2), // Focus color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF0C5F5C)),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                        color: Color(0xFF0C5F5C),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Register Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C5F5C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Daftar'),
                    onPressed: () async {
                      final parentContext = Navigator.of(context).context;

                      // Extract patient details
                      final noMr = widget.patientData?['no_mr'] ?? '';
                      final namaPasien =
                          widget.patientData?['nama_pasien'] ?? '';
                      final tanggalLahir =
                          widget.patientData?['tanggal_lahir'] ?? '';
                      final noBpjs = widget.patientData?['no_bpjs'] ?? '';
                      final noRujukan = isUsingBpjs
                          ? _rujukanController.text
                          : '12345678909871';

                      final url = Uri.parse(
                          'https://rspiss.com/rspi/simrs-ci/website/RspissWebsite/daftarKonsultasi_online');

                      final request = http.Request('GET', url);

                      request.headers.addAll({
                        'x-token':
                            'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.D40InPMAGpdkU1rM9aA5JRQLAP8Jff462hso3w7d9qw', // Replace with the actual token
                        'x-username':
                            'rspiss22', // Replace with the actual username
                        'Content-Type': 'application/json',
                      });

                      // print("kunjungan ${widget.selectedDateTime}");
                      // print("waktu ${selectedStartTime}");
                      // print("poliid ${widget.poliId}");
                      // print("isbojs ${isUsingBpjs}");
                      // print("dokter id ${widget.doctor?['id_dokter']}");
                      // print("mr ${noMr}");
                      // print("nama ${namaPasien}");
                      // print("tgl lahir ${tanggalLahir}");
                      // print("nobpjs ${noBpjs}");
                      // print("no rujuk ${noRujukan}");

                      request.body = jsonEncode({
                        "reg_buffer_tanggal_kunjungan": widget.selectedDateTime,
                        "reg_buffer_waktu": selectedStartTime,
                        "id_poli": widget.poliId,
                        "reg_buffer_jenis_pasien": isUsingBpjs ? 5 : 2,
                        "id_cust_usr": "489cbbf4aa5b0d5b6510f0e939a069b6",
                        "id_dokter": widget.doctor?['id_dokter'],
                        "cust_usr_kode": noMr,
                        "cust_usr_nama": namaPasien,
                        "cust_usr_tanggal_lahir": tanggalLahir,
                        "reg_buffer_no_rujukan": isUsingBpjs
                            ? noRujukan
                            : "", // Include referral number
                        "cust_usr_no_jaminan": noBpjs
                      });

                      final streamedResponse = await request.send();

                      final response =
                          await http.Response.fromStream(streamedResponse);

                      if (response.statusCode == 200) {
                        final responseData = jsonDecode(response.body);

                        print(responseData);
                        showDialog(
                          context: parentContext,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            // Check if 'responseData' and 'responseData['data']' are not null
                            final String qrCode = responseData != null &&
                                    responseData['data'] != null
                                ? responseData['data']['qr_code'] ?? ""
                                : ""; // Default placeholder

                            return BarcodePopup(
                              qrcode: qrCode,
                              medicalRecordNumber: '',
                              department: widget.poliNama ?? 'kosong',
                              doctorName: widget.doctor?['nama'] ?? "",
                              schedule: jadwal ?? "",
                              close: true,
                            );
                          },
                        );
                      } else {
                        final responseData = jsonDecode(response.body);
                        print(responseData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Pendaftaran gagal: ${response.statusCode}'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

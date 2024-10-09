import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/landing.dart';

class ConfirmationPage extends StatelessWidget {
  final List<String?> formData;

  ConfirmationPage({required this.formData});

  @override
  Widget build(BuildContext context) {
    // For demonstration, display the combined data
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pendaftaran'),
        backgroundColor: const Color(0xFF0C5F5C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Data Pendaftaran:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            buildDataRow('Nama', formData[0]),
            buildDataRow('Email', formData[1]),
            buildDataRow('Tempat Lahir', formData[2]),
            buildDataRow('Tanggal Lahir', formData[3]),
            buildDataRow('Jenis Kelamin', formData[4]),
            buildDataRow('Agama', formData[5]),
            buildDataRow('Golongan Darah', formData[6]),
            buildDataRow('Rhesus', formData[7]),
            buildDataRow('Kewarganegaraan', formData[8]),
            buildDataRow('Alamat', formData[9]),
            buildDataRow('Provinsi', formData[10]),
            buildDataRow('Nomor Telepon', formData[11]),
            buildDataRow('Nomor KTP/Identitas', formData[12]),
            buildDataRow('Nomor BPJS', formData[13]),
            buildDataRow('Pendidikan Terakhir', formData[14]),
            buildDataRow('Pekerjaan', formData[15]),
            buildDataRow('Status Pernikahan', formData[16]),
            buildDataRow('Nama Penanggung Jawab', formData[17]),
            buildDataRow('Status Penanggung Jawab', formData[18]),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle final submission or further processing
                // For example, send data to an API or show a success dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pendaftaran Berhasil!'),
                      content: Text('Data Anda telah berhasil disimpan.'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate back to the landing page or reset the form
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Landing()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('OK'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C5F5C),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C5F5C),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Konfirmasi', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(width: 8),
          Expanded(
              child: Text(value ?? '-',
                  style: TextStyle(fontWeight: FontWeight.w400))),
        ],
      ),
    );
  }
}

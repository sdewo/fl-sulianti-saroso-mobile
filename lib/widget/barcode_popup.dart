import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/landing.dart';

class BarcodePopup extends StatelessWidget {
  final String? medicalRecordNumber;
  final String department;
  final String qrcode;
  final String doctorName;
  final String schedule;
  final bool close;

  const BarcodePopup({
    Key? key,
    required this.medicalRecordNumber,
    required this.department,
    required this.qrcode,
    required this.doctorName,
    required this.schedule,
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Landing()),
                  (Route<dynamic> route) => false,
                );
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
          qrcode.isNotEmpty
              ? Image.network(
                  qrcode,
                  height: 200,
                  width: 200,
                )
              : const Icon(
                  Icons.image_not_supported_outlined, // Icon when no image
                  size: 100,
                  color: Colors.grey,
                ),
          const SizedBox(height: 16),
          // _buildInfoRow('Nomor Rekam Medis', medicalRecordNumber ?? "kosong"),
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

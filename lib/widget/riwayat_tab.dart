import 'package:flutter/material.dart';
import 'package:fl_rspi/widget/history_card.dart';
import 'package:fl_rspi/widget/barcode_popup.dart';

class RiwayatTab extends StatefulWidget {
  final String type;
  const RiwayatTab({required this.type, super.key});

  @override
  _RiwayatTabState createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  List<Map<String, String>> historyData = [];

  @override
  Widget build(BuildContext context) {
    return historyData.isEmpty
        ? const Center(child: Text('Tidak ada riwayat yang ditemukan'))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              final history = historyData[index];
              return HistoryCard(
                date: history['date'] ?? '',
                poliklinik: history['poliklinik'] ?? '',
                doctor: history['doctor'] ?? '',
                price: history['price'] ?? '',
                status: history['status'] ?? '',
                statusColor:
                    history['status'] == 'Selesai' ? Colors.green : Colors.red,
                icon: history['status'] == 'Selesai'
                    ? Icons.check_circle
                    : Icons.cancel,
                onTap: () {
                  // Show QR or any action
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return const BarcodePopup(
                  //       medicalRecordNumber: '123456789',
                  //       department: 'Anak',
                  //       doctorName: 'dr. Desrinawati Muhammad Amin, Sp.A',
                  //       schedule: 'Senin, 2 September 2024 (09:00 - 12.00 WIB)',
                  //       close: false,
                  //     );
                  //   },
                  // );
                },
              );
            },
          );
  }

  void updateHistory(List<Map<String, String>> newData) {
    setState(() {
      historyData = newData;
    });
  }
}

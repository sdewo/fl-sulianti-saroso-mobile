import 'package:flutter/material.dart';

class CekRiwayatPopup extends StatefulWidget {
  final Function(String, String) onSubmit;

  const CekRiwayatPopup({required this.onSubmit, super.key});

  @override
  _CekRiwayatPopupState createState() => _CekRiwayatPopupState();
}

class _CekRiwayatPopupState extends State<CekRiwayatPopup> {
  final TextEditingController _noMrNikController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cek Riwayat'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _noMrNikController,
            decoration: const InputDecoration(
              labelText: 'No MR/NIK',
            ),
          ),
          TextField(
            controller: _tglLahirController,
            decoration: const InputDecoration(
              labelText: 'Tanggal Lahir (YYYY-MM-DD)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(
              _noMrNikController.text,
              _tglLahirController.text,
            );
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

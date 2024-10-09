import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class InputPopup extends StatefulWidget {
  final Function(String, DateTime) onSubmit;

  const InputPopup({
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  _InputPopupState createState() => _InputPopupState();
}

class _InputPopupState extends State<InputPopup> {
  final TextEditingController _rekamMedisController = TextEditingController();
  DateTime? _selectedDate;

  // Method to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
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
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to format the selected date
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Cek Riwayat ",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0C5F5C),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Masukan No Rekam Medis/NIK',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _rekamMedisController,
            style: const TextStyle(height: 1), // Adjusted height
            decoration: InputDecoration(
              labelText: 'Nomor Rekam Medis/NIK',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tanggal Lahir',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _selectDate(context), // Trigger date picker
            child: AbsorbPointer(
              child: TextField(
                style: const TextStyle(height: 1), // Adjusted height
                decoration: InputDecoration(
                  labelText: _selectedDate == null
                      ? 'Pilih tanggal lahir'
                      : formatDate(_selectedDate!), // Use formatDate function
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelStyle:
                      const TextStyle(color: Colors.grey, fontSize: 16),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8),
          child: TextButton(
            onPressed: () {
              if (_rekamMedisController.text.isNotEmpty &&
                  _selectedDate != null) {
                widget.onSubmit(
                  _rekamMedisController.text,
                  _selectedDate!,
                );
                Navigator.of(context).pop(); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF0C5F5C), // Green background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              minimumSize: const Size(70, 12), // Mengatur ukuran minimal button
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10), // Horizontal padding
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 14, // Font size lebih kecil
                fontWeight: FontWeight.bold, // Bold text style
              ),
            ),
          ),
        )
      ],
    );
  }
}

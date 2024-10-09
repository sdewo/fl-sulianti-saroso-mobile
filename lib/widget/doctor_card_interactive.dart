import 'package:flutter/material.dart';
import 'package:fl_rspi/widget/daftar_popup.dart';
import 'package:intl/date_symbol_data_local.dart'; // Untuk inisialisasi locale data
import 'package:intl/intl.dart';

class DoctorCardInteractive extends StatefulWidget {
  final String poliId;
  final String poliNama;
  final Map<String, dynamic> doctor;
  final Map<String, dynamic> patientData;

  const DoctorCardInteractive(
      {Key? key,
      required this.doctor,
      required this.poliId,
      required this.poliNama,
      required this.patientData})
      : super(key: key);

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCardInteractive>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedDay;
  String? selectedTime;
  final ScrollController _scrollController = ScrollController();
  DateTime currentDate = DateTime.now(); // Tanggal saat aplikasi diakses
  late String formattedDate; // Buat variabel instance untuk formattedDate
  late String selectedDates; // Buat variabel instance untuk formattedDate
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Inisialisasi formattedDate saat initState
    formattedDate =
        "${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";

    selectedDates =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.doctor);

    final Map<String, dynamic> jadwal = widget.doctor["jadwal"] ?? {};

    final String imageUrl =
        widget.doctor["foto"] ?? "https://via.placeholder.com/150";
    final String doctorName = widget.doctor["nama"] ?? "Unknown Doctor";
    final String specialist =
        widget.doctor["spesialis"] ?? "Unknown Specialist";

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.75),
                    border: Border.all(
                      color: const Color(0xFF0C5F5C),
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.75),
                    child: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: 35,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1E1F1F),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        "Spesialis $specialist",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Pilih Jadwal yang Sesuai',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  style: const TextStyle(height: 0.2),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_month),
                    labelText: _selectedDate == null
                        ? 'Pilih tanggal'
                        : formatDate(_selectedDate!), // Use formatDate function
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Colors.grey, width: 2), // Focus color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Display selected schedule
            if (_selectedDate != null)
              Center(
                child: SizedBox(
                  width: double.infinity, // Set width to full available width
                  child: ElevatedButton(
                    onPressed: () {
                      // Show popup dialog
                      _showDaftarPopup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C5F5C),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Daftar"),
                  ),
                ),
              ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  // String formatDate(DateTime date) {
  //   return "${date.day}"
  //       "${date.month}"
  //       "${date.year}";
  // }

  String formatDate(DateTime date) {
    // Define the format you want: d MMMM y (7 Oktober 2024)
    return DateFormat("d MMMM y").format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showDaftarPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Gunakan formatter untuk mengubah _selectedDate menjadi String
        String? formattedDate = _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null;
        print(formattedDate);
        return ConfirmationPopup(
          selectedDay: formatDate(_selectedDate!),
          selectedDateTime: formattedDate, // Format _selectedDate ke String
          poliId: widget.poliId,
          poliNama: widget.poliNama,
          patientData: widget.patientData,
          doctor: widget.doctor,
        );
      },
    );
  }
}

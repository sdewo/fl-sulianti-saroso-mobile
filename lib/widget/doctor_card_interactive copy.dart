import 'package:flutter/material.dart';
import 'package:fl_rspi/widget/daftar_popup.dart';

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
    String waktuKunjungan =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}  ";

    print(widget.doctor);

    final Map<String, dynamic> jadwal = widget.doctor["jadwal"] ?? {};
    final Map<String, String> regulerSchedule =
        Map<String, String>.from(jadwal["reguler"] ?? {});
    final Map<String, String> eksekutifSchedule =
        Map<String, String>.from(jadwal["ekseutif"] ?? {});
    // final List eksekutifSchedule = jadwal["eksekutif"] ?? [];

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
        padding: const EdgeInsets.all(15.0),
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
            const SizedBox(height: 16),
            Container(
              height: kToolbarHeight - 6,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Color(0xFF0C5F5C),
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: "Reguler"),
                  Tab(text: "Eksekutif"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScheduleList(regulerSchedule, formattedDate),
                  _buildScheduleList(eksekutifSchedule, formattedDate),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display selected schedule
            if (selectedDay != null && selectedTime != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      "Jadwal Terpilih: $selectedDay ($formattedDate), $selectedTime",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    // Full-width "Daftar" button
                    SizedBox(
                      width:
                          double.infinity, // Set width to full available width
                      child: ElevatedButton(
                        onPressed: () {
                          // Show popup dialog
                          _showDaftarPopup();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C5F5C),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Daftar"),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showDaftarPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print(selectedTime);
        return ConfirmationPopup(
          selectedDay: selectedDay,
          selectedTime: selectedTime,
          selectedDateTime: selectedDates, // Menggunakan formattedDate
          poliId: widget.poliId,
          poliNama: widget.poliNama,
          patientData: widget.patientData,
          doctor: widget.doctor,
        );
      },
    );
  }

  Widget _buildScheduleList(
      Map<String, String> schedule, String formattedDate) {
    if (schedule.isEmpty) {
      return const Center(child: Text("No schedule available"));
    }

    final allowedDays = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
    final availableDays = schedule.entries
        .where((entry) => allowedDays.contains(entry.key) && entry.value != "-")
        .toList();

    if (availableDays.isEmpty) {
      return const Center(child: Text("No available schedule for this doctor"));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: .0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 20.0, // Horizontal spacing between items
        mainAxisSpacing: 20.0, // Vertical spacing between items
        childAspectRatio: 2.8, // Adjust item aspect ratio as needed
      ),
      itemCount: availableDays.length,
      itemBuilder: (context, index) {
        final entry = availableDays[index];
        final day = entry.key;
        final time = entry.value;
        final isSelected = selectedDay == day && selectedTime == time;

        return OutlinedButton(
          onPressed: () {
            setState(() {
              if (isSelected) {
                selectedDay = null;
                selectedTime = null;
              } else {
                selectedDay = day;
                selectedTime = time;
              }
            });
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            backgroundColor:
                isSelected ? const Color(0xFF0C5F5C).withOpacity(0.1) : null,
            side: const BorderSide(color: Color(0xFF0C5F5C), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "$day ($formattedDate) \n\n$time",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isSelected ? const Color(0xFF0C5F5C) : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class DoctorCard extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedDay;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract schedules (reguler and eksekutif)
    final Map<String, dynamic> jadwal = widget.doctor["jadwal"] ?? {};
    final Map<String, String> regulerSchedule =
        Map<String, String>.from(jadwal["reguler"] ?? {});
    final List eksekutifSchedule = jadwal["eksekutif"] ?? [];

    // Safely get doctor details
    final String imageUrl =
        widget.doctor["foto"] ?? "https://via.placeholder.com/150";
    final String doctorName = widget.doctor["nama"] ?? "Unknown Doctor";
    final String specialist =
        widget.doctor["spesialis"] ?? "Unknown Specialist";

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            // Tab bar for Reguler and Eksekutif
            Container(
              height: kToolbarHeight - 6,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
                labelColor: const Color(0xFF0C5F5C),
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
            // Jadwal Reguler dan Eksekutif
            SizedBox(
              height: 120,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScheduleList(regulerSchedule),
                  _buildEksekutifSchedule(eksekutifSchedule),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display selected schedule
            if (selectedDay != null && selectedTime != null)
              Center(
                child: Text(
                  "Jadwal Terpilih: $selectedDay, $selectedTime",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(height: 10),
            // Button to confirm registration
          ],
        ),
      ),
    );
  }

  // Build the regular schedule list
  Widget _buildScheduleList(Map<String, String> schedule) {
    if (schedule.isEmpty) {
      return const Center(child: Text("No regular schedule available"));
    }

    // Daftar hari yang diperbolehkan (Senin hingga Sabtu)
    final allowedDays = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];

    // Filter days that have a schedule and are within the allowed days
    final availableDays = schedule.entries
        .where((entry) => allowedDays.contains(entry.key) && entry.value != "-")
        .toList();

    if (availableDays.isEmpty) {
      return const Center(child: Text("No available schedule for this doctor"));
    }

    return Wrap(
      // spacing: 8,
      // runSpacing: 8,
      // alignment: WrapAlignment.spaceBetween, // Center the items horizontally
      crossAxisAlignment: WrapCrossAlignment.end, // Center the items vertically
      children: availableDays.map((entry) {
        final day = entry.key;
        final time = entry.value;
        return SizedBox(
          width: 100, // Fixed width for uniformity
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                selectedDay = day;
                selectedTime = time;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              side: const BorderSide(color: Color(0xFF0C5F5C), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$day", // Sesuaikan tanggal jika diperlukan
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Center align the text
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Center align the text
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build executive schedule list (non-interactive)
  Widget _buildEksekutifSchedule(List schedule) {
    if (schedule.isEmpty) {
      return const Center(child: Text("No executive schedule available"));
    }

    return ListView.builder(
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            schedule[index],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        );
      },
    );
  }
}

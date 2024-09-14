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
        borderRadius: BorderRadius.circular(10), // if you need this
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
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align for better wrapping
              children: [
                Container(
                  width: 60, // Adjust width and height as needed
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        5.75), // Adjust the radius as needed
                    border: Border.all(
                      color: Color(0xFF0C5F5C), // Border color
                      width: 0.5, // Border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        5.75), // Match the radius for a consistent look
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Display the image if available
                        if (imageUrl.isNotEmpty)
                          Image.network(
                            imageUrl,
                            width: 60, // Adjust width and height as needed
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.account_circle_rounded,
                                  size: 35,
                                  color: Colors.grey, // Error icon color
                                ),
                              );
                            },
                          )
                      ],
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
                        overflow: TextOverflow.ellipsis, // Truncate if too long
                        maxLines: 1,
                      ),
                      Text(
                        "Spesialis ${specialist}",
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
                    color: Colors.white),
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
              height: 120, // Adjust height as needed
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScheduleList(regulerSchedule),
                  _buildEksekutifSchedule(eksekutifSchedule),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build regular schedule in rows
  Widget _buildScheduleList(Map<String, String> schedule) {
    if (schedule.isEmpty) {
      return const Center(child: Text("No regular schedule available"));
    }

    final daysOfWeek = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];

    // First three days (Monday to Wednesday)
    final firstRowDays = daysOfWeek.sublist(0, 3);
    // Last three days (Thursday to Saturday)
    final secondRowDays = daysOfWeek.sublist(3, 6);

    return Column(
      children: [
        // First row: Monday to Wednesday
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: firstRowDays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: firstRowDays.map((day) {
            final time = schedule[day] ?? "-";
            return Expanded(
              child: Center(
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Second row: Thursday to Saturday
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: secondRowDays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: secondRowDays.map((day) {
            final time = schedule[day] ?? "-";
            return Expanded(
              child: Center(
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build executive schedule in a list
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

import 'package:fl_rspi/screens/jadwal_dokter.dart';
import 'package:fl_rspi/screens/daftar_poliklinik.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const JadwalDokterPage(),
    DaftarPoliklinik(),
    const Center(child: Text('Konsultasi Online')),
    const Center(child: Text('Riwayat')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 90, // Adjust height if needed
        child: BottomAppBar(
          color: const Color.fromARGB(
              255, 255, 255, 255), // Set BottomAppBar background color to white
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem('assets/icons/Icon.svg', "Jadwal\nDokter", 0),
              _buildNavItem('assets/icons/ph_hospital_light.svg',
                  "Daftar\nPoliklinik", 1),
              _buildNavItem('assets/icons/konsultasi_online.svg',
                  "Konsultasi\nOnline", 2),
              _buildNavItem('assets/icons/clock_rewind.svg', "Riwayat", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String svgPath, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10), // Adjust padding to avoid overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              svgPath,
              height: 24, // Adjust the size of the SVG icon
              color: _selectedIndex == index
                  ? const Color(
                      0xFF0C5F5C) // Use the custom color #0C5F5C when selected
                  : Colors.grey, // Default to grey when not selected
            ),
            const SizedBox(height: 3), // Space between icon and text
            Text(
              label,
              textAlign: TextAlign.center, // Center text with line breaks
              style: TextStyle(
                fontSize: 12, // Adjust text size
                color: _selectedIndex == index
                    ? const Color(
                        0xFF0C5F5C) // Use the custom color #0C5F5C when selected
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

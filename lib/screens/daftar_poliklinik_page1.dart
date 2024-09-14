import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_rspi/screens/daftar_poliklinik_page2.dart';
import 'dart:convert';

class PoliklinikPage1 extends StatefulWidget {
  @override
  _PoliklinikPageState createState() => _PoliklinikPageState();
}

class _PoliklinikPageState extends State<PoliklinikPage1> {
  List<String> poliklinikList = [];
  bool isLoading = true; // Add loading flag

  @override
  void initState() {
    super.initState();
    fetchPoliklinikData();
  }

  Future<void> fetchPoliklinikData() async {
    final response = await http.get(Uri.parse(
        'https://rspiss.com/rspi/simrs-ci/website/RspissShow/jadwalDokter'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      // Extract unique specializations
      Set<String> specializations = {};
      for (var doctor in data) {
        if (doctor['spesialis'] != null) {
          specializations.add(doctor['spesialis']);
        }
      }

      setState(() {
        poliklinikList = specializations.toList();
        isLoading = false; // Set loading to false when data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Poliklinik"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1, // Makes the card square
                ),
                itemCount: poliklinikList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorListPage(
                                specialist: poliklinikList[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_hospital,
                              size: 40,
                              color: Colors.teal,
                            ),
                            SizedBox(height: 16),
                            Text(
                              poliklinikList[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

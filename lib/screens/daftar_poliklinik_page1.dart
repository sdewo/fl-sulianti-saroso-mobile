import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_rspi/screens/daftar_poliklinik_page2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class PoliklinikPage1 extends StatefulWidget {
  final String pageTitle; // Dynamic title passed from outside
  final Map<String, dynamic> patientData;

  PoliklinikPage1({required this.pageTitle, required this.patientData});

  @override
  _PoliklinikPageState createState() => _PoliklinikPageState();
}

class _PoliklinikPageState extends State<PoliklinikPage1> {
  List<Map<String, dynamic>> poliklinikList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPoliklinikData();
  }

  Future<void> fetchPoliklinikData() async {
    final url = Uri.parse(
        'https://rspiss.com/rspi/simrs-ci/website/RspissWebsite/PoliKlinik');

    final headers = {
      'x-token':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.D40InPMAGpdkU1rM9aA5JRQLAP8Jff462hso3w7d9qw',
      'x-username': 'rspiss22',
      'Content-Type': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      List poliklinikData = jsonData['response']['list'];

      List<Map<String, dynamic>> poliklinikInfo = poliklinikData
          .map<Map<String, dynamic>>((poli) => {
                'poli_id': poli['poli_id'],
                'poli_nama': poli['poli_nama'],
                'icon_poli': poli['icon_poli'] // Get the icon (SVG or null)
              })
          .toList();

      setState(() {
        poliklinikList = poliklinikInfo;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.pageTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C5F5C),
                        ),
                      ),
                      const Text(
                        '2/3', // Page indicator
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 14,
                        ),
                        label: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'Pilih Poliklinik',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      padding:
                          const EdgeInsets.only(top: 0, bottom: 16.0, left: 0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: poliklinikList.length,
                      itemBuilder: (context, index) {
                        final poliklinik = poliklinikList[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorListPage(
                                    patientData: widget.patientData,
                                    specialist: poliklinik['poli_nama'],
                                    pageTitle: "Daftar Poliklinik",
                                    poliNama: poliklinik['poli_nama'],
                                    poliId: poliklinik['poli_id'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (poliklinik['icon_poli'] != null &&
                                      poliklinik['icon_poli'].contains('<svg'))
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xFFECF6F6), // Ganti dengan warna latar belakang yang diinginkan
                                        border: Border.all(
                                          color: const Color(
                                              0xFF0C5F5C), // Ganti dengan warna bingkai yang diinginkan
                                          width:
                                              0.3, // Ganti dengan ketebalan bingkai yang diinginkan
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            8), // Ganti dengan radius sudut yang diinginkan
                                      ),
                                      padding: const EdgeInsets.all(
                                          8), // Ganti dengan padding yang diinginkan
                                      child: SvgPicture.string(
                                        poliklinik['icon_poli'],
                                        height: 22,
                                        color: const Color(0xFF0C5F5C),
                                      ),
                                    )
                                  else
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xFFECF6F6), // Ganti dengan warna latar belakang yang diinginkan
                                        border: Border.all(
                                          color: const Color(
                                              0xFF0C5F5C), // Ganti dengan warna bingkai yang diinginkan
                                          width:
                                              0.3, // Ganti dengan ketebalan bingkai yang diinginkan
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            8), // Ganti dengan radius sudut yang diinginkan
                                      ),
                                      padding: const EdgeInsets.all(
                                          8), // Ganti dengan padding yang diinginkan
                                      child: const Icon(
                                        Icons.local_hospital,
                                        size: 22,
                                        color: Color(0xFF0C5F5C),
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  Text(
                                    poliklinik['poli_nama'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade800,
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
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/landing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding

class DaftarPasienPage2 extends StatelessWidget {
  final Map<String, dynamic>
      patientData; // Menerima data pasien dari halaman sebelumnya

  // Constructor untuk inisialisasi patientData
  DaftarPasienPage2({required this.patientData});

  // GlobalKey untuk form
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input tambahan
  final TextEditingController addressController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController identityNumberController =
      TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController guardianNameController = TextEditingController();

  String? selectedNationality;
  String? selectedMaritalStatus;
  String? selectedGuardianStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Pasang form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat Datang!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700]),
                ),
                SizedBox(height: 8),
                Text("Isi formulir berikut untuk mendaftar"),
                SizedBox(height: 16),
                Center(
                  child: Image.asset(
                    'assets/images/pana.png',
                    height: 130.03,
                  ),
                ),
                SizedBox(height: 16),
                // buildDropdownField("Kewarganegaraan", ["Indonesia", "Lainnya"],
                //     (value) {
                //   selectedNationality = value;
                // }, "Pilih kewarganegaraan", selectedNationality),
                buildTextField(addressController, "Alamat", "Masukkan alamat"),
                // buildTextField(
                //     provinceController, "Provinsi", "Masukkan provinsi"),
                buildTextField(phoneNumberController, "Nomor Telepon",
                    "Masukkan nomor telepon"),
                buildTextField(identityNumberController, "Nomor KTP/Identitas",
                    "Masukkan nomor KTP/Identitas"),
                buildTextField(insuranceNumberController, "Nomor BPJS",
                    "Masukkan nomor BPJS"),
                // buildTextField(educationController, "Pendidikan Terakhir",
                //     "Masukkan pendidikan terakhir"),
                // buildTextField(
                //     jobController, "Pekerjaan", "Masukkan pekerjaan"),
                buildDropdownField("Status Pernikahan",
                    ["Belum Menikah", "Menikah", "Lainnya"], (value) {
                  selectedMaritalStatus = value;
                }, "Pilih status pernikahan", selectedMaritalStatus),
                buildTextField(guardianNameController, "Nama Penanggung Jawab",
                    "Masukkan nama penanggung jawab"),
                buildDropdownField("Status Penanggung Jawab", [
                  "Tidak Tahu",
                  "Ayah",
                  "Ibu",
                  "Suami",
                  "Istri",
                  "Anak",
                  "Keluarga",
                  "Teman",
                  "Lainnya"
                ], (value) {
                  selectedGuardianStatus = value;
                }, "Pilih status penanggung jawab", selectedGuardianStatus),
                SizedBox(height: 16),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Gabungkan data pasien yang ada dengan data baru
                        Map<String, dynamic> completePatientData = {
                          ...patientData, // Sertakan data yang ada
                          "cust_usr_asal_negara": selectedNationality,
                          "cust_usr_alamat": addressController.text,
                          "id_prop": "10", // Sesuaikan sesuai data yang valid
                          "cust_usr_no_hp": phoneNumberController.text,
                          "cust_usr_no_identitas":
                              identityNumberController.text,
                          "cust_usr_no_jaminan": insuranceNumberController.text,
                          "id_pendidikan": "0", // Sesuaikan ID yang valid
                          "id_pekerjaan": "0", // Sesuaikan ID yang valid
                          "id_status_perkawinan":
                              selectedMaritalStatus == "Belum Menikah"
                                  ? "0"
                                  : selectedMaritalStatus == "Menikah"
                                      ? "1"
                                      : "2", // Sesuaikan mapping ID
                          "cust_usr_penanggung_jawab":
                              guardianNameController.text,
                          "cust_usr_penanggung_jawab_status": selectedGuardianStatus ==
                                  "Tidak Tahu"
                              ? "0" // Tidak Tahu
                              : selectedGuardianStatus == "Ayah"
                                  ? "1" // Ayah
                                  : selectedGuardianStatus == "Ibu"
                                      ? "2" // Ibu
                                      : selectedGuardianStatus == "Suami"
                                          ? "3" // Suami
                                          : selectedGuardianStatus == "Istri"
                                              ? "4" // Istri
                                              : selectedGuardianStatus == "Anak"
                                                  ? "5" // Anak
                                                  : selectedGuardianStatus ==
                                                          "Keluarga"
                                                      ? "6" // Keluarga
                                                      : selectedGuardianStatus ==
                                                              "Teman"
                                                          ? "7" // Teman
                                                          : "8", // Lain-lain (Other)
                        };

                        // print(patientData);

                        try {
                          // Construct the URL with query parameters
                          final url = Uri.parse(
                              'https://rspiss.com/rspi/simrs-ci/website/RspissWebsite/createPasienBaru');

                          // print(completePatientData['cust_usr_agama']);
                          // print(completePatientData['cust_usr_alamat']);
                          // print(completePatientData['cust_usr_asal_negara']);
                          // print(completePatientData['cust_usr_no_jaminan']);
                          // print(completePatientData['cust_usr_gol_darah']);
                          // print(
                          //     completePatientData['cust_usr_gol_darah_resus']);
                          // print(completePatientData['cust_usr_jenis_kelamin']);
                          // print(completePatientData['cust_usr_nama']);
                          // print(completePatientData['cust_usr_email']);
                          // print(completePatientData['cust_usr_no_hp']);
                          // print(completePatientData['cust_usr_no_identitas']);
                          // print(
                          //     completePatientData['cust_usr_penanggung_jawab']);
                          // print(completePatientData[
                          //     'cust_usr_penanggung_jawab_status']);
                          // print(completePatientData['cust_usr_tanggal_lahir']);
                          // print(completePatientData['cust_usr_tempat_lahir']);
                          // print(completePatientData['id_pendidikan']);
                          // print(completePatientData['id_pekerjaan']);
                          // print(completePatientData['id_prop']);
                          // print(completePatientData['id_status_perkawinan']);

                          // Prepare the GET request
                          final request = http.Request('GET', url);

                          // Set headers
                          request.headers.addAll({
                            'x-token':
                                'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.D40InPMAGpdkU1rM9aA5JRQLAP8Jff462hso3w7d9qw',
                            'x-username': 'rspiss22',
                            'Content-Type': 'application/json',
                          });

                          request.body = jsonEncode({
                            "cust_usr_agama": completePatientData[
                                'cust_usr_agama'], //*Option -> 0=Tidak Tahu, 1=ISLAM, 2=KRISTEN PROTESTAN, 3=KRISTEN KHATOLIK, 4=HINDU, 5=BUDHA, 6=KEPERCAYAAN, 7=LAIN-LAIN, 8=KONGHUCU
                            "cust_usr_alamat": completePatientData[
                                'cust_usr_alamat'], //Alamat Lengkap Domisili
                            "cust_usr_asal_negara":
                                "2f18113d5dfa5f847c00268290861867", //ID Poli
                            "cust_usr_no_jaminan": completePatientData[
                                'cust_usr_no_jaminan'], //Nomor BPJS Pasien
                            "cust_usr_gol_darah": completePatientData[
                                'cust_usr_gol_darah'], //Option -> 0=Tidak Tahu, 1=A, 2=AB, 3=B, 4=0
                            "cust_usr_gol_darah_resus": completePatientData[
                                'cust_usr_gol_darah_resus'], //Option -> 0=Tidak Tahu, 1=Positif, 2=Negatif
                            "cust_usr_jenis_kelamin": completePatientData[
                                'cust_usr_jenis_kelamin'], //*Option -> 0=Tidak Tahu, L=Laki-laki, P=Perempuan
                            "cust_usr_nama": completePatientData[
                                'cust_usr_nama'], //Nama Pasien
                            "cust_usr_email": completePatientData[
                                'cust_usr_email'], //Email Pasien
                            "cust_usr_no_hp": completePatientData[
                                'cust_usr_no_hp'], //Nomor HP Pasien
                            "cust_usr_no_identitas": completePatientData[
                                'cust_usr_no_identitas'], //*NIK pasien
                            "cust_usr_penanggung_jawab": completePatientData[
                                'cust_usr_penanggung_jawab'], //Penanggung Jawab Pasien, keluarga/kerabat
                            "cust_usr_penanggung_jawab_status": completePatientData[
                                'cust_usr_penanggung_jawab_status'], //Option -> 0=Tidak Tahu, 1=Ayah, 2=Ibu, 3=Suami, 4=Istri, 5=Anak, 6=Keluarga, 7=Teman, 8=Lain-lain
                            "cust_usr_tanggal_lahir": completePatientData[
                                'cust_usr_tanggal_lahir'], //*Tanggal Lahir Pasien
                            "cust_usr_tempat_lahir": completePatientData[
                                'cust_usr_tempat_lahir'], //*Tempat Lahir Pasien
                            "id_pekerjaan": "0", //ID Pekerjaan
                            "id_pendidikan": "0", //ID Pendidikan
                            "id_prop": "10", //ID Tempat Domisili
                            "id_status_perkawinan": completePatientData[
                                'id_status_perkawinan'], //ID Perkawinan
                          });

                          // Send the request and await the response
                          final response = await request.send();

                          if (response.statusCode == 200) {
                            // API call successful
                            final responseData =
                                await response.stream.bytesToString();
                            final decodedData = jsonDecode(responseData);
                            final metadata = decodedData['metadata']['code'];
                            print(decodedData);
                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  titlePadding: EdgeInsets.zero,
                                  contentPadding: EdgeInsets.zero,
                                  content: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset('assets/images/pana2.png',
                                            height: 130.03),
                                        SizedBox(height: 16),
                                        const Text(
                                          'Pendaftaran Berhasil!',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Harap sebutkan Nama Lengkap atau NIK Anda di konter administrasi RSPI Sulianti Saroso untuk proses verifikasi data.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 16),
                                        // Display patient name and email
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Nama: ${completePatientData['cust_usr_nama'] ?? "N/A"}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email: ${completePatientData['cust_usr_email'] ?? "N/A"}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Landing()),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 10),
                                          ),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            // Handle error response
                            throw Exception(
                                'Failed to create patient: ${response}');
                          }
                        } catch (e) {
                          // Handle error
                          print(e);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Something went wrong! Please try again.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text("Daftar", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat TextField dengan validasi
  Widget buildTextField(
      TextEditingController controller, String label, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field ini wajib diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Membuat DropdownField dengan validasi
  Widget buildDropdownField(String label, List<String> items,
      ValueChanged<String?> onChanged, String hintText, String? currentValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: Text(hintText),
            value: currentValue,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Field ini wajib diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

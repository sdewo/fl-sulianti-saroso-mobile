import 'package:flutter/material.dart';
import 'package:fl_rspi/screens/daftar_pasien_page2.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class RegistrationFormPage1 extends StatefulWidget {
  @override
  _RegistrationFormPage1State createState() => _RegistrationFormPage1State();
}

class _RegistrationFormPage1State extends State<RegistrationFormPage1> {
  // GlobalKey to manage form state
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture input values
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? gender; // Will hold selected gender
  String? religion; // Will hold selected religion
  String? bloodType; // Will hold selected blood type
  String? rhesusType; // Will hold selected rhesus type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selamat Datang!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C5F5C)),
                ),
                SizedBox(height: 8),
                const Row(
                  children: [
                    Text("Isi formulir berikut untuk mendaftar"),
                    Spacer(),
                    Text("1/2"),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/images/pana.png',
                    height: 130.03,
                  ),
                ),
                SizedBox(height: 24),
                buildLabeledTextField(
                    nameController, "Nama Pasien", "Masukkan nama pasien"),
                buildLabeledTextField(
                    emailController, "Alamat Email", "Masukkan alamat email"),
                buildLabeledTextField(birthPlaceController, "Tempat Lahir",
                    "Masukkan tempat lahir"),
                buildLabeledDateField(context, "Tanggal Lahir", dateController),
                buildLabeledDropdownField(
                    "Jenis Kelamin", ["Laki-laki", "Perempuan", "Tidak Tahu"],
                    (value) {
                  setState(() {
                    gender = value;
                  });
                }, "Pilih jenis kelamin", gender),
                buildLabeledDropdownField("Agama", [
                  "Islam",
                  "Kristen",
                  "Katolik",
                  "Hindu",
                  "Budha",
                  "Konghucu",
                  "Lainnya"
                ], (value) {
                  setState(() {
                    religion = value;
                  });
                }, "Pilih agama", religion),
                buildLabeledDropdownField(
                    "Golongan Darah", ["A", "B", "AB", "O", "Tidak Tahu"],
                    (value) {
                  setState(() {
                    bloodType = value;
                  });
                }, "Pilih golongan darah", bloodType),
                buildLabeledDropdownField("Rhesus Golongan Darah",
                    ["Positif", "Negatif", "Tidak Tahu"], (value) {
                  setState(() {
                    rhesusType = value;
                  });
                }, "Pilih rhesus golongan darah", rhesusType),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate form and check if all fields are filled
                      if (_formKey.currentState!.validate()) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(
                          DateFormat('dd/MM/yyyy').parse(dateController.text),
                        );
                        // Create a map to hold the values
                        Map<String, dynamic> patientData = {
                          "cust_usr_nama": nameController.text,
                          "cust_usr_email": emailController.text,
                          "cust_usr_tanggal_lahir": formattedDate,
                          "cust_usr_tempat_lahir": birthPlaceController.text,
                          "cust_usr_jenis_kelamin": gender == "Laki-laki"
                              ? "L" // L for Laki-laki
                              : gender == "Perempuan"
                                  ? "P" // P for Perempuan
                                  : "0", // T for Tidak Tahu (or any other value you prefer)
                          "cust_usr_agama": religion == "Islam"
                              ? "1"
                              : religion == "Kristen"
                                  ? "2"
                                  : religion == "Katolik"
                                      ? "3"
                                      : religion == "Hindu"
                                          ? "4"
                                          : religion == "Budha"
                                              ? "5"
                                              : religion == "Konghucu"
                                                  ? "8"
                                                  : "7", // Adjust these values as needed
                          "cust_usr_gol_darah": bloodType == "A"
                              ? "1"
                              : bloodType == "AB"
                                  ? "2"
                                  : bloodType == "B"
                                      ? "3"
                                      : bloodType == "O"
                                          ? "4"
                                          : "0", // Adjust these values as needed
                          "cust_usr_gol_darah_resus": rhesusType == "Positif"
                              ? "1"
                              : rhesusType == "Negatif"
                                  ? "2"
                                  : "0",
                        };

                        // Navigate to the next page with the data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DaftarPasienPage2(patientData: patientData),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C5F5C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Selanjutnya",
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabeledTextField(
      TextEditingController controller, String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(height: 20),
        TextFormField(
          controller: controller, // Assign the controller
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Colors.red, width: 2), // Focus color
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2),
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
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildLabeledDropdownField(
      String label,
      List<String> items,
      ValueChanged<String?> onChanged,
      String placeholder,
      String? currentValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.grey, width: 2), // Focus color
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          hint: Text(placeholder), // Placeholder
          value: currentValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field ini wajib diisi';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildLabeledDateField(
      BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(height: 20),
        TextFormField(
          controller: controller, // Assign the controller
          decoration: InputDecoration(
            hintText: "dd/mm/yyyy",
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.grey, width: 2), // Focus color
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          readOnly: true, // Make the field non-editable but tappable
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
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

            if (pickedDate != null) {
              // Format the picked date and set it in the controller
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
              controller.text = formattedDate; // Update the TextFormField
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field ini wajib diisi';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

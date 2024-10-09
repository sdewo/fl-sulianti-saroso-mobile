import 'package:fl_rspi/onboarding/components/onboarding_info.dart';

class OnboardingData {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "Selamat Datang!",
        description: "Buat Janji Tanpa Antre",
        longdescription:
            "Jadwalkan kunjungan Anda secara mudah melalui aplikasi RSPI Sulianti Saroso.",
        image: "assets/images/onboarding1.png"),
    OnboardingInfo(
        title: "",
        description: "Konsultasi dari Rumah",
        longdescription:
            "Lakukan konsultasi online dengan dokter pilihan Anda tanpa batasan jarak dan waktu.",
        image: "assets/images/onboarding2.png"),
    OnboardingInfo(
        title: "",
        description: "Pantau Jadwal Dokter Terbaru",
        longdescription:
            "Lihat jadwal dokter secara lengkap dan buat janji sesuai waktu Anda.",
        image: "assets/images/onboarding3.png"),
  ];
}

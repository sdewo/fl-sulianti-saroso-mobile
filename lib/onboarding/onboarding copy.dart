import 'package:flutter/material.dart';
import 'package:fl_rspi/onboarding/components/onboarding_data.dart';
import 'package:fl_rspi/screens/landing.dart';

const primaryColor = Color(0xFF0C5F5C);

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          body(), // Elemen pertama (body)
          Container(
            alignment: Alignment(0, 0.45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildDots(), // Elemen kedua (dots)
                // button(), // Elemen ketiga (button)
              ],
            ),
          ),
          Container(
            alignment: Alignment(0, 0.65),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                button(), // Elemen ketiga (button)
              ],
            ),
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                skip(), // Elemen ketiga (button)
              ],
            ),
          )
        ],
      ),
    );
  }

  //Body
  Widget body() {
    return Expanded(
      child: Center(
        child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 60, left: 32, right: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      controller.items[currentIndex].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0C5F5C),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(controller.items[currentIndex]
                        .image), // Display the onboarding image
                    const SizedBox(height: 20),
                    Text(
                      controller.items[currentIndex].description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0C5F5C),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      controller.items[currentIndex].longdescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  //Dots
  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          controller.items.length,
          (index) => AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: currentIndex == index ? primaryColor : Colors.grey,
              ),
              height: 8,
              width: 8,
              duration: const Duration(milliseconds: 700))),
    );
  }

  //Button
  Widget button() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: primaryColor,
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            currentIndex != controller.items.length - 1
                ? currentIndex++
                : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Landing()),
                  );
            ;
          });
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan teks dan ikon
          children: [
            Text(
              "Selanjutnya",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8), // Jarak antara teks dan ikon
            Icon(
              Icons.arrow_forward, // Ikon panah ke kanan
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget skip() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Landing()),
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        backgroundColor: null,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16), // Radius untuk sudut melengkung
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Lewati",
            style: TextStyle(
              color: Color(0xFF0C5F5C),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

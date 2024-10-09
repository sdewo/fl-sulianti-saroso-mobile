import 'package:flutter/material.dart';
import 'package:fl_rspi/onboarding/components/onboarding_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fl_rspi/screens/landing.dart';

const primaryColor = Color(0xFF0C5F5C);

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingData();
  final pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFECF6F6),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: PageView.builder(
                  onPageChanged: (index) => setState(
                      () => isLastPage = controller.items.length - 1 == index),
                  itemCount: controller.items.length,
                  controller: pageController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 32, right: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            controller.items[index].title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0C5F5C),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Image.asset(controller.items[index]
                              .image), // Display the onboarding image
                          const SizedBox(height: 20),
                          Text(
                            controller.items[index].description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0C5F5C),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            controller.items[index].longdescription,
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
            Container(
              alignment: Alignment(0, 0.45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.items.length,
                    onDotClicked: (index) => pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn),
                    effect: const WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: primaryColor,
                    ),
                  ), // Elemen kedua (dots)
                  // button(), // Elemen ketiga (button)
                ],
              ),
            ),
            Container(
              alignment: Alignment(0, 0.65),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  button(isLastPage), // Elemen ketiga (button)
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
        ));
  }

  //Now the problem is when press get started button
  // after re run the app we see again the onboarding screen
  // so lets do one time onboarding

  //Get started button

  Widget button(isLastPage) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: primaryColor,
      ),
      child: isLastPage
          ? TextButton(
              onPressed: () async {
                final pres = await SharedPreferences.getInstance();
                pres.setBool("onboarding", true);

                //After we press get started button this onboarding value become true
                // same key
                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Landing()));
              },
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Pusatkan teks dan ikon
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
            )
          : TextButton(
              onPressed: () => pageController.nextPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeIn),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Pusatkan teks dan ikon
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
      onPressed: () async {
        final pres = await SharedPreferences.getInstance();
        pres.setBool("onboarding", true);

        //After we press get started button this onboarding value become true
        // same key
        if (!mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Landing()));
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

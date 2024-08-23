
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kiratakip/auth/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.teal,
    );

    const bodyTextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    const pageDecoration = PageDecoration(
      titleTextStyle: titleStyle,
      bodyTextStyle: bodyTextStyle,
      pageColor: Colors.white,
      imagePadding: EdgeInsets.all(24.0),
      contentMargin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      bodyAlignment: Alignment.center,
      titlePadding: EdgeInsets.only(top: 32.0),
    );

    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Kiracı Listesi ve Bilgiler",
            bodyWidget:const IntroPage(
              imagePath: 'assets/resimler/birinci.png',
              title: "Kiracı Listesi ve Bilgiler",
              description: "Kiracı listenizi ve temel bilgilerini görüntüleyin. Ayrıca arşivlenmiş kiracıları da buradan görebilirsiniz.",
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Ödeme Tablosu",
            bodyWidget:const IntroPage(
              imagePath: 'assets/resimler/ikinci.png',
              title: "Ödeme Tablosu",
              description: "Kiracınızın aylık ödeme tablosunu, toplam ödenmesi gereken miktarı ve ödediği miktarı burada görebilirsiniz.",
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Ev Sahibi Bilgileri",
            bodyWidget:const IntroPage(
              imagePath: 'assets/resimler/ucuncu.png',
              title: "Ev Sahibi Bilgileri",
              description: "Mülk sayınız, kiracı sayınız ve aylık, yıllık ile toplam kazancınızı bu sayfadan takip edebilirsiniz.",
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Kiracı Bilgileri",
            bodyWidget:const  IntroPage(
              imagePath: 'assets/resimler/dorduncu.png',
              title: "Kiracı Bilgileri",
              description: "Kiracı ile ilgili detaylı bilgileri ve yönetim seçeneklerini buradan görüntüleyebilirsiniz.",
            ),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        showSkipButton: true,
        skip: const Text('Atla', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
        next: const Icon(Icons.arrow_forward, color: Colors.teal),
        done: const Text('Tamam', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          color: const Color(0xFFBDBDBD),
          activeSize: const Size(22.0, 10.0),
          activeColor: Colors.teal,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        nextFlex: 0,
        showNextButton: true,
        showDoneButton: true,
        onSkip: () => _onIntroEnd(context),
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const IntroPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.75;

    const titleStyle = TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.teal,
    );

    const bodyTextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: imageSize,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          description,
          textAlign: TextAlign.center,
          style: bodyTextStyle,
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pomodoro/pages/home_page.dart';
import 'package:resize/resize.dart';

class SplashPage extends StatefulWidget {
  // static get route => CupertinoPageRoute(builder: (_) => const SplashPage());
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loader();
  }

  bool isloaded = false;
  @override
  Widget build(BuildContext context) {
    if (isloaded) {
      return const HomePage();
    } else {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                // color: Colors.black,
                width: 7.rem,
                height: 7.rem,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100.rem,
                  height: 100.rem,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Text(
            //   'POMODORO TIMER',
            //   style: Theme.of(context).textTheme.titleSmall!.copyWith(
            //         color: Colors.primaries.first.shade400,
            //         letterSpacing: 5,
            //       ),
            // ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                color: Colors.primaries.first.shade400,
              ),
            )
          ],
        ),
      );
    }
  }

  Future<void> loader() async {
    await Future.delayed(const Duration(seconds: 3), () {
      isloaded = true;
      setState(() {});
    });
  }
}

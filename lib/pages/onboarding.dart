import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/pages/homepage.dart';
import 'package:pomodoro/utils/onboard.dart';
import 'package:pomodoro/widgets/on_boarding_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int pageIndex = 0;
  late PageController pageController;

  Duration animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: isPhone || width < 426 ? width - 30 : 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: data.length,
                      onPageChanged: (value) {
                        setState(() {
                          pageIndex = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              data[index].image,
                              width: height < width ? 100 : 150,
                            ),
                            Text(
                              data[index].title,
                              style: const TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                            // const SizedBox(height: 20),
                            Text(
                              data[index].desc,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      OnBoardingButton(
                        onTap: () {
                          pageController.previousPage(
                              duration: animationDuration, curve: Curves.ease);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                        ),
                      ),
                      const Spacer(),
                      OnBoardingButton(
                        onTap: () async {
                          if (pageIndex < data.length - 1) {
                            pageController.nextPage(
                                duration: animationDuration,
                                curve: Curves.ease);
                          } else {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                            await prefs.setBool("onboarding", false);
                          }
                        },
                        child: pageIndex < data.length - 1
                            ? const Icon(Icons.arrow_forward_ios_rounded)
                            : const Text("Start!",
                                style: TextStyle(fontSize: 20)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
